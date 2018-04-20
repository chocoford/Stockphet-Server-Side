import Vapor
import FluentProvider

struct CurrentIndexesController {
    func addRoutes(to drop: Droplet) {
        let currentIndexesGroup = drop.grouped("currentIndexes")
        currentIndexesGroup.get("all", String.parameter, handler: allIndexesInfo)
        currentIndexesGroup.post("create", String.parameter, handler: createCurrentIndexes)
        currentIndexesGroup.get("latest", String.parameter, handler: getCurrentIndexes)
    }
    
    func allIndexesInfo(_ req: Request) throws -> ResponseRepresentable {
        let identifer = try req.parameters.next(String.self)
        if identifer == "sz" {
            let indexes = try CurrentIndexSz.all()
            return try indexes.makeJSON()
        } else {
            let indexes = try CurrentIndexSh.all()
            return try indexes.makeJSON()
        }
        
    }
    
    func createCurrentIndexes(_ req: Request) throws -> ResponseRepresentable {
        let identifer = try req.parameters.next(String.self)
        guard let json = req.json else { throw Abort.badRequest }
        if identifer == "sz" {
            let index = try CurrentIndexSz.init(json: json)
            try index.save()
            return index
        } else {
            let index = try CurrentIndexSh.init(json: json)
            try index.save()
            return index
        }
    }
    
    func getCurrentIndexes(_ req: Request) throws -> ResponseRepresentable {
        let identifer = try req.parameters.next(String.self)
        if identifer == "sz" {
            return (try CurrentIndexSz.makeQuery().filter(raw: "id = LAST_INSERT_ID()").first()?.makeJSON())!
        } else {
            return (try CurrentIndexSh.makeQuery().filter(raw: "id = LAST_INSERT_ID()").first()?.makeJSON())!
        }
    }
    
}
