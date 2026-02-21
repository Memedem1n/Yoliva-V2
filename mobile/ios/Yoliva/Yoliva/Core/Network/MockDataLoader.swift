// mobile/ios/Yoliva/Yoliva/Core/Network/MockDataLoader.swift
import Foundation

/// Utility to load and decode mock JSON data from the application bundle.
final class MockDataLoader {
    static let shared = MockDataLoader()
    private init() {}
    
    enum MockError: Error {
        case fileNotFound, dataLoadingFailed, decodingError(Error)
    }
    
    /// Loads a JSON file and decodes it into the specified type.
    /// - Parameter fileName: The name of the JSON file (without extension).
    /// - Returns: Decoded object of type T.
    func load<T: Decodable>(_ fileName: String) throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw MockError.fileNotFound
        }
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw MockError.dataLoadingFailed
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw MockError.decodingError(error)
        }
    }
}
