//
//  FavoritesViewModel.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//
import CoreData

protocol FavoritesViewModelProtocol: class {
    var articles: [ArticleData]? { get }
    var bindViewModelToController: (() -> ()) { get set }
}

class FavoritesViewModel: NSObject, FavoritesViewModelProtocol {
    private(set) var articles: [ArticleData]? {
        didSet {
            bindViewModelToController()
        }
    }
    private var observer: NSObjectProtocol?
    var bindViewModelToController: () -> () = {}
    
    override init() {
        super.init()
        fetchSavedArticles()
        reloadTableViewIfNeeded()
    }
    
    func fetchSavedArticles() {
        let articlesFetch: NSFetchRequest<ArticleData> = ArticleData.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let articles = try managedContext.fetch(articlesFetch)
            self.articles = articles
        } catch let error as NSError {
            print(Constants.Error.coreDataError(error))
        }
    }
    
    func reloadTableViewIfNeeded() {
        observer = NotificationCenter.default.addObserver(
            forName: Constants.NotificationType.articleSaved,
            object: nil,
            queue: .main,
            using: { [unowned self] _ in
                self.fetchSavedArticles()
        })
    }
}
