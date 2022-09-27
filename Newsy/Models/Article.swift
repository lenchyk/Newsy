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
    let publishedAt: String?
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

class Source: NSObject, NSSecureCoding, Decodable {
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
    }
    
    required init?(coder: NSCoder) {
        guard
            let id = coder.decodeObject(of: [NSString.self], forKey: "id") as? String,
            let name = coder.decodeObject(of: [NSString.self], forKey: "name") as? String
        else {
            return nil
        }
        
        self.id = id
        self.name = name
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }

    let id: String?
    let name: String?
}
