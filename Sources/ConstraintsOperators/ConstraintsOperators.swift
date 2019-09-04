//
//  ConstraintsOperators.swift
//  PBKit
//
//  Created by Данил Войдилов on 15/05/2019.
//  Copyright © 2019 PochtaBank. All rights reserved.
//

import UIKit

infix operator =|: RangeFormationPrecedence
infix operator >=|: RangeFormationPrecedence
infix operator <=|: RangeFormationPrecedence

public protocol UILayoutable: class {}

extension UIView: UILayoutable {
    @available(iOS 11.0, *)
    public var safeAreaLayout: ConvienceLayout<UILayoutGuide> { return safeAreaLayoutGuide.layout }
}

extension UILayoutGuide: UILayoutable {}

extension UILayoutable {
    public var layout: ConvienceLayout<Self> { return ConvienceLayout(self) }
}

public struct ConvienceLayout<T: UILayoutable> {
    private weak var item: T?
    
    public var width:                Attribute<Size> { return Attribute(type: .width, item: item) }
    public var height:               Attribute<Size> { return Attribute(type: .height, item: item) }
    
    public var top:                  Attribute<Vertical> { return Attribute(type: .top, item: item) }
    public var bottom:               Attribute<Vertical> { return Attribute(type: .bottom, item: item) }
    public var lastBaseline:         Attribute<Vertical> { return Attribute(type: .lastBaseline, item: item) }
    public var firstBaseline:        Attribute<Vertical> { return Attribute(type: .firstBaseline, item: item) }
    public var topMargin:            Attribute<Vertical> { return Attribute(type: .topMargin, item: item) }
    public var bottomMargin:         Attribute<Vertical> { return Attribute(type: .bottomMargin, item: item) }
    
    public var leading:              Attribute<LeadTrail> { return Attribute(type: .leading, item: item) }
    public var trailing:             Attribute<LeadTrail> { return Attribute(type: .trailing, item: item) }
    public var leadingMargin:        Attribute<LeadTrail> { return Attribute(type: .leadingMargin, item: item) }
    public var trailingMargin:       Attribute<LeadTrail> { return Attribute(type: .trailingMargin, item: item) }
    
    public var left:                 Attribute<LeftRight> { return Attribute(type: .left, item: item) }
    public var right:                Attribute<LeftRight> { return Attribute(type: .right, item: item) }
    public var leftMargin:           Attribute<LeftRight> { return Attribute(type: .leftMargin, item: item) }
    public var rightMargin:          Attribute<LeftRight> { return Attribute(type: .rightMargin, item: item) }
    
    public var centerX:              Attribute<CenterX>  { return Attribute(type: .centerX, item: item) }
    public var centerY:              Attribute<Vertical> { return Attribute(type: .centerY, item: item) }
    public var centerXWithinMargins: Attribute<CenterX>  { return Attribute(type: .centerXWithinMargins, item: item) }
    public var centerYWithinMargins: Attribute<Vertical> { return Attribute(type: .centerYWithinMargins, item: item) }
    
    public init(_ item: T) {
        self.item = item
    }
    
    private init() {}
    
