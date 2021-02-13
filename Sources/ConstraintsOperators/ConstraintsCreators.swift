//
//  ConstraintsCreators.swift
//  TestPr
//
//  Created by crypto_user on 10/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

public protocol ConstraintProtocol {
    var isActive: Bool { get nonmutating set }
    var priority: UILayoutPriority { get nonmutating set }
}

extension NSLayoutConstraint: ConstraintProtocol {}

extension Array: ConstraintProtocol where Element: ConstraintProtocol {
	
    public var isActive: Bool {
        get { return reduce(false, { $0 || $1.isActive }) }
        nonmutating set { forEach { $0.isActive = newValue } }
    }
    
    public var priority: UILayoutPriority {
        get { return UILayoutPriority(rawValue: self.reduce(0.0, { Swift.max($0, $1.priority.rawValue) })) }
        nonmutating set { forEach { $0.priority = newValue } }
    }
    
}

private struct ConstraintBuilder {
	
	static func make(item: UILayoutable, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, toItem: UILayoutable?, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
				NSLayoutConstraint.create(item: item, attribute: attribute1, relatedBy: relatedBy, toItem: toItem, attribute: attribute2, multiplier: multiplier, constant: constant)
    }
    
		static func makeToParent(item: UILayoutable, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
				make(item: item, attribute: attribute1, relatedBy: relatedBy, toItem: item.parent, attribute: attribute2, multiplier: multiplier, constant: constant)
    }
    
		static func constraints(for constraint: NSLayoutConstraint) -> [NSLayoutConstraint] {
				((constraint.firstItem as? UILayoutable)?.constraints ?? []) +
            ((constraint.secondItem as? UILayoutable)?.constraints ?? [])
    }
    
    static func makeWithOffset(item: UILayoutable, attribute: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation, multiplier: CGFloat, constant: CGFloat, offset: CGFloat) -> NSLayoutConstraint {
        let result: NSLayoutConstraint
        switch attribute {
        case .width, .height:
            result = make(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1 / multiplier, constant: max(0, offset - constant))
        case .notAnAttribute:
            result = make(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: attribute, multiplier: 1 / multiplier, constant: offset - constant)
        case .bottom, .trailing, .bottomMargin, .trailingMargin, .lastBaseline, .right, .rightMargin:
					result = makeToParent(item: item, attribute: attribute, relatedBy: relation.reversed, attribute: attribute, multiplier: 1 / multiplier, constant: constant - offset)
        default:
            result = makeToParent(item: item, attribute: attribute, relatedBy: relation, attribute: attribute, multiplier: 1 / multiplier, constant: offset - constant)
        }
        return result
    }
}

struct ConstraintsBuilder {
    
    static func make(item: [UILayoutable], attribute attribute1: [NSLayoutConstraint.Attribute], relatedBy: NSLayoutConstraint.Relation, toItem: [UILayoutable?], attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        for first in item {
            for attribute in attribute1 {
							for second in toItem {
                result.append(NSLayoutConstraint.create(item: first, attribute: attribute, relatedBy: relatedBy, toItem: second, attribute: attribute2, multiplier: multiplier, constant: constant))
							}
            }
        }
        return result
    }
    
    static func makeToParent(item: [UILayoutable], attribute attribute1: [NSLayoutConstraint.Attribute], relatedBy: NSLayoutConstraint.Relation, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        item.forEach {
            result += make(item: [$0], attribute: attribute1, relatedBy: relatedBy, toItem: [$0.parent], attribute: attribute2, multiplier: multiplier, constant: constant)
        }
        return result
    }
    
    static func makeToView(item: [UILayoutable], attribute attribute1: [NSLayoutConstraint.Attribute], relatedBy: NSLayoutConstraint.Relation, itemTo: [UILayoutable?], multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        item.forEach {
            for attribute in attribute1 {
                result += make(item: [$0], attribute: [attribute], relatedBy: relatedBy, toItem: itemTo, attribute: attribute, multiplier: multiplier, constant: constant)
            }
        }
        return result
    }
    
    static func makeWithOffset(item: [UILayoutable], attribute: [NSLayoutConstraint.Attribute], relatedBy relation: NSLayoutConstraint.Relation, multiplier: CGFloat, constant: CGFloat, offset: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        item.forEach {
            for a in attribute {
							result.append(ConstraintBuilder.makeWithOffset(item: $0, attribute: a, relatedBy: relation, multiplier: multiplier, constant: constant, offset: offset))
            }
        }
        return result
    }
    
    static func constraints(for constraint: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        return Array(constraint.map(ConstraintBuilder.constraints).joined())
    }
    
    static func array(for constraints: [[NSLayoutConstraint]]) -> [NSLayoutConstraint] {
        return Array(constraints.joined())
    }
    
    static func willConflict(_ constraint: [NSLayoutConstraint], with other: NSLayoutConstraint) -> Bool {
        for c in constraint {
            if c.willConflict(with: other) {
                return true
            }
        }
        return false
    }
}

extension NSLayoutConstraint {
    
    static func create(item: UILayoutable, attribute: Attribute, relatedBy: Relation, toItem: UILayoutable?, attribute att1: Attribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
			NSLayoutConstraint(item: item.itemForConstraint, attribute: attribute, relatedBy: relatedBy, toItem: toItem?.itemForConstraint, attribute: att1, multiplier: multiplier, constant: constant)
    }
    
}

extension NSLayoutConstraint.Relation {
	
	var reversed: NSLayoutConstraint.Relation {
		switch self {
		case .greaterThanOrEqual: return .lessThanOrEqual
		case .lessThanOrEqual: 		return .greaterThanOrEqual
		case .equal:							return .equal
		default:									return self
		}
	}
	
}
