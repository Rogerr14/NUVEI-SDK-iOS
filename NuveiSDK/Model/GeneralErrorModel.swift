import Foundation

public struct GeneralErrorModel: Codable, Error {
    public struct APIError: Codable,Error {
        public let type: String
        public let help: String
        public let description: String
    }

    public let error: APIError

    public var errorDescription: String {
        error.description.isEmpty ? "Error desconocido" : error.description
    }
}
