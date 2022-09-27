//
//  ArticleData+CoreDataClass.swift
//  Newsy
//
//  Created by Lena Soroka on 27.09.2022.
//
//

import Foundation
import CoreData

@objc(ArticleData)
public class ArticleData: NSManagedObject {
    func set(data: Article) {
        self.source = data.source
        self.title = data.title
        self.articleDescription = data.description
        self.content = data.content
        self.publishedAt = data.publishedAt
        self.url = data.url
        self.urlToImage = data.urlToImage
    }
}
