import Foundation
@testable import QuickELogger

let directoryDict = [ Directory.documents: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!,
                      Directory.temp: FileManager.default.temporaryDirectory,
                      Directory.library: FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!,
                      Directory.caches: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! ]

func deleteAllTestFiles() {
    let fileManager = FileManager.default
    
    directoryDict.values.forEach { directory in
        guard let allFilePathsDirectory = try? fileManager.contentsOfDirectory(atPath: directory.path) else {
            return
        }
        
        guard allFilePathsDirectory.count != 0 else {
            return
        }
                
        let files = allFilePathsDirectory.filter { filePath in
            return !isFilePathStringADirectory(filePath: directory.path + "/" + filePath)
        }
        
        guard files.count != 0 else {
            return
        }
        
        files.forEach { documentPath in
            try! fileManager.removeItem(atPath: directory.path + "/" + documentPath)
        }
    }
}

func isFilePathStringADirectory(filePath: String) -> Bool {
    var isDirectory: ObjCBool = false

    if FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory) {
        return isDirectory.boolValue
    } else {
        return false
    }
}
