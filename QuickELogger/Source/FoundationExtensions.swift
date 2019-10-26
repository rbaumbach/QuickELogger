import Foundation

extension JSONEncoder.DateEncodingStrategy: Equatable {
    // MARK: - <Equatable>
    
    public static func == (lhs: JSONEncoder.DateEncodingStrategy, rhs: JSONEncoder.DateEncodingStrategy) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}

extension JSONDecoder.DataDecodingStrategy: Equatable {
    // MARK: - <Equatable>
    
    public static func == (lhs: JSONDecoder.DataDecodingStrategy, rhs: JSONDecoder.DataDecodingStrategy) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}
