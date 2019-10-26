import Foundation

// MARK: - FileManager

protocol FileManagerProtocol {
    func urls(for directory: FileManager.SearchPathDirectory,
              in domainMask: FileManager.SearchPathDomainMask) -> [URL]
}

extension FileManager: FileManagerProtocol { }

// MARK: - JSONEncoder

protocol JSONEncoderProtocol {
    var outputFormatting: JSONEncoder.OutputFormatting { get set }
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get set }
    
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

extension JSONEncoder: JSONEncoderProtocol { }

// MARK: - JSONDecoder

protocol JSONDecoderProtocol {
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get set }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: JSONDecoderProtocol { }

// MARK: - UUID

protocol UUIDProtocol {
    var uuidString: String { get }
}

extension UUID: UUIDProtocol { }
