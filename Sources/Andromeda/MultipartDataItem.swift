import UIKit

public struct MultipartDataItem {
    
    // MARK: - Properties.
    
    let key: String
    let data: Data
    let fileName: String?
    let mimeType: String?
    
    // MARK: - Initialization.
    
    public init?(key: String, value: Any?, fileName: String? =  nil, mimeType: String? = nil) {
        var data: Data? {
            if let value = value as? Int {
                return String(value).data(using: .utf8)
            }
            else if let value = value as? Double {
                return String(value).data(using: .utf8)
            }
            else if let value = value as? CGFloat {
                return String(Double(value)).data(using: .utf8)
            }
            else if let value = value as? Bool {
                return String(value).data(using: .utf8)
            }
            else if let value = value as? String {
                return String(value).data(using: .utf8)
            }
            else if let value = value as? Data {
                return value
            }
            else if let _ = value as? UIImage {
                preconditionFailure("Convert UIImage to Data")
            }
            else {
                preconditionFailure("Unsupported data format")
            }
        }
        
        if let data = data {
            self.key = key
            self.data = data
            self.fileName = fileName
            self.mimeType = mimeType
        }
        else {
            return nil
        }
    }
    
}


