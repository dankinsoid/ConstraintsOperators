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
    
    public var width:                Attribute.Size { return Attribute.Size(type: .width, item: item) }
    public var height:               Attribute.Size { return Attribute.Size(type: .height, item: item) }
    
    public var top:                  Attribute.Vertical { return Attribute.Vertical(type: .top, item: item) }
    public var bottom:               Attribute.Vertical { return Attribute.Vertical(type: .bottom, item: item) }
    public var lastBaseline:         Attribute.Vertical { return Attribute.Vertical(type: .lastBaseline, item: item) }
    public var firstBaseline:        Attribute.Vertical { return Attribute.Vertical(type: .firstBaseline, item: item) }
    public var topMargin:            Attribute.Vertical { return Attribute.Vertical(type: .topMargin, item: item) }
    public var bottomMargin:         Attribute.Vertical { return Attribute.Vertical(type: .bottomMargin, item: item) }
    
    public var leading:              Attribute.LeadTrail { return Attribute.LeadTrail(type: .leading, item: item) }
    public var trailing:             Attribute.LeadTrail { return Attribute.LeadTrail(type: .trailing, item: item) }
    public var leadingMargin:        Attribute.LeadTrail { return Attribute.LeadTrail(type: .leadingMargin, item: item) }
    public var trailingMargin:       Attribute.LeadTrail { return Attribute.LeadTrail(type: .trailingMargin, item: item) }
    
    public var left:                 Attribute.LeftRight { return Attribute.LeftRight(type: .left, item: item) }
    public var right:                Attribute.LeftRight { return Attribute.LeftRight(type: .right, item: item) }
    public var leftMargin:           Attribute.LeftRight { return Attribute.LeftRight(type: .leftMargin, item: item) }
    public var rightMargin:          Attribute.LeftRight { return Attribute.LeftRight(type: .rightMargin, item: item) }
    
    public var centerX:              Attribute.CenterX { return Attribute.CenterX(type: .centerX, item: item) }
    public var centerY:              Attribute.Vertical { return Attribute.Vertical(type: .centerY, item: item) }
    public var centerXWithinMargins: Attribute.CenterX { return Attribute.CenterX(type: .centerXWithinMargins, item: item) }
    public var centerYWithinMargins: Attribute.Vertical { return Attribute.Vertical(type: .centerYWithinMargins, item: item) }
    
    public var notAnAttribute:       Attribute { return Attribute(type: .notAnAttribute, item: item) }
    
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
    
    public class Attribute {
        fileprivate final var type: NSLayoutConstraint.Attribute
        fileprivate final weak var item: T?
        fileprivate final var constant: CGFloat
        fileprivate final var multiplier: CGFloat
        fileprivate final var priority: UILayoutPriority
        fileprivate final var isActive = true
        
        fileprivate init(type: NSLayoutConstraint.Attribute, item: T?, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required, isActive: Bool = true) {
            self.type = type
            self.item = item
            self.constant = constant
            self.multiplier = multiplier
            self.priority = priority
        }
        
        public final class LeadTrail: Attribute {
            
            public func priority(_ _priority: UILayoutPriority) -> LeadTrail {
                return LeadTrail(type: type, item: item, constant: constant, multiplier: multiplier, priority: _priority)
            }
            
            public func priority(_ _priority: Float) -> LeadTrail {
                return LeadTrail(type: type, item: item, constant: constant, multiplier: multiplier, priority: UILayoutPriority(_priority))
            }
            
            public var disabled: LeadTrail {
                return LeadTrail(type: type, item: item, constant: constant, multiplier: multiplier, isActive: false)
            }
            
        }
        
        public final class LeftRight: Attribute {
            
            public func priority(_ _priority: UILayoutPriority) -> LeftRight {
                return LeftRight(type: type, item: item, constant: constant, multiplier: multiplier, priority: _priority)
            }
            
            public func priority(_ _priority: Float) -> LeftRight {
                return LeftRight(type: type, item: item, constant: constant, multiplier: multiplier, priority: UILayoutPriority(_priority))
            }
            
            public var disabled: LeftRight {
                return LeftRight(type: type, item: item, constant: constant, multiplier: multiplier, isActive: false)
            }
            
        }
        
        public final class CenterX: Attribute {
            
            public func priority(_ _priority: UILayoutPriority) -> CenterX {
                return CenterX(type: type, item: item, constant: constant, multiplier: multiplier, priority: _priority)
            }
            
            public func priority(_ _priority: Float) -> CenterX {
                return CenterX(type: type, item: item, constant: constant, multiplier: multiplier, priority: UILayoutPriority(_priority))
            }
            
            public var disabled: CenterX {
                return CenterX(type: type, item: item, constant: constant, multiplier: multiplier, isActive: false)
            }
            
        }
        
        public final class Vertical: Attribute {
            
            public func priority(_ _priority: UILayoutPriority) -> Vertical {
                return Vertical(type: type, item: item, constant: constant, multiplier: multiplier, priority: _priority)
            }
            
            public func priority(_ _priority: Float) -> Vertical {
                return Vertical(type: type, item: item, constant: constant, multiplier: multiplier, priority: UILayoutPriority(_priority))
            }
            
            public var disabled: Vertical {
                return Vertical(type: type, item: item, constant: constant, multiplier: multiplier, isActive: false)
            }
            
        }
        
        public final class Size: Attribute {
            
            public func priority(_ _priority: UILayoutPriority) -> Size {
                return Size(type: type, item: item, constant: constant, multiplier: multiplier, priority: _priority)
            }
            
            public func priority(_ _priority: Float) -> Size {
                return Size(type: type, item: item, constant: constant, multiplier: multiplier, priority: UILayoutPriority(_priority))
            }
            
            public var disabled: Size {
                return Size(type: type, item: item, constant: constant, multiplier: multiplier, isActive: false)
            }
            
        }
        
    }
    
}

