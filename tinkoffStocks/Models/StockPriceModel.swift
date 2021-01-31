//
//  StockPriceModel.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//
// Общие данные о китайских свечах акций, приходят с https://finnhub.io
// Больше информации https://finnhub.io/docs/api/stock-candles

import Foundation

// MARK: - Welcome
struct StockPrice: Codable {
    let c, h, l, o: [Double]?
    let s: String?
    let t, v: [Int]?
}
