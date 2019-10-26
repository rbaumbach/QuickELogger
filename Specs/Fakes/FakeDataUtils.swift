import Foundation
@testable import QuickELogger

class FakeDataUtils: DataUtilsProtocol {
    // MARK: - Captured properties
    
    var capturedLoadDataURL = URL(string: "file://junk")
    var capturedWriteData: Data?
    var capturedWriteURL: URL?
    
    // MARK: - Stubbed properties
    
    var stubbedLoadData = "burritos".data(using: .utf8)!
    
    // MARK: - Exceptions
    
    var shouldThrowLoadDataException = false
    var shouldThrowWriteException = false
    
    // MARK: - <DataUtilsProtocol>
    
    func loadData(contentsOfPath: URL) throws -> Data {
        capturedLoadDataURL = contentsOfPath
        
        if shouldThrowLoadDataException {
            throw FakeError.whoCares
        } else {
            return stubbedLoadData
        }
    }
    
    func write(data: Data, toPath path: URL) throws {
        capturedWriteData = data
        capturedWriteURL = path
        
        if shouldThrowWriteException {
            throw FakeError.whoCares
        }
    }
}