    public func setEdges<D: UILayoutable>(to view: D?, leading: CGFloat? = 0, trailing: CGFloat? = 0, top: CGFloat? = 0, bottom: CGFloat? = 0, priority: UILayoutPriority = .required) {
        (item as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        if let lead = leading {
            let constr = NSLayoutConstraint(item: item as Any, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: lead)
            constr.priority = priority
            constr.isActive = true
        }
        if let trail = trailing {
            let constr = NSLayoutConstraint(item: item as Any, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: trail)
            constr.priority = priority
            constr.isActive = true
        }
        if let top = top {
            let constr = NSLayoutConstraint(item: item as Any, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: top)
            constr.priority = priority
            constr.isActive = true
        }
        if let bottom = bottom {
            let constr = NSLayoutConstraint(item: item as Any, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: bottom)
            constr.priority = priority
            constr.isActive = true
        }
    }
    
    public struct Attribute<A> {
        fileprivate var type: NSLayoutConstraint.Attribute
        fileprivate weak var item: T?
        fileprivate var constant: CGFloat
        fileprivate var multiplier: CGFloat
        fileprivate var priority: UILayoutPriority
        fileprivate var isActive = true
        
        fileprivate init(type: NSLayoutConstraint.Attribute, item: T?, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required, isActive: Bool = true) {
            self.type = type
            self.item = item
            self.constant = constant
            self.multiplier = multiplier
            self.priority = priority
        }
        
        public func priority(_ _priority: Float) -> Attribute<A> {
            return Attribute<A>(type: type, item: item, constant: constant, multiplier: multiplier, priority: UILayoutPriority(_priority))
        }
        
        public var disabled: Attribute<A> {
            return Attribute<A>(type: type, item: item, constant: constant, multiplier: multiplier, isActive: false)
        }
    }
    
    public enum LeadTrail: CenterXAttributeCompatible {}
    public enum LeftRight: CenterXAttributeCompatible {}
    public enum CenterX {}
    public enum Vertical {}
    public enum Size {}
}

public protocol CenterXAttributeCompatible {}

fileprivate func setup<A: UILayoutable, B: UILayoutable, C, D>(_ lhs: ConvienceLayout<A>.Attribute<C>, _ rhs: ConvienceLayout<B>.Attribute<D>, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
    let result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: rhs.item, attribute: rhs.type, multiplier: rhs.multiplier / lhs.multiplier, constant: rhs.constant - lhs.constant)
    result.priority = min(lhs.priority, rhs.priority)
    let active = lhs.isActive && rhs.isActive
    if active {
        removeConflicts(lhs, rhs, with: result)
    }
    result.isActive = active
    return result
}

fileprivate func removeConflicts<A: UILayoutable, B: UILayoutable, C, D>(_ lhs: ConvienceLayout<A>.Attribute<C>, _ rhs: ConvienceLayout<B>.Attribute<D>?, with constraint: NSLayoutConstraint) {
    let lConstraints = (lhs.item as? UIView)?.constraints ?? []
    let rConstraints = (rhs?.item as? UIView)?.constraints ?? []
    let constraints = lConstraints + rConstraints
    constraints.filter({ constraint.willConflict(with: $0) }).forEach {
        $0.isActive = false
    }
}

