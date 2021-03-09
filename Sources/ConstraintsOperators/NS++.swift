//
//  NS++.swift
//  TestPr
//
//  Created by crypto_user on 11/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func willConflict(with rhs: NSLayoutConstraint) -> Bool {
        guard rhs.isActive, priority == rhs.priority else { return false }
        if self.firstItem == nil && secondItem == nil || rhs.firstItem == nil && rhs.secondItem == nil {
            return false
        }
        return (first == rhs.first && second == rhs.second) && relation == rhs.relation ||
            (first == rhs.second && second == rhs.first) && relation.isOpposite(to: rhs.relation)
    }
    
    public struct Item: Equatable {
        let attribute: NSLayoutConstraint.Attribute
        let view: AnyObject?
        
        public static func ==(lhs: NSLayoutConstraint.Item, rhs: NSLayoutConstraint.Item) -> Bool {
            if let left = lhs.view, let right = rhs.view {
                return left === right && lhs.attribute == rhs.attribute
            }
            if lhs.view == nil, rhs.view == nil {
                return lhs.attribute == rhs.attribute
            }
            return false
        }
    }
    
    fileprivate var first: Item {
        return Item(attribute: firstAttribute, view: firstItem)
    }
    
    fileprivate var second: Item {
        return Item(attribute: secondAttribute, view: secondItem)
    }
    
}

extension NSLayoutConstraint.Relation {
    
    fileprivate func isOpposite(to rhs: NSLayoutConstraint.Relation) -> Bool {
        switch (self, rhs) {
        case (.equal, .equal): return true
        case (.greaterThanOrEqual, .lessThanOrEqual): return true
        case (.lessThanOrEqual, .greaterThanOrEqual): return true
        default: return false
        }
    }
    
}

extension UILayoutable {
    var parent: UILayoutable? {
			return (itemForConstraint.item as? UIView)?.superview
    }
    var constraints: [NSLayoutConstraint] {
			return (itemForConstraint.item as? UIView)?.constraints ?? (self as? UILayoutGuide)?.owningView?.constraints ?? []
    }
}
