import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our DailyIndex table
final class DailyIndexController: ResourceRepresentable {
    /// When users call 'GET' on '/dailyIndexs'
    /// it should return an index of all available dailyIndexs
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try DailyIndex.all().makeJSON()
    }

    /// When consumers call 'POST' on '/dailyIndexs' with valid JSON
    /// construct and save the dailyIndex
    func store(_ req: Request) throws -> ResponseRepresentable {
        let dailyIndex = try req.dailyIndex()
        try dailyIndex.save()
        return dailyIndex
    }

    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/dailyIndexs/13rd88' we should show that specific dailyIndex
    func show(_ req: Request, dailyIndex: DailyIndex) throws -> ResponseRepresentable {
        return dailyIndex
    }

    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'dailyIndexs/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, dailyIndex: DailyIndex) throws -> ResponseRepresentable {
        try dailyIndex.delete()
        return Response(status: .ok)
    }

    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/dailyIndexs' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try DailyIndex.makeQuery().delete()
        return Response(status: .ok)
    }

    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, dailyIndex: DailyIndex) throws -> ResponseRepresentable {
        // See `extension DailyIndex: Updateable`
        try dailyIndex.update(for: req)

        // Save an return the updated dailyIndex.
        try dailyIndex.save()
        return dailyIndex
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this 
    /// implementation
    func makeResource() -> Resource<DailyIndex> {
        return Resource(
            index: index,
            store: store,
            show: show,
            destroy: delete,
            clear: clear
        )
    }
    
    func select(_ req: Request) throws -> ResponseRepresentable {
        var reslutJson: JSON?
        
        let identifier = req.data["identifier"]?.string
        let date = req.data["date"]?.string
        do {
            let query = try DailyIndex.makeQuery()
            if identifier != nil && date != nil {
                try query.and { andGroup in
                    try andGroup.filter("di_id", identifier!)
                    try andGroup.filter("di_date", date!)
                }
                if let result = try query.first() {
                    reslutJson = try result.makeJSON()
                } else {
                    print("fetch error.")
                }
            } else {
                if identifier != nil || date != nil {
                    try query.and { andGroup in
                        if identifier != nil {
                            try andGroup.filter("di_id", identifier!)
                        }
                        if date != nil {
                            try andGroup.filter("di_date", date!)
                        }
                    }
                }
                do {
                    reslutJson = try query.all().makeJSON()
                } catch {
                    print("error happened when make json in fetch procedure: \(error.localizedDescription)")
                }
            }
            
        } catch {
            print(error.localizedDescription)
            throw Abort(.badRequest, reason: "make query failed.")
        }
        return reslutJson ?? "selecting error."
    }
 
    
}

extension Request {
    /// Create a dailyIndex from the JSON body
    /// return BadRequest error if invalid 
    /// or no JSON
    func dailyIndex() throws -> DailyIndex {
        guard let json = json else { throw Abort.badRequest }
        return try DailyIndex(json: json)
    }
}

/// Since DailyIndexController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension DailyIndexController: EmptyInitializable { }
