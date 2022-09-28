//
//  ArticleData+CoreDataProperties.swift
//  Newsy
//
//  Created by Lena Soroka on 27.09.2022.
//
//

import Foundation
import CoreData

extension ArticleData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleData> {
        return NSFetchRequest<ArticleData>(entityName: Constants.Articles.name)
    }

    @NSManaged var source: Source?
    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var url: URL?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var content: String?

}

extension ArticleData : Identifiable {

}
