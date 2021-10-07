import Foundation

public protocol Configurator {
    var baseURL: String { get }
    var errorHandler: ErrorHandler { get }
    var decoder: JSONDecoder { get }
}


