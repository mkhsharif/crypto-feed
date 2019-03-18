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
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        
        self.title = "Pairs"
        
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
        
        if(currentPairs[indexPath.row].added) {
            self.delegate?.addPair(pair: currentPairs[indexPath.row].pair)
        } else {
            var count = 0
            for price in (self.delegate?.getPrices())! {
                if currentPairs[indexPath.row].pair == price.ticker {
                    self.delegate?.removePrice(index: count)
                }
                 count += 1
            }
        }
        tableView.reloadData()
    }
    
   //search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentPairs = pairs
            tableView.reloadData()
            return
            
        }
        currentPairs = pairs.filter({ pairs -> Bool in
            return pairs.pair.contains(searchText)
        })
        tableView.reloadData()
    }
    
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


