import Foundation
import Alamofire

public struct Service {
    
    // MARK: - Properties.
    
    private let configuration: Configurator
    private let session: Session
    
    // MARK: - Initialization.
    
    public init(configuration: Configurator) {
        self.configuration = configuration
        self.session = Alamofire.Session(eventMonitors: [])
    }
    
    // MARK: - Public Methods.
    
    @discardableResult
    public func send<R: Request>(_ request: R, then completion: ((Result<R.SuccessResponse, R.FailureResponse>) -> Void)?) -> DataRequest {
        let dataRequest = session.request(
            configuration.baseURL + request.path,
            method: HTTPMethod(method: request.method),
            parameters: request.nonNilParameters,
            encoding: request.encoding,
            headers: HTTPHeaders(configuration.headers)
        )
        
        dataRequest.responseData(emptyResponseCodes: request.emptyResponseCodes) { dataResponse in
            if case .success (let data) = dataResponse.result, data.isEmpty {
                completion?(.success(statusCode: dataResponse.response!.statusCode))
                return
            }
            
            let result = handle(dataResponse: dataResponse, for: request)
            
            if case .failure (let error) = result {
                configuration.errorHandler.handleError(error, in: request)
            }
            
            completion?(result)
        }
        
        if configuration.showsRequestLogs {
            Logger().log(request: request, dataRequest: dataRequest)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func upload<UR: UploadRequest>(request: UR, then completion: ((UploadResult<UR.SuccessResponse, UR.FailureResponse>) -> Void)?) -> Alamofire.UploadRequest {
        let uploadRequest = session.upload(
            multipartFormData: multipartFormData(for: request),
            to: configuration.baseURL + request.path,
            method: HTTPMethod(method: request.method),
            headers: HTTPHeaders(configuration.headers),
            interceptor: nil,
            fileManager: .default
        )
        
        uploadRequest.uploadProgress { (progress) in
            completion?(.progress(progress.fractionCompleted))
        }
        
        uploadRequest.responseData {
            let result = self.handle(dataResponse: $0, for: request)
            
            if case .failure (let error) = result {
                configuration.errorHandler.handleError(error, in: request)
            }
            
            completion?(result)
        }
        
        if configuration.showsRequestLogs {
            Logger().log(request: request, uploadRequest: uploadRequest)
        }
        
        return uploadRequest
    }
    
    public func cancelAll() {
        AF.cancelAllRequests()
    }
    
    // MARK: - Private Methods.
    
    private func handle<R: Request>(dataResponse: AFDataResponse<Data>, for request: R) -> Result<R.SuccessResponse, R.FailureResponse> {
        guard let data = dataResponse.data else {
            let error = Error<R.FailureResponse>(httpCode: dataResponse.response?.statusCode, data: dataResponse.data)
            return .failure(error)
        }
        
        do {
            let response = try configuration.decoder.decode(R.SuccessResponse.self, from: data)
            return .data(serializedResponse: response)
        }
        catch (let error) {
            var message: String {
                switch error as? DecodingError {
                case .typeMismatch(_, let context):
                    return context.codingPath.debugDescription
                case .valueNotFound(_, let context):
                    return context.debugDescription
                case .keyNotFound(let codingKey, _):
                    return "Failed to find key '\(codingKey.stringValue)'"
                case .dataCorrupted(let context):
                    return context.debugDescription
                case .none:
                    return "Unknown decoding error"
                @unknown default:
                    return "Unknown decoding error"
                }
            }
            
            if configuration.showsDecoderLogs {
                print(request.method, request.path)
                print(error.localizedDescription)
                print(message)
            }
            
            let error = Error<R.FailureResponse>(httpCode: dataResponse.response?.statusCode, data: dataResponse.data)
            return .failure(error)
        }
    }
    
    private func handle<UR: UploadRequest>(dataResponse: AFDataResponse<Data>, for request: UR) -> UploadResult<UR.SuccessResponse, UR.FailureResponse> {
        guard let data = dataResponse.data else {
            let error = Error<UR.FailureResponse>(httpCode: dataResponse.response?.statusCode, data: dataResponse.data)
            return .failure(error)
        }
        
        do {
            let response = try configuration.decoder.decode(UR.SuccessResponse.self, from: data)
            return .success(response)
        }
        catch (let error) {
            var message: String {
                switch error as? DecodingError {
                case .typeMismatch(_, let context):
                    return context.debugDescription
                case .valueNotFound(_, let context):
                    return context.debugDescription
                case .keyNotFound(let codingKey, _):
                    return "Failed to find key '\(codingKey.stringValue)'"
                case .dataCorrupted(let context):
                    return context.debugDescription
                case .none:
                    return "Unknown decoding error"
                @unknown default:
                    return "Unknown decoding error"
                }
            }
            
            let error = Error<UR.FailureResponse>(httpCode: dataResponse.response?.statusCode, data: dataResponse.data)
            return .failure(error)
        }
    }
    
    private func multipartFormData<UR: UploadRequest>(for uploadRequest: UR) -> MultipartFormData {
        let multipartFormData = MultipartFormData()
        
        for multipartDataItem in uploadRequest.parameters {
            guard let multipartDataItem = multipartDataItem else {
                continue
            }
            
            multipartFormData.append(
                multipartDataItem.data,
                withName: multipartDataItem.key,
                fileName: multipartDataItem.fileName,
                mimeType: multipartDataItem.mimeType
            )
        }
        
        return multipartFormData
    }
    
}
