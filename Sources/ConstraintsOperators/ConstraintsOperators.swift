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

extension UILayoutPriority: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = UInt16
    public typealias FloatLiteralType = RawValue
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(RawValue(value))
    }
    
}

extension UILayoutable {
    public var layout: ConvienceLayout<Self> { return ConvienceLayout(self) }
}

public struct ConvienceLayout<T: UILayoutable> {
    private weak var item: T?
    
    public var width:                 Attribute.Size { return Attribute.Size(type: .width, item: item) }
    public var height:                    Attribute.Size { return Attribute.Size(type: .height, item: item) }
    
    public var top:                      Attribute.Vertical { return Attribute.Vertical(type: .top, item: item) }
    public var bottom:                  Attribute.Vertical { return Attribute.Vertical(type: .bottom, item: item) }
    public var lastBaseline:         Attribute.Vertical { return Attribute.Vertical(type: .lastBaseline, item: item) }
    public var firstBaseline:         Attribute.Vertical { return Attribute.Vertical(type: .firstBaseline, item: item) }
    public var topMargin:             Attribute.Vertical { return Attribute.Vertical(type: .topMargin, item: item) }
    public var bottomMargin:         Attribute.Vertical { return Attribute.Vertical(type: .bottomMargin, item: item) }
    
    public var leading:                  Attribute.LeadTrail { return Attribute.LeadTrail(type: .leading, item: item) }
    public var trailing:              Attribute.LeadTrail { return Attribute.LeadTrail(type: .trailing, item: item) }
    public var leadingMargin:         Attribute.LeadTrail { return Attribute.LeadTrail(type: .leadingMargin, item: item) }
    public var trailingMargin:          Attribute.LeadTrail { return Attribute.LeadTrail(type: .trailingMargin, item: item) }
    
    public var left:                  Attribute.LeftRight { return Attribute.LeftRight(type: .left, item: item) }
    public var right:                 Attribute.LeftRight { return Attribute.LeftRight(type: .right, item: item) }
    public var leftMargin:              Attribute.LeftRight { return Attribute.LeftRight(type: .leftMargin, item: item) }
    public var rightMargin:              Attribute.LeftRight { return Attribute.LeftRight(type: .rightMargin, item: item) }
    
    public var centerX:                  Attribute.CenterX { return Attribute.CenterX(type: .centerX, item: item) }
    public var centerY:                  Attribute.Vertical { return Attribute.Vertical(type: .centerY, item: item) }
    public var centerXWithinMargins: Attribute.CenterX { return Attribute.CenterX(type: .centerXWithinMargins, item: item) }
    public var centerYWithinMargins: Attribute.Vertical { return Attribute.Vertical(type: .centerYWithinMargins, item: item) }
    
    public var notAnAttribute:          Attribute { return Attribute(type: .notAnAttribute, item: item) }
    
    public init(_ item: T) {
        self.item = item
    }
    
    private init() {}
    
