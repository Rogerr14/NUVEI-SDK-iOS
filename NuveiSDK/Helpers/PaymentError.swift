//
//  PaymentError.swift
//  NuveiSDK
//
//  Created by Jorge on 17/7/25.
//

import Foundation

@available(iOS 15.0, *)
public enum PaymentError: Error, LocalizedError {
    case invalidInput(String)
    case networkError(String)
    case invalidResponse
    case serverError(String)
    case unauthorized
    case insufficientParameters
    case invalidFormat
    case operationNotAllowed
    case invalidConfiguration
    
    public var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return message
        case .networkError(let message):
            return "Error de red: \(message)"
        case .invalidResponse:
            return "Respuesta del servidor no válida"
        case .serverError(let message):
            return "Error del servidor: \(message)"
        case .unauthorized:
            return "No autorizado"
        case .insufficientParameters:
            return "Parámetros insuficientes"
        case .invalidFormat:
            return "Formato inválido"
        case .operationNotAllowed:
            return "Operación no permitida"
        case .invalidConfiguration:
            return "Configuración inválida"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidInput:
            return "Verifica los datos proporcionados e intenta de nuevo."
        case .networkError:
            return "Revisa tu conexión a internet e intenta de nuevo."
        case .invalidResponse, .serverError:
            return "Contacta al soporte técnico."
        case .unauthorized:
            return "Verifica tus credenciales de autenticación."
        case .insufficientParameters:
            return "Asegúrate de proporcionar todos los parámetros requeridos."
        case .invalidFormat:
            return "Corrige el formato de los datos e intenta de nuevo."
        case .operationNotAllowed:
            return "Esta operación no está permitida. Contacta al soporte."
        case .invalidConfiguration:
            return "Revisa la configuración del SDK e intenta de nuevo."
        }
    }
}
