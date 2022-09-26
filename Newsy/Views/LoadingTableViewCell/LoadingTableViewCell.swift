//
//  LoadingTableViewCell.swift
//  Newsy
//
//  Created by Lena Soroka on 26.09.2022.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    @IBOutlet var loadingActivityIndicator: UIActivityIndicatorView!
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.Main.loadingCellIdentifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
