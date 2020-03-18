struct GatewayAPICharge: Codable {
    let amount: Double
    let currency: String
    let code: String
    let category: String
    let description: String
}
