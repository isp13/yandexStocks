//
//  CompanyShortModel.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//
// Общие данные о компании, приходят с https://finnhub.io
// Больше информации https://finnhub.io/docs/api/stock-symbols

import Foundation

// MARK: - WelcomeElement
struct CompanyShortElement: Codable {
    let currency, someDescription, displaySymbol, figi: String?
    let mic, symbol, type: String?

    enum CodingKeys: String, CodingKey {
        case currency
        case someDescription = "description"
        case displaySymbol, figi, mic, symbol, type
    }
}

typealias CompanyShort = [CompanyShortElement]
