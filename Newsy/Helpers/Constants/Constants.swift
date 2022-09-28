//
//  Constants.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//

import UIKit

enum Constants {
    enum Articles {
        static let name = "ArticleData"
    }
    enum API {
        static let url = "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com&apiKey="
        static var urlPaginatedString: (Int, String) -> String = { page, apiKey in
            return "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com&pageSize=\(pageSize)&page=\(page)&apiKey=\(apiKey)"
        }
        static var urlSearchString: (String, Int, String) -> String = { word, page, apiKey in
            return "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com&sortBy=relevancy&pageSize=\(pageSize)&q=\(word)&page=\(page)&apiKey=\(apiKey)"
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
        static var coreDataError: (NSError) -> String = { error in
            return "Unresolved error: \(error) description: \(error.userInfo)"
        }
        static let delegateError = "Unexpected app delegate type"
        static let keyNotAvailableError = "The key is not available!"
        static let noKeyFound = "Couldn't find the key"
    }
    enum Main {
        static let loadTime: TimeInterval = 3
        static let bottomDistance: CGFloat = 100
        static let cellHeight: CGFloat = 200
        static let cellIdentifier = "ArticleTableViewCell"
        static let loadingCellIdentifier = "LoadingTableViewCell"
    }
    enum Favorite {
        static let cellIdentifier = "FavoriteTableViewCell"
    }
    enum NotificationType {
        static let articleSaved = Notification.Name(rawValue: "Article saved")
    }
    enum Common {
        static let search = "Search"
    }
}
