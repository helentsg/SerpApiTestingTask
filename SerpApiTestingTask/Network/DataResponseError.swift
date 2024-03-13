
import Foundation

enum DataResponseError: Error {
    case url
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .url:
            return "Invalid URL".localizedString
        case .network:
            return "An error occurred while fetching data ".localizedString
        case .decoding:
            return "An error occurred while decoding data".localizedString
        }
    }
}
