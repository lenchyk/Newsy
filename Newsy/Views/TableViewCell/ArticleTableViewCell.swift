//
//  ArticleTableViewCell.swift
//  Newsy
//
//  Created by Lena Soroka on 25.09.2022.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var articleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.Main.cellIdentifier, bundle: nil)
    }
    
    func configureCell(with data: Article) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        authorLabel.text = data.author
        sourceLabel.text = data.source?.name
        //setupImage(for: data.urlToImage)
    }
    
    private func setupImage(for urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        if let data = try? Data(contentsOf: url) {
            articleImageView.image = UIImage(data: data)
        } else {
            print(Constants.Error.imageError)
        }
    }
}
