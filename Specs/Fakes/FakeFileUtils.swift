import Foundation
@testable import QuickELogger

class FakeFileUtils: FileUtilsProtocol {
    // MARK: - Captured properties
    
    var capturedBuildFullFileURLDirectory: Directory?
    var capturedBuildFullFileURLFilename: String?
    
    // MARK: - Stubbed properties
    
    var stubbedBullFullFileURL: URL = {
        var components = URLComponents()
        components.scheme = "file"
        components.host = ""
        components.path = "/fake-directory/fakefilename.json"
        
        return components.url!
    }()
    
    // MARK: - <FileUtilsProtocol>
    
    func buildFullFileURL(directory: Directory, filename: String) -> URL {
        capturedBuildFullFileURLDirectory = directory
        capturedBuildFullFileURLFilename = filename
        
        return stubbedBullFullFileURL
    }
}
