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

// MARK: - DataUtils

protocol DataUtilsProtocol {
    func loadData(contentsOfPath: URL) throws -> Data
    func write(data: Data, toPath path: URL) throws
}

class DataUtils: DataUtilsProtocol {
    func loadData(contentsOfPath path: URL) throws -> Data {
        return try Data(contentsOf: path, options: .alwaysMapped)
    }
    
    func write(data: Data, toPath path: URL) throws {
        try data.write(to: path, options: .atomic)
    }
}

// MARK: - FileUtils

protocol FileUtilsProtocol {
    func buildFullFileURL(directory: Directory, filename: String) -> URL
}

class FileUtils: FileUtilsProtocol {
    let fileManager: FileManagerProtocol
    
    init(fileManager: FileManagerProtocol = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func buildFullFileURL(directory: Directory, filename: String) -> URL {
        var directoryPath: URL
        
        switch directory {
        case .documents:
            directoryPath = systemDirectory(.documentDirectory)
            
        case .temp:
            directoryPath = fileManager.temporaryDirectory
            
        case .library:
            directoryPath = systemDirectory(.libraryDirectory)
            
        case .caches:
            directoryPath = systemDirectory(.cachesDirectory)
            
        case .applicationSupport:
            directoryPath = systemDirectory(.applicationSupportDirectory)
            
            if !fileManager.fileExists(atPath: directoryPath.path) {
                try! fileManager.createDirectory(at: directoryPath,
                                                 withIntermediateDirectories: false,
                                                 attributes: nil)
            }
        }
                                
        return directoryPath.appendingPathComponent(filename)
    }
    
    private func systemDirectory(_ directory: FileManager.SearchPathDirectory) -> URL {
        return fileManager.urls(for: directory, in: .userDomainMask).first!
    }
}
