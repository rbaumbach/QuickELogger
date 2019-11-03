import Foundation
@testable import QuickELogger

func getLogMessages(filename: String = "QuickELogger", directory: Directory = .documents) -> [LogMessage] {
    var fullPathOfJSONFile: URL
    
    switch directory {
    case .documents:
        fullPathOfJSONFile = directoryDict[.documents]!.appendingPathComponent("\(filename).json")
        
    case .temp:
        fullPathOfJSONFile = directoryDict[.temp]!.appendingPathComponent("\(filename).json")
        
    case .library:
        fullPathOfJSONFile = directoryDict[.library]!.appendingPathComponent("\(filename).json")
    
    case .caches:
        fullPathOfJSONFile = directoryDict[.caches]!.appendingPathComponent("\(filename).json")
    
    case .applicationSupport:
        fullPathOfJSONFile = directoryDict[.applicationSupport]!.appendingPathComponent("\(filename).json")
        
    case .custom(let url):
        fullPathOfJSONFile = url.appendingPathComponent("\(filename).json")
    }
            
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
