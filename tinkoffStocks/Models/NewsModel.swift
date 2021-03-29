//
//  NewsModel.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//
// Новости рынков, как-то коррелирующие с акциями, приходят с https://finnhub.io
// Больше информации https://finnhub.io/docs/api/market-news

import Foundation

struct NewsElement: Codable {
    let category: String?
    let datetime: Int?
    let headline: String?
    let id: Int?
    let image: String?
    let related, source, summary: String?
    let url: String?
}

typealias News = [NewsElement]
