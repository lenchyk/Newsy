//
//  WebViewModel.swift
//  Newsy
//
//  Created by Lena Soroka on 27.09.2022.
//
import Foundation
import UIKit

protocol WebViewModelProtocol: class {
    var mainURL: URL? { get }
}

class WebViewModel: WebViewModelProtocol {
    var mainURL: URL?
    
    init(url: URL?) {
        self.mainURL = url
    }
}
