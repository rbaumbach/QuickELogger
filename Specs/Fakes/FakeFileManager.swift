import Foundation
@testable import QuickELogger

class FakeFileManager: FileManagerProtocol {
    // MARK: - Captured properties
    
    var capturedSearchPathDirectory: FileManager.SearchPathDirectory?
    var capturedSearchPathDomainMask: FileManager.SearchPathDomainMask?
    
    var capturedFileExistsPath: String?
    
    var capturedCreateDirectoryURL: URL?
    var capturedCreateDirectoryCreateIntermediates: Bool?
    var capturedCreateDirectoryAttributes: [FileAttributeKey: Any]?
    
    // MARK: - Stubbed properties
        
    var stubbedTemporaryDirectory: URL = {
        var components = URLComponents()
        components.scheme = "file"
        components.host = ""
        components.path = "/fake-temp-directory"
        
        return components.url!
    }()
    
    var stubbedURLs: [URL] = {
        var components = URLComponents()
        components.scheme = "file"
        components.host = ""
        components.path = "/fake-directory/extra-fake-directory"
        
        return [components.url!, URL(string: "https://theaccidentalengineer.com")!]
    }()
    
    var stubbedFileExistsPath = false
    
    // MARK: - <FileManagerProtocol>
    
    var temporaryDirectory: URL {
        return stubbedTemporaryDirectory
    }
    
    func urls(for directory: FileManager.SearchPathDirectory,
              in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        capturedSearchPathDirectory = directory
        capturedSearchPathDomainMask = domainMask
        
        return stubbedURLs
    }
    
    func fileExists(atPath path: String) -> Bool {
        capturedFileExistsPath = path
        
        return stubbedFileExistsPath
    }
    
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws {
        capturedCreateDirectoryURL = url
        capturedCreateDirectoryCreateIntermediates = createIntermediates
        capturedCreateDirectoryAttributes = attributes
    }
}
