import Foundation

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
