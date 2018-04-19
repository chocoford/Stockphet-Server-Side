import Vapor
import FluentProvider
import HTTP

final class DailyIndex: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the DailyIndex
    var identifier: String
    var date: String
    var change: String
    var changeAmount: String
    var openPrice: String
    var closePrice: String
    var highPrice: String
    var lowPrice: String
    var transactionVol: String
    var turnoverVol: String
    var riseNum: Int
    var fallNum: Int
    var parityNum: Int
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let identifier = "di_id"
        static let date = "di_date"
        static let change = "di_change"
        static let changeAmount = "di_change_amount"
        static let openPrice = "di_oprice"
        static let closePrice = "di_cprice"
        static let highPrice = "di_hprice"
        static let lowPrice = "di_lprice"
        static let transactionVol = "di_transaction_vol"
        static let turnoverVol = "di_turnover_vol"
        static let riseNum = "di_rise_num"
        static let fallNum = "di_fall_num"
        static let parityNum = "di_parity_num"
    }
    
    /// Creates a new DailyIndex
    init(identifier: String, date: String, change: String, changeAmount: String, openPrice: String, closePrice: String, highPrice: String, lowPrice: String, transactionVol: String, turnoverVol: String, riseNum: Int, fallNum: Int, parityNum: Int) {
        self.identifier = identifier
        self.date = date
        self.change = change
        self.changeAmount = changeAmount
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.transactionVol = transactionVol
        self.turnoverVol = turnoverVol
        self.riseNum = riseNum
        self.fallNum = fallNum
        self.parityNum = parityNum
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the DailyIndex from the
    /// database row
    init(row: Row) throws {
        identifier = try row.get(DailyIndex.Keys.identifier)
        date = try row.get(DailyIndex.Keys.date)
        change = try row.get(DailyIndex.Keys.change)
        changeAmount = try row.get(DailyIndex.Keys.changeAmount)
        openPrice = try row.get(DailyIndex.Keys.openPrice)
        closePrice = try row.get(DailyIndex.Keys.closePrice)
        highPrice = try row.get(DailyIndex.Keys.highPrice)
        lowPrice = try row.get(DailyIndex.Keys.lowPrice)
        transactionVol = try row.get(DailyIndex.Keys.transactionVol)
        turnoverVol = try row.get(DailyIndex.Keys.turnoverVol)
        riseNum = try row.get(DailyIndex.Keys.riseNum)
        fallNum = try row.get(DailyIndex.Keys.fallNum)
        parityNum = try row.get(DailyIndex.Keys.parityNum)
    }

    
    // Serializes the DailyIndex to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(DailyIndex.Keys.identifier, identifier)
        try row.set(DailyIndex.Keys.date, date)
        try row.set(DailyIndex.Keys.change, change)
        try row.set(DailyIndex.Keys.changeAmount, changeAmount)
        try row.set(DailyIndex.Keys.openPrice, openPrice)
        try row.set(DailyIndex.Keys.closePrice, closePrice)
        try row.set(DailyIndex.Keys.highPrice, highPrice)
        try row.set(DailyIndex.Keys.lowPrice, lowPrice)
        try row.set(DailyIndex.Keys.transactionVol, transactionVol)
        try row.set(DailyIndex.Keys.turnoverVol, turnoverVol)
        try row.set(DailyIndex.Keys.riseNum, riseNum)
        try row.set(DailyIndex.Keys.fallNum, fallNum)
        try row.set(DailyIndex.Keys.parityNum, parityNum)
        return row
    }
}


// MARK: Fluent Preparation

extension DailyIndex: Preparation {
    /// Prepares a table/collection in the database
    /// for storing DailyIndex
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(DailyIndex.Keys.identifier)
            builder.string(DailyIndex.Keys.date)
            builder.string(DailyIndex.Keys.change)
            builder.string(DailyIndex.Keys.changeAmount)
            builder.string(DailyIndex.Keys.openPrice)
            builder.string(DailyIndex.Keys.closePrice)
            builder.string(DailyIndex.Keys.highPrice)
            builder.string(DailyIndex.Keys.lowPrice)
            builder.string(DailyIndex.Keys.transactionVol)
            builder.string(DailyIndex.Keys.turnoverVol)
            builder.string(DailyIndex.Keys.riseNum)
            builder.string(DailyIndex.Keys.fallNum)
            builder.string(DailyIndex.Keys.parityNum)
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
//     - Creating a new DailyIndex (DailyIndex /DailyIndex)
//     - Fetching a DailyIndex (GET /DailyIndex, GET /DailyIndex/:id)
//
extension DailyIndex: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            identifier: try json.get(DailyIndex.Keys.identifier),
            date: try json.get(DailyIndex.Keys.date),
            change: try json.get(DailyIndex.Keys.change),
            changeAmount: try json.get(DailyIndex.Keys.changeAmount),
            openPrice: try json.get(DailyIndex.Keys.openPrice),
            closePrice: try json.get(DailyIndex.Keys.closePrice),
            highPrice: try json.get(DailyIndex.Keys.highPrice),
            lowPrice: try json.get(DailyIndex.Keys.lowPrice),
            transactionVol: try json.get(DailyIndex.Keys.transactionVol),
            turnoverVol: try json.get(DailyIndex.Keys.turnoverVol),
            riseNum: try json.get(DailyIndex.Keys.riseNum),
            fallNum: try json.get(DailyIndex.Keys.fallNum),
            parityNum: try json.get(DailyIndex.Keys.parityNum)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        
        try json.set(DailyIndex.Keys.id, id)
        try json.set(DailyIndex.Keys.identifier, identifier)
        try json.set(DailyIndex.Keys.date, date)
        try json.set(DailyIndex.Keys.change, change)
        try json.set(DailyIndex.Keys.changeAmount, changeAmount)
        try json.set(DailyIndex.Keys.openPrice, openPrice)
        try json.set(DailyIndex.Keys.closePrice, closePrice)
        try json.set(DailyIndex.Keys.highPrice, highPrice)
        try json.set(DailyIndex.Keys.lowPrice, lowPrice)
        try json.set(DailyIndex.Keys.transactionVol, transactionVol)
        try json.set(DailyIndex.Keys.turnoverVol, turnoverVol)
        try json.set(DailyIndex.Keys.riseNum, riseNum)
        try json.set(DailyIndex.Keys.fallNum, fallNum)
        try json.set(DailyIndex.Keys.parityNum, parityNum)
        return json

    }
}

// MARK: HTTP

// This allows DailyIndex models to be returned
// directly in route closures
extension DailyIndex: ResponseRepresentable { }

// MARK: Update

// This allows the DailyIndex model to be updated
// dynamically by the request.
extension DailyIndex: Updateable {
    // Updateable keys are called when `DailyIndex.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<DailyIndex>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            //            UpdateableKey(DailyIndex.Keys.content, String.self) { DailyIndex, content in
            //                DailyIndex.content = content
            //            }
        ]
    }
}


