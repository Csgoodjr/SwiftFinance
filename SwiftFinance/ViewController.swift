//
//  ViewController.swift
//  SwiftFinance
//
//  Created by CJ Good on 5/21/20.
//  Copyright © 2020 CJ Good. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var searchBarText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var pointsChangeLabel: UILabel!
    @IBOutlet weak var todaysHighLabel: UILabel!
    @IBOutlet weak var todaysLowLabel: UILabel!
        
    struct StockQuote: Codable {
        var symbol: String
        var price: Float
        var changesPercentage: Float
        var change: Float
        var dayLow: Float
        var dayHigh: Float
        var yearHigh: Float
        var yearLow: Float
        var marketCap: Float
        var priceAvg50: Float
        var priceAvg200: Float
        var volume: Int
        var avgVolume: Int
        var exchange: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Text Field Delegate
        searchBarText.delegate = self
        // Round borders around the search button
        searchButton.layer.cornerRadius = 5
        self.titleLabel.isEnabled = false
        self.priceLabel.isEnabled = false
        self.exchangeLabel.isEnabled = false
        self.percentChangeLabel.isEnabled = false
        self.pointsChangeLabel.isEnabled = false
        self.todaysHighLabel.isEnabled = false
        self.todaysLowLabel.isEnabled = false
    }
    
    func createStockDisplay(stock: StockQuote) {
        DispatchQueue.main.async {
            self.titleLabel.text = stock.symbol
            self.priceLabel.text = "$\(stock.price.rounded())"
            self.exchangeLabel.text = stock.exchange
            self.percentChangeLabel.text = "\(stock.changesPercentage.rounded())%"
            self.pointsChangeLabel.text = "\(stock.change.rounded()) points"
            self.todaysHighLabel.text = "$\(stock.dayHigh.rounded())"
            self.todaysLowLabel.text = "$\(stock.dayLow.rounded())"
            if (stock.changesPercentage > 0) {
                self.percentChangeLabel.textColor = UIColor.green
            } else {
                self.percentChangeLabel.textColor = UIColor.red
            }
            if (stock.change > 0) {
                self.pointsChangeLabel.textColor = UIColor.green
            } else {
                self.pointsChangeLabel.textColor = UIColor.red
            }
        }
    }
    
    func createStockQuote(data: Data) {
        do {
            let currentStock = try JSONDecoder().decode([StockQuote].self, from: data)
            createStockDisplay(stock: currentStock[0])
        } catch let err {
            print(err)
        }
    }
    
    func getStockData(ticker: String, apiKey: String){
        let url_string = "https://financialmodelingprep.com/api/v3/quote/"+ticker+"?apikey="+apiKey
        if let url = URL(string: url_string) {
            URLSession.shared.dataTask(with: url) { data,res,err in
                if let data = data {
                    self.createStockQuote(data: data)
                }
            }.resume()
        }
    }
    // Gather stock data when the search button is pressed
    @IBAction func onSearchPress(_ sender: Any) {
        getStockData(ticker: searchBarText.text!.uppercased(), apiKey: "a4309126267e88ff20a7e88bc93d3b1a")
        self.view.endEditing(true)
        self.titleLabel.isEnabled = true
        self.priceLabel.isEnabled = true
        self.exchangeLabel.isEnabled = true
        self.percentChangeLabel.isEnabled = true
        self.pointsChangeLabel.isEnabled = true
        self.todaysHighLabel.isEnabled = true
        self.todaysLowLabel.isEnabled = true
    }
}

