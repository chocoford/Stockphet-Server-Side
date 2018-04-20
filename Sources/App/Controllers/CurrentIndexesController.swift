import Vapor
import FluentProvider

struct CurrentIndexesController {
    func addRoutes(to drop: Droplet) {
        let currentIndexesGroup = drop.grouped("api", "currentIndexes")
        currentIndexesGroup.get("all", String.parameter, handler: allIndexesInfo)
        currentIndexesGroup.get("latest", String.parameter, handler: getCurrentIndexes)
        let currentIndexesInsertGroup = drop.grouped(host: "localhost")
        currentIndexesInsertGroup.post("create_ci", String.parameter, handler: createCurrentIndexes)
    }
    
    func allIndexesInfo(_ req: Request) throws -> ResponseRepresentable {
        let identifer = try req.parameters.next(String.self)
        print(identifer)
        if identifer == "sz" {
            let indexes = try CurrentIndexSz.all()
            return try indexes.makeJSON()
        } else if identifer == "sh" {
            let indexes = try CurrentIndexSh.all()
            return try indexes.makeJSON()
        } else {
            throw Abort.badRequest
        }
        
    }
    
    func createCurrentIndexes(_ req: Request) throws -> ResponseRepresentable {
        let identifer = try req.parameters.next(String.self)
        guard let json = req.json else { throw Abort.badRequest }
        if identifer == "sz" {
            let index = try CurrentIndexSz.init(json: json)
            try index.save()
            return index
        } else if identifer == "sh" {
            let index = try CurrentIndexSh.init(json: json)
            try index.save()
            return index
        } else {
            throw Abort.badRequest
        }
    }
    
    func getCurrentIndexes(_ req: Request) throws -> ResponseRepresentable {
        let identifer = try req.parameters.next(String.self)
        if identifer == "sz" {
            return (try CurrentIndexSz.makeQuery().filter(raw: "id = (select max(id) from \(CurrentIndexSz.entity))").first()?.makeJSON())!
        } else if identifer == "sh" {
            return (try CurrentIndexSh.makeQuery().filter(raw: "id = (select max(id) from \(CurrentIndexSh.entity))").first()?.makeJSON())!
        } else {
            throw Abort.badRequest
        }
    }
    
}
