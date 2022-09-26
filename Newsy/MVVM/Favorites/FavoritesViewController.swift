//
//  FavoritesViewController.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet private var emptyStateView: EmptyStateView!
    @IBOutlet private var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureEmptyState()
    }
    
    private func configureEmptyState() {
        //favoritesTableView.isHidden = true
        emptyStateView.setupUI(for: .favorites)
    }
}
