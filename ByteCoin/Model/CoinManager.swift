//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Dmytro Vasylenko on 13.08.2022.
//
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(rate: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "5D827601-ADA7-4763-904F-3379F478353E"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            //        Create a URL session
            let session = URLSession(configuration: .default)
            //        Give the session a task
            let  task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let rate = self.parseJSON(safeData) {
                        let rateString = String(format: "%.2f", rate)
                        self.delegate?.didUpdateRate(rate: rateString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            let lastRate = decodedData.rate
            return lastRate
        } catch {
            print(error )
            
        }
        return nil
    }
}
