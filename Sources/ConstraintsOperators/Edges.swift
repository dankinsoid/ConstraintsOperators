//
//  Edges.swift
//  TestPr
//
//  Created by crypto_user on 09/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit
import VDUIKit

extension Edges.Set {
    
    var attributes: [NSLayoutConstraint.Attribute] {
        var result: [NSLayoutConstraint.Attribute] = []
        if contains(.top) { result.append(.top) }
        if contains(.bottom) { result.append(.bottom) }
        if contains(.trailing) { result.append(.trailing) }
        if contains(.leading) { result.append(.leading) }
        return result
    }
    
}
