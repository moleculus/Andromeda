import Foundation
import Pulse
import Logging

public protocol Configurator {
    var baseURL: String { get }
    var errorHandler: ErrorHandler { get }
    var decoder: JSONDecoder { get }
    var loggerStore: LoggerStore { get }
    var logger: Logger { get }
}

