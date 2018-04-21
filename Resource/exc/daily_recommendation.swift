//
//  main.swift
//  Stockanalysis
//
//  Created by Dove·Z on 2018/4/10.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Foundation

struct StockanalysisUtls {
    private static let max = Int(Int32.max)
    static var seed: Int = 0 {
        didSet{
            m_hi = seed
            m_lo = seed
        }
    }
    static var m_lo: Int = 0
    static var m_hi: Int = 0
    static func randui() -> Int {
        m_hi = (m_hi << 16 + m_hi>>16) % max
        m_hi = (m_hi + m_lo) % max
        m_lo = (m_lo + m_hi) % max
        return m_hi
    }
    
    static func randi(range: Int) -> Int {
        return Int(range * randui() / max)
    }
    static func randd(range: Double) -> Double {
        return ((range * Double(randui()) / Double(max)))
    }
}

enum IndexTend {
    case rise
    case fall
    case shock
    case low
}

struct IndexStatus {
    var dailyChange: [Double]
}

let status: IndexStatus = IndexStatus.init(dailyChange: [4, 3, -5, 2, 1]) //[收盘价]

func nowIndexTend(_ status: IndexStatus) -> IndexTend {
    let change: [Double] = {
        var result = [Double]()
        var tailNum = status.dailyChange[0] / 100.0
        for (n, c) in status.dailyChange.map({ return $0 / 100.0 }).enumerated() {
            if n == 0 {
                result.append(c)
            } else {
                tailNum = c * tailNum
                result.append(c + result[n - 1] + tailNum)
//                print(c, result[n - 1], tailNum)
            }
        }
        return result.map({ return $0 * 100 })
        }()
    
    print(change)
    
    do { // check two special circumstance, rise always and fall always
        if change.first! > 0 {
            for (i, value) in change.enumerated() {
                if value < 0 { break }
                if i == change.count - 1 { return .rise }
            }
        } else {
            for (i, value) in change.enumerated() {
                if value > 0 { break }
                if i == change.count - 1 { return .fall }
            }
        }
        
    }
    
    let xAvg = Double(change.count - 1) / 2.0
    let yAvg: Double = {
        var sum: Double = 0
        for value in change {
            sum += value
        }
        return sum / Double(change.count)
    }()
    
    let variance: Double = {
        var sum: Double = 0
        for value in change {
            sum += pow(value - yAvg, 2)
        }
        return sum / Double(change.count)
        
    }()
    
    
    //计算回归方程斜率
    var son = 0.0, mum = 0.0
    for (x,y) in change.enumerated() {
        son += (Double(x) - xAvg) * (y - yAvg)
        mum += pow(Double(x) - xAvg, 2)
    }
    
    let slope = son / mum
    print(slope, variance)
    
    if slope > 1 {
        return .rise
    } else if slope < -1 {
        return .fall
    } else {
        if variance < 2 {
            return . low
        } else {
            return .shock
        }
    }
}


struct RecommendedStock: Codable {
    var rank: Int
    var code: String
    var date: String
    var poers: Double  //possibility of earning return scale
    var ecvs: Double //estimated company value scale
    var elps: Double //estimated liquidity premium scale
    var erps: Double //estimated risk preference scale
}


StockanalysisUtls.seed = Int(Date().timeIntervalSince1970)
var code = try JSONDecoder.init().decode([String].self, from: Data.init(contentsOf: URL.init(fileURLWithPath: "../stock_code.json"))).map({
    return $0.suffix(6)
})

var rankingStockCode = [String]()

///about date.
var today = Date()
today.addTimeInterval(3600 * -7)
let selectingDate = String(today.description.split(separator: " ").first!)
today.addTimeInterval(3600 * 24)
let showDate = String(today.description.split(separator: " ").first!)

print(selectingDate, showDate)


for i in 0..<50 {
    let index = StockanalysisUtls.randi(range: code.count)
    rankingStockCode.append(String(code[index]))
    
    do {
        let recomendedStock = RecommendedStock.init(rank: i,
                                                    code: String(code[index]),
                                                    date: showDate,
                                                    poers: 1 - Double(i+1) / 50,
                                                    ecvs: StockanalysisUtls.randd(range: 90),
                                                    elps: 1 - Double(i+1) / 70,
                                                    erps: StockanalysisUtls.randd(range: 90))
        
        guard let uploadData = try? JSONEncoder().encode(recomendedStock) else {
            fatalError()
        }
         let url = URL(string: "http://localhost:8081/insert_dr")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.init(configuration: .default).uploadTask(with: request, from: uploadData) { data, response, error in
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
        }
        task.resume()
        
        print(recomendedStock)
    }
    
    code.remove(at: index)

    Thread.sleep(forTimeInterval: 0.05)
    
}

print(rankingStockCode)
do {
    let data = try JSONEncoder().encode(rankingStockCode)
    if !FileManager.default.createFile(atPath: "../dailyRecommendationCode.json", contents: data, attributes: [:]) {
        print("file create failed.")
    }
} catch {
    print(error.localizedDescription)
}








