internal struct GatewayAPINewSMSRequest: Encodable {
    let message: String
    let recipients: [GatewayAPIRecipient]
    let `class`: GatewayAPITextClass
    let sender: String
}
