public enum GatewayAPIChargeSender {
    case `default`
    case custom(String)
    
    public var sender: String {
        switch self {
        case .default:
            return "1204"
        case .custom(let value):
            return value
        }
    }
}
