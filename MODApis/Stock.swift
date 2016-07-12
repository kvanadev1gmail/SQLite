

import Foundation

class Stock{

	var change : Float!
	var changePercent : Float!
	var changePercentYTD : Float!
	var changeYTD : Float!
	var high : Float!
	var lastPrice : Float!
	var low : Float!
	var mSDate : Float!
	var marketCap : Int!
	var name : String!
	var open : Float!
	var status : String!
	var symbol : String!
	var timestamp : String!
	var volume : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	convenience init(fromDictionary dictionary: NSDictionary){
        self.init()
		change = dictionary["Change"] as? Float
		changePercent = dictionary["ChangePercent"] as? Float
		changePercentYTD = dictionary["ChangePercentYTD"] as? Float
		changeYTD = dictionary["ChangeYTD"] as? Float
		high = dictionary["High"] as? Float
		lastPrice = dictionary["LastPrice"] as? Float
		low = dictionary["Low"] as? Float
		mSDate = dictionary["MSDate"] as? Float
		marketCap = dictionary["MarketCap"] as? Int
		name = dictionary["Name"] as? String
		open = dictionary["Open"] as? Float
		status = dictionary["Status"] as? String
		symbol = dictionary["Symbol"] as? String
		timestamp = dictionary["Timestamp"] as? String
		volume = dictionary["Volume"] as? Int
	}

}