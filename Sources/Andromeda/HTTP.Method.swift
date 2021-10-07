import Foundation
import Alamofire

public enum HTTP {
    public enum Method: String {
        case delete = "DELETE"
        case get = "GET"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
    }
}

extension HTTPMethod {
    init(method: HTTP.Method) {
        self.init(rawValue: method.rawValue)
    }
}
