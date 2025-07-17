//
//  Extension.swift
//  PaymentSDK
//
//  Created by Gustavo Sotelo on 05/09/17.
//  Copyright © 2017 Payment. All rights reserved.
////
//

import Foundation
extension String {
    var localized: String {
        let bundle = Bundle(identifier: "com.nuvei.NuveiSDK") ?? Bundle.main
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
