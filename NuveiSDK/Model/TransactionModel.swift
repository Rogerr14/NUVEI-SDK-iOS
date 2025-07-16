//
//  TransactionModel.swift
//  NuveiSdk
//
//  Created by Jorge on 16/7/25.
//
import Foundation

class TransactionModel: NSObject{
    open var authorizationCode: NSNumber?
    open var amount: NSNumber?
    open var paymentDate: Date?
    open var status: String?
    open var carrierCode: String?
    open var message: String?
    open var statusDetail: NSNumber?
    open var transactionId: String?
    open var carrierData: [String:Any]?
    
    static func parseTransaction(_ data: Any?) -> TransactionModel {
        let data = data as! [String: Any]
        let trx = TransactionModel()
        trx.amount = data["amount"] as? NSNumber
        trx.status = data["status"] as? String
        trx.statusDetail = data["status_detail"] as? Int as NSNumber?
        trx.transactionId = data["transaction_id"] as? String
        trx.carrierData = data["carrier_data"] as? [String: Any]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        if let paymentdate = (data["payment_date"] as? String) {
            trx.paymentDate = dateFormatter.date(from: paymentdate)
        }
        return trx
    }

    static func parseTransactionV2(_ data: Any?) ->TransactionModel {
        let data = data as! [String: Any]
        let trx = TransactionModel()
        trx.amount = data["amount"] as? NSNumber
        trx.status = data["status"] as? String
        trx.statusDetail = data["status_detail"] as? Int as NSNumber?
        trx.transactionId = data["id"] as? String
        trx.authorizationCode = data["authorization_code"] as? Int as NSNumber?
        trx.carrierCode = data["carrier_code"] as? String
        trx.message = data["message"] as? String

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        if let paymentdate = (data["payment_date"] as? String) {
            trx.paymentDate = dateFormatter.date(from: paymentdate)
        }

        return trx
    }
}
