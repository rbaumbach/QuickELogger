import Foundation

protocol QuickELoggerProtocol {
    func log(message: String, type: LogType)
}

class QuickELogger: NSObject, QuickELoggerProtocol {
    // MARK: - Readonly properties
    
    let filename: String
    
    // MARK: - Private properties
    
    private let engine: QuickELoggerEngineProtocol
    
    // MARK: - Init methods
    
    init(filename: String = "Quick-E-Logger") {
        self.filename = filename
        self.engine = QuickELoggerEngine(filename: filename)
    }
    
    // MARK: - Public methods
    
    func log(message: String, type: LogType) {
        engine.log(message: message, type: type, currentDate: Date())
    }
}
