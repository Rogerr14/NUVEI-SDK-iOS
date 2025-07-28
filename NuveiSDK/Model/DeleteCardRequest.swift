//
//  DeleteCardRequest.swift
//  NuveiSDK
//
//  Created by Jorge on 28/7/25.
//

struct DeleteCardRequest: Encodable {
    let card: Card
    let user: User
    
    struct Card: Encodable {
        let token: String
    }
    
    struct User: Encodable {
        let id: String
    }
}
