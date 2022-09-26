//
//  Articles.swift
//  Newsy
//
//  Created by Lena Soroka on 25.09.2022.
//

import Foundation

class ArticlesData: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}
