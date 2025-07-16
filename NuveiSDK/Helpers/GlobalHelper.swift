//
//  GlobalHelper.swift
//  NuveiSdk
//
//  Created by Jorge on 16/7/25.
//

import Foundation
import CryptoKit
import UIKit

class GlobalHelper{
    static func generateAuthToken(key:String, code: String) ->String {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let uniqueToken = generateUniqueToken(key: key, timestamp: timestamp)
        let authToken = "\(code);\(timestamp);\(uniqueToken)"
        let base64Token = Data(authToken.utf8).base64EncodedString(options: .lineLength64Characters)
        return base64Token.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
    private static func generateUniqueToken(key :String, timestamp:String)->String{
        let data = "\(timestamp)\(key)".data(using: .utf8)!
        let keyvalue = SymmetricKey(data: key.data(using: .utf8)!)
        let hmac = HMAC<SHA256>.authenticationCode(for: data, using: keyvalue)
        return Data(hmac).map{
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    static func validateExpDate(_ expDate: String) -> Bool {
        let today = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.month, .year], from: today)
        let todayMonth = components.month!
        let todayYear = components.year! - 2000
        let valExp = expDate.components(separatedBy: "/")

        if valExp.count > 1 {
            let expYear = Int(valExp[1])!
            let expMonth = Int(valExp[0])!
            if expYear > todayYear {
                return true
            } else if expYear == todayYear && expMonth > todayMonth && expMonth <= 12 {
                return true
            }
        }

        return false
    }
    
    
    
    public static func getTypeCard(_ cardNumber: String) -> PaymentCardType {
        if cardNumber.count < 15  || cardNumber.count > 16 {
            return PaymentCardType.notSupported
        }

        let predicateAmex = NSPredicate(format: "SELF MATCHES %@", REGEX_AMEX)
        if predicateAmex.evaluate(with: cardNumber) {
            return PaymentCardType.amex
        }

        let predicateVisa = NSPredicate(format: "SELF MATCHES %@", REGEX_VISA)
        if predicateVisa.evaluate(with: cardNumber) {
            return PaymentCardType.visa
        }

        let predicateMC = NSPredicate(format: "SELF MATCHES %@", REGEX_MASTERCARD)
        if predicateMC.evaluate(with: cardNumber) {
            return PaymentCardType.masterCard
        }

        let predicateDiners = NSPredicate(format: "SELF MATCHES %@", REGEX_DINERS)
        if predicateDiners.evaluate(with: cardNumber) {
            return PaymentCardType.diners
        }

        let predicateDiscover = NSPredicate(format: "SELF MATCHES %@", REGEX_DISCOVER)
        if predicateDiscover.evaluate(with: cardNumber) {
            return PaymentCardType.discover
        }

        let predicateJCB = NSPredicate(format: "SELF MATCHES %@", REGEX_JCB)
        if predicateJCB.evaluate(with: cardNumber) {
            return PaymentCardType.jcb
        }

        return PaymentCardType.notSupported
    }
    
    
    public func getCardTypeAsset(cardType: PaymentCardType) -> UIImage? {
        let bundle = Bundle(for: CardModel.self)
        if cardType == PaymentCardType.amex {
            return UIImage(named: "stp_card_amex", in: bundle, compatibleWith: nil)
        } else if cardType == PaymentCardType.masterCard {
            return UIImage(named: "stp_card_mastercard", in: bundle, compatibleWith: nil)
        } else if cardType == PaymentCardType.visa {
            return UIImage(named: "stp_card_visa", in: bundle, compatibleWith: nil)
        } else if cardType == PaymentCardType.diners {
            return UIImage(named: "stp_card_diners", in: bundle, compatibleWith: nil)
        } else if cardType == PaymentCardType.discover {
            return UIImage(named: "stp_card_discover", in: bundle, compatibleWith: nil)
        } else if cardType == PaymentCardType.jcb {
            return UIImage(named: "stp_card_jcb", in: bundle, compatibleWith: nil)
        } else {
            return UIImage(named: "stp_card_unknown", in: bundle, compatibleWith: nil)
        }
    }
}
