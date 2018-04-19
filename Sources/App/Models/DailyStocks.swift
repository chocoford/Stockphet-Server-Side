import Vapor
import FluentProvider
import HTTP

final class DailyStock: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the DailyStock
    var stockCode: String
    var stockName: String
    var date: String
    var changeAmount:String
    var changeRate: String
    var openPrice: String
    var closePrice: String
    var highPrice: String
    var lowPrice: String
    var forePrice: String
    var committeeRate: String
    var quantityRatio: String
    var turnoverRate: String
    var turnoverVol: String
    var transactionVol: String
    var netAssetsPerShare: String
    var peRate: String
    var pbRate: String
    var eps: String
    var totalValue: String
    var currencyValue: String
    
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let stockCode = "ds_code"
        static let stockName = "ds_name"
        static let date = "ds_date"
        static let changeAmount = "ds_change_amount"
        static let changeRate = "ds_change"
        static let openPrice = "ds_oprice"
        static let closePrice = "ds_cprice"
        static let highPrice = "ds_hprice"
        static let lowPrice = "ds_lprice"
        static let forePrice = "ds_fprice"
        static let committeeRate = "ds_committee"
        static let quantityRatio = "ds_quantity_ratio"
        static let turnoverRate = "ds_turnover_rate"
        static let turnoverVol = "ds_turnover_vol"
        static let transactionVol = "ds_transaction_vol"
        static let netAssetsPerShare = "ds_net_assets_per_share"
        static let peRate = "ds_pe_rate"
        static let pbRate = "ds_pb_rate"
        static let eps = "ds_eps"
        static let totalValue = "ds_total_value"
        static let currencyValue = "ds_currency_value"
    }
    
    /// Creates a new DailyStock
    init(stockCode: String, stockName: String, date: String, changeAmount: String, changeRate: String, openPrice: String, closePrice: String, highPrice: String, lowPrice: String, forePrice: String, committeeRate: String, quantityRatio: String, turnoverRate: String, turnoverVol: String, transactionVol: String, netAssetsPerShare: String, peRate: String, pbRate: String, eps: String, totalValue: String, currencyValue: String) {
        self.stockCode = stockCode
        self.stockName = stockName
        self.date = date
        self.changeAmount = changeAmount
        self.changeRate = changeRate
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.forePrice = forePrice
        self.committeeRate = committeeRate
        self.quantityRatio = quantityRatio
        self.turnoverRate = turnoverRate
        self.turnoverVol = turnoverVol
        self.transactionVol = transactionVol
        self.netAssetsPerShare = netAssetsPerShare
        self.peRate = peRate
        self.pbRate = pbRate
        self.eps = eps
        self.totalValue = totalValue
        self.currencyValue = currencyValue
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the DailyStock from the
    /// database row
    init(row: Row) throws {
        stockCode = try row.get(DailyStock.Keys.stockCode)
        stockName = try row.get(DailyStock.Keys.stockName)
        date = try row.get(DailyStock.Keys.date)
        changeAmount = try row.get(DailyStock.Keys.changeAmount)
        changeRate = try row.get(DailyStock.Keys.changeRate)
        
        openPrice = try row.get(DailyStock.Keys.openPrice)
        closePrice = try row.get(DailyStock.Keys.closePrice)
        highPrice = try row.get(DailyStock.Keys.highPrice)
        lowPrice = try row.get(DailyStock.Keys.lowPrice)
        forePrice = try row.get(DailyStock.Keys.forePrice)
        
        committeeRate = try row.get(DailyStock.Keys.committeeRate)
        quantityRatio = try row.get(DailyStock.Keys.quantityRatio)
        turnoverRate = try row.get(DailyStock.Keys.turnoverRate)
        turnoverVol = try row.get(DailyStock.Keys.turnoverVol)
        transactionVol = try row.get(DailyStock.Keys.transactionVol)
        
        netAssetsPerShare = try row.get(DailyStock.Keys.netAssetsPerShare)
        peRate = try row.get(DailyStock.Keys.peRate)
        pbRate = try row.get(DailyStock.Keys.pbRate)
        eps = try row.get(DailyStock.Keys.eps)
        totalValue = try row.get(DailyStock.Keys.totalValue)
        
        currencyValue = try row.get(DailyStock.Keys.currencyValue)
    }
    
    // Serializes the DailyStock to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(DailyStock.Keys.stockCode, stockCode)
        try row.set(DailyStock.Keys.stockName, stockName)
        try row.set(DailyStock.Keys.date, date)
        try row.set(DailyStock.Keys.changeAmount, changeAmount)
        try row.set(DailyStock.Keys.changeRate, changeRate)
        
        try row.set(DailyStock.Keys.openPrice, openPrice)
        try row.set(DailyStock.Keys.closePrice, closePrice)
        try row.set(DailyStock.Keys.highPrice, highPrice)
        try row.set(DailyStock.Keys.lowPrice, lowPrice)
        try row.set(DailyStock.Keys.forePrice, forePrice)
        
        try row.set(DailyStock.Keys.committeeRate, committeeRate)
        try row.set(DailyStock.Keys.quantityRatio, quantityRatio)
        try row.set(DailyStock.Keys.turnoverRate, turnoverRate)
        try row.set(DailyStock.Keys.turnoverVol, turnoverVol)
        try row.set(DailyStock.Keys.transactionVol, transactionVol)
        
        try row.set(DailyStock.Keys.netAssetsPerShare, netAssetsPerShare)
        try row.set(DailyStock.Keys.peRate, peRate)
        try row.set(DailyStock.Keys.pbRate, pbRate)
        try row.set(DailyStock.Keys.eps, eps)
        try row.set(DailyStock.Keys.totalValue, totalValue)
        
        try row.set(DailyStock.Keys.currencyValue, currencyValue)
        return row
    }
}

