        import Foundation

        struct MessageResponse: Codable {
            let message: String
        }
       
struct CardListContainer: Codable {
    let resultSize: Int
    let cards: [CardModel]
    
    enum CodingKeys: String, CodingKey {
        case resultSize = "result_size"
        case cards
    }
}

        struct CardContainer: Codable {
            let card: CardModel
        }

        @available(iOS 15.0, *)
        internal final class InterceptorHttp {
            private let baseURL: URL
            
            init(testMode: Bool) {
                guard let base =  URL(string: testMode ? testUrl : prodUrl) else{
                    fatalError("Invalid base URL")
                }
                self.baseURL = base
            }
            
            
           
            // Contenedor genérico para respuestas
            struct ServerResponse<T: Codable>: Codable {
                let value: T?
                let error: GeneralErrorModel?
                
                
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
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
                    var value: T?
                    var error: GeneralErrorModel?
                    
                    // Iterar sobre todas las claves del JSON
                    for key in container.allKeys {
                        if key.stringValue == "error" {
                            error = try container.decodeIfPresent(GeneralErrorModel.self, forKey: key)
                        } else  {
                            value = try container.decode(T.self, forKey: key)
                        }
                    }
                    
                    self.value = value
                    self.error = error
                }
              
            }
            
            func makeRequest<T: Codable>(
                endpoint: String,
                method: String = "GET",
                parameters: [String: String]? = nil,
                body: Data? = nil,
                token: String,
                responseType: T.Type
            ) async throws -> T {
                let url = try buildURL(endpoint, parameters: parameters)
                let request = try buildRequest(url: url, method: method, body: body, token: token)
                print("request \(String(describing: request.allHTTPHeaderFields))")
                
                let (data, response) = try await URLSession.shared.data(for: request)
               
                if let rawString = String(data: data, encoding: .utf8){
                    print("Respuesta JSON: \(rawString)")
                }else{
                    print("incodeableeee")
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("entra a esta parte")
                    throw GeneralErrorModel(error: GeneralErrorModel.APIError(
                                   type: "Invalid http response",
                                   help: "Invalid http response",
                                   description: ""
                               ))
        //            throw PaymentError.networkError("Invalid http response")
                }
                print(httpResponse.statusCode)
                print("avanza antes del decoder")
                
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                
                switch httpResponse.statusCode {
                        case 200..<300:
                            // Intentamos decodificar la respuesta genérica
                            do {
                                return try decoder.decode(responseType, from: data)
                            } catch {
                                // Intentamos decodificar solo un mensaje (caso { "message": "card deleted" })
                                if responseType == MessageResponse.self {
                                    let msgResp = try decoder.decode(MessageResponse.self, from: data)
                                    guard let casted = msgResp as? T else { throw error }
                                    return casted
                                }
                                throw GeneralErrorModel(
                                    error: GeneralErrorModel.APIError(
                                               type: "Invalid http response",
                                               help: "",
                                               description: "Failed to decoding response"
                                           ))
                            }
                        
                        case 400..<500:
                            print("entra aqui")
                    if let apiError = try? decoder.decode(GeneralErrorModel.self, from: data) {
                                print("eenndns")
                                throw apiError
                            }
                    throw GeneralErrorModel(error: GeneralErrorModel.APIError(
                                   type: "Invalid input",
                                   help: "",
                                   description: ""
                                   ))
                        case 500..<600:
                    throw GeneralErrorModel(error: GeneralErrorModel.APIError(type: "Server Error", help: "", description: "Contact to Admin Server"))
                        default:
                            throw GeneralErrorModel(error: GeneralErrorModel.APIError(type: "Server Error", help: "", description: "Contact to Admin Server"))
                        }
            }
            
            
            private func buildURL(_ endpoint: String, parameters: [String: String]?) throws -> URL {
                guard !endpoint.isEmpty else {
                    throw GeneralErrorModel(error: GeneralErrorModel.APIError(type: "Invalid input", help: "", description: "Empty endpoint"))
                }

                var components = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: true)
                if let params = parameters {
                    components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
                }

                guard let finalURL = components?.url else {
                    throw GeneralErrorModel(error: GeneralErrorModel.APIError(type: "Invalid input", help: "", description: "Failed to build request"))
                }

                return finalURL
            }
            
            private func buildRequest(url: URL, method: String, body: Data?, token: String) throws -> URLRequest {
                print("----------------")
                print(token)
                    var request = URLRequest(url: url)
                    request.httpMethod = method.uppercased()
                let sanitizedToken = token.trimmingCharacters(in: .whitespacesAndNewlines)
                print("sabitize \(sanitizedToken)")
//                request.addValue(token, forHTTPHeaderField: "Auth-Token")
                request.addValue(token, forHTTPHeaderField: "Auth-Token")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    
                    if let body = body {
                        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                    }
                print(request.allHTTPHeaderFields ?? "")
                    return request
                }
        }
