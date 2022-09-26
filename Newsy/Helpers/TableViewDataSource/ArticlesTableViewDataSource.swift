//
//  ArticlesTableViewDataSource.swift
//  Newsy
//
//  Created by Lena Soroka on 25.09.2022.
//

import Foundation
import UIKit

class ArticlesTableViewDataSource<Cell: UITableViewCell, Data>: NSObject, UITableViewDataSource {
    private var cellIdentifier: String
    private var items: [Data]
    var configureCells: (Cell, Data) -> () = { _, _ in }
    
    init(
        cellIdentifier: String,
        items: [Data],
        configureCells: @escaping (Cell, Data) -> ()
    ) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCells = configureCells
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Cell
        let item = self.items[indexPath.row]
        configureCells(cell, item)
        return cell
    }
}
