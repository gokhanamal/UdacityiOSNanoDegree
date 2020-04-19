//
//  Extentios+Double.swift
//  Sikke
//
//  Created by Gokhan Namal on 17.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation

extension Double {
    func toString() -> String {
        return String(format: "%.2f",self)
    }
    
    func formatCurrency(currency: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = currency
        return currencyFormatter.string(from: NSNumber(value: self))
    }
}
