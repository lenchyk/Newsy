//
//  MainViewController.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    @IBOutlet private var newsTableView: UITableView!
    @IBOutlet private var emptyStateView: EmptyStateView!
    private var mainViewModel: MainViewModelProtocol?
    private var dataSource: ArticlesTableViewDataSource<ArticleTableViewCell, Article>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        mainViewModel = MainViewModel()
        newsTableView.register(
            ArticleTableViewCell.nib(),
            forCellReuseIdentifier: Constants.Main.cellIdentifier
        )
        newsTableView.register(
            LoadingTableViewCell.nib(),
            forCellReuseIdentifier: Constants.Main.loadingCellIdentifier
        )
        mainViewModel?.bindViewModelToController = { [weak self] in
            self?.configureDataSource()
        }
        newsTableView.delegate = self
        configureRefreshControl()
    }
    
    // MARK: - Empty state view when no data is available
    private func configureEmptyState() {
        newsTableView.isHidden = true
        emptyStateView.setupUI(for: .main)
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
            configureEmptyState()
        } else {
            dataSource = ArticlesTableViewDataSource(
                cellIdentifier: Constants.Main.cellIdentifier,
                items: articles,
                configureCells: { cell, data in
                    cell.configureCell(with: data)
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
        if position > (newsTableView.contentSize.height - 100 - scrollView.frame.size.height) {
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
}
