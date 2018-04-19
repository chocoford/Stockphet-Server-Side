import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our DailyBlock table
final class DailyBlockController: ResourceRepresentable {
    /// When users call 'GET' on '/dailyBlocks'
    /// it should return an index of all available dailyBlocks
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try DailyBlock.all().makeJSON()
    }

    /// When consumers call 'POST' on '/dailyBlocks' with valid JSON
    /// construct and save the dailyBlock
    func store(_ req: Request) throws -> ResponseRepresentable {
        let dailyBlock = try req.dailyBlock()
        try dailyBlock.save()
        return dailyBlock
    }

    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/dailyBlocks/13rd88' we should show that specific dailyBlock
    func show(_ req: Request, dailyBlock: DailyBlock) throws -> ResponseRepresentable {
        return dailyBlock
    }

    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'dailyBlocks/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, dailyBlock: DailyBlock) throws -> ResponseRepresentable {
        try dailyBlock.delete()
        return Response(status: .ok)
    }

    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/dailyBlocks' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try DailyBlock.makeQuery().delete()
        return Response(status: .ok)
    }

    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, dailyBlock: DailyBlock) throws -> ResponseRepresentable {
        // See `extension DailyBlock: Updateable`
        try dailyBlock.update(for: req)

        // Save an return the updated dailyBlock.
        try dailyBlock.save()
        return dailyBlock
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this 
    /// implementation
    func makeResource() -> Resource<DailyBlock> {
        return Resource(
            index: index,
            store: store,
            show: show,
            destroy: delete,
            clear: clear
        )
    }
    
    func select(with parameters: Request) throws -> ResponseRepresentable {
        
        let blockId = parameters.data["blockID"]?.string
        let date = parameters.data["date"]?.string ?? String(Date.init(timeIntervalSinceNow: 3600 * -7).description.split(separator: " ").first!)
        
        do {
            let query = try DailyBlock.makeQuery()
            
            if blockId == nil {
                if date != "all" {
                    try query.and { andGroup in
                        try andGroup.filter("db_date", date)
                    }
                }
                do {
                    return try query.all().makeJSON()
                } catch {
                    print("error happened when make json in fetch procedure: \(error.localizedDescription)")
                }
            } else {
                try query.and { andGroup in
                    try andGroup.filter("db_id", blockId)
                    try andGroup.filter("db_date", date)
                }
                do {
                    if let result = try query.first() {
                        return try result.makeJSON()
                    } else {
                        print("fetch error.")
                    }
                } catch {
                    print("error happened when make json in fetch procedure: \(error.localizedDescription)")
                }
            }
            
            
            
        }
        return "selecting error"
    }
    
}

extension Request {
    /// Create a dailyBlock from the JSON body
    /// return BadRequest error if invalid 
    /// or no JSON
    func dailyBlock() throws -> DailyBlock {
        guard let json = json else { throw Abort.badRequest }
        return try DailyBlock(json: json)
    }
}

/// Since DailyBlockController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension DailyBlockController: EmptyInitializable { }
