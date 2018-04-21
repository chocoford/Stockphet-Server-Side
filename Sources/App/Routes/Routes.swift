import Vapor

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        get("plaintext") { req in
            return "Hello, world!"
        }
        
        let currentIndexesController = CurrentIndexesController()
        currentIndexesController.addRoutes(to: self)
        let dailyStockImagesController = DailyStockImagesController.init()
        dailyStockImagesController.addRountes(to: self)
        
        group(host: "localhost") { vapor in
            let dailyStockController = DailyStockController()
            let dailyBlockController = DailyBlockController()
            let dailyIndexController = DailyIndexController()
            let recommendedStockController = DailyRecommendationController()
            vapor.post("insert_ds") { request in
                // only responds to requests to localhost
                return try dailyStockController.store(request)
            }
            vapor.post("insert_db") { request in
                return try dailyBlockController.store(request)
            }
            vapor.post("insert_di") { request in
                return try dailyIndexController.store(request)
            }
            
            vapor.post("insert_dr", handler: { (requset) -> ResponseRepresentable in
                return try recommendedStockController.store(requset)
            })
            

            
        }
        
        get("query", String.parameter) { req in
            let dailyStockController = DailyStockController()
            let dailyBlockController = DailyBlockController()
            let dailyIndexController = DailyIndexController()
            let dailyRecommendationController = DailyRecommendationController()
            do {
                switch try req.parameters.next(String.self) {
                case "dailyStocks":
                    return try dailyStockController.select(req)
                case "allDailyStocks":
                    return try dailyStockController.index(req)
                case "validStockCodes":
                    return (try! DailyStock.database?.raw("select distinct ds_code from daily_stocks").wrapped.array?.compactMap({
                        return $0["ds_code"]
                    }).description) ?? "error"
                case "dailyRecommendationCode":
                    return try Response(filePath: "Resources/dailyRecommendationCode.json")
                case "dailyRecommendation":
                    return try dailyRecommendationController.select(req)
                case "dailyIndex":
                    return try dailyIndexController.select(req)
                case "dailyBlocks":
                    return try dailyBlockController.select(with: req)
                default:
                    return "error"
                }
            } catch {
                print(error.localizedDescription)
                throw Abort.badRequest
            }
        }
        
        get("resource", String.parameter) {req in
            switch try req.parameters.next(String.self) {
            case "stockInfo":
                return try Response(filePath: "Resources/stock_info.json")
                
            case "stockStock":
                return try Response(filePath: "Resources/stock_code.json")

                
            default:
                return "error"
            }
        }
        
//        
        get("redirect") { request in
            return Response(redirect: "http://vapor.codes")
        }
        
        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }
        
        get("description") { req in return req.description }
        
        try resource("posts", DailyStockController.self)
    }
}

