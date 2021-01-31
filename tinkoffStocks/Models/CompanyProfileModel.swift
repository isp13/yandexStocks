//
//  CompanyProfileModel.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//
// Подробная информация о компании, ее акции, приходят с https://finnhub.io
// Больше информации https://finnhub.io/docs/api/company-profile2

import Foundation

protocol Loopable {
    func allProperties(limit: Int) -> [String: Any]
}

extension Loopable {
    func allProperties(limit: Int = Int.max) -> [String: Any] {
        return props(obj: self, count: 0, limit: limit)
    }

    private func props(obj: Any, count: Int, limit: Int) -> [String: Any] {
        let mirror = Mirror(reflecting: obj)
        var result: [String: Any] = [:]
        for (prop, val) in mirror.children {
            guard let prop = prop else { continue }
            if limit == count {
                result[prop] = val
            } else {
                let subResult = props(obj: val, count: count + 1, limit: limit)
                result[prop] = subResult.count == 0 ? val : subResult
            }
        }
        return result
    }
}


// MARK: - Welcome
struct CompanyProfile: Codable, Loopable {
    let address, city, country, currency: String?
    let cusip, sedol, welcomeDescription, employeeTotal: String?
    let exchange, ggroup, gind, gsector: String?
    let gsubind, ipo, isin: String?
    let marketCapitalization: Double?
    let naics, naicsNationalIndustry, naicsSector, naicsSubsector: String?
    let name, phone: String?
    let shareOutstanding: Double?
    let state, ticker: String?
    let weburl: String?
    let logo: String?
    let finnhubIndustry: String?

    enum CodingKeys: String, CodingKey {
        case address, city, country, currency, cusip, sedol
        case welcomeDescription = "description"
        case employeeTotal, exchange, ggroup, gind, gsector, gsubind, ipo, isin, marketCapitalization, naics, naicsNationalIndustry, naicsSector, naicsSubsector, name, phone, shareOutstanding, state, ticker, weburl, logo, finnhubIndustry
    }
}


