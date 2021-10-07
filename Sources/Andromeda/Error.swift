import Foundation

public enum Error<Response: Decodable> {
    case undefined
    case tokenIsInvalid
    case internalServerError
    case serverIsTemporarilyUnavailable
    case custom (Response)
    
    public init(httpCode: Int?, data: Data?) {
        guard let httpCode = httpCode else {
            self = .undefined
            return
        }
        
        switch httpCode {
        case 401:
            self = .tokenIsInvalid
        case 500:
            self = .internalServerError
        case 502:
            self = .serverIsTemporarilyUnavailable
        default:
            guard let data = data, let response = try? JSONDecoder().decode(Response.self, from: data) else {
                self = .undefined
                return
            }
            
            self = .custom(response)
        }
    }
}
