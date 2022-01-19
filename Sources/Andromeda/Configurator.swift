import Foundation

public protocol Configurator {
    var baseURL: String { get }
    var errorHandler: ErrorHandler { get }
    var decoder: JSONDecoder { get }
    var headers: [String: String] { get }
    var showsLogs: Bool { get }
}


