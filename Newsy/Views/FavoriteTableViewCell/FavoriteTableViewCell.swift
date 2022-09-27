//
//  FavoriteTableViewCell.swift
//  Newsy
//
//  Created by Lena Soroka on 27.09.2022.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.Favorite.cellIdentifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with data: ArticleData) {
        titleLabel.text = data.title
        descriptionLabel.text = data.articleDescription
        authorLabel.text = data.author
        sourceLabel.text = data.source?.name
    }
}
