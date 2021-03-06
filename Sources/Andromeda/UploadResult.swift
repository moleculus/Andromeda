import Foundation

public enum UploadResult<SuccessResponse: Decodable, FailureResponse: Decodable> {
    case success (SuccessResponse)
    case progress (Double)
    case failure (Error<FailureResponse>)
}
