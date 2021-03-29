//
//  QuoteModel.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//

import Foundation

struct Quote: Codable {
    let c, h, l, o: Double? // Current price, High price of the day, Low price of the day, Open price of the day
    let pc: Double?
    let t: Int?
}
