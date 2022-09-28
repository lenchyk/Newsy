//
//  MainViewController.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet private var loaderView: UIActivityIndicatorView!
    @IBOutlet private var newsTableView: UITableView!
    @IBOutlet private var emptyStateView: EmptyStateView!
    @IBOutlet private var searchBar: UISearchBar!
    private var mainViewModel: MainViewModelProtocol?
    private var dataSource: ArticlesTableViewDataSource<ArticleTableViewCell, Article>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        configureUI()
        mainViewModel = MainViewModel()
        configureLoader()
        newsTableView.register(
            ArticleTableViewCell.nib(),
            forCellReuseIdentifier: Constants.Main.cellIdentifier
        )
        mainViewModel?.bindViewModelToController = { [weak self] in
            self?.configureDataSource()
        }
        newsTableView.delegate = self
        configureRefreshControl()
    }
    
    private func configureUI() {
        emptyStateView.setupUI(for: .main)
        configureSearchBar()
        configureRefreshControl()
    }
    
    // show user loading when the app starts getting api data
    private func configureLoader() {
        newsTableView.isHidden = true
        emptyStateView.isHidden = true
        searchBar.isHidden = true
        loaderView.startAnimating()
        mainViewModel?.actions?.stopInitialLoader = {
            DispatchQueue.main.async {
                self.loaderView.stopAnimating()
                self.loaderView.isHidden = true
                self.searchBar.isHidden = false
                self.newsTableView.isHidden = false
                self.emptyStateView.isHidden = false
            }
        }
    }
    
    // MARK: - Search bar
    private func configureSearchBar() {
        searchBar.placeholder = Constants.Common.search
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        mainViewModel?.actions?.shouldSearchArticleForWord(searchText)
        searchBar.resignFirstResponder()
        // to enable cancel button after keyboard dissmisal
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.placeholder = Constants.Common.search
        mainViewModel?.actions?.shouldRefreshDataSource()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
        
    // MARK: - Refresh Control
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        newsTableView.refreshControl = refreshControl
    }
    
    @objc private func pullToRefresh(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Main.loadTime, execute: {
            self.mainViewModel?.actions?.shouldRefreshDataSource()
            self.newsTableView.refreshControl?.endRefreshing()
        })
    }
    
    // MARK: - Table view configuration
    private func configureDataSource() {
        guard let articles = mainViewModel?.articles else { return }
        if articles.isEmpty {
            DispatchQueue.main.async {
                self.newsTableView.isHidden = true
            }
        } else {
            dataSource = ArticlesTableViewDataSource(
                cellIdentifier: Constants.Main.cellIdentifier,
                items: articles,
                configureCells: { cell, data in
                    cell.configureCell(with: data)
                    cell.saveButtonIsPressed = { [weak self] in
                        self?.mainViewModel?.actions?.shouldSaveFavourite(data)
                    }
                    cell.cellIsSelected = { [weak self] in
                        guard let self = self else { return }
                        self.mainViewModel?.actions?.shouldOpenWebView(self, data)
                    }
                }
            )
            
            DispatchQueue.main.async {
                self.newsTableView.dataSource = self.dataSource
                self.newsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (newsTableView.contentSize.height - Constants.Main.bottomDistance - scrollView.frame.size.height) {
            newsTableView.tableFooterView = addLoadingCell()
            mainViewModel?.actions?.shouldFetchNextDataPage()
            stopLoadingWhenNeeded()
        }
    }
    
    func addLoadingCell() -> UIView {
        let footerView = UIView(
            frame: CGRect(x: 0, y: 0, width: view.frame.width, height: Constants.Main.cellHeight))
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = footerView.center
        footerView.addSubview(indicator)
        indicator.startAnimating()
        return footerView
    }
    
    func stopLoadingWhenNeeded() {
        mainViewModel?.actions?.shouldFinishLoading = {
            DispatchQueue.main.async {
                self.newsTableView.tableFooterView = nil
            }
        }
    }
    
    // for deselecting cell after tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
