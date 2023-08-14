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
    
    private func formattedCurrency(style: NumberFormatter.Style) -> String {
        let currencyFormatter = NumberFormatter()
        // Assuming for this exercise we will just be AUD
        currencyFormatter.locale = Locale(identifier: "en_AU")
        currencyFormatter.numberStyle = style
        return currencyFormatter.string(from: self as NSNumber) ?? ""
    }
    
    func toCurrencyFormat() -> String {
        return formattedCurrency(style: .currency)
    }
    
    func toCurrencySpokenText() -> String {
        return formattedCurrency(style: .currencyPlural)
    }
}
