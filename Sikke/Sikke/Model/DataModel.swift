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
        Currency(countryCode: "EU", currencyName: "Euro", currencyCode: "EUR"),
        Currency(countryCode: "DK", currencyName: "Danish krone", currencyCode: "DKK"),
        Currency(countryCode: "GB", currencyName: "Pound sterling", currencyCode: "GBP"),
        Currency(countryCode: "HU", currencyName: "Hungarian forint", currencyCode: "HUF"),
        Currency(countryCode: "PL", currencyName: "Polish zloty", currencyCode: "PLN"),
        Currency(countryCode: "RO", currencyName: "Romanian leu", currencyCode: "RON"),
        Currency(countryCode: "SE", currencyName: "Swedish krona", currencyCode: "SEK"),
        Currency(countryCode: "CH", currencyName: "Swiss franc", currencyCode: "CHF"),
        Currency(countryCode: "IS", currencyName: "Icelandic krona", currencyCode: "ISK"),
        Currency(countryCode: "NO", currencyName: "Norwegian krone", currencyCode: "NOK"),
        Currency(countryCode: "HR", currencyName: "Croatian kuna", currencyCode: "HRK"),
        Currency(countryCode: "RU", currencyName: "Russian rouble", currencyCode: "RUB"),
        Currency(countryCode: "AU", currencyName: "Australian dollar", currencyCode: "AUD"),
        Currency(countryCode: "CA", currencyName: "Canadian dollar", currencyCode: "CAD"),
        Currency(countryCode: "CN", currencyName: "Chinese yuan renminbi", currencyCode: "CNY"),
        Currency(countryCode: "HK", currencyName: "Hong Kong dollar", currencyCode: "HKD"),
        Currency(countryCode: "ID", currencyName: "Indonesian rupiah", currencyCode: "IDR"),
        Currency(countryCode: "IL", currencyName: "Israeli shekel", currencyCode: "ILS"),
        Currency(countryCode: "IN", currencyName: "Indian rupee", currencyCode: "INR"),
        Currency(countryCode: "KR", currencyName: "South Korean won", currencyCode: "KRW"),
        Currency(countryCode: "MX", currencyName: "Mexican peso", currencyCode: "MXN"),
        Currency(countryCode: "MY", currencyName: "Malaysian ringgit", currencyCode: "MYR"),
        Currency(countryCode: "NZ", currencyName: "New Zealand dollar", currencyCode: "NZD"),
        Currency(countryCode: "PH", currencyName: "Philippine peso", currencyCode: "PHP"),
        Currency(countryCode: "SG", currencyName: "Singapore dollar", currencyCode: "SGD"),
        Currency(countryCode: "TH", currencyName: "Thai baht", currencyCode: "THB"),
        Currency(countryCode: "ZA", currencyName: "South African rand", currencyCode: "ZAR"),
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
    var flag: UIImage?
    let currencyName: String
    let countryCode: String
    let currencyCode: String
    
    init(countryCode: String, currencyName: String, currencyCode: String) {
        self.countryCode = countryCode
        self.currencyName = currencyName
        self.flag = Flag(countryCode: countryCode)?.originalImage
        self.currencyCode = currencyCode
    }
}
