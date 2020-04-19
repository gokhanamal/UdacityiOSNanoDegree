//
//  File.swift
//  Sikke
//
//  Created by Gokhan Namal on 19.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

class PortfolioCell: UITableViewCell {
    static let reuseIdentifier = "PortfolioCell"
    
    @IBOutlet var flag: UIImageView?
    @IBOutlet var percentageLabel: UILabel?
    @IBOutlet var currencyNameLabel: UILabel?
    @IBOutlet var amountLabel: UILabel?
    @IBOutlet var currentValueLabel: UILabel?
    @IBOutlet weak var arrow: UIImageView!
    
    func setCell(currency: Currency, portfolio: Portfolio, baseCurrency: String) {
       
        let currentRate = DataModel.rates[currency.currencyCode] ?? 1.0
        let currentVal = (1/currentRate) * portfolio.amount
        let percentage = (((1/currentRate) - portfolio.purchasePrice) / portfolio.purchasePrice)*100
        
        flag?.image = currency.flag
        currencyNameLabel?.text = currency.currencyName
        amountLabel?.text = portfolio.amount.formatCurrency(currency: currency.currencyCode)
        percentageLabel?.text = percentage.toString() + "%"
        currentValueLabel?.text = currentVal.formatCurrency(currency: baseCurrency)
        
        setArrow(percentage: percentage)
    }
    
    func setArrow(percentage: Double) {
        arrow.isHidden = false
        if percentage > 0 {
            arrow.image = UIImage(systemName: "arrowtriangle.up.fill")
            arrow.tintColor = Colors.green
        } else if percentage < 0 {
            arrow.image = UIImage(systemName: "arrowtriangle.down.fill")
            arrow.tintColor = .red
        } else {
            arrow.isHidden = true
        }
         
    }
}
