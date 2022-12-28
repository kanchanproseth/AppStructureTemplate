//
//  NewsEntity.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//


import Foundation

// MARK: - Movies
struct NewsEntity: Codable {
    let totalArticles: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let title: String?
    let description: String?
    let content: String?
    let url: String?
    let image: String?
    let publishedAt: String?
    let source: Source?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case content, url, image, publishedAt, source
    }
}

// MARK: - Source
struct Source: Codable {
    let name: String?
    let url: String?
}

