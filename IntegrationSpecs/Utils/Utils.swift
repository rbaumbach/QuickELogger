import Foundation
@testable import QuickELogger

func getLogMessages(filename: String = "QuickELogger", directory: Directory = .documents()) -> [LogMessage] {    
    let fullFilename = filename + ".json"
    
    let fullPathOfJSONFile = FileUtils().buildFullFileURL(directory: directory,
                                                          filename: fullFilename)
                
    guard let jsonData = try? Data(contentsOf: fullPathOfJSONFile, options: .alwaysMapped) else {
        return []
    }
    
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .iso8601

    guard let logMessages = try? jsonDecoder.decode([LogMessage].self, from: jsonData) else {
        return []
    }

    return logMessages
}
