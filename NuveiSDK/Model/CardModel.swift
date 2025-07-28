////
////  CardModel.swift
////  NuveiSdk
////
////  Created by Jorge on 16/7/25.
////
//
//import Foundation
//
//
////typo of disponibilities card
//public enum PaymentCardType: String {
//    case visa = "vi"
//    case masterCard = "mc"
//    case amex = "ax"
//    case diners = "di"
//    case discover = "dc"
//    case jcb = "jb"
//    case elo = "el"
//    case credisensa = "cs"
//    case solidario = "so"
//    case exito = "ex"
//    case alkosto = "ak"
//    case notSupported = ""
//}
//
//
////card prefixes
let REGEX_AMEX = "^3[47][0-9]{5,}$"
let REGEX_VISA = "^4[0-9]{6,}$"
let REGEX_MASTERCARD = "^5[1-5][0-9]{5,}$"
let REGEX_DINERS = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
let REGEX_DISCOVER = "^65[4-9][0-9]{13}|64[4-9][0-9]{13}|6011[0-9]{12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10})$"
let REGEX_JCB = "^(?:2131|1800|35[0-9]{3})[0-9]{11}$"

//import SwiftUI
//
//@available(iOS 15.0, *)
//public struct CardModel: Codable, Identifiable {
//    public var id = UUID()
//    public var status: String?
//    public var transactionId: String?
//    public var token: String?
//    public var cardHolderName: String
//    public var fiscalNumber: String?
//    public var termination: String?
//    public var isDefault: Bool
//    public var expiryMonth: String
//    public var expiryYear: String
//    public var bin: String?
//    public var nip: String?
//    public var msg: String?
//    public var cardImage: Image {
//            let imageName = GlobalHelper.getCardTypeAsset(cardType: cardType)
//            if let uiImage = UIImage(named: imageName, in: Bundle.module, compatibleWith: nil) {
//                return Image(uiImage: uiImage)
//            }
//            return Image(systemName: "creditcard") // Fallback
//        }
//    public var cardType: PaymentCardType
//    public var cardNumber: String {
//        didSet {
//                self.termination = String(self.cardNumber.suffix(4))
//            
//        }
//    }
//    private var cvc: String?
//    public var type: String? {
//        didSet {
//            guard let type = type else { return }
//            switch type.lowercased() {
//            case "vi": self.cardType = .visa
//            case "ax": self.cardType = .amex
//            case "mc": self.cardType = .masterCard
//            case "di": self.cardType = .diners
//            case "al": self.cardType = .alkosto
//            case "ex": self.cardType = .exito
//            default: self.cardType = .notSupported
//            }
//        }
//    }
//    
//    public enum PaymentCardType: String, Codable {
//        case visa = "vi"
//        case masterCard = "mc"
//        case amex = "ax"
//        case diners = "di"
//        case discover = "dc"
//        case jcb = "jb"
//        case elo = "el"
//        case credisensa = "cs"
//        case solidario = "so"
//        case exito = "ex"
//        case alkosto = "ak"
//        case notSupported = ""
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case status
//        case transactionId = "transaction_reference"
//        case token
//        case cardHolderName = "holder_name"
//        case fiscalNumber
//        case isDefault
//        case expiryMonth = "expiry_month"
//        case expiryYear = "expiry_year"
//        case bin
//        case nip
//        case msg = "message"
//        case type
//        case cardNumber = "number"
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        status = try container.decodeIfPresent(String.self, forKey: .status)
//        transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
//        token = try container.decodeIfPresent(String.self, forKey: .token)
//        cardHolderName = try container.decodeIfPresent(String.self, forKey: .cardHolderName)!
//        fiscalNumber = try container.decodeIfPresent(String.self, forKey: .fiscalNumber)
//        cardNumber = try container.decodeIfPresent(String.self, forKey: .cardNumber)!
//        isDefault = try container.decodeIfPresent(Bool.self, forKey: .isDefault) ?? false
//        expiryMonth = try container.decodeIfPresent(String.self, forKey: .expiryMonth)!
//        expiryYear = try container.decodeIfPresent(String.self, forKey: .expiryYear)!
//        bin = try container.decodeIfPresent(String.self, forKey: .bin)
//        nip = try container.decodeIfPresent(String.self, forKey: .nip)
//        msg = try container.decodeIfPresent(String.self, forKey: .msg)
//        type = try container.decodeIfPresent(String.self, forKey: .type)
//        cardType = PaymentCardType(rawValue: type ?? "") ?? .notSupported
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(status, forKey: .status)
//        try container.encodeIfPresent(transactionId, forKey: .transactionId)
//        try container.encodeIfPresent(token, forKey: .token)
//        try container.encodeIfPresent(cardHolderName, forKey: .cardHolderName)
//        try container.encodeIfPresent(fiscalNumber, forKey: .fiscalNumber)
//        try container.encodeIfPresent(cardNumber, forKey: .cardNumber)
//        try container.encode(isDefault, forKey: .isDefault)
//        try container.encodeIfPresent(expiryMonth, forKey: .expiryMonth)
//        try container.encodeIfPresent(expiryYear, forKey: .expiryYear)
//        try container.encodeIfPresent(bin, forKey: .bin)
//        try container.encodeIfPresent(nip, forKey: .nip)
//        try container.encodeIfPresent(msg, forKey: .msg)
//        try container.encodeIfPresent(type, forKey: .type)
//        try container.encodeIfPresent(cardNumber, forKey: .cardNumber)
//    }
//    
//    public init(status: String? = nil,
//                transactionId: String? = nil,
//                token: String? = nil,
//                cardHolderName: String,
//                fiscalNumber: String? = nil,
//                termination: String? = nil,
//                isDefault: Bool = false,
//                expiryMonth: String,
//                expiryYear: String,
//                bin: String? = nil,
//                nip: String? = nil,
//                msg: String? = nil,
//                cardType: PaymentCardType = .notSupported,
//                cardNumber: String,
//                cvc: String? = nil) {
//        self.status = status
//        self.transactionId = transactionId
//        self.token = token
//        self.cardHolderName = cardHolderName
//        self.fiscalNumber = fiscalNumber
//        self.termination = termination
//        self.isDefault = isDefault
//        self.expiryMonth = expiryMonth
//        self.expiryYear = expiryYear
//        self.bin = bin
//        self.nip = nip
//        self.msg = msg
//        self.cardType = cardType
//        self.cardNumber = cardNumber
//        self.cvc = cvc
//    }
//    
//    public static func createCard(cardHolderName: String, cardNumber: String, expiryMonth: NSInteger, expiryYear: NSInteger, cvc: String) -> CardModel? {
//        let today = Date()
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.month, .year], from: today)
//        let todayMonth = components.month!
//        let todayYear = components.year!
//        
//        guard GlobalHelper.getTypeCard(cardNumber) != .notSupported else {
//            return nil
//        }
//        
//        if expiryYear < todayYear {
//            return nil
//        }
//        
//        if expiryMonth <= todayMonth && expiryYear == todayYear {
//            return nil
//        }
//        
//        return CardModel(
//            cardHolderName: cardHolderName,
//            expiryMonth: "\(expiryMonth)",
//            expiryYear: "\(expiryYear)",
//            cardNumber: cardNumber,
//            cvc: cvc
//        )
//    }
//}
//
//



