import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our DailyRecommendation table
final class DailyRecommendationController: ResourceRepresentable {
    /// When users call 'GET' on '/dailyRecommendations'
    /// it should return an index of all available dailyRecommendations
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try DailyRecommendation.all().makeJSON()
    }

    /// When consumers call 'POST' on '/dailyRecommendations' with valid JSON
    /// construct and save the dailyRecommendation
    func store(_ req: Request) throws -> ResponseRepresentable {
        let dailyRecommendation = try req.dailyRecommendation()
        try dailyRecommendation.save()
        return dailyRecommendation
    }

    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/dailyRecommendations/13rd88' we should show that specific dailyRecommendation
    func show(_ req: Request, dailyRecommendation: DailyRecommendation) throws -> ResponseRepresentable {
        return dailyRecommendation
    }

    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'dailyRecommendations/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, dailyRecommendation: DailyRecommendation) throws -> ResponseRepresentable {
        try dailyRecommendation.delete()
        return Response(status: .ok)
    }

    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/dailyRecommendations' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try DailyRecommendation.makeQuery().delete()
        return Response(status: .ok)
    }

    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, dailyRecommendation: DailyRecommendation) throws -> ResponseRepresentable {
        // See `extension DailyRecommendation: Updateable`
        try dailyRecommendation.update(for: req)

        // Save an return the updated dailyRecommendation.
        try dailyRecommendation.save()
        return dailyRecommendation
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this 
    /// implementation
    func makeResource() -> Resource<DailyRecommendation> {
        return Resource(
            index: index,
            store: store,
            show: show,
            destroy: delete,
            clear: clear
        )
    }
    
    func select(_ req: Request) throws -> ResponseRepresentable {
        let today = String(Date().description.split(separator: " ").first!)
        
        var reslutJson: JSON?
        
        let count = req.data["count"]?.int ?? 50
        let date = req.data["date"]?.string
        let rank = req.data["rank"]?.string
        let code = req.data["code"]?.string
        
        do {
            let query = try DailyRecommendation.makeQuery()
            if code != nil {
                try query.and { andGroup in
                    try andGroup.filter("code", code!)
                    try andGroup.filter("date", today)
                }
                if let result = try query.first() {
                    reslutJson = try result.makeJSON()
                }
            } else {
                if rank != nil && date == nil {                         //select today the stock result according to rank.
                    try query.and { andGroup in
                        try andGroup.filter("rank", rank!)
                        try andGroup.filter("date", today)
                    }
                    if let result = try query.first() {
                        reslutJson = try result.makeJSON()
                    }
                    
                    
                } else if rank == nil && date != nil {
                    try query.and { andGroup in
                        if date != "all" {
                            try andGroup.filter("date", date!)
                        }
                        try andGroup.filter("rank", .lessThan, count)
                    }
                    reslutJson = try query.all().makeJSON()
                    
                } else if rank != nil && date != nil {                  //including sepecify date and rank as well as specific rank all date
                    if date == "all" {
                        try query.and { andGroup in
                            try andGroup.filter("rank", rank!)
                        }
                        reslutJson = try query.all().makeJSON()
                    } else {
                        try query.and { andGroup in
                            try andGroup.filter("rank", rank!)
                            try andGroup.filter("date", date!)
                        }
                        if let result = try query.first() {
                            reslutJson = try result.makeJSON()
                        } else {
                            print("fetch error.")
                        }
                    }
                } else {
                    try query.and { andGroup in
                        try andGroup.filter("rank", .lessThan, count)
                    }
                    reslutJson = try query.all().makeJSON()
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
    /// Create a dailyRecommendation from the JSON body
    /// return BadRequest error if invalid 
    /// or no JSON
    func dailyRecommendation() throws -> DailyRecommendation {
        guard let json = json else { throw Abort.badRequest }
        return try DailyRecommendation(json: json)
    }
}

/// Since DailyRecommendationController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension DailyRecommendationController: EmptyInitializable { }
