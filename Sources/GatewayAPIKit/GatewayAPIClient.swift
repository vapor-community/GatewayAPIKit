import Foundation
import NIO
import NIOFoundationCompat
import NIOHTTP1
import NIOHTTPCompression
import AsyncHTTPClient

public final class GatewayAPIClient {
    static let baseUrl = "https://gatewayapi.com"
    
    private let httpClient: HTTPClient
    private let apiKey: String
    
    public init(eventLoopGroup: EventLoopGroup, apiKey: String) {
        self.apiKey = apiKey
        httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
    }
    
    /// Send a new SMS to a list of recipients
    ///
    /// # MSISDN
    /// Mobile Station International Subscriber Directory Number, but you may think of this as the full mobile number, including area code if available and the country code, but without prefixed zeros or ‘+’.
    /// - Examples:
    ///     * 4510203040 (In Denmark known as: 10 20 30 40)
    ///     - 46735551020 (In Sweden known as: 073-555 10 20)
    ///     - 17325551020 (In US known as: (732) 555-1020)
    ///
    /// - Parameters:
    ///     - message: The actual message to send to the recipients
    ///     - recipients: Array of recipients MSISDN. The number of recipients in a single message is limited to 10.000.
    ///     - sender: Up to 11 alphanumeric characters, or 15 digits, that will be shown as the sender of the SMS.
    ///     - textClass: Default “standard”. The message class to use for this request. If specified it must be the same for all messages in the request.
    public func send(_ message: String,
                     to recipients: [String],
                     from sender: String,
                     as textClass: GatewayAPITextClass = .standard) -> EventLoopFuture<GatewayAPINewSMSResponse> {
        let newSmsRequest = GatewayAPINewSMSRequest(message: message,
                                                    recipients: recipients.map { GatewayAPIRecipient(msisdn: $0) },
                                                    class: textClass,
                                                    sender: sender)
        
        return request(.POST, endPoint: "/rest/mtsms", body: newSmsRequest)
    }
    
    private func request<Body, Response>(_ method: HTTPMethod, endPoint: String, body: Body) -> EventLoopFuture<Response> where Response: Decodable, Body: Encodable {
        let authKey = "\(apiKey):".data(using: .utf8)!.base64EncodedString()
        
        do {
            let request = try HTTPClient.Request(url: GatewayAPIClient.baseUrl + endPoint,
                                                 method: method,
                                                 headers: ["Authorization": "Basic \(authKey)", "Content-Type": "application/json"],
                                                 body: .data(JSONEncoder().encode(body)))
            
            return httpClient.execute(request: request).flatMap { response in
                guard var buffer = response.body else {
                    fatalError("GatewayAPI body missing")
                }

                let data = buffer.readData(length: buffer.readableBytes)!
                let decoder = JSONDecoder()
                
                do {
                    guard response.status == .ok else {
                        return self.httpClient.eventLoopGroup.next().makeFailedFuture(try decoder.decode(GatewayAPIError.self, from: data))
                    }
                    
                    return self.httpClient.eventLoopGroup.next().makeSucceededFuture(try decoder.decode(Response.self, from: data))
                } catch {
                    return self.httpClient.eventLoopGroup.next().makeFailedFuture(error)
                }
            }
        } catch {
            return httpClient.eventLoopGroup.next().makeFailedFuture(error)
        }
    }
    
    deinit {
        try? httpClient.syncShutdown()
    }
}