import Foundation
import SwiftUI

public enum PaymentCardType: String, Codable {
    case visa = "vi"
    case masterCard = "mc"
    case amex = "ax"
    case diners = "di"
    case discover = "dc"
    case jcb = "jb"
    case elo = "el"
    case credisensa = "cs"
    case solidario = "so"
    case exito = "ex"
    case alkosto = "ak"
    case notSupported = ""
}

@available(iOS 15.0, *)
public class CardModel: Codable, Identifiable {
    public let id: String
    public let status: String?
    public let transactionId: String?
    public let token: String?
    public let cardHolderName: String
    public let fiscalNumber: String?
    public let termination: String?
    public let isDefault: Bool
    public let expiryMonth: String
    public let expiryYear: String
    public let bin: String?
    public let nip: String?
    public let msg: String?
    public let cardType: PaymentCardType
    public let cardNumber: String
    
    public var cardImage: Image {
        let imageName = GlobalHelper.getCardTypeAsset(cardType: cardType)
        if let uiImage = UIImage(named: imageName, in: Bundle(for: NuveiSdk.self), compatibleWith: nil) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "creditcard")
    }
    
    public var displayCardNumber: String {
        "···· ···· \(termination ?? String(cardNumber.suffix(4)))"
    }
    
    public var displayName: String {
        cardHolderName
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case transactionId = "transaction_reference"
        case token
        case cardHolderName = "holder_name"
        case fiscalNumber
        case isDefault
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case bin
        case nip
        case msg = "message"
        case type
        case cardNumber = "number"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
        self.cardHolderName = try container.decodeIfPresent(String.self, forKey: .cardHolderName)!
        self.fiscalNumber = try container.decodeIfPresent(String.self, forKey: .fiscalNumber)
        self.cardNumber = try container.decodeIfPresent(String.self, forKey: .cardNumber) ?? ""
        self.isDefault = try container.decodeIfPresent(Bool.self, forKey: .isDefault) ?? false
        self.expiryMonth = try container.decodeIfPresent(String.self, forKey: .expiryMonth)!
        self.expiryYear = try container.decodeIfPresent(String.self, forKey: .expiryYear)!
        self.bin = try container.decodeIfPresent(String.self, forKey: .bin)
        self.nip = try container.decodeIfPresent(String.self, forKey: .nip)
        self.msg = try container.decodeIfPresent(String.self, forKey: .msg)
        let type = try container.decodeIfPresent(String.self, forKey: .type)
        self.cardType = PaymentCardType(rawValue: type ?? "") ?? .notSupported
        self.termination = String(self.cardNumber.suffix(4))
        self.id = token ?? UUID().uuidString
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(cardHolderName, forKey: .cardHolderName)
        try container.encodeIfPresent(fiscalNumber, forKey: .fiscalNumber)
        try container.encodeIfPresent(cardNumber, forKey: .cardNumber)
        try container.encode(isDefault, forKey: .isDefault)
        try container.encodeIfPresent(expiryMonth, forKey: .expiryMonth)
        try container.encodeIfPresent(expiryYear, forKey: .expiryYear)
        try container.encodeIfPresent(bin, forKey: .bin)
        try container.encodeIfPresent(nip, forKey: .nip)
        try container.encodeIfPresent(msg, forKey: .msg)
        try container.encodeIfPresent(cardType.rawValue, forKey: .type)
    }
    
    public init(status: String? = nil,
                transactionId: String? = nil,
                token: String? = nil,
                cardHolderName: String,
                fiscalNumber: String? = nil,
                termination: String? = nil,
                isDefault: Bool = false,
                expiryMonth: String,
                expiryYear: String,
                bin: String? = nil,
                nip: String? = nil,
                msg: String? = nil,
                cardType: PaymentCardType = .notSupported,
                cardNumber: String) {
        self.status = status
        self.transactionId = transactionId
        self.token = token
        self.cardHolderName = cardHolderName
        self.fiscalNumber = fiscalNumber
        self.termination = termination ?? String(cardNumber.suffix(4))
        self.isDefault = isDefault
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.bin = bin
        self.nip = nip
        self.msg = msg
        self.cardType = cardType
        self.cardNumber = cardNumber
        self.id = token ?? UUID().uuidString
    }
    
    public static func createCard(cardHolderName: String, cardNumber: String, expiryMonth: Int, expiryYear: Int, cvc: String) -> CardModel? {
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: today)
        let todayMonth = components.month!
        let todayYear = components.year!
        
        guard GlobalHelper.getTypeCard(cardNumber) != .notSupported else {
            return nil
        }
        
        if expiryYear < todayYear {
            return nil
        }
        
        if expiryMonth <= todayMonth && expiryYear == todayYear {
            return nil
        }
        
        return CardModel(
            cardHolderName: cardHolderName,
            expiryMonth: "\(expiryMonth)",
            expiryYear: "\(expiryYear)",
            cardType: GlobalHelper.getTypeCard(cardNumber),
            cardNumber: cardNumber
        )
    }
}
