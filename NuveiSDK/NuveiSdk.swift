//
//  NuveiSDK.swift
//  NuveiSDK
//
//  Created by Jorge on 16/7/25.
//

import Foundation

public final class NuveiSdk {
    private static let shared = NuveiSdk()
    private var testMode: Bool = false
    private var appCode: String = ""
    private var appKey: String = ""
    private var serverCode: String = ""
    private var serverKey: String = ""
    private var interceptoHttp: InterceptorHttp?
    
    public static func initEnvironment(appCode: String, appKey: String, serverCode: String, serverKey: String, testMode: Bool) {
        shared.testMode = testMode
        shared.appCode = appCode
        shared.appKey = appKey
        shared.serverCode = serverCode
        shared.serverKey = serverKey
        shared.interceptoHttp = InterceptorHttp(testMode: testMode)
        print("Environments ok: environments ok")
    }
    
    public static func listCardAvaliables(uid: String) async throws -> [CardModel] {
        guard !uid.isEmpty else {
            print("prueba de guard")
            throw GeneralErrorModel(error: GeneralErrorModel.APIError(type: "Invalid input", help: "", description: "Empty UID"))
        }
        
        guard let interceptor = shared.interceptoHttp else {
            print("fallo")
            throw GeneralErrorModel(error: GeneralErrorModel.APIError(type: "Invalid configuration", help: "", description: "Request http not valid"))
        }
        print("Entra hasta antes del token")
        let token = GlobalHelper.generateAuthToken(key: shared.serverKey, code: shared.serverCode)
        print(token)
        
            let response = try await interceptor.makeRequest(
                endpoint: "v2/card/list",
                method: "GET",
                parameters: ["uid": uid],
                token: token,
                responseType: CardListContainer.self
            )
            print("cantidad: \(response)")
        return response.cards
       
       
    }
    
    
    public static func deleteCard(uid: String, tokenCard : String)async throws -> String {
        
        guard !uid.isEmpty, !tokenCard.isEmpty else{
            throw GeneralErrorModel.APIError(type: "Invalid input", help: "", description: "Empty data")
        }
        guard let interceptor = shared.interceptoHttp else {
            throw GeneralErrorModel.APIError(type: "Invalid configuration", help: "", description: "Request http not valid")
        }
        let token = GlobalHelper.generateAuthToken(key: shared.serverKey, code: shared.serverCode)
        let requestBody = DeleteCardRequest(
            card: DeleteCardRequest.Card(token: tokenCard),
            user: DeleteCardRequest.User(id: uid)
        )
        
        let bodyData = try JSONEncoder().encode(requestBody)
        
        let response = try await interceptor.makeRequest(
            endpoint: "v2/card/delete/",
            method: "POST",
            body: bodyData,
            token: token,
            responseType: MessageResponse.self
        )
        
        return response.message
        
    }
    
    
    
    
    
    public static func addCard(cardModel: CardModel, uid: String, email: String) async throws -> CardModel{
        
       
        
        guard let interceptor = shared.interceptoHttp else {
            throw GeneralErrorModel.APIError(type: "Invalid configuration", help: "", description: "Request http not valid")
        }
        let token = GlobalHelper.generateAuthToken(key: shared.serverKey, code: shared.serverCode)
        
        
        let userDict: [String: String] = [
                  "id": uid,
                  "email": email
              ]

              // Codificar el modelo cardModel a diccionario JSON
              let cardData = try JSONEncoder().encode(cardModel)
              let cardJson = try JSONSerialization.jsonObject(with: cardData) as? [String: Any] ?? [:]

              let bodyDict: [String: Any] = [
                  "user": userDict,
                  "card": cardJson
              ]
              let bodyData = try JSONSerialization.data(withJSONObject: bodyDict)

        
        let response = try await interceptor.makeRequest(
            endpoint: "v2/card/delete/",
            method: "POST",
            body: bodyData,
            token: token,
            responseType: CardContainer.self
        )
        
        return response.card
    }
}
