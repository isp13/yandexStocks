//
//  StockPriceModel.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import Foundation

// MARK: - Welcome
struct StockPrice: Codable {
    let c, h, l, o: [Double]?
    let s: String?
    let t, v: [Int]?
}
