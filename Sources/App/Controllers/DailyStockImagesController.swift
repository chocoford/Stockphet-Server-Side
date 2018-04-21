import Vapor

struct DailyStockImagesController {
    func addRountes(to drop: Droplet) {
        let imageGroup = drop.grouped("api", "image")
        imageGroup.get(String.parameter, handler: getSpecificImage)
    }
    
    func getSpecificImage(_ req: Request) throws -> ResponseRepresentable {
        let imageName = try req.parameters.next(String.self)
        return try Response(filePath: "Public/daily_stock_img/\(imageName).png")
    }
    
    func getPreviousDayImage(_ req: Request) throws -> ResponseRepresentable {
        var i: Double = 0
        var previousDay = ""
        while true {
            previousDay = String(Date.init(timeIntervalSinceNow: 3600 * -7 - 86400 * i).description.split(separator: " ").first!)
            do {
                if try DailyIndex.makeQuery().filter("di_date", previousDay).all().count > 0 {
                    break
                }
            } catch {
                print("error happened when make json in fetch procedure: \(error.localizedDescription)")
            }
            i += 1
        }
        let imageName = try req.parameters.next(String.self)
        return try Response(filePath: "Public/daily_stock_img/\(imageName)_\(previousDay).png")
    }
}
