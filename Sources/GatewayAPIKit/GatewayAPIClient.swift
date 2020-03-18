import Foundation
import NIO
import NIOFoundationCompat
import NIOHTTP1
import NIOHTTPCompression
import AsyncHTTPClient

public struct GatewayAPIClient {
    let baseUrl = "https://gatewayapi.com"
    let eventLoop: EventLoop
    let httpClient: HTTPClient
    let apiKey: String
    
    public init(eventLoop: EventLoop, httpClient: HTTPClient, apiKey: String) {
        self.eventLoop = eventLoop
        self.httpClient = httpClient
        self.apiKey = apiKey
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
    ///     - sendTime: Date to schedule message sending at certain time.
    ///     - textClass: Default “standard”. The message class to use for this request. If specified it must be the same for all messages in the request.
    public func send(_ message: String,
                     to recipients: [String],
                     from sender: String,
                     atTime sendTime: Date? = nil,
                     as textClass: GatewayAPITextClass? = nil) -> EventLoopFuture<GatewayAPINewSMSResponse> {
        let sendtime = sendTime?.timeIntervalSince1970
        
        let newSmsRequest = GatewayAPINewSMSRequest(message: message,
                                                    recipients: recipients.map { GatewayAPIRecipient(msisdn: $0) },
                                                    class: textClass,
                                                    sender: sender,
                                                    sendTime: sendtime)
        
        return httpRequest(.POST, endPoint: "/rest/mtsms", body: newSmsRequest)
    }
    
    /// Send a charged SMS to one receipient
    /// - Important
    ///     Overcharged SMS is only possible in Denmark at the moment
    /// - Parameters:
    ///     - recipient: Array of recipients MSISDN. The number of recipients in a single message is limited to 10.000.
    ///     - sender: Up to 11 alphanumeric characters, or 15 digits, that will be shown as the sender of the SMS.
    ///     - message: The actual message to send to the recipient
    ///     - amount: The amount to be charged including VAT.
    ///     - currency: Currency used in ISO 4217
    ///     - productCode: Product code. P01-P10.
    ///     - description: Description of the charge to appear on the phonebill for the MSISDN owner.
    ///     - category: Service category category. SC00-SC34.
    public func sendChargedSMS(to recipient: String,
                               from sender: String,
                               message: String,
                               amount: Double,
                               currency: String,
                               productCode: String,
                               description: String,
                               category: String) -> EventLoopFuture<GatewayAPINewSMSResponse> {
        let charge = GatewayAPICharge(amount: amount, currency: currency, code: productCode, category: category, description: description)
        let recipient = GatewayAPIRecipient(msisdn: recipient, charge: charge)
        
        let chargedSMSRequest = GatewayAPINewSMSRequest(message: message, recipients: [recipient], class: .charge, sender: sender)
        
        return httpRequest(.POST, endPoint: "/rest/mtsms", body: chargedSMSRequest)
    }
}
