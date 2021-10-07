import Foundation

public enum Result<SuccessResponse: Decodable, FailureResponse: Decodable> {
    case success (statusCode: Int, serializedResponse: SuccessResponse?)
    case failure (Error<FailureResponse>)
}

