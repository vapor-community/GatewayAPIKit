struct GatewayAPINewSMSRequest: Encodable {
    let message: String
    let recipients: [GatewayAPIRecipient]
    let `class`: GatewayAPITextClass?
    let sender: String
    let sendTime: Double?
    
    init(message: String, recipients: [GatewayAPIRecipient], `class`: GatewayAPITextClass? = nil, sender: String, sendTime: Double? = nil) {
        self.message = message
        self.recipients = recipients
        self.class = `class`
        self.sender = sender
        self.sendTime = sendTime
    }
    
    private enum CodingKeys: String, CodingKey {
        case message
        case recipients
        case `class`
        case sender
        case sendTime = "sendtime"
    }
}
