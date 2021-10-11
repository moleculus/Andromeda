import Foundation
import Alamofire

public protocol Request {
    associatedtype SuccessResponse: Decodable
    associatedtype FailureResponse: Decodable
    
    var path: String { get }
    var method: HTTP.Method { get }
    var parameters: [String: Any?] { get }
    var emptyResponseCodes: Set<Int> { get }
}

extension Request {
    public var emptyResponseCodes: Set<Int> {
        return [ 204, 205 ]
    }
}

extension Request {
    var nonNilParameters: [String: Any]? {
        let parameters = self.parameters.compactMapValues { $0 }
        
        if parameters.keys.isEmpty {
            return nil
        }
        else {
            return parameters
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
