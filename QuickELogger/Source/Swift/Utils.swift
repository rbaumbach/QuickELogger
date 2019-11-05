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
    // MARK: - Readonly properties
    
    let fileManager: FileManagerProtocol
    
    // MARK: - Init methods

    init(fileManager: FileManagerProtocol = FileManager.default) {
        self.fileManager = fileManager
    }
    
    // MARK: - Public methods

    func buildFullFileURL(directory: Directory, filename: String) -> URL {
        var directoryPath: URL

        switch directory {
        case .documents(let path):
            if let path = path {
                directoryPath = systemDirectory(.documentDirectory).appendingPathComponent(path)
                
                createDirectoryIfNoneExists(directoryPath: directoryPath)
            } else {
                directoryPath = systemDirectory(.documentDirectory)
            }
        case .temp(let path):
            if let path = path {
                directoryPath = fileManager.temporaryDirectory.appendingPathComponent(path)
                
                createDirectoryIfNoneExists(directoryPath: directoryPath)
            } else {
                directoryPath = fileManager.temporaryDirectory
            }
        case .library(let path):
            if let path = path {
                directoryPath = systemDirectory(.libraryDirectory).appendingPathComponent(path)
                
                createDirectoryIfNoneExists(directoryPath: directoryPath)
            } else {
                directoryPath = systemDirectory(.libraryDirectory)
            }

        case .caches(let path):
            if let path = path {
                directoryPath = systemDirectory(.cachesDirectory).appendingPathComponent(path)
                
                createDirectoryIfNoneExists(directoryPath: directoryPath)
            } else {
                directoryPath = systemDirectory(.cachesDirectory)
            }

        case .applicationSupport(let path):
            if let path = path {
                directoryPath = systemDirectory(.applicationSupportDirectory).appendingPathComponent(path)
            } else {
                directoryPath = systemDirectory(.applicationSupportDirectory)
            }

            createDirectoryIfNoneExists(directoryPath: directoryPath)

        case .custom(let url):
            directoryPath = url
            
            createDirectoryIfNoneExists(directoryPath: url)
        }

        return directoryPath.appendingPathComponent(filename)
    }
    
    // MARK: - Private methods

    private func systemDirectory(_ directory: FileManager.SearchPathDirectory) -> URL {
        return fileManager.urls(for: directory, in: .userDomainMask).first!
    }
        
    private func createDirectoryIfNoneExists(directoryPath: URL) {
        if !fileManager.fileExists(atPath: directoryPath.path) {
            do {
                try fileManager.createDirectory(at: directoryPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                preconditionFailure("Unable to create directory: \(directoryPath)")
            }
        }
    }
}
