import Foundation
import Utensils
@testable import QuickELogger

func documentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

let directoryDict = [ Directory(): documentsDirectory(),
                      Directory(.temp()): FileManager.default.temporaryDirectory,
                      Directory(.library()): FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!,
                      Directory(.caches()): FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!,
                      Directory(.applicationSupport()): FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first! ]

func deleteTestArtifacts() {
    deleteAllTestFiles()
    deleteAllTestDirectories()
}

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

func deleteAllTestDirectories() {
    let fileManager = FileManager.default
    
    directoryDict.forEach { directoryKey, directoryValue in
        guard var allFilePathsDirectory = try? fileManager.contentsOfDirectory(atPath: directoryValue.path) else {
            return
        }
        
        guard allFilePathsDirectory.count != 0 else {
            return
        }
        
        // The library directory has a bunch of system directories, let's not touch those...
        
        if directoryKey == Directory(.library()) {
            allFilePathsDirectory = allFilePathsDirectory.filter { filePath in
                let librarySystemDirs = ["Preferences", "SplashBoard", "Caches", "Saved Application State"]
                
                return !librarySystemDirs.contains(filePath)
            }
        }
        
        allFilePathsDirectory.forEach { documentPath in
            try! fileManager.removeItem(atPath: directoryValue.path + "/" + documentPath)
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
