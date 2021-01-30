//
//  apiModels.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import Foundation

import Foundation

// MARK: - Welcome
struct BasicFinantials: Codable {
    let series: Series
    let metric: Metric?
}

// MARK: - Series
struct Series: Codable {
    let annual: Annual
    
    let metricType: String?
    let symbol: String?
}

// MARK: - Annual
struct Annual: Codable {
    let currentRatio, salesPerShare, netMargin: [CurrentRatio]
}

// MARK: - CurrentRatio
struct CurrentRatio: Codable {
    let period: String
    let v: Double
}

// MARK: - Metric
struct Metric: Codable {
    let the10DayAverageTradingVolume, the52WeekHigh, the52WeekLow: Double
    let the52WeekLowDate: String
    let the52WeekPriceReturnDaily, beta: Double

    enum CodingKeys: String, CodingKey {
        case the10DayAverageTradingVolume = "10DayAverageTradingVolume"
        case the52WeekHigh = "52WeekHigh"
        case the52WeekLow = "52WeekLow"
        case the52WeekLowDate = "52WeekLowDate"
        case the52WeekPriceReturnDaily = "52WeekPriceReturnDaily"
        case beta
    }
}
