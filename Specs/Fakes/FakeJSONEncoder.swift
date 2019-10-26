import Foundation
@testable import QuickELogger

class FakeJSONEncoder: JSONEncoderProtocol {
    // MARK: - Captured properties
    
    var capturedOutputFormatting: JSONEncoder.OutputFormatting?
    var capturedDateEncodingStrategy: JSONEncoder.DateEncodingStrategy?
    var capturedEncodeValue: Any?
        
    // MARK: - Stubbed properties
    
    var stubbedOutputFormatting = JSONEncoder.OutputFormatting.prettyPrinted
    var stubbedDateEncodingStrategy = JSONEncoder.DateEncodingStrategy.iso8601
    
    var stubbedEncodeData = "tacos".data(using: .utf8)!
        
    // MARK: - <JSONEncoderProtocol>
    
    var outputFormatting: JSONEncoder.OutputFormatting {
        get {
            return stubbedOutputFormatting
        }
        
        set(newOutputFormatting) {
            capturedOutputFormatting = newOutputFormatting
        }
    }
    
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        get {
            return stubbedDateEncodingStrategy
        }
        
        set(newDateEncodingStrategy) {
            capturedDateEncodingStrategy = newDateEncodingStrategy
        }
    }
    
    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        capturedEncodeValue = value
        
        return stubbedEncodeData
    }
}
