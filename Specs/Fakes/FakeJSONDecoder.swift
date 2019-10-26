import Foundation
@testable import QuickELogger

class FakeJSONDecoder<T>: JSONDecoderProtocol {
    // MARK: - Captured properties
    
    var capturedDateDecodingStrategy: JSONDecoder.DateDecodingStrategy?
    
    var capturedDecodeTypeAsString: String?
    var capturedDecodeData: Data?
        
    // MARK: - Stubbed properties
    
    var stubbedDateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
    var stubbedDecodedJSON: T?
    
    // MARK: - Exceptions
    
    var shouldThrowDecodeException = false
        
    // MARK: - <JSONDecoderProtocol>
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        get {
            return stubbedDateDecodingStrategy
        }
        
        set(newDateDecodingStrategy) {
            capturedDateDecodingStrategy = newDateDecodingStrategy
        }
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        capturedDecodeTypeAsString = "\(T.Type.self)"
        capturedDecodeData = data
        
        if shouldThrowDecodeException {
            throw FakeError.whoCares
        }
        
        if let stubbedDecodedJSON = stubbedDecodedJSON {
            return stubbedDecodedJSON as! T
        } else {
            preconditionFailure("FakeJSONDecoder.stubbedDecodedJSON property has not been set")
        }
    }
}