// MARK: Fluent Preparation

extension DailyStock: Preparation {
    /// Prepares a table/collection in the database
    /// for storing DailyStock
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(DailyStock.Keys.stockCode)
            builder.string(DailyStock.Keys.stockName)
            builder.string(DailyStock.Keys.date)//历史遗留
            builder.string(DailyStock.Keys.changeAmount)
            
            builder.string(DailyStock.Keys.changeRate)
            builder.string(DailyStock.Keys.openPrice)
            builder.string(DailyStock.Keys.closePrice)
            builder.string(DailyStock.Keys.highPrice)
            builder.string(DailyStock.Keys.lowPrice)
            
            builder.string(DailyStock.Keys.forePrice)
            builder.string(DailyStock.Keys.committeeRate)
            builder.string(DailyStock.Keys.quantityRatio)
            builder.string(DailyStock.Keys.turnoverRate)
            builder.string(DailyStock.Keys.turnoverVol)
            
            builder.string(DailyStock.Keys.transactionVol)
            builder.string(DailyStock.Keys.netAssetsPerShare)
            builder.string(DailyStock.Keys.peRate)
            builder.string(DailyStock.Keys.pbRate)
            builder.string(DailyStock.Keys.eps)
            
            builder.string(DailyStock.Keys.totalValue)
            builder.string(DailyStock.Keys.currencyValue)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new DailyStock (DailyStock /DailyStock)
//     - Fetching a DailyStock (GET /DailyStock, GET /DailyStock/:id)
//
extension DailyStock: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            stockCode: try json.get(DailyStock.Keys.stockCode),
            stockName: try json.get(DailyStock.Keys.stockName),
            date: try json.get(DailyStock.Keys.date),
            changeAmount: try json.get(DailyStock.Keys.changeAmount),
            changeRate: try json.get(DailyStock.Keys.changeRate),
            
            openPrice: try json.get(DailyStock.Keys.openPrice),
            closePrice: try json.get(DailyStock.Keys.closePrice),
            highPrice: try json.get(DailyStock.Keys.highPrice),
            lowPrice: try json.get(DailyStock.Keys.lowPrice),
            forePrice: try json.get(DailyStock.Keys.forePrice),
            
            committeeRate: try json.get(DailyStock.Keys.committeeRate),
            quantityRatio: try json.get(DailyStock.Keys.quantityRatio),
            turnoverRate: try json.get(DailyStock.Keys.turnoverRate),
            turnoverVol: try json.get(DailyStock.Keys.turnoverVol),
            transactionVol: try json.get(DailyStock.Keys.transactionVol),
            
            netAssetsPerShare: try json.get(DailyStock.Keys.netAssetsPerShare),
            peRate: try json.get(DailyStock.Keys.peRate),
            pbRate: try json.get(DailyStock.Keys.pbRate),
            eps: try json.get(DailyStock.Keys.eps),
            totalValue: try json.get(DailyStock.Keys.totalValue),
            
            currencyValue: try json.get(DailyStock.Keys.currencyValue)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        
        try json.set(DailyStock.Keys.id, id)
        try json.set(DailyStock.Keys.stockCode, stockCode)
        try json.set(DailyStock.Keys.stockName, stockName)
        try json.set(DailyStock.Keys.date, date)
        try json.set(DailyStock.Keys.changeAmount, changeAmount)
        
        try json.set(DailyStock.Keys.changeRate, changeRate)
        try json.set(DailyStock.Keys.openPrice, openPrice)
        try json.set(DailyStock.Keys.closePrice, closePrice)
        try json.set(DailyStock.Keys.highPrice, highPrice)
        try json.set(DailyStock.Keys.lowPrice, lowPrice)
        
        try json.set(DailyStock.Keys.forePrice, forePrice)
        try json.set(DailyStock.Keys.committeeRate, committeeRate)
        try json.set(DailyStock.Keys.quantityRatio, quantityRatio)
        try json.set(DailyStock.Keys.turnoverRate, turnoverRate)
        try json.set(DailyStock.Keys.turnoverVol, turnoverVol)
        
        try json.set(DailyStock.Keys.transactionVol, transactionVol)
        try json.set(DailyStock.Keys.netAssetsPerShare, netAssetsPerShare)
        try json.set(DailyStock.Keys.peRate, peRate)
        try json.set(DailyStock.Keys.pbRate, pbRate)
        try json.set(DailyStock.Keys.eps, eps)
        
        try json.set(DailyStock.Keys.totalValue, totalValue)
        try json.set(DailyStock.Keys.currencyValue, currencyValue)
        return json
    }
}

// MARK: HTTP

// This allows DailyStock models to be returned
// directly in route closures
extension DailyStock: ResponseRepresentable { }

// MARK: Update

// This allows the DailyStock model to be updated
// dynamically by the request.
extension DailyStock: Updateable {
    // Updateable keys are called when `DailyStock.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<DailyStock>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            //            UpdateableKey(DailyStock.Keys.content, String.self) { DailyStock, content in
            //                DailyStock.content = content
            //            }
        ]
    }
}


