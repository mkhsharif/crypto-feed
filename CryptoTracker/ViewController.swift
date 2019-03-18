//
//  ViewController.swift
//  CryptoTracker
//
//  Created by MKHS on 3/12/19.
//  Copyright © 2019 mkhs. All rights reserved.
//

import UIKit
import WebKit


protocol EditList {
    func addPair(pair: String)
    func getPairs() -> [Pair]
    func getPrices() -> [Price]
    func removePrice(index: Int)
}

struct Ticker: Decodable {
    let symbols: [Symbol]
}

struct Symbol: Decodable {
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
}

struct LastPrice: Decodable {
    let symbol: String
    let priceChangePercent: String
    let lastPrice: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate, WKNavigationDelegate, EditList {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    
    
    var prices: [Price] = []
    var pairs: [Pair] = []
    
   // var updateTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewController.updatePrices), userInfo: nil, repeats: true)
    
    //var pairs = [String: Bool]()
    
    

    
    override func viewDidLoad() {
        
        self.title = "Profit Trail"
        
        let jsonUrlString = "https://api.binance.com/api/v1/exchangeInfo"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) {(data, res, err) in
            // check err
            // check response status 200 OK
            guard let data = data else { return }
            print(data)
            do {
                let ticker = try JSONDecoder().decode(Ticker.self, from: data)
                for i in 0...ticker.symbols.count - 1 {
                    //self.pairs[ticker.symbols[i].symbol] = false
                    self.pairs.append(Pair(
                        pair: ticker.symbols[i].symbol,
                        base: ticker.symbols[i].baseAsset,
                        quote: ticker.symbols[i].quoteAsset,
                        added: false))
                }
                
                self.pairs.sort {$0.pair < $1.pair}
            } catch let jsonErr {
                print("Error: ", jsonErr)
            }
            }.resume()
        
        let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updatePrices), userInfo: nil, repeats: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! PriceCell
        
        // selected color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        
        // show ticker
         cell.tickerOutlet.text = prices[indexPath.row].ticker
        
        // show price
        if Double(prices[indexPath.row].price)! >= 1.0 {
            let curPrice = round(100.0 * Double(prices[indexPath.row].price)!) / 100.0
            cell.priceOutlet.text = "$\(curPrice)"
        } else {
            cell.priceOutlet.text = "$\(prices[indexPath.row].price)"
        }
        
        // show percent change
        if Double(prices[indexPath.row].percentChange)! >= 0.0 {
            cell.percentChangeOutlet!.backgroundColor = UIColor.green
            cell.percentChangeOutlet.text = "+\(prices[indexPath.row].percentChange)%"
        } else {
            cell.percentChangeOutlet!.backgroundColor = UIColor.red
            cell.percentChangeOutlet.text = "\(prices[indexPath.row].percentChange)%"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = URL(string: "https://www.tradingview.com/chart/?symbol=BINANCE:\(prices[indexPath.row].ticker)")
        webView.load(URLRequest(url: url!))
    }
    
    // make table view cell editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // handle deleted cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        for pair in pairs {
            if prices[indexPath.row].ticker == pair.pair {
                pair.added = false
            }
        }
        prices.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    // on segue (plus button) we can change things about the file before it loads
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pairVC = segue.destination as! PairViewController
        pairVC.delegate = self
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: view.frame.height)
//    }
    
    // orientation management
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        print(UIDevice.current.orientation.isLandscape)
      
        
    }
   
    
    // fetch data from binance and display it within the table
    func addPair(pair: String) {
        
        let urlReq = "https://api.binance.com/api/v1/ticker/24hr?symbol=\(pair)"
        
        print(urlReq)
        
         guard let url = URL(string: urlReq) else { return }
        print(url)
        URLSession.shared.dataTask(with: url) {(data, res, err) in
          
            guard let data = data else { return }
            print(data)
            
            do {
                let lastPrice = try JSONDecoder().decode(LastPrice.self, from: data)
                print(lastPrice)
                self.prices.append(Price(ticker: lastPrice.symbol, price: lastPrice.lastPrice, percentChange: lastPrice.priceChangePercent))
                
                 self.tableView.reloadData()
                
            } catch let jsonErr {
                print("Error: ", jsonErr)
            }
        }.resume()
    
    }
    
    func removePrice(index: Int) {
        prices.remove(at: index)
        tableView.reloadData()
    }
    
    
    @objc func test() {
        print("UPDATED")
    }
    
    @objc func updatePrices() {
        for price in prices {
            let urlReq = "https://api.binance.com/api/v1/ticker/24hr?symbol=\(price.ticker)"
            
            //print(urlReq)
            
            guard let url = URL(string: urlReq) else { return }
            print(url)
            URLSession.shared.dataTask(with: url) {(data, res, err) in
                
                guard let data = data else { return }
                print(data)
                
                do {
                    let lastPrice = try JSONDecoder().decode(LastPrice.self, from: data)
                    print(lastPrice)
                    price.price = lastPrice.lastPrice
                    price.percentChange = lastPrice.priceChangePercent
            
                    
                } catch let jsonErr {
                    print("Error: ", jsonErr)
                }
            }.resume()
            
        }
        self.tableView.reloadData()
        
    }
    
    func getPairs() -> [Pair] {
        return pairs
    }
    
    func getPrices() -> [Price] {
        return prices
    }

}

class Price {
    var ticker = ""
    var price = ""
    var percentChange = ""
    
    convenience init(ticker: String, price: String, percentChange: String) {
        self.init()
        self.ticker = ticker
        self.price = price
        self.percentChange = percentChange
    }
}