fileprivate func setup<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute, _ rhs: ConvienceLayout<B>.Attribute, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
    let result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: rhs.item, attribute: rhs.type, multiplier: rhs.multiplier / lhs.multiplier, constant: rhs.constant - lhs.constant)
    result.priority = min(lhs.priority, rhs.priority)
    let active = lhs.isActive && rhs.isActive
    if active {
        removeConflicts(lhs, rhs, with: result)
    }
    result.isActive = active
    return result
}

fileprivate func removeConflicts<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute, _ rhs: ConvienceLayout<B>.Attribute?, with constraint: NSLayoutConstraint) {
    let lConstraints = (lhs.item as? UIView)?.constraints ?? []
    let rConstraints = (rhs?.item as? UIView)?.constraints ?? []
    let constraints = lConstraints + rConstraints
    constraints.filter({ constraint.willConflict(with: $0) }).forEach {
        $0.isActive = false
    }
}

fileprivate func setup<A: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
    let result: NSLayoutConstraint
    let active = lhs.isActive
    defer {
        result.priority = lhs.priority
        if active {
            removeConflicts(lhs, nil as ConvienceLayout<A>.Attribute?, with: result)
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
public func =|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.Size, _ rhs: ConvienceLayout<B>.Attribute.Size) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeadTrail, _ rhs: ConvienceLayout<B>.Attribute.LeadTrail) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.CenterX, _ rhs: ConvienceLayout<B>.Attribute.LeadTrail) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeadTrail, _ rhs: ConvienceLayout<B>.Attribute.CenterX) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeftRight, _ rhs: ConvienceLayout<B>.Attribute.LeftRight) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.CenterX, _ rhs: ConvienceLayout<B>.Attribute.LeftRight) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeftRight, _ rhs: ConvienceLayout<B>.Attribute.CenterX) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.CenterX, _ rhs: ConvienceLayout<B>.Attribute.CenterX) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.Vertical, _ rhs: ConvienceLayout<B>.Attribute.Vertical) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ lhs: T, _ rhs: CGFloat) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.Size, _ rhs: ConvienceLayout<B>.Attribute.Size) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeadTrail, _ rhs: ConvienceLayout<B>.Attribute.LeadTrail) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.CenterX, _ rhs: ConvienceLayout<B>.Attribute.LeadTrail) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeadTrail, _ rhs: ConvienceLayout<B>.Attribute.CenterX) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeftRight, _ rhs: ConvienceLayout<B>.Attribute.LeftRight) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.CenterX, _ rhs: ConvienceLayout<B>.Attribute.LeftRight) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeftRight, _ rhs: ConvienceLayout<B>.Attribute.CenterX) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.CenterX, _ rhs: ConvienceLayout<B>.Attribute.CenterX) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.Vertical, _ rhs: ConvienceLayout<B>.Attribute.Vertical) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ lhs: T, _ rhs: CGFloat) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeadTrail, _ rhs: ConvienceLayout<B>.Attribute.LeadTrail) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.Size, _ rhs: ConvienceLayout<B>.Attribute.Size) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.CenterX, _ rhs: ConvienceLayout<B>.Attribute.LeadTrail) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeadTrail, _ rhs: ConvienceLayout<B>.Attribute.CenterX) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeftRight, _ rhs: ConvienceLayout<B>.Attribute.LeftRight) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.CenterX, _ rhs: ConvienceLayout<B>.Attribute.LeftRight) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.LeftRight, _ rhs: ConvienceLayout<B>.Attribute.CenterX) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.CenterX, _ rhs: ConvienceLayout<B>.Attribute.CenterX) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute.Vertical, _ rhs: ConvienceLayout<B>.Attribute.Vertical) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ lhs: T, _ rhs: CGFloat) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

public func *<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ lhs: CGFloat, _ rhs: T) -> T {
    let result = rhs
    result.multiplier = lhs
    return result
}

public func *<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ rhs: T, _ lhs: CGFloat) -> T {
    let result = rhs
    result.multiplier *= lhs
    return result
}

public func /<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ rhs: T, _ lhs: CGFloat) -> T {
    let result = rhs
    result.multiplier /= lhs
    return result
}

public func +<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ lhs: CGFloat, _ rhs: T) -> T {
    let result = rhs
    result.constant += lhs
    return result
}

public func +<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ rhs: T, _ lhs: CGFloat) -> T {
    let result = rhs
    result.constant += lhs
    return result
}

public func -<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ lhs: CGFloat, _ rhs: T) -> T {
    return lhs + rhs * (-1)
}

public func -<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ rhs: T, _ lhs: CGFloat) -> T {
    let result = rhs
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
