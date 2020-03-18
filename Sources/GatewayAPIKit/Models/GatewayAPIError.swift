public struct GatewayAPIError: Decodable, Error {
    public var code: String?
    public var incidentUUID: String
    public var message: String
    public var variables: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case incidentUUID = "incident_uuid"
        case message
        case variables
    }
}
