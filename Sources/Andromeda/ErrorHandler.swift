import Foundation
import Alamofire

public protocol ErrorHandler {
    func handleError<R: Request>(_ error: Error<R.FailureResponse>, in _: R)
    func handleError<UR: UploadRequest>(_ error: Error<UR.FailureResponse>, in _: UR)
}
