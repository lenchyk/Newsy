//
//  Constants.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//

import UIKit

enum Constants {
    enum API {
        static let key = "240bc2e1153c4410bdfeb3ae6cf27303"
        static let url = "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com&apiKey="
        static var urlPaginatedString: (Int) -> String = { page in
            return "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com&pageSize=\(pageSize)&page=\(page)&apiKey=\(key)"
        }
        static let pageSize: Int = 10
    }
    enum EmptyState {
        static let noInfo = "Sorry, there is no info."
        static let noFavorites = "You have no saved records."
    }
    enum Error {
        static let fetchError = "Error! The data is not fetched!"
        static let decodeError = "The error occured when decoding data!"
        static let imageError = "Couldn't load the image."
        static var requestError: (String) -> String = { error in
            return "Request failed with \(error)"
        }
    }
    enum Main {
        static let loadTime: TimeInterval = 3
        static let cellHeight: CGFloat = 200
        static let cellIdentifier = "ArticleTableViewCell"
        static let loadingCellIdentifier = "LoadingTableViewCell"
    }
}
