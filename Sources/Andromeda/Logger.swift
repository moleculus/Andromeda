import Foundation
import Alamofire

struct Logger {
        
    // MARK: - Public Methods.
        
    func log<R: Request>(request: R, dataRequest: DataRequest) {
        dataRequest.responseJSON { (response) in                        
            print("\n===")
            print(Date().timeIntervalSince1970)
            print(dataRequest.request?.headers as Any)
            print(request.path)
            print(request.nonNilParameters as Any)
            print("---")
            print(response.result)
            print("===\n")
        }
    }
    
    func log<UR: UploadRequest>(request: UR, uploadRequest: Alamofire.UploadRequest) {
        uploadRequest.responseJSON { (response) in
            print("\n===")
            print(Date().timeIntervalSince1970)
            print(uploadRequest.request?.headers as Any)
            print(request.path)
            print(request.parameters as Any)
            print("---")
            print(response.result)
            print("===\n")
        }
    }
    
}
