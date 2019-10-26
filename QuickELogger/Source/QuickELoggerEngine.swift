import Foundation

struct LogMessage: Equatable, Codable {
    var id: String
    var timeStamp: Date
    var type: LogType
    var message: String
}

enum LogType: String, Equatable, Codable {
    case info
    case debug
    case error
}

protocol QuickELoggerEngineProtocol {
    func log(message: String, type: LogType, currentDate: Date)
}

class QuickELoggerEngine: QuickELoggerEngineProtocol {
    // MARK: - Readonly properties
    
    let filename: String
    let fileManager: FileManagerProtocol
    let dataUtils: DataUtilsProtocol
    let uuid: UUIDProtocol
    
    private(set) var jsonEncoder: JSONEncoderProtocol
    private(set) var jsonDecoder: JSONDecoderProtocol

    private(set) lazy var jsonFilePath: URL = {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                        
        return documentsDirectory.appendingPathComponent(filename)
    }()
    
    // MARK: - Init method
    
    init(filename: String,
         fileManager: FileManagerProtocol = FileManager.default,
         jsonEncoder: JSONEncoderProtocol = JSONEncoder(),
         jsonDecoder: JSONDecoderProtocol = JSONDecoder(),
         dataUtils: DataUtilsProtocol = DataUtils(),
         uuid: UUIDProtocol = UUID()) {
        self.filename = filename + ".json"
        self.fileManager = fileManager
        self.jsonEncoder = jsonEncoder
        self.jsonEncoder.outputFormatting = .prettyPrinted
        self.jsonEncoder.dateEncodingStrategy = .iso8601
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.dateDecodingStrategy = .iso8601
        self.dataUtils = dataUtils
        self.uuid = uuid
    }
    
    // MARK: - Public methods
    
    func log(message: String, type: LogType = .debug, currentDate: Date) {
        let logMessage = LogMessage(id: uuid.uuidString,
                                    timeStamp: currentDate,
                                    type: type,
                                    message: message)
        
        var logMessages = getLogMessages()
        logMessages.append(logMessage)
        
        saveLogMessages(messages: logMessages)
    }
    
    // MARK: - Private methods
    
    private func getLogMessages() -> [LogMessage] {
        guard let jsonData = try? dataUtils.loadData(contentsOfPath: jsonFilePath) else {
            return []
        }
        
        guard let logMessages = try? jsonDecoder.decode([LogMessage].self, from: jsonData) else {
            return []
        }
        
        return logMessages
    }
    
    private func saveLogMessages(messages: [LogMessage]) {
        let encodedJSONData = try! jsonEncoder.encode(messages)
        
        try! dataUtils.write(data: encodedJSONData, toPath: jsonFilePath)
    }
}
