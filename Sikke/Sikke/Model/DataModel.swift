//
//  DataModel.swift
//  Sikke
//
//  Created by Gokhan Namal on 16.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit
import FlagKit

class DataModel {
    static var currencies: [Currency] = [
        Currency(countryCode: "US", currencyName: "US dollar", currencyCode: "USD"),
        Currency(countryCode: "JP", currencyName: "Japanese yen", currencyCode: "JPY"),
        Currency(countryCode: "BG", currencyName: "Bulgarian lev", currencyCode: "BGN"),
        Currency(countryCode: "CZ", currencyName: "Czech koruna", currencyCode: "CZK"),
        Currency(countryCode: "TR", currencyName: "Turkish lira", currencyCode: "TRY"),
        Currency(countryCode: "EU", currencyName: "Euro", currencyCode: "EUR")
    ]
    
    static var rates = [String: Double]()
    
    static let dataController = DataController(modelName: "SikkeModel")
    
    static func getCurrency(currencyCode: String) -> Currency? {
        let index = DataModel.currencies.firstIndex(where: {$0.currencyCode == currencyCode})
        if let index = index {
            return DataModel.currencies[index]
        }
        return nil
    }
}

struct Currency {
    var flag: UIImage
    let currencyName: String
    let countryCode: String
    let currencyCode: String
    
    init(countryCode: String, currencyName: String, currencyCode: String) {
        self.countryCode = countryCode
        self.currencyName = currencyName
        self.flag = Flag(countryCode: countryCode)!.originalImage
        self.currencyCode = currencyCode
    }
}
