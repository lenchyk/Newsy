//
//  Array+extensions.swift
//  Newsy
//
//  Created by Lena Soroka on 25.09.2022.
//

import Foundation

extension Array {
    func getSubArray(from index0: Int = 0, to index1: Int) -> Array {
        return Array(self[index0..<index1])
    }
}
