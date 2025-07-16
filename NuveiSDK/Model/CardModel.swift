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


open class CardModel: NSObject{
    open var status: String?
    open var transactionId: String?
    open var token: String?
    open var cardHolderName: String?
    open var fiscalNumber: String?
    open var termination: String?
    open var isDefault: Bool = false
    open  var expiryMonth: String?
    open var expiryYear: String?
    open var bin: String?
    open var nip: String?
    open var msg: String?
    open var cardType: PaymentCardType = .notSupported
    internal var cardNumber: String?{
        didSet{
            if cardNumber != nil{
                self.termination = String(self.cardNumber!.suffix(4))
            }
        }
    }
    internal var cvc: String?
    open var type: String?{
        didSet{
            if self.type == "vi" {
                self.cardType = .visa
            }
            if self.type == "ax" {
                self.cardType = .amex
            }
            if self.type == "mc" {
                self.cardType = .masterCard
            }
            if self.type == "di" {
                self.cardType = .diners
            }
            if self.type == "al" {
                self.cardType = .alkosto
            }
            if self.type == "ex" {
                self.cardType = .exito
            }
        }
    }
    
    //create a card object
    public static func createCard(cardHolderName: String, cardNumber: String, expityMonth: NSInteger, expiryYear: NSInteger, cvc:String)->CardModel? {
        let cardModel = CardModel()
        let today =  Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.month, .year], from: today)
        let todayMonth = components.month!
        let todayYear = components.year!
        
        if GlobalHelper.getTypeCard(cardNumber) == .notSupported{
            return nil
        }
        
        if expiryYear < todayYear{
            return nil
        }
        
        if expityMonth <= todayMonth && expiryYear == todayYear{
            return nil
        }
        
        cardModel.cardNumber = cardNumber
        cardModel.cardHolderName = cardHolderName
        cardModel.expiryMonth = "\(expityMonth)"
        cardModel.expiryYear = "\(expiryYear)"
        cardModel.cvc = cvc
        return cardModel
    }
    
    public func getJSONString()-> String?{
        var json: Any? = nil
        do{
            json = try JSONSerialization.data(withJSONObject: self.getDict(), options: .prettyPrinted)
        } catch {}
            if json != nil {
                let jsonText = String(data: json as! Data, encoding: String.Encoding.ascii)
                return jsonText
            }
            return nil
        
    }
    
    public func getDict() -> NSDictionary {
        let dict = [
            "bin": self.bin,
            "status": self.status,
            "token": self.token,
            "expiry_year": self.expiryYear,
            "expiry_month": self.expiryMonth,
            "transaction_reference": self.transactionId,
            "holder_name": self.cardHolderName,
            "type": self.type,
            "number": self.termination,
            "message": ""
        ]
        return dict as NSDictionary
    }
    
}
