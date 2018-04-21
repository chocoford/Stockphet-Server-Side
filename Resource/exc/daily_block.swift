import Foundation
struct keys {
    static let stockBlock = "s_block"
    static let stockCode = "s_code"
    static let dailyStockCode = "ds_code"
    static let dailyStockChange = "ds_change"
}
struct DailyStock: Codable {
    var id: Int
    var ds_code: String
    var ds_name: String
    var ds_date: String
    var ds_change_amount:String
    var ds_change: String
    var ds_oprice: String
    var ds_cprice: String
    var ds_hprice: String
    var ds_lprice: String
    var ds_fprice: String
    var ds_committee: String
    var ds_quantity_ratio: String
    var ds_turnover_rate: String
    var ds_turnover_vol: String
    var ds_transaction_vol: String
    var ds_net_assets_per_share: String
    var ds_pe_rate: String
    var ds_pb_rate: String
    var ds_eps: String
    var ds_total_value: String
    var ds_currency_value: String
}

struct DailyBlock: Encodable {
    var db_id: String
    var db_name: String
    var db_date: String
    var db_change: Double
    var db_change_amount:Double
    var db_rise_num: Int
    var db_fall_num: Int
    var db_parity_num: Int
}

let CPA = [
    "电力行业":"dlyy",
    "航天航空":"hthk",
    "民航机场":"mhjc",
    "化工行业":"hgxy",
    "电信运营":"dxyy",
    "机械行业":"jxxy",
    "商业百货":"sybh",
    "钢铁行业":"gtxy",
    "农药兽药":"nysy",
    "多元金融":"dyjr",
    "珠宝首饰":"zbss",
    "电子信息":"dzxx",
    "工程建设":"gcjs",
    "医药制造":"yyzz",
    "券商信托":"qsxt",
    "高速公路":"gsgl",
    "造纸印刷":"zzys",
    "化纤行业":"hxxy",
    "公用事业":"gysy",
    "塑胶制品":"sjzp",
    "汽车行业":"qcxy",
    "食品饮料":"spyl",
    "家电行业":"jdxy",
    "保险":"bx",
    "包装材料":"bzcl",
    "港口水运":"gksy",
    "房地产":"fdc",
    "化肥行业":"hfxy",
    "文化传媒":"whcm",
    "银行":"yx",
    "输配电气":"spdq",
    "装修装饰":"zxzs",
    "工艺商品":"gysp",
    "电子元件":"dzyj",
    "酿酒行业":"njxy",
    "石油行业":"syxy",
    "有色金属":"ysjs",
    "煤炭采选":"mtcx",
    "仪器仪表":"yqyb",
    "国际贸易":"gjmy",
    "木业家具":"myjj",
    "文教休闲":"wjxx",
    "水泥建材":"snjc",
    "软件服务":"rjfw",
    "医疗行业":"ylxy",
    "综合行业":"zhxy",
    "通讯行业":"txxy",
    "船舶制造":"cbzz",
    "玻璃陶瓷":"bltc",
    "园林工程":"ylgc",
    "农牧饲渔":"nmsy",
    "贵金属":"gjs",
    "环保工程":"hbgc",
    "材料行业":"clxy",
    "旅游酒店":"lyjd",
    "交运设备":"jysb",
    "安防设备":"afsb",
    "纺织服装":"fzfz",
    "交运物流":"jywl",
    "金属制品":"jszp",
    "专用设备":"zysb"
]


/*
func transformChineseToCPA(_ string: String) -> String {
    let stringRef = NSMutableString(string: string) as CFMutableString
    CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false) // 转换为带音标的拼音
    CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false) // 去掉音标
    let pinyin = stringRef as String
    var cpa = ""
    for ch in pinyin.capitalized {
        if ch >= "A" && ch <= "Z" {
            cpa.append(ch)
        }
    }
    return cpa.lowercased()
}
*/


let jsonDecoder = JSONDecoder.init()
var stocksCodeBlock = [String: String]()
var uniqueBlock = Set<String>.init()


