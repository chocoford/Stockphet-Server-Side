import Vapor
import FluentProvider

struct CurrentIndexesController {
    func addRoutes(to drop: Droplet) {
        let currentIndexesGroup = drop.grouped("currentIdexes")
        currentIndexesGroup.get("all", String.parameter, handler: allIndexesInfo)
        currentIndexesGroup.post("create", String.parameter, handler: createCurrentIndexes)
        currentIndexesGroup.get("latest", String.parameter, handler: getCurrentIndexes)
    }
    
    func allIndexesInfo(_ req: Request) throws -> ResponseRepresentable {
        let identifer = try req.parameters.next(String.self)
        if identifer == "sz" {
            let indexes = try CurrentIndexSZ.all()
            return try indexes.makeJSON()
        } else {
            let indexes = try CurrentIndexSH.all()
            return try indexes.makeJSON()
        }
        
    }
    
    func createCurrentIndexes(_ req: Request) throws -> ResponseRepresentable {
        let identifer = try req.parameters.next(String.self)
        guard let json = req.json else { throw Abort.badRequest }
        if identifer == "sz" {
            let index = try CurrentIndexSZ.init(json: json)
            try index.save()
            return index
        } else {
            let index = try CurrentIndexSH.init(json: json)
            try index.save()
            return index
        }
    }
    
    func getCurrentIndexes(_ req: Request) throws -> ResponseRepresentable {
        let identifer = try req.parameters.next(String.self)
        if identifer == "sz" {
            return (try CurrentIndexSZ.makeQuery().filter(raw: "id = LAST_INSERT_ID()").first()?.makeJSON())!
        } else {
            return (try CurrentIndexSH.makeQuery().filter(raw: "id = LAST_INSERT_ID()").first()?.makeJSON())!
        }
    }
    
}
