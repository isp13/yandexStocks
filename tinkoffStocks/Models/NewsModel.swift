//
//  NewsModel.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import Foundation

// MARK: - WelcomeElement
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
