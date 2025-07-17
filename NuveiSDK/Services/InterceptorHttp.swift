import Foundation
import CryptoKit

@available(iOS 15.0, *)
internal final class InterceptorHttp {
    private let baseURL: URL
    private let testMode: Bool
    
    init(testMode: Bool) {
        self.testMode = testMode
        self.baseURL = URL(string: testMode ? testUrl : prodUrl)!
    }
    
    // Contenedor genérico para respuestas
    struct ServerResponse<T: Codable>: Codable {
        let data: T?
        let error: GeneralErrorModel?
        let resultSize: Int?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
            var dataValue: T?
            var errorValue: GeneralErrorModel?
            var resultSizeValue: Int?
            
            // Iterar sobre todas las claves del JSON
            for key in container.allKeys {
                if key.stringValue == "error" {
                    errorValue = try container.decodeIfPresent(GeneralErrorModel.self, forKey: key)
                } else if key.stringValue == "result_size" {
                    resultSizeValue = try container.decodeIfPresent(Int.self, forKey: key)
                } else {
                    // Intentar decodificar cualquier otra clave como data
                    dataValue = try container.decodeIfPresent(T.self, forKey: key)
                }
            }
            
            self.data = dataValue
            self.error = errorValue
            self.resultSize = resultSizeValue
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: DynamicCodingKeys.self)
            if let data = data {
                // Codificar data con una clave genérica (e.g., "data")
                let key = DynamicCodingKeys(stringValue: "data")!
                try container.encode(data, forKey: key)
            }
            if let error = error {
                try container.encode(error, forKey: DynamicCodingKeys(stringValue: "error")!)
            }
            if let resultSize = resultSize {
                try container.encode(resultSize, forKey: DynamicCodingKeys(stringValue: "result_size")!)
            }
        }
        
        // Clave dinámica para decodificar cualquier clave del JSON
        struct DynamicCodingKeys: CodingKey {
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            var intValue: Int?
            init?(intValue: Int) {
                return nil
            }
        }
    }
    
    func makeRequest<T: Codable>(
        endpoint: String,
        method: String,
        parameters: [String: String]? = nil,
        body: [String: Any]? = nil,
        token: String
    ) async throws -> T {
        let url = try buildURL(endpoint, parameters: parameters)
        let request = try buildRequest(url: url, method: method, body: body, token: token)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeneralErrorModel.networkError
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let serverResponse = try decoder.decode(ServerResponse<T>.self, from: data)
        
        if (200...299).contains(httpResponse.statusCode) {
            if let error = serverResponse.error {
                throw error
            }
            guard let data = serverResponse.data else {
                throw GeneralErrorModel.invalidResponse
            }
            return data
        } else {
            if let error = serverResponse.error {
                throw error
            }
            throw GeneralErrorModel.networkError
        }
    }
    
    private func buildURL(_ endpoint: String, parameters: [String: String]?) throws -> URL {
        guard !endpoint.isEmpty else {
            throw GeneralErrorModel.invalidInput
        }
        
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: true)
        if let params = parameters, !params.isEmpty {
            components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components?.url else {
            throw GeneralErrorModel.invalidInput
        }
        return url
    }
    
    private func buildRequest(url: URL, method: String, body: [String: Any]?, token: String) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.uppercased()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Auth-Token")
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw GeneralErrorModel.invalidInput
            }
        }
        
        return request
    }
}
