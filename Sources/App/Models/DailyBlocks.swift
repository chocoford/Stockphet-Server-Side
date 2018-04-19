import Vapor
import FluentProvider
import HTTP

final class DailyBlock: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the DailyBlock
    var identifier: String
    var name: String
    var date: String
    var change: Double
    var changeAmount: Double
    var riseNum: Int
    var fallNum: Int
    var parityNum: Int
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let identifer = "db_id"
        static let name = "db_name"
        static let date = "db_date"
        static let change = "db_change"
        static let changeAmount = "db_change_amount"
        static let riseNum = "db_rise_num"
        static let fallNum = "db_fall_num"
        static let parityNum = "db_parity_num"
    }
    
    /// Creates a new DailyBlock
    init(identifier: String, name: String, date: String, change: Double, changeAmount: Double, riseNum: Int, fallNum: Int, parityNum: Int) {
        self.identifier = identifier
        self.name = name
        self.date = date
        self.change = change
        self.changeAmount = changeAmount
        self.riseNum = riseNum
        self.fallNum = fallNum
        self.parityNum = parityNum
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the DailyBlock from the
    /// database row
    init(row: Row) throws {
        identifier = try row.get(DailyBlock.Keys.identifer)
        name = try row.get(DailyBlock.Keys.name)
        date = try row.get(DailyBlock.Keys.date)
        change = try row.get(DailyBlock.Keys.change)
        changeAmount = try row.get(DailyBlock.Keys.changeAmount)
        riseNum = try row.get(DailyBlock.Keys.riseNum)
        fallNum = try row.get(DailyBlock.Keys.fallNum)
        parityNum = try row.get(DailyBlock.Keys.parityNum)
    }
    
    // Serializes the DailyBlock to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(DailyBlock.Keys.identifer, identifier)
        try row.set(DailyBlock.Keys.name, name)
        try row.set(DailyBlock.Keys.date, date)
        try row.set(DailyBlock.Keys.change, change)
        try row.set(DailyBlock.Keys.changeAmount, changeAmount)
        try row.set(DailyBlock.Keys.riseNum, riseNum)
        try row.set(DailyBlock.Keys.fallNum, fallNum)
        try row.set(DailyBlock.Keys.parityNum, parityNum)
        return row
    }
}

// MARK: Fluent Preparation

extension DailyBlock: Preparation {
    /// Prepares a table/collection in the database
    /// for storing DailyBlock
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(DailyBlock.Keys.identifer)
            builder.string(DailyBlock.Keys.name)
            builder.string(DailyBlock.Keys.date)
            builder.double(DailyBlock.Keys.change)
            builder.double(DailyBlock.Keys.changeAmount)
            builder.int(DailyBlock.Keys.riseNum)
            builder.int(DailyBlock.Keys.fallNum)
            builder.int(DailyBlock.Keys.parityNum)
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
//     - Creating a new DailyBlock (DailyBlock /DailyBlock)
//     - Fetching a DailyBlock (GET /DailyBlock, GET /DailyBlock/:id)
//
extension DailyBlock: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            identifier: try json.get(DailyBlock.Keys.identifer),
            name: try json.get(DailyBlock.Keys.name),
            date: try json.get(DailyBlock.Keys.date),
            change: try json.get(DailyBlock.Keys.change),
            changeAmount: try json.get(DailyBlock.Keys.changeAmount),
            riseNum: try json.get(DailyBlock.Keys.riseNum),
            fallNum: try json.get(DailyBlock.Keys.fallNum),
            parityNum: try json.get(DailyBlock.Keys.parityNum)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(DailyBlock.Keys.id, id)
        try json.set(DailyBlock.Keys.identifer, identifier)
        try json.set(DailyBlock.Keys.name, name)
        try json.set(DailyBlock.Keys.date, date)
        try json.set(DailyBlock.Keys.change, change)
        try json.set(DailyBlock.Keys.changeAmount, changeAmount)
        try json.set(DailyBlock.Keys.riseNum, riseNum)
        try json.set(DailyBlock.Keys.fallNum, fallNum)
        try json.set(DailyBlock.Keys.parityNum, parityNum)
        return json
    }
}

// MARK: HTTP

// This allows DailyBlock models to be returned
// directly in route closures
extension DailyBlock: ResponseRepresentable { }

// MARK: Update

// This allows the DailyBlock model to be updated
// dynamically by the request.
extension DailyBlock: Updateable {
    // Updateable keys are called when `DailyBlock.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<DailyBlock>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            //            UpdateableKey(DailyBlock.Keys.content, String.self) { DailyBlock, content in
            //                DailyBlock.content = content
            //            }
        ]
    }
}


