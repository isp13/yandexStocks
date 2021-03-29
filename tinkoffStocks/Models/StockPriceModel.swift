//
//  StockPriceModel.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//
// Общие данные о китайских свечах акций, приходят с https://finnhub.io
// Больше информации https://finnhub.io/docs/api/stock-candles

import Foundation

struct StockPrice: Codable {
    let c, h, l, o: [Double]? // Current price, High price of the day, Low price of the day, Open price of the day
    let s: String?
    let t, v: [Int]?
}
