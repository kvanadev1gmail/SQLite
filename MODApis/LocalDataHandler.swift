//
//  LocalDataHandler.swift
//  MODApis
//
//  Created by Narendra Kumar on 7/9/16.
//  Copyright © 2016 Kvana. All rights reserved.
//

import Foundation
import SQLite
class LocalDataHandler{
    static let sharedManager = LocalDataHandler()
    let users = Table("Stocks")
    let symbol = Expression<String>("symbol")
    let name = Expression<String?>("name")
    let lastPrice = Expression<Double>("lastPrice")
    
    func createStockTable() throws {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        let db = try Connection("\(path)/db.sqlite3")
        try db.run(users.create(ifNotExists: true) { t in
            t.column(symbol, primaryKey: true)
            t.column(name)
            t.column(lastPrice)
            })
    }
    
    func readStocks() throws -> [Stock] {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        let db = try Connection("\(path)/db.sqlite3")
        var results : [Stock] = []
        for user in try db.prepare(users) {
            print("From local cache id: \(user[symbol]), name: \(user[name]), email: \(user[lastPrice])")
            let stock = Stock()
            stock.name = user[name]
            stock.symbol = user[symbol]
            stock.lastPrice = Float(user[lastPrice])
            results.append(stock)
        }
        return results
    }
    
    func createStock(stock : Stock) throws {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        let db = try Connection("\(path)/db.sqlite3")
        let insert = users.insert(name <- stock.name, lastPrice <- Double(stock.lastPrice), symbol <- stock.symbol)
        try db.run(insert)
    }
    
}
