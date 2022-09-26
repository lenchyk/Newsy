//
//  Article.swift
//  Newsy
//
//  Created by Lena Soroka on 25.09.2022.
//

import Foundation

struct Article: Decodable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: String?
    let publishedAt: String? // should be in proper format
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source = "source"
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
}

struct Source: Decodable {
    let id: String?
    let name: String?
}
