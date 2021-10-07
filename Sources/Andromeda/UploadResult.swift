import Foundation

public enum UploadResult<SuccessResponse: Decodable, FailureResponse: Decodable> {
    case success (SuccessResponse)
    case progres (Double)
    case failure (Error<FailureResponse>)
}
