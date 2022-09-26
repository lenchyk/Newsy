//
//  MainViewModel.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//
import Foundation

protocol MainViewModelProtocol: class {
    var articles: [Article]? { get }
    var actions: MainViewModelActions? { get }
    var bindViewModelToController: ( () -> ()) { get set }
}

class MainViewModelActions {
    var shouldRefreshDataSource: () -> () = {}
    var shouldFetchNextDataPage: () -> () = {}
    var shouldOpenWebView: () -> () = {}
    var shouldFinishLoading: () -> () = {}
}

class MainViewModel: NSObject, MainViewModelProtocol {
    private var apiService: ApiServiceProtocol?
    var actions: MainViewModelActions?
    
    private(set) var articles: [Article]? {
        didSet {
            self.bindViewModelToController()
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
            guard let isPaginating = self.apiService?.isPaginating else { return }
            if !isPaginating {
                self.apiService?.getNextDataPage { result in
                    switch result {
                    case .success(let newArticles):
                        guard let newArticles = newArticles else { return }
                        self.articles?.append(contentsOf: newArticles)
                        self.actions?.shouldFinishLoading()
                    case .failure(let error):
                        print(Constants.Error.requestError(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    // initial fetch and refresh the data
    func fetchData() {
        apiService?.getArticlesData { [unowned self] result in
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                print(Constants.Error.requestError(error.localizedDescription))
            }
        }
    }
}