fileprivate func setup<A: UILayoutable, N>(_ lhs: ConvienceLayout<A>.Attribute<N>, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
    let result: NSLayoutConstraint
    let active = lhs.isActive
    defer {
        result.priority = lhs.priority
        if active {
            removeConflicts(lhs, nil as ConvienceLayout<A>.Attribute<N>?, with: result)
        }
        result.isActive = active
    }
    switch lhs.type {
    case .width, .height:
        result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1 / lhs.multiplier, constant: max(0, rhs - lhs.constant))
    case .notAnAttribute:
        result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: nil, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
    case .bottom, .trailing, .bottomMargin, .trailingMargin, .lastBaseline, .right, .rightMargin:
        if #available(iOS 11.0, *) {
            result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: (lhs.item as? UIView)?.superview?.safeAreaLayoutGuide, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: -rhs - lhs.constant)
        } else {
            result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: (lhs.item as? UIView)?.superview, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: -rhs - lhs.constant)
        }
    default:
        if #available(iOS 11.0, *) {
            result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: (lhs.item as? UIView)?.superview?.safeAreaLayoutGuide, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
        } else {
            result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: (lhs.item as? UIView)?.superview, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
        }
    }
    return result
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable, T>(_ lhs: ConvienceLayout<A>.Attribute<T>, _ rhs: ConvienceLayout<B>.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable, T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout<A>.Attribute<ConvienceLayout<A>.CenterX>, _ rhs: ConvienceLayout<B>.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable, T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout<A>.Attribute<T>, _ rhs: ConvienceLayout<B>.Attribute<ConvienceLayout<B>.CenterX>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, T>(_ lhs: ConvienceLayout<A>.Attribute<T>, _ rhs: CGFloat) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable, T>(_ lhs: ConvienceLayout<A>.Attribute<T>, _ rhs: ConvienceLayout<B>.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable, T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout<A>.Attribute<T>, _ rhs: ConvienceLayout<B>.Attribute<ConvienceLayout<B>.CenterX>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable, T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout<A>.Attribute<ConvienceLayout<A>.CenterX>, _ rhs: ConvienceLayout<B>.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, T>(_ lhs: ConvienceLayout<A>.Attribute<T>, _ rhs: CGFloat) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable, T>(_ lhs: ConvienceLayout<A>.Attribute<T>, _ rhs: ConvienceLayout<B>.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable, T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout<A>.Attribute<ConvienceLayout<A>.CenterX>, _ rhs: ConvienceLayout<B>.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable, T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout<A>.Attribute<T>, _ rhs: ConvienceLayout<B>.Attribute<ConvienceLayout<B>.CenterX>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, T>(_ lhs: ConvienceLayout<A>.Attribute<T>, _ rhs: CGFloat) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

public func *<A: UILayoutable, T>(_ lhs: CGFloat, _ rhs: ConvienceLayout<A>.Attribute<T>) -> ConvienceLayout<A>.Attribute<T> {
    var result = rhs
    result.multiplier = lhs
    return result
}

public func *<A: UILayoutable, T>(_ rhs: ConvienceLayout<A>.Attribute<T>, _ lhs: CGFloat) -> ConvienceLayout<A>.Attribute<T> {
    var result = rhs
    result.multiplier *= lhs
    return result
}

public func /<A: UILayoutable, T>(_ rhs: ConvienceLayout<A>.Attribute<T>, _ lhs: CGFloat) -> ConvienceLayout<A>.Attribute<T> {
    var result = rhs
    result.multiplier /= lhs
    return result
}

public func +<A: UILayoutable, T>(_ lhs: CGFloat, _ rhs: ConvienceLayout<A>.Attribute<T>) -> ConvienceLayout<A>.Attribute<T> {
    var result = rhs
    result.constant += lhs
    return result
}

public func +<A: UILayoutable, T>(_ rhs: ConvienceLayout<A>.Attribute<T>, _ lhs: CGFloat) -> ConvienceLayout<A>.Attribute<T> {
    var result = rhs
    result.constant += lhs
    return result
}

public func -<A: UILayoutable, T>(_ lhs: CGFloat, _ rhs: ConvienceLayout<A>.Attribute<T>) -> ConvienceLayout<A>.Attribute<T> {
    return lhs + rhs * (-1)
}

public func -<A: UILayoutable, T>(_ rhs: ConvienceLayout<A>.Attribute<T>, _ lhs: CGFloat) -> ConvienceLayout<A>.Attribute<T> {
    var result = rhs
    result.constant -= lhs
    return result
}

extension NSLayoutConstraint {
    
    fileprivate func willConflict(with rhs: NSLayoutConstraint) -> Bool {
        guard rhs.isActive, priority == rhs.priority else { return false }
        if self.firstItem == nil && secondItem == nil || rhs.firstItem == nil && rhs.secondItem == nil {
            return false
        }
        return (first == rhs.first && second == rhs.second) && relation == rhs.relation ||
            (first == rhs.second && second == rhs.first) && relation.isOpposite(to: rhs.relation)
    }
    
    fileprivate struct Item: Equatable {
        let attribute: NSLayoutConstraint.Attribute
        let view: AnyObject?
        
        static func ==(lhs: NSLayoutConstraint.Item, rhs: NSLayoutConstraint.Item) -> Bool {
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
