//
//  GlobalHelper.swift
//  NuveiSdk
//
//  Created by Jorge on 16/7/25.
//

import Foundation
import CommonCrypto
import SwiftUI


class GlobalHelper{
    static func generateAuthToken(key:String, code: String) ->String {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let uniqueToken = generateUniqueToken(key: key, timestamp: timestamp)
        let authToken = "\(code);\(timestamp);\(uniqueToken)"
        let base64Token = Data(authToken.utf8).base64EncodedString()
        return base64Token.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
    private static func generateUniqueToken(key :String, timestamp:String)->String{
        // Crear la cadena para el hash: "key" + "timestamp"
                let input = key + timestamp
                guard let inputData = input.data(using: .utf8) else {
                    print("Error: No se pudo convertir la entrada a datos UTF-8")
                    return ""
                }
                
                // Generar hash SHA-256
                var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
                inputData.withUnsafeBytes { buffer in
                    _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &digest)
                }
                
                // Convertir a representación hexadecimal
                let hexString = digest.map { String(format: "%02hhx", $0) }.joined()
                print("UNIQ-TOKEN (SHA-256): '\(hexString)'")
                return hexString
    }
    
    public static func validateExpDate(_ expDate: String) -> Bool {
            let today = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month, .year], from: today)
            guard let currentMonth = components.month,
                  let currentYear = components.year else {
                return false
            }

            let parts = expDate.components(separatedBy: "/")
            guard parts.count == 2,
                  let expMonth = Int(parts[0]),
                  let expYear = Int(parts[1]) else {
                return false
            }

            let adjustedYear = expYear + 2000 // Asumiendo formato YY

            if adjustedYear > currentYear {
                return true
            } else if adjustedYear == currentYear && expMonth >= currentMonth && expMonth <= 12 {
                return true
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
    
    
    public static func  getCardTypeAsset(cardType: PaymentCardType) -> String {
            switch cardType {
            case .amex:
                return "stp_card_amex"
            case .masterCard:
                return "stp_card_mastercard"
            case .visa:
                return "stp_card_visa"
            case .diners:
                return  "stp_card_diners"
            case .discover:
                return "stp_card_discover"
            case .jcb:
                return "stp_card_jcb"
            default:
                return "stp_card_unknown"
            }
        }

}
