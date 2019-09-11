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

public protocol ConstraintsCreator {
    associatedtype First
    associatedtype Second
    associatedtype Constraint: ConstraintProtocol
    associatedtype A: AttributeConvertable//: ConstraintProtocol
    static func make(item: First, attribute attribute1: A, relatedBy: NSLayoutConstraint.Relation, toItem: Second?, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> Constraint
    static func constraints(for constraint: Constraint) -> [NSLayoutConstraint]
    static func array(for constraint: [Constraint]) -> [NSLayoutConstraint]
    static func willConflict(_ constraint: Constraint, with other: NSLayoutConstraint) -> Bool
    static func makeToParent(item: First, attribute attribute1: A, relatedBy: NSLayoutConstraint.Relation, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> Constraint
    static func makeWithOffset(item: First, attribute: A, relatedBy relation: NSLayoutConstraint.Relation, multiplier: CGFloat, constant: CGFloat, offset: CGFloat) -> Constraint
    static func makeToView(item: First, attribute attribute1: A, relatedBy: NSLayoutConstraint.Relation, itemTo: Second?, multiplier: CGFloat, constant: CGFloat) -> Constraint
}

public struct ConstraintBuilder: ConstraintsCreator {
    
    public static func make(item: UILayoutable, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, toItem: UILayoutable?, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute1, relatedBy: relatedBy, toItem: toItem, attribute: attribute2, multiplier: multiplier, constant: constant)
    }
    
    public static func makeToParent(item: UILayoutable, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return make(item: item, attribute: attribute1, relatedBy: relatedBy, toItem: item.parent, attribute: attribute2, multiplier: multiplier, constant: constant)
    }
    
    public static func makeToView(item: UILayoutable, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, itemTo: UILayoutable?, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return make(item: item, attribute: attribute1, relatedBy: relatedBy, toItem: item, attribute: attribute1, multiplier: multiplier, constant: constant)
    }
    
    public static func constraints(for constraint: NSLayoutConstraint) -> [NSLayoutConstraint] {
        return ((constraint.firstItem as? UILayoutable)?.constraints ?? []) +
            ((constraint.secondItem as? UILayoutable)?.constraints ?? [])
    }
    
    public static func array(for constraints: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        return constraints
    }
    
    public static func willConflict(_ constraint: NSLayoutConstraint, with other: NSLayoutConstraint) -> Bool {
        return constraint.willConflict(with: other)
    }
    
    public static func makeWithOffset(item: UILayoutable, attribute: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation, multiplier: CGFloat, constant: CGFloat, offset: CGFloat) -> NSLayoutConstraint {
        let result: Constraint
        switch attribute {
        case .width, .height:
            result = make(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1 / multiplier, constant: max(0, offset - constant))
        case .notAnAttribute:
            result = make(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: attribute, multiplier: 1 / multiplier, constant: offset - constant)
        case .bottom, .trailing, .bottomMargin, .trailingMargin, .lastBaseline, .right, .rightMargin:
            result = makeToParent(item: item, attribute: attribute, relatedBy: relation, attribute: attribute, multiplier: 1 / multiplier, constant: constant - offset)
        default:
            result = makeToParent(item: item, attribute: attribute, relatedBy: relation, attribute: attribute, multiplier: 1 / multiplier, constant: offset - constant)
        }
        return result
    }
}

public struct ConstraintsBuilder: ConstraintsCreator {
    public typealias A = [NSLayoutConstraint.Attribute]
    
    public static func make(item: [UILayoutable], attribute attribute1: [NSLayoutConstraint.Attribute], relatedBy: NSLayoutConstraint.Relation, toItem: UILayoutable?, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        for first in item {
            for attribute in attribute1 {
                result.append(NSLayoutConstraint(item: first, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute: attribute2, multiplier: multiplier, constant: constant))
            }
        }
        return result
    }
    
    public static func makeToParent(item: [UILayoutable], attribute attribute1: [NSLayoutConstraint.Attribute], relatedBy: NSLayoutConstraint.Relation, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        item.forEach {
            result += make(item: [$0], attribute: attribute1, relatedBy: relatedBy, toItem: $0.parent, attribute: attribute2, multiplier: multiplier, constant: constant)
        }
        return result
    }
    
    public static func makeToView(item: [UILayoutable], attribute attribute1: [NSLayoutConstraint.Attribute], relatedBy: NSLayoutConstraint.Relation, itemTo: UILayoutable?, multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        item.forEach {
            for attribute in attribute1 {
                result += make(item: [$0], attribute: [attribute], relatedBy: relatedBy, toItem: itemTo, attribute: attribute, multiplier: multiplier, constant: constant)
            }
        }
        return result
    }
    
    public static func makeWithOffset(item: [UILayoutable], attribute: [NSLayoutConstraint.Attribute], relatedBy relation: NSLayoutConstraint.Relation, multiplier: CGFloat, constant: CGFloat, offset: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        item.forEach {
            for a in attribute {
                result.append(ConstraintBuilder.makeWithOffset(item: $0, attribute: a, relatedBy: relation, multiplier: multiplier, constant: constant, offset: offset))
            }
        }
        return result
    }
    
    public static func constraints(for constraint: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        return Array(constraint.map(ConstraintBuilder.constraints).joined())
    }
    
    public static func array(for constraints: [[NSLayoutConstraint]]) -> [NSLayoutConstraint] {
        return Array(constraints.joined())
    }
    
    public static func willConflict(_ constraint: [NSLayoutConstraint], with other: NSLayoutConstraint) -> Bool {
        for c in constraint {
            if c.willConflict(with: other) {
                return true
            }
        }
        return false
    }
    
}
