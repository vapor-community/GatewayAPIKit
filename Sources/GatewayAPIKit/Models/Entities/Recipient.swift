struct GatewayAPIRecipient: Codable {
    let msisdn: String
    let charge: GatewayAPICharge?
    
    init(msisdn: String, charge: GatewayAPICharge? = nil) {
        self.msisdn = msisdn
        self.charge = charge
    }
}
