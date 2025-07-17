//
//  CardModel.swift
//  NuveiSdk
//
//  Created by Jorge on 16/7/25.
//

import Foundation


//typo of disponibilities card
public enum PaymentCardType: String {
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


//card prefixes
let REGEX_AMEX = "^3[47][0-9]{5,}$"
let REGEX_VISA = "^4[0-9]{6,}$"
let REGEX_MASTERCARD = "^5[1-5][0-9]{5,}$"
let REGEX_DINERS = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
let REGEX_DISCOVER = "^65[4-9][0-9]{13}|64[4-9][0-9]{13}|6011[0-9]{12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10})$"
let REGEX_JCB = "^(?:2131|1800|35[0-9]{3})[0-9]{11}$"



@available(iOS 15.0, *)
public struct CardModel: Codable {
    public var status: String?
    public var transactionId: String?
    public var token: String?
    public var cardHolderName: String?
    public var fiscalNumber: String?
    public var termination: String?
    public var isDefault: Bool
    public var expiryMonth: String?
    public var expiryYear: String?
    public var bin: String?
    public var nip: String?
    public var msg: String?
    public var cardType: PaymentCardType
    private var cardNumber: String? {
        didSet {
            if cardNumber != nil {
                self.termination = String(self.cardNumber!.suffix(4))
            }
        }
    }
    private var cvc: String?
    public var type: String? {
        didSet {
            guard let type = type else { return }
            switch type.lowercased() {
            case "vi": self.cardType = .visa
            case "ax": self.cardType = .amex
            case "mc": self.cardType = .masterCard
            case "di": self.cardType = .diners
            case "al": self.cardType = .alkosto
            case "ex": self.cardType = .exito
            default: self.cardType = .notSupported
            }
        }
    }
    
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
    
    enum CodingKeys: String, CodingKey {
        case status
        case transactionId = "transaction_reference"
        case token
        case cardHolderName = "holder_name"
        case fiscalNumber
        case termination = "number"
        case isDefault
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case bin
        case nip
        case msg = "message"
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        cardHolderName = try container.decodeIfPresent(String.self, forKey: .cardHolderName)
        fiscalNumber = try container.decodeIfPresent(String.self, forKey: .fiscalNumber)
        termination = try container.decodeIfPresent(String.self, forKey: .termination)
        isDefault = try container.decodeIfPresent(Bool.self, forKey: .isDefault) ?? false
        expiryMonth = try container.decodeIfPresent(String.self, forKey: .expiryMonth)
        expiryYear = try container.decodeIfPresent(String.self, forKey: .expiryYear)
        bin = try container.decodeIfPresent(String.self, forKey: .bin)
        nip = try container.decodeIfPresent(String.self, forKey: .nip)
        msg = try container.decodeIfPresent(String.self, forKey: .msg)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        cardType = PaymentCardType(rawValue: type ?? "") ?? .notSupported
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(cardHolderName, forKey: .cardHolderName)
        try container.encodeIfPresent(fiscalNumber, forKey: .fiscalNumber)
        try container.encodeIfPresent(termination, forKey: .termination)
        try container.encode(isDefault, forKey: .isDefault)
        try container.encodeIfPresent(expiryMonth, forKey: .expiryMonth)
        try container.encodeIfPresent(expiryYear, forKey: .expiryYear)
        try container.encodeIfPresent(bin, forKey: .bin)
        try container.encodeIfPresent(nip, forKey: .nip)
        try container.encodeIfPresent(msg, forKey: .msg)
        try container.encodeIfPresent(type, forKey: .type)
    }
    
    public init(status: String? = nil,
                transactionId: String? = nil,
                token: String? = nil,
                cardHolderName: String? = nil,
                fiscalNumber: String? = nil,
                termination: String? = nil,
                isDefault: Bool = false,
                expiryMonth: String? = nil,
                expiryYear: String? = nil,
                bin: String? = nil,
                nip: String? = nil,
                msg: String? = nil,
                cardType: PaymentCardType = .notSupported,
                cardNumber: String? = nil,
                cvc: String? = nil) {
        self.status = status
        self.transactionId = transactionId
        self.token = token
        self.cardHolderName = cardHolderName
        self.fiscalNumber = fiscalNumber
        self.termination = termination
        self.isDefault = isDefault
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.bin = bin
        self.nip = nip
        self.msg = msg
        self.cardType = cardType
        self.cardNumber = cardNumber
        self.cvc = cvc
    }
    
    public static func createCard(cardHolderName: String, cardNumber: String, expiryMonth: NSInteger, expiryYear: NSInteger, cvc: String) -> CardModel? {
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
            cardNumber: cardNumber,
            cvc: cvc
        )
    }
}


