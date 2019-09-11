//
//  NS++.swift
//  TestPr
//
//  Created by crypto_user on 11/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

extension UILayoutable {
    var parent: UILayoutable? {
        if #available(iOS 11.0, *) {
            return (self as? UIView)?.superview?.safeAreaLayoutGuide
        } else {
            return (self as? UIView)?.superview
        }
    }
    var constraints: [NSLayoutConstraint] {
        return (self as? UIView)?.constraints ?? (self as? UILayoutGuide)?.owningView?.constraints ?? []
    }
}

extension Array where Element == UILayoutable {
    
    var parents: [UILayoutable] {
        var result: [UILayoutable] = []
        var ids: Set<ObjectIdentifier> = []
        for parent in compactMap({ $0.parent }) {
            let id = ObjectIdentifier(parent)
            if !ids.contains(id) {
                ids.insert(id)
                result.append(parent)
            }
        }
        return result
    }
    
}
