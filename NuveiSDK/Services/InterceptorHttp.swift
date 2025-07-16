//
//  interceptorHttp.swift
//  NuveiSdk
//
//  Created by Jorge on 15/7/25.
//
import Foundation
import CryptoKit

class InterceptorHttp{
    
    
    private let testMode: Bool
    
    init(testMode: Bool) {
        self.testMode = testMode
    }
    
    private func buildUrl(_ endpoint:String, parameters: [String: String]?) -> String{
        let baseUrl = testMode ? testUrl : prodUrl
        var finalUrl = baseUrl + endpoint
        if let params = parameters, !params.isEmpty {
            let queryString = encodeParamsGet(params)
            finalUrl += "?\(queryString)"
        }
        return finalUrl;
    }
    
    
    private func encodeParamsGet(_ parameters: [String: String]) -> String {
            var queryItems: [String] = []
            for (key, value) in parameters {
                guard let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    continue
                }
                queryItems.append("\(escapedKey)=\(escapedValue)")
            }
            return queryItems.joined(separator: "&")
   }
    
    private func encodeParamsJson(_ parameters: [String: Any]) -> Data? {
            do {
                return try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                print("Error codificando JSON: \(error)")
                return nil
            }
   }
    
    struct ServerResponse: Codable {
            let data: [String: AnyCodable]?
            let message: String
            let error: Bool
        }
    
    func makeRequestV2(
            endpoint: String,
            parameters: [String: String]? = nil,
            body: [String: Any]? = nil,
            appCode: String,
            appKey: String,
            methodHttp: String,
            responseCallback: @escaping (Error?, Int?, ServerResponse?) -> Void
        ) {
            let completeUrl = buildUrl(endpoint, parameters: parameters)
            guard let url = URL(string: completeUrl) else {
                let error = NSError(domain: "NuveiRequest", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
                responseCallback(error, nil, nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = methodHttp
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(GlobalHelper.generateAuthToken(key: appKey, code: appCode), forHTTPHeaderField: "Auth-Token")
            
            if let body = body {
                request.httpBody = encodeParamsJson(body)
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    responseCallback(error, 400, nil)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    let error = NSError(domain: "PaymentRequest", code: 400, userInfo: [NSLocalizedDescriptionKey: "Respuesta inválida"])
                    responseCallback(error, 400, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let serverResponse = try decoder.decode(ServerResponse.self, from: data)
                    responseCallback(nil, httpResponse.statusCode, serverResponse)
                } catch {
                    let parsingError = NSError(domain: "JSON", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error parseando JSON: \(error)"])
                    responseCallback(parsingError, httpResponse.statusCode, nil)
                }
            }
            task.resume()
        }

}


// Estructura auxiliar para manejar valores dinámicos en JSON
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self.value = string
        } else if let int = try? container.decode(Int.self) {
            self.value = int
        } else if let double = try? container.decode(Double.self) {
            self.value = double
        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
        } else if let array = try? container.decode([AnyCodable].self) {
            self.value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Tipo no soportado")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let string as String:
            try container.encode(string)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let bool as Bool:
            try container.encode(bool)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Tipo no soportado"))
        }
    }
}
