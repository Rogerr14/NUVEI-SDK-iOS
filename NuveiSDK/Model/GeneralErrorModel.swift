//
//  GeneralErrorModel.swift
//  NuveiSDK
//
//  Created by Jorge on 17/7/25.
//
import Foundation

@available(iOS 15.0, *)
public struct GeneralErrorModel: Codable, LocalizedError {
    public let code: Int 
    public let descriptionData: String
    public let help: String?
    public let type: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case descriptionData = "message"
        case help
        case type
    }
    
    public init(code: Int, description: String, help: String?, type: String?) {
        self.code = code
        self.descriptionData = description
        self.help = help
        self.type = type
    }
    
    public var errorDescription: String? {
        descriptionData
    }
    
    public var recoverySuggestion: String? {
        help
    }
    
    public static func createError(_ err: Error) -> GeneralErrorModel {
        return GeneralErrorModel(
            code: (err as NSError).code,
            description: err.localizedDescription,
            help: nil,
            type: nil
        )
    }
    
    public static func createError(_ code: Int, description: String, help: String?, type: String?) -> GeneralErrorModel {
        return GeneralErrorModel(code: code, description: description, help: help, type: type)
    }
    
    
    // Predefined error cases
        public static let invalidInput = GeneralErrorModel(code: 400, description: "invalid Input", help: "", type: "invalid_input")
        public static let networkError = GeneralErrorModel(code: 503, description: "Error Network", help: "Review your internet connection", type: "network_error")
        public static let unauthorized = GeneralErrorModel(code: 401, description: "No Authorize", help: "review credentials", type: "auth_error")
        public static let invalidResponse = GeneralErrorModel(code: 500, description: "Internal Server Error", help: "Contact to support", type: "server_error")
    
}
