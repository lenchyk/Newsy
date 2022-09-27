//
//  SourceTransformer.swift
//  Newsy
//
//  Created by Lena Soroka on 27.09.2022.
//

import UIKit

class SourceTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [Source.self]
    }
    
    static func register() {
        let className = String(describing: SourceTransformer.self)
        let name = NSValueTransformerName(className)
        
        let transformer = SourceTransformer()
        ValueTransformer.setValueTransformer(
            transformer, forName: name)
    }
}
