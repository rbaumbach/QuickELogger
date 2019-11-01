import Foundation
@testable import QuickELogger

class FakeFileManager: FileManagerProtocol {
    // MARK: - Captured properties
    
    var capturedSearchPathDirectory: FileManager.SearchPathDirectory?
    var capturedSearchPathDomainMask: FileManager.SearchPathDomainMask?
    
    // MARK: - Stubbed properties
    
    var stubbedTemporaryDirectory = URL(string: "https://temp.temp")!
    
    var stubbedURLS = [URL(string: "https://ryan.codes")!,
                       URL(string: "https://theaccidentalengineer.com")!]
    
    // MARK: - <FileManagerProtocol>
    
    var temporaryDirectory: URL {
        return stubbedTemporaryDirectory
    }
    
    func urls(for directory: FileManager.SearchPathDirectory,
              in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        capturedSearchPathDirectory = directory
        capturedSearchPathDomainMask = domainMask
        
        return stubbedURLS
    }
}
