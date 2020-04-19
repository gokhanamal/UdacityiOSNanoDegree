//
//  SikkeClient.swift
//  Sikke
//
//  Created by Gokhan Namal on 16.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation

class SikkeClient {
    enum Endpoints {
        static let baseURL = "https://api.exchangeratesapi.io"
        
        case getRates(String)
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .getRates(let baseCurrency): return Endpoints.baseURL + "/latest?base=" + baseCurrency
            }
        }

    }
    
    class func getRates(baseCurrency: String, completion: @escaping (Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getRates(baseCurrency).url) {data, _, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(RatesResponse.self, from: data)
                DataModel.rates = responseObject.rates
            
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
}
