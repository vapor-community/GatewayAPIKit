import Foundation
import NIO
import NIOHTTP1
import AsyncHTTPClient

extension GatewayAPIClient {
    func httpRequest<Body, Response>(_ method: HTTPMethod, endPoint: String, body: Body) -> EventLoopFuture<Response> where Response: Decodable, Body: Encodable {
        let authKey = "\(apiKey):".data(using: .utf8)!.base64EncodedString()
        
        do {
            let request = try HTTPClient.Request(url: baseUrl + endPoint,
                method: method,
                headers: ["Authorization": "Basic \(authKey)", "Content-Type": "application/json"],
                body: .data(JSONEncoder().encode(body)))
            
            return httpClient.execute(request: request, eventLoop: .delegate(on: eventLoop)).flatMap { response in
                let buffer = response.body ?? ByteBuffer(.init())
                let data = Data(buffer.readableBytesView)
                let decoder = JSONDecoder()
                
                do {
                    guard response.status == .ok else {
                        return self.eventLoop.makeFailedFuture(try decoder.decode(GatewayAPIError.self, from: data))
                    }
                    
                    return self.eventLoop.makeSucceededFuture(try decoder.decode(Response.self, from: data))
                } catch {
                    return self.eventLoop.makeFailedFuture(error)
                }
            }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
}
