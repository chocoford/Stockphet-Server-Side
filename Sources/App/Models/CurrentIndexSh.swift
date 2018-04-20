import Vapor
import MySQLProvider


final class CurrentIndexSh:CurrentIndex, Model {
    static var entity = "current_indexes_sh"
}
extension CurrentIndexSh: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Properties.id, id)
        //        try json.set(Properties.identifier, identifier)
        try json.set(Properties.time, time)
        try json.set(Properties.price, price)
        try json.set(Properties.change, change)
        try json.set(Properties.changeAmount, changeAmount)
        try json.set(Properties.transactionVol, transactionVol)
        try json.set(Properties.turnoverVol, turnoverVol)
        try json.set(Properties.riseNum, riseNum)
        try json.set(Properties.fallNum, fallNum)
        try json.set(Properties.parityNum, parityNum)
        return json
    }
    
    convenience init(json: JSON) throws {
        try self.init(
            //            identifier: json.get(Properties.identifier),
            time: json.get(Properties.time),
            price: json.get(Properties.price),
            change: json.get(Properties.change),
            changeAmount: json.get(Properties.changeAmount),
            transactionVol: json.get(Properties.transactionVol),
            turnoverVol: json.get(Properties.turnoverVol),
            riseNum: json.get(Properties.riseNum),
            fallNum: json.get(Properties.fallNum),
            parityNum: json.get(Properties.parityNum))
    }
}

extension CurrentIndexSh: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { builder in
            builder.id()
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


extension CurrentIndexSh: ResponseRepresentable {}

