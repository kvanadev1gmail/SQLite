//
//  ViewController.swift
//  MODApis
//
//  Created by Narendra Kumar on 7/9/16.
//  Copyright © 2016 Kvana. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
extension NSDate {
    
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
}
class ViewController: UIViewController {
    let symbol_ge = "ge"
    let lastFetchTime = "LastFetchTime"
    var results : [Stock] = []
    
    @IBOutlet weak var lastPriceValueLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var symolValueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStocksFromCache()
        if(results.count==0 || isLastday() == true){
            getDataFromServer(symbol_ge)
        }else{
            let stock = results.first!
            self.nameValueLabel.text = stock.name
            self.symolValueLabel.text = stock.symbol
            self.lastPriceValueLabel.text = "\(stock.lastPrice)"        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetchStocksFromCache(){
        do{
            try LocalDataHandler.sharedManager.createStockTable()
            let stocks = try LocalDataHandler.sharedManager.readStocks()
            if(stocks.count > 0){
               self.results = stocks
            }
        }catch {
           print("Error on DB creation")
        }
    }
    
    func isLastday() -> Bool {
        guard let date = NSUserDefaults.standardUserDefaults().valueForKey(self.lastFetchTime) else{
            return false
        }
        if (date.daysFrom(NSDate()) > 0 ){
            return true
        }
        return false
    }
    
    func getDataFromServer(symbol : String){
        Alamofire.request(.GET, "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol="+symbol)
            .responseJSON { response in
                if let JSON = response.result.value as? NSDictionary {
                    print("JSON: \(JSON)")
                    let stock = Stock(fromDictionary: JSON)
                    do{
                        try LocalDataHandler.sharedManager.createStock(stock)
                    }catch{
                        print("Error on read stocks from catch")
                    }
                    NSUserDefaults.standardUserDefaults().setValue(NSDate(), forKey: self.lastFetchTime)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.results.removeAll()
                    self.results.append(stock)
                    self.nameValueLabel.text = stock.name
                    self.symolValueLabel.text = stock.symbol
                    self.lastPriceValueLabel.text = "\(stock.lastPrice)"
                }
        }
    }

}