do {
    let stocksInfoJson = try Data.init(contentsOf: URL.init(fileURLWithPath: "../stock_info.json"))
    let stocksInfo = try jsonDecoder.decode([[String: String]].self, from: stocksInfoJson)
    print("the number of known stock info : \(stocksInfo.count)")
    for stockInfo in stocksInfo {
        stocksCodeBlock[stockInfo[keys.stockCode]!] = stockInfo[keys.stockBlock]!
        if stockInfo[keys.stockBlock]! != "-" {
            uniqueBlock.insert(stockInfo[keys.stockBlock]!)
        }
    }
    print("the number of known block: \(uniqueBlock.count)")
} catch {
    print(error.localizedDescription)
}


//check for cpa

for block in uniqueBlock {
    if CPA[block] == nil {
        fatalError("cpa has error.")
    }
}

let selectDate = Date.init(timeIntervalSinceNow: .init(-3600 * 7)).description.split(separator: " ").first!
var todayStocks = [DailyStock]()

do {
    let jsonData = try Data.init(contentsOf: URL.init(string: "http://localhost:8081/query/dailyStocks?ds_date=\(selectDate)")!)
//    let jsonData = try Data.init(contentsOf: URL.init(string: "http://localhost:8081/query/dailyStocks?date=2018-04-04")!)
    print(jsonData)
    todayStocks = try jsonDecoder.decode([DailyStock].self, from: jsonData)
//    print(todayStocks)
} catch {
    fatalError(error.localizedDescription)
}

///prepare for counter
var statist: [String: Double] = [:]
var counter: [String: Int] = [:]

do {
    for block in uniqueBlock {
        counter["\(block)+"] = 0
        counter["\(block)-"] = 0
        counter["\(block)"] = 0
        counter["\(block)_count"] = 0
        statist["\(block)_change"] = 0.0
        statist["\(block)_changeAmount"] = 0.0
    }
}

///Analyse
do {
    for stock in todayStocks {
        if stock.ds_change.contains("+") {
            counter["\(stocksCodeBlock[stock.ds_code]!)+"]! += 1
        } else if stock.ds_change.contains("-") && stock.ds_change != "-" {
            counter["\(stocksCodeBlock[stock.ds_code]!)-"]! += 1
        } else {
            counter["\(stocksCodeBlock[stock.ds_code]!)"]! += 1
        }
        statist["\(stocksCodeBlock[stock.ds_code]!)_change"]! += Double(stock.ds_change) ?? 0.0
        statist["\(stocksCodeBlock[stock.ds_code]!)_changeAmount"]! += Double(stock.ds_change_amount) ?? 0.0
        counter["\(stocksCodeBlock[stock.ds_code]!)_count"]! += 1
    }
}



var totalNum = 0
var uploadData = Data.init()
for block in uniqueBlock {
    
    let data = DailyBlock.init(db_id: CPA[block]!,
                               db_name: block,
                               db_date: String.init(selectDate),
//                               db_date: String.init("2018-04-04"),
                               db_change: statist["\(block)_change"]! / Double(counter["\(block)_count"]!),
                               db_change_amount: statist["\(block)_changeAmount"]! / Double(counter["\(block)_count"]!),
                               db_rise_num: counter["\(block)+"]!,
                               db_fall_num: counter["\(block)-"]!,
                               db_parity_num: counter[block]!)


    let jsonEncoder = JSONEncoder.init()
    var postRequest = URLRequest.init(url: URL.init(string: "http://localhost:8088/insert_db")!)
    postRequest.httpMethod = "POST"
    do {
        uploadData = try jsonEncoder.encode(data)
        postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    } catch {
        print(error.localizedDescription)
    }


    URLSession.init(configuration: .default).uploadTask(with: postRequest, from: uploadData) { (data, response, error) in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
                print ("server error")
                return
        }
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print ("got data: \(dataString)")
        }
    }.resume()
    Thread.sleep(forTimeInterval: 0.05)
//    totalNum += counter["\(block)_count"]!
}
//print(totalNum)