    public func setEdges<D: UILayoutable>(to view: D?, leading: CGFloat? = 0, trailing: CGFloat? = 0, top: CGFloat? = 0, bottom: CGFloat? = 0, priority: UILayoutPriority = .required) {
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
        
        fileprivate init(type: NSLayoutConstraint.Attribute, item: T?, constant: CGFloat = 0, multiplier: CGFloat = 1) {
            self.type = type
            self.item = item
            self.constant = constant
            self.multiplier = multiplier
        }
        
        public final class LeadTrail: Attribute {
            
            @discardableResult
            public func set<B: UILayoutable>(_ layout: ConvienceLayout<B>.Attribute.LeadTrail, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, activate: Bool = true) -> NSLayoutConstraint {
                return setup(self, layout, relation: relation, priority: priority, active: activate)
            }
            
            @discardableResult
            public func set<B: UILayoutable>(_ layout: ConvienceLayout<B>.Attribute.CenterX, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, activate: Bool = true) -> NSLayoutConstraint {
                return setup(self, layout, relation: relation, priority: priority, active: activate)
            }
            
        }
        
        public final class LeftRight: Attribute {
            
            @discardableResult
            public func set<B: UILayoutable>(_ layout: ConvienceLayout<B>.Attribute.LeftRight, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, activate: Bool = true) -> NSLayoutConstraint {
                return setup(self, layout, relation: relation, priority: priority, active: activate)
            }
            
            @discardableResult
            public func set<B: UILayoutable>(_ layout: ConvienceLayout<B>.Attribute.CenterX, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, activate: Bool = true) -> NSLayoutConstraint {
                return setup(self, layout, relation: relation, priority: priority, active: activate)
            }
            
        }
        
        public final class CenterX: Attribute {
            
            @discardableResult
            public func set<B: UILayoutable>(_ layout: ConvienceLayout<B>.Attribute.CenterX, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, activate: Bool = true) -> NSLayoutConstraint {
                return setup(self, layout, relation: relation, priority: priority, active: activate)
            }
            
            @discardableResult
            public func set<B: UILayoutable>(_ layout: ConvienceLayout<B>.Attribute.LeadTrail, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, activate: Bool = true) -> NSLayoutConstraint {
                return setup(self, layout, relation: relation, priority: priority, active: activate)
            }
            
            @discardableResult
            public func set<B: UILayoutable>(_ layout: ConvienceLayout<B>.Attribute.LeftRight, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, activate: Bool = true) -> NSLayoutConstraint {
                return setup(self, layout, relation: relation, priority: priority, active: activate)
            }
            
        }
        
        public final class Vertical: Attribute {
            
            @discardableResult
            public func set<B: UILayoutable>(_ layout: ConvienceLayout<B>.Attribute.Vertical, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, activate: Bool = true) -> NSLayoutConstraint {
                return setup(self, layout, relation: relation, priority: priority, active: activate)
            }
            
        }
        
        public final class Size: Attribute {
            
            @discardableResult
            public func set<B: UILayoutable>(_ layout: ConvienceLayout<B>.Attribute.Size, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, activate: Bool = true) -> NSLayoutConstraint {
                return setup(self, layout, relation: relation, priority: priority, active: activate)
            }
            
        }
        
    }
    
}

fileprivate func setup<A: UILayoutable, B: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute, _ rhs: ConvienceLayout<B>.Attribute, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required, active: Bool = true) -> NSLayoutConstraint {
    let result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: rhs.item, attribute: rhs.type, multiplier: rhs.multiplier / lhs.multiplier, constant: rhs.constant - lhs.constant)
    result.priority = priority
    result.isActive = active
    return result
}

fileprivate func setup<A: UILayoutable>(_ lhs: ConvienceLayout<A>.Attribute, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required, active: Bool = true) -> NSLayoutConstraint {
    switch lhs.type {
    case .width, .height:
        let result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1 / lhs.multiplier, constant: max(0, rhs - lhs.constant))
        result.priority = priority
        result.isActive = active
        return result
    case .notAnAttribute:
        let result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: nil, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
        result.priority = priority
        result.isActive = active
        return result
    case .bottom, .trailing, .bottomMargin, .trailingMargin, .lastBaseline, .right, .rightMargin:
        let result: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: (lhs.item as? UIView)?.superview?.safeAreaLayoutGuide, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: -rhs - lhs.constant)
        } else {
            result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: (lhs.item as? UIView)?.superview, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: -rhs - lhs.constant)
        }
        result.priority = priority
        result.isActive = active
        return result
    default:
        let result: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: (lhs.item as? UIView)?.superview?.safeAreaLayoutGuide, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
        } else {
            result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: (lhs.item as? UIView)?.superview, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
        }
        result.priority = priority
        result.isActive = active
        return result
    }
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
    let result = rhs
    result.constant -= lhs
    return result
}

public func -<A: UILayoutable, T: ConvienceLayout<A>.Attribute>(_ rhs: T, _ lhs: CGFloat) -> T {
    let result = rhs
    result.constant -= lhs
    return result
}
