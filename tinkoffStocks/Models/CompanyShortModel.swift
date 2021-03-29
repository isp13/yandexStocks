//
//  CompanyShortModel.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//
// Общие данные о компании, приходят с https://finnhub.io
// Больше информации https://finnhub.io/docs/api/stock-symbols

import Foundation
import RealmSwift


class CompanyShortElement: Object, Codable  {
    @objc dynamic var currency, someDescription, displaySymbol, figi: String?
    @objc dynamic var mic, symbol, type: String?

    enum CodingKeys: String, CodingKey {
        case currency
        case someDescription = "description"
        case displaySymbol, figi, mic, symbol, type
    }
    
    init(currency: String?, description: String?, displaySymbol: String?, figi: String?, mic: String?, symbol: String?, type: String?) {
        self.currency = currency
        self.someDescription = description
        self.displaySymbol = displaySymbol
        self.figi = figi
        self.mic = mic
        self.symbol = symbol
        self.type = type
    }
    
    override init() {
        
    }
}

typealias CompanyShort = [CompanyShortElement]
