//
//  EmptyStateView.swift
//  Newsy
//
//  Created by Lena Soroka on 24.09.2022.
//

import UIKit

enum EmptyStateType {
    case main
    case favorites
}

class EmptyStateView: UIView {
    private lazy var textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        text.font = .systemFont(ofSize: 18, weight: .regular)
        return text
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }
    
    func setupUI(for type: EmptyStateType) {
        switch type {
        case .favorites:
            textLabel.text = Constants.EmptyState.noFavorites
            imageView.image = #imageLiteral(resourceName: "sad")
        case .main:
            textLabel.text = Constants.EmptyState.noInfo
            imageView.image = #imageLiteral(resourceName: "alert")
        }
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        
        // image
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        // text
        addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
