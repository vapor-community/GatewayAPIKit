public struct GatewayAPIError: Codable, Error {
    var code: String?
    var incident_uuid: String
    var message: String
    var variables: [String]?
}
