//
//  ViewController.swift
//  Sikke
//
//  Created by Gokhan Namal on 16.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit
import CoreData


protocol CurrencyViewControllerDelegate {
    func didSelect(currencyCode: String)
    func createInvestment(portfolio: Portfolio)
}

enum ActionType {
    case createInvestment
    case changeBaseCurrency
}

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var actionType: ActionType = .changeBaseCurrency
    var delegate: CurrencyViewControllerDelegate?
    
    var currencies = DataModel.currencies
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveCurrency(currency: String, amount: String?, exchangeRate: String?) {
        guard let amount = amount, let exchangeRate = exchangeRate else {return}
        if amount.isEmpty || exchangeRate.isEmpty {
            showAlert(title: "Field Error!", message: "Please fill all fields.", actions: nil)
            return
        }
        let portfolio = Portfolio(context: DataModel.dataController.viewContext)
        portfolio.amount = Double(amount) ?? 0.0
        portfolio.purchasePrice = Double(exchangeRate) ?? 1.0
        portfolio.currency = currency
        portfolio.createdAt = Date()
        
        do {
            try DataModel.dataController.viewContext.save()
            self.delegate?.createInvestment(portfolio: portfolio)
            self.dismiss(animated: true, completion: nil)
        } catch {
            showAlert(title: "Save Error!", message: error.localizedDescription, actions: nil)
        }
    }
    
    func showCreateInvestmentAlert() {
        let ac = UIAlertController(title: "Investment Details", message: nil, preferredStyle: .alert)
        guard
            let index = tableView.indexPathForSelectedRow?.row,
            let base = UserDefaults.standard.string(forKey: "baseCurrency")
        else {return}
        
        let currency = currencies[index]
        ac.message = "Please fill the fields according to your investment details."
        ac.addTextField(configurationHandler: { textField in
            textField.placeholder = "Amount in \(currency.currencyCode)"
            textField.keyboardType = .decimalPad
        })
        ac.addTextField(configurationHandler: { textField in
            textField.placeholder = "Exchange rate \(currency.currencyCode)/\(base)"
            textField.keyboardType = .decimalPad
            if currency.currencyCode == base {
                textField.text = "1.0"
                textField.isEnabled = false
            }
        })
    
        let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
            self.saveCurrency(currency: currency.currencyCode, amount: ac.textFields?[0].text, exchangeRate: ac.textFields?[1].text)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(submitAction)
        ac.addAction(cancel)

        present(ac, animated: true)
    }
}

extension CurrencyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            currencies = DataModel.currencies
        } else {
            currencies = DataModel.currencies.filter({ currency in
                let searchText =  searchText.lowercased()
                let currencyName = currency.currencyName.lowercased()
                let currencyCode = currency.currencyCode.lowercased()
                if currencyName.contains(searchText) || currencyCode.contains(searchText) {
                    return true
                }
                return false
            })
        }
        tableView.reloadData()
    }
}

extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        let currency = currencies[indexPath.row]
        cell.textLabel?.text = currency.currencyCode
        cell.detailTextLabel?.text = currency.currencyName
        cell.imageView?.image = currency.flag
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencies[indexPath.row]
    
        switch actionType {
        case .createInvestment:
            showCreateInvestmentAlert()
        case .changeBaseCurrency:
            dismiss(animated: true, completion: {self.delegate?.didSelect(currencyCode: currency.currencyCode)})
        }
    }
}
