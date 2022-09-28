//
//  MainViewModel.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//
import Foundation
import UIKit

protocol MainViewModelProtocol: class {
    var articles: [Article]? { get }
    var actions: MainViewModelActions? { get }
    var bindViewModelToController: ( () -> ()) { get set }
}

class MainViewModelActions {
    var stopInitialLoader: () -> () = {}
    var shouldRefreshDataSource: () -> () = {}
    var shouldFetchNextDataPage: () -> () = {}
    var shouldOpenWebView: (UIViewController, Article) -> () = { _, _ in }
    var shouldFinishLoading: () -> () = {}
    var shouldSaveFavourite: (Article) -> () = { _ in }
    var shouldSearchArticleForWord: (String) -> () = { _ in }
}

enum FilterType {
    case category, country, sources
}

class MainViewModel: NSObject, MainViewModelProtocol {
    private var apiService: ApiServiceProtocol?
    var actions: MainViewModelActions?
    private var shouldSortByPublishedAt: Bool = false
    
    private(set) var articles: [Article]? {
        didSet {
            bindViewModelToController()
        }
    }
    
    var bindViewModelToController: () -> () = {}
    
    override init() {
        super.init()
        apiService = ApiService()
        actions = MainViewModelActions()
        fetchData()
        configureActions()
    }
    
    func configureActions() {
        actions?.shouldRefreshDataSource = { [unowned self] in
            self.fetchData()
        }
        actions?.shouldFetchNextDataPage = { [unowned self] in
            self.fetchNextPage()
        }
        actions?.shouldSaveFavourite = { [unowned self] article in
            self.save(article)
        }
        actions?.shouldOpenWebView = { [unowned self] viewController, article in
            self.goToWebPage(from: viewController, article)
        }
        actions?.shouldSearchArticleForWord = { [unowned self] word in
            self.search(word)
        }
    }
    
    private func save(_ article: Article) {
        let managedContent = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let articleData = ArticleData(context: managedContent)
        articleData.set(data: article)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    // initial fetch and refresh the data
    private func fetchData() {
        apiService?.getArticlesData { [unowned self] result in
            switch result {
            case .success(let articles):
                self.actions?.stopInitialLoader()
                self.articles = articles
            case .failure(let error):
                print(Constants.Error.requestError(error.localizedDescription))
            }
        }
    }
    
    private func fetchNextPage() {
        guard let isPaginating = apiService?.isPaginating else { return }
        if !isPaginating {
            apiService?.getNextDataPage { [weak self] result in
                switch result {
                case .success(let newArticles):
                    guard let newArticles = newArticles else { return }
                    self?.articles?.append(contentsOf: newArticles)
                    self?.actions?.shouldFinishLoading()
                case .failure(let error):
                    print(Constants.Error.requestError(error.localizedDescription))
                }
            }
        }
    }
    
    private func search(_ word: String) {
        if !word.isEmpty {
            apiService?.search(for: word) { [weak self] result in
                switch result {
                case .success(let articles):
                    guard let searchResult = articles else { return }
                    self?.articles = searchResult
                case .failure(let error):
                    print(Constants.Error.requestError(error.localizedDescription))
                }
            }
        }
    }
    
    private func goToWebPage(from viewController: UIViewController, _ article: Article) {
        let webViewController = WebViewController()
        let webViewModel = WebViewModel(url: article.url)
        webViewController.webViewModel = webViewModel
        webViewController.modalPresentationStyle = .fullScreen
        webViewController.modalTransitionStyle = .flipHorizontal
        viewController.present(webViewController, animated: true, completion: nil)
    }
}

