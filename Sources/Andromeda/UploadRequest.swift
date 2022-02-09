import Foundation
import Alamofire

public protocol UploadRequest {
    associatedtype SuccessResponse: Decodable
    associatedtype FailureResponse: Decodable
    
    var path: String { get }
    var method: HTTP.Method { get }
    var parameters: [MultipartDataItem?] { get }
}

