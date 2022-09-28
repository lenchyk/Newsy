//
//  FavoritesViewController.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate {
    @IBOutlet private var emptyStateView: EmptyStateView!
    @IBOutlet private var favoritesTableView: UITableView!
    private var favoritesViewModel: FavoritesViewModel?
    private var dataSource: ArticlesTableViewDataSource<FavoriteTableViewCell, ArticleData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        emptyStateView.setupUI(for: .favorites)
        favoritesViewModel = FavoritesViewModel()
        reloadDataSource()
        favoritesTableView.delegate = self
        favoritesTableView.register(
            FavoriteTableViewCell.nib(),
            forCellReuseIdentifier: Constants.Favorite.cellIdentifier
        )
        favoritesViewModel?.bindViewModelToController = { [weak self] in
            self?.reloadDataSource()
        }
    }
    
    // MARK: - Data Source
    private func reloadDataSource() {
        guard let articles = favoritesViewModel?.articles else { return }
        if articles.isEmpty {
            DispatchQueue.main.async {
                self.favoritesTableView.isHidden = true
            }
        } else {
            dataSource = ArticlesTableViewDataSource(
                cellIdentifier: Constants.Favorite.cellIdentifier,
                items: articles,
                configureCells: { cell, data in
                    cell.configure(with: data)
                }
            )
            
            DispatchQueue.main.async {
                self.favoritesTableView.dataSource = self.dataSource
                self.favoritesTableView.reloadData()
            }
        }
    }
}
