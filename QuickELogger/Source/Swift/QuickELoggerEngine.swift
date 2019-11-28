//Copyright (c) 2019 Ryan Baumbach <github@ryan.codes>
//
//Permission is hereby granted, free of charge, to any person obtaining
//a copy of this software and associated documentation files (the
//"Software"), to deal in the Software without restriction, including
//without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to
//permit persons to whom the Software is furnished to do so, subject to
//the following conditions:
//
//The above copyright notice and this permission notice shall be
//included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import Capsule
import Utensils

public struct LogMessage: Equatable, Codable {
    var id: String
    var timeStamp: Date
    var type: LogType
    var message: String
}

protocol QuickELoggerEngineProtocol {
    func log(message: String, type: LogType, currentDate: Date)
}

class QuickELoggerEngine: QuickELoggerEngineProtocol {
    // MARK: - Readonly properties
    
    let filename: String
    let directory: Directory
    let fileManager: FileManagerProtocol
    let dataWrapper: DataWrapperProtocol
    let uuid: UUIDProtocol
    
    private(set) var jsonEncoder: JSONEncoderProtocol
    private(set) var jsonDecoder: JSONDecoderProtocol
    
    // MARK: - Init method
    
    init(filename: String,
         directory: Directory,
         fileManager: FileManagerProtocol = FileManager.default,
         jsonEncoder: JSONEncoderProtocol = JSONEncoder(),
         jsonDecoder: JSONDecoderProtocol = JSONDecoder(),
         dataWrapper: DataWrapperProtocol = DataWrapper(),
         uuid: UUIDProtocol = UUID()) {
        self.filename = filename + ".json"
        self.directory = directory
        self.fileManager = fileManager
        self.jsonEncoder = jsonEncoder
        self.jsonEncoder.outputFormatting = .prettyPrinted
        self.jsonEncoder.dateEncodingStrategy = .iso8601
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.dateDecodingStrategy = .iso8601
        self.dataWrapper = dataWrapper
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
        guard let jsonData = try? dataWrapper.loadData(contentsOfPath: jsonFilePath()) else {
            return []
        }
        
        guard let logMessages = try? jsonDecoder.decode([LogMessage].self, from: jsonData) else {
            return []
        }
        
        return logMessages
    }
    
    private func jsonFilePath() -> URL {
        return directory.url().appendingPathComponent(filename)
    }
    
    private func saveLogMessages(messages: [LogMessage]) {
        let encodedJSONData = try! jsonEncoder.encode(messages)
        
        do {
            try dataWrapper.write(data: encodedJSONData, toPath: jsonFilePath())
        } catch {
            preconditionFailure("Unable to save messages json to file path: \(jsonFilePath())")
        }
    }
}
