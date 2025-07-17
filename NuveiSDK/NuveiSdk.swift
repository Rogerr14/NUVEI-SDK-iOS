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
    }
    
    public static func listCardAvaliables(uid: String) async throws -> [CardModel] {
        guard !uid.isEmpty else {
            throw GeneralErrorModel.invalidInput
        }
        
        guard let interceptor = shared.interceptoHttp else {
            throw GeneralErrorModel(code: 400, description: "SDK no inicializado. Llame a initEnvironment primero.", help: nil, type: "sdk_not_initialized")
        }
        
        let token = GlobalHelper.generateAuthToken(key: shared.serverKey, code: shared.serverCode)
        let response = try await interceptor.makeRequest(
            endpoint: "v2/card/list",
            method: "GET",
            parameters: ["uid": uid],
            token: token
        ) as [CardModel]
        
        return response
    }
}
