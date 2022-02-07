import Foundation

public enum Result<SuccessResponse: Decodable, FailureResponse: Decodable> {
    case data (serializedResponse: SuccessResponse?)
    case success (statusCode: Int)
    case failure (Error<FailureResponse>)
}

