//
//  Extensions.swift
//  XeroProgrammingExercise
//
//  Created by Joseph Grist on 10/8/2023.
//  Copyright © 2023 Xero Ltd. All rights reserved.
//

import Foundation
import SwiftUI

extension Date {
    
    static var standardFormat: String {
        get { return "dd/MM/yyyy" }
    }
    
    func toStandardFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.standardFormat
        return dateFormatter.string(from: self)
    }
}

extension Decimal {
    func toCurrencyFormat() -> String {
        // Assuming for this excercide we will just assume always AUD
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_AU")
        return currencyFormatter.string(from: self as NSNumber) ?? ""
    }
}


var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

