import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our DailyStock table
final class DailyStockController: ResourceRepresentable {
    /// When users call 'GET' on '/dailyStocks'
    /// it should return an index of all available dailyStocks
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try DailyStock.all().makeJSON()
    }

    /// When consumers call 'POST' on '/dailyStocks' with valid JSON
    /// construct and save the dailyStock
    func store(_ req: Request) throws -> ResponseRepresentable {
        let dailyStock = try req.dailyStock()
        try dailyStock.save()
        return dailyStock
    }

    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/dailyStocks/13rd88' we should show that specific dailyStock
    func show(_ req: Request, dailyStock: DailyStock) throws -> ResponseRepresentable {
        return dailyStock
    }

    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'dailyStocks/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, dailyStock: DailyStock) throws -> ResponseRepresentable {
        try dailyStock.delete()
        return Response(status: .ok)
    }

    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/dailyStocks' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try DailyStock.makeQuery().delete()
        return Response(status: .ok)
    }

    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, dailyStock: DailyStock) throws -> ResponseRepresentable {
        // See `extension DailyStock: Updateable`
        try dailyStock.update(for: req)

        // Save an return the updated dailyStock.
        try dailyStock.save()
        return dailyStock
    }

    /// When a user calls 'PUT' on a specific resource, we should replace any
    /// values that do not exist in the request with null.
    /// This is equivalent to creating a new DailyStock with the same ID.
    func replace(_ req: Request, dailyStock: DailyStock) throws -> ResponseRepresentable {
        // First attempt to create a new DailyStock from the supplied JSON.
        // If any required fields are missing, this request will be denied.
        let _ = try req.dailyStock()

        // Update the dailyStock with all of the properties from
        // the new dailyStock
//        dailyStock.content = new.content
//        try dailyStock.save()

        // Return the updated dailyStock
        return dailyStock
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this 
    /// implementation
    func makeResource() -> Resource<DailyStock> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
    
    func insertManually(_ req: Request) throws -> ResponseRepresentable {
//        print(req.description)
        guard  let stockCode = req.data[DailyStock.Keys.stockCode]?.string,
            let stockName = req.data[DailyStock.Keys.stockName]?.string,
            let date = req.data[DailyStock.Keys.date]?.string,
            let changeAmount = req.data[DailyStock.Keys.changeAmount]?.string,
            let changeRate = req.data[DailyStock.Keys.changeRate]?.string,
            let openPrice = req.data[DailyStock.Keys.openPrice]?.string,
            let closePrice = req.data[DailyStock.Keys.closePrice]?.string,
            let highPrice = req.data[DailyStock.Keys.highPrice]?.string,
            let lowPrice = req.data[DailyStock.Keys.lowPrice]?.string,
            let forePrice = req.data[DailyStock.Keys.forePrice]?.string,
            let committeeRate = req.data[DailyStock.Keys.committeeRate]?.string,
            let quantityRatio = req.data[DailyStock.Keys.quantityRatio]?.string,
            let turnoverRate = req.data[DailyStock.Keys.turnoverRate]?.string,
            let turnoverVol = req.data[DailyStock.Keys.turnoverVol]?.string,
            let transactionVol = req.data[DailyStock.Keys.transactionVol]?.string,
            let netAssetsPerShare = req.data[DailyStock.Keys.netAssetsPerShare]?.string,
            let peRate = req.data[DailyStock.Keys.peRate]?.string,
            let pbRate = req.data[DailyStock.Keys.pbRate]?.string,
            let eps = req.data[DailyStock.Keys.eps]?.string,
            let totalValue = req.data[DailyStock.Keys.totalValue]?.string,
            let currencyValue = req.data[DailyStock.Keys.currencyValue]?.string  else {
                
            throw Abort(.badRequest, reason: "parameter error.")
        }
        let dailyStock = DailyStock.init(stockCode: stockCode, stockName: stockName, date: date, changeAmount: changeAmount, changeRate: changeRate, openPrice: openPrice, closePrice: closePrice, highPrice: highPrice, lowPrice: lowPrice, forePrice: forePrice, committeeRate: committeeRate, quantityRatio: quantityRatio, turnoverRate: turnoverRate, turnoverVol: turnoverVol, transactionVol: transactionVol, netAssetsPerShare: netAssetsPerShare, peRate: peRate, pbRate: pbRate, eps: eps, totalValue: totalValue, currencyValue: currencyValue)
        do {
            try dailyStock.save()
        } catch {
            print(error.localizedDescription)
            return error.localizedDescription
        }
        return "success"
    }
    
    func select(_ req: Request) throws -> ResponseRepresentable {
        var reslutJson: JSON?
        let stockCode = req.data["code"]?.string
        let stockName = req.data["name"]?.string
        let date = req.data["date"]?.string
        do {
            let query = try DailyStock.makeQuery()
            
            try query.and { andGroup in
                if stockName != nil {
                    try andGroup.filter("ds_name", stockName!)
                } else if stockCode != nil {
                    try andGroup.filter("ds_code", stockCode!)
                }
                if date != nil {
                    try andGroup.filter("ds_date", date)
                }
            }
            do {
                if stockCode == nil && stockName == nil || date == nil{
                    let result = try query.all()
                    reslutJson = try result.makeJSON()
                } else {
                    if let result = try query.first() {
                        reslutJson = try result.makeJSON()
                    } else {
                        print("fetch error.")
                    }
                }
            } catch {
                print("error happened when make json in fetch procedure: \(error.localizedDescription)")
            }            
        } catch {
            print(error.localizedDescription)
            throw Abort(.badRequest, reason: "make query failed.")
        }
        
        return reslutJson ?? "selecting error."
    }
 
    
}

extension Request {
    /// Create a dailyStock from the JSON body
    /// return BadRequest error if invalid 
    /// or no JSON
    func dailyStock() throws -> DailyStock {
        guard let json = json else { throw Abort.badRequest }
        return try DailyStock(json: json)
    }
}

/// Since DailyStockController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension DailyStockController: EmptyInitializable { }
