//
//  ResponseModel.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 14.03.2023.
//

import Foundation

// MARK: - Welcome
struct ResponseModel: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}
