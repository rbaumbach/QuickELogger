import Foundation
@testable import QuickELogger

func documentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

func fullJSONFilepath(filename: String) -> URL {
    return documentsDirectory().appendingPathComponent("\(filename).json")
}

func emptyDocumentsDirectory() {
    let documentsDirectoryPath = documentsDirectory().path
    
    let fileManager = FileManager.default
    
    let allFilePathsInDocumentsDirectory = try! fileManager.contentsOfDirectory(atPath: documentsDirectoryPath)
    
    allFilePathsInDocumentsDirectory.forEach { documentPath in
        try! fileManager.removeItem(atPath: documentsDirectoryPath + "/" + documentPath)
    }
}

func getLogMessages(filename: String = "QuickELogger") -> [LogMessage] {
    let fullPathOfJSONFile = fullJSONFilepath(filename: filename)
    
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

func saveLogMessages(filename: String, messages: [LogMessage]) {
    let fullPathOfJSONFile = fullJSONFilepath(filename: filename)
    
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .iso8601
    
    let encodedJSONData = try! jsonEncoder.encode(messages)
    
    try! encodedJSONData.write(to: fullPathOfJSONFile, options: .atomic)
}
