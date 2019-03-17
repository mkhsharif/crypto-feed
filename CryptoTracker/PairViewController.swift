//
//  PairViewController.swift
//  CryptoTracker
//
//  Created by MKHS on 3/14/19.
//  Copyright © 2019 mkhs. All rights reserved.
//

import UIKit



class PairViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var pairs: [Pair] = []
    var currentPairs: [Pair] = []
    let check = UIImage(named: "checkmark")
    var delegate: EditList?
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        
        pairs = (delegate?.getPairs())!
        currentPairs = pairs
        
    }
    
    
    // table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pairCell", for: indexPath) as! PairCell
        
        cell.pairOutlet.text = currentPairs[indexPath.row].pair
        
        if currentPairs[indexPath.row].added {
            cell.checkOutlet.setImage(check, for: UIControl.State.normal)
        } else {
            cell.checkOutlet.setImage(nil, for: UIControl.State.normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPairs[indexPath.row].added = !currentPairs[indexPath.row].added
        
        self.delegate?.addPair(pair: currentPairs[indexPath.row].pair)
        
        tableView.reloadData()
    }
    
   //search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return false }
        currentPairs = pairs.filter({pairs -> Bool in pairs.pair.contains(searchBar.text)})
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        <#code#>
    }
    
//    func addPair(pair: String) {
//        // get price pair
//        prices.append(Price(ticker: pair, price: 0.0, percentChange: 0.0))
//    }
//
}

class Pair {
    var pair = ""
    var base = ""
    var quote = ""
    var added = false
    
    convenience init(pair: String, base: String, quote: String, added: Bool) {
        self.init()
        self.pair = pair
        self.base = base
        self.quote = quote
        self.added = added
    }
}


