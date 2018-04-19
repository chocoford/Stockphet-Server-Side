import Vapor
import FluentProvider
import HTTP

final class DailyRecommendation: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the DailyRecommendation
    var rank: Int
    var code: String
    var date: String
    var poer: Double
    var epl: Double
    var ecv: Double
    var erp: Double

    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let rank = "rank"
        static let code = "code"
        static let date = "date"
        static let poer = "poers"
        static let elp = "elps"
        static let ecv = "ecvs"
        static let erp = "erps"
    }
    
    /// Creates a new DailyRecommendation
    init(code: String, date: String, rank: Int, poer: Double, epl: Double, ecv: Double, erp: Double) {
        self.code = code
        self.date = date
        self.rank = rank
        self.poer = poer
        self.epl = epl
        self.ecv = ecv
        self.erp = erp
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the DailyRecommendation from the
    /// database row
    init(row: Row) throws {
        code = try row.get(DailyRecommendation.Keys.code)
        date = try row.get(DailyRecommendation.Keys.date)
        rank = try row.get(DailyRecommendation.Keys.rank)
        poer = try row.get(DailyRecommendation.Keys.poer)
        epl = try row.get(DailyRecommendation.Keys.elp)
        ecv = try row.get(DailyRecommendation.Keys.ecv)
        erp = try row.get(DailyRecommendation.Keys.erp)
    }
    
    // Serializes the DailyRecommendation to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(DailyRecommendation.Keys.code, code)
        try row.set(DailyRecommendation.Keys.date, date)
        try row.set(DailyRecommendation.Keys.rank, rank)
        try row.set(DailyRecommendation.Keys.poer, poer)
        try row.set(DailyRecommendation.Keys.elp, epl)
        try row.set(DailyRecommendation.Keys.ecv, ecv)
        try row.set(DailyRecommendation.Keys.erp, erp)
        return row
    }
}

// MARK: Fluent Preparation

extension DailyRecommendation: Preparation {
    /// Prepares a table/collection in the database
    /// for storing DailyRecommendation
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(DailyRecommendation.Keys.code)
            builder.string(DailyRecommendation.Keys.date)
            builder.int(DailyRecommendation.Keys.rank)
            builder.double(DailyRecommendation.Keys.poer)
            builder.double(DailyRecommendation.Keys.elp)
            builder.double(DailyRecommendation.Keys.ecv)
            builder.double(DailyRecommendation.Keys.erp)
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
//     - Creating a new DailyRecommendation (DailyRecommendation /DailyRecommendation)
//     - Fetching a DailyRecommendation (GET /DailyRecommendation, GET /DailyRecommendation/:id)
//
extension DailyRecommendation: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            code: try json.get(DailyRecommendation.Keys.code),
            date: try json.get(DailyRecommendation.Keys.date),
            rank: try json.get(DailyRecommendation.Keys.rank),
            poer: try json.get(DailyRecommendation.Keys.poer),
            epl: try json.get(DailyRecommendation.Keys.elp),
            ecv: try json.get(DailyRecommendation.Keys.ecv),
            erp: try json.get(DailyRecommendation.Keys.erp)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        
        try json.set(DailyRecommendation.Keys.id, id)
        try json.set(DailyRecommendation.Keys.code, code)
        try json.set(DailyRecommendation.Keys.date, date)
        try json.set(DailyRecommendation.Keys.rank, rank)
        try json.set(DailyRecommendation.Keys.poer, poer)
        try json.set(DailyRecommendation.Keys.elp, epl)
        try json.set(DailyRecommendation.Keys.ecv, ecv)
        try json.set(DailyRecommendation.Keys.erp, erp)
        return json
    }
}

// MARK: HTTP

// This allows DailyRecommendation models to be returned
// directly in route closures
extension DailyRecommendation: ResponseRepresentable { }

// MARK: Update

// This allows the DailyRecommendation model to be updated
// dynamically by the request.
extension DailyRecommendation: Updateable {
    // Updateable keys are called when `DailyRecommendation.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<DailyRecommendation>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            //            UpdateableKey(DailyRecommendation.Keys.content, String.self) { DailyRecommendation, content in
            //                DailyRecommendation.content = content
            //            }
        ]
    }
}


