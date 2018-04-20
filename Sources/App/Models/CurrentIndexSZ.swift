import Vapor
import MySQLProvider


final class CurrentIndexSZ: CurrentIndex {
    static let entity = "current_indexes_sz"

}
extension CurrentIndexSZ: JSONConvertible {
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

extension CurrentIndexSZ: ResponseRepresentable {}

