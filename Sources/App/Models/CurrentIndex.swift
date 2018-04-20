import Vapor
import FluentProvider
import MySQLProvider


class CurrentIndex: Model {
    var storage = Storage()
    
    struct Properties {
        static let id = "id"
//        static let identifier = "identifier"
        static let time = "time"
        static let price = "price"
        static let change = "change"
        static let changeAmount = "change_amount"
        static let transactionVol = "transaction_vol"
        static let turnoverVol = "turnover_vol"
        static let riseNum = "rise_num"
        static let fallNum = "fall_num"
        static let parityNum = "parity_num"
    }
    
//    var identifier: String
    var time: String
    var price: String
    var change: String
    var changeAmount: String
    var transactionVol: String
    var turnoverVol: String
    var riseNum: Int
    var fallNum: Int
    var parityNum: Int
    
    init(time: String, price: String, change: String, changeAmount: String, transactionVol: String, turnoverVol: String, riseNum: Int, fallNum: Int, parityNum: Int) {
//        self.identifier = identifier
        self.time = time
        self.price = price
        self.change = change
        self.changeAmount = changeAmount
        self.transactionVol = transactionVol
        self.turnoverVol = turnoverVol
        self.riseNum = riseNum
        self.fallNum = fallNum
        self.parityNum = parityNum
    }
    
    func makeRow() throws -> Row {
        var row = Row()
//        try row.set(Properties.identifier, identifier)
        try row.set(Properties.time, time)
        try row.set(Properties.price, price)
        try row.set(Properties.change, change)
        try row.set(Properties.changeAmount, changeAmount)
        try row.set(Properties.transactionVol, transactionVol)
        try row.set(Properties.turnoverVol, turnoverVol)
        try row.set(Properties.riseNum, riseNum)
        try row.set(Properties.fallNum, fallNum)
        try row.set(Properties.parityNum, parityNum)
        return row
    }
    
    required init(row: Row) throws {
//        identifier = try row.get(Properties.identifier)
        time = try row.get(Properties.time)
        price = try row.get(Properties.price)
        change = try row.get(Properties.change)
        changeAmount = try row.get(Properties.changeAmount)
        transactionVol = try row.get(Properties.transactionVol)
        turnoverVol = try row.get(Properties.turnoverVol)
        riseNum = try row.get(Properties.riseNum)
        fallNum = try row.get(Properties.fallNum)
        parityNum = try row.get(Properties.parityNum)
    }
}

extension CurrentIndex: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { builder in
            builder.id()
//            builder.string(Properties.identifier)
            builder.string(Properties.time)
            builder.string(Properties.price)
            builder.string(Properties.change)
            builder.string(Properties.changeAmount)
            builder.string(Properties.transactionVol)
            builder.string(Properties.turnoverVol)
            builder.int(Properties.riseNum)
            builder.int(Properties.fallNum)
            builder.int(Properties.parityNum)
            
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

//extension CurrentIndex: JSONConvertible {
//    func makeJSON() throws -> JSON {
//        var json = JSON()
//        try json.set(Properties.id, id)
////        try json.set(Properties.identifier, identifier)
//        try json.set(Properties.time, time)
//        try json.set(Properties.price, price)
//        try json.set(Properties.change, change)
//        try json.set(Properties.changeAmount, changeAmount)
//        try json.set(Properties.transactionVol, transactionVol)
//        try json.set(Properties.turnoverVol, turnoverVol)
//        try json.set(Properties.riseNum, riseNum)
//        try json.set(Properties.fallNum, fallNum)
//        try json.set(Properties.parityNum, parityNum)
//        return json
//    }
//    
//    convenience init(json: JSON) throws {
//        try self.init(
////            identifier: json.get(Properties.identifier),
//                      time: json.get(Properties.time),
//                      price: json.get(Properties.price),
//                      change: json.get(Properties.change),
//                      changeAmount: json.get(Properties.changeAmount),
//                      transactionVol: json.get(Properties.transactionVol),
//                      turnoverVol: json.get(Properties.turnoverVol),
//                      riseNum: json.get(Properties.riseNum),
//                      fallNum: json.get(Properties.fallNum),
//                      parityNum: json.get(Properties.parityNum))
//    }
//}


