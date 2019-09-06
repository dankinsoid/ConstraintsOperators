//
//  ConstraintsOperators.swift
//  PBKit
//
//  Created by Данил Войдилов on 15/05/2019.
//  Copyright © 2019 PochtaBank. All rights reserved.
//

import UIKit

infix operator =|: AssignmentPrecedence
infix operator >=|: AssignmentPrecedence
infix operator <=|: AssignmentPrecedence

public protocol UILayoutable: class {}

extension UIView: UILayoutable {
    @available(iOS 11.0, *)
    public var safeAreaLayout: ConvienceLayout { return safeAreaLayoutGuide.layout }
}

extension UILayoutGuide: UILayoutable {}

extension UILayoutable {
    public var layout: ConvienceLayout { return ConvienceLayout(self) }
}

public struct ConvienceLayout {
    private let item: UILayoutable
    
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
    
    fileprivate func attribute<T>(as other: ConvienceLayout.Attribute<T>) -> Attribute<T> {
        return Attribute(type: other.type, item: item)
    }
    
    fileprivate func attribute<T>(type: NSLayoutConstraint.Attribute) -> Attribute<T> {
        return Attribute(type: type, item: item)
    }
    
    public init(_ item: UILayoutable) {
        self.item = item
    }
    
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
        fileprivate var item: UILayoutable
        fileprivate var constant: CGFloat
        fileprivate var multiplier: CGFloat
        fileprivate var priority: UILayoutPriority
        fileprivate var isActive = true
        
        fileprivate init(type: NSLayoutConstraint.Attribute, item: UILayoutable, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required, isActive: Bool = true) {
            self.type = type
            self.item = item
            self.constant = constant
            self.multiplier = multiplier
            self.priority = priority
        }
        
        fileprivate func asAny() -> Attribute<Void> {
            return Attribute<Void>(type: type, item: item, constant: constant, multiplier: multiplier, priority: priority, isActive: isActive)
        }
        
        public func priority(_ _priority: Float) -> Attribute<A> {
            return Attribute<A>(type: type, item: item, constant: constant, multiplier: multiplier, priority: UILayoutPriority(_priority))
        }
        
        public var deactivated: Attribute<A> {
            return Attribute<A>(type: type, item: item, constant: constant, multiplier: multiplier, isActive: false)
        }
        
    }
    
    public enum LeadTrail: CenterXAttributeCompatible, HorizontalLayoutableAttribute {}
    public enum LeftRight: CenterXAttributeCompatible {}
    public enum CenterX: HorizontalLayoutableAttribute {}
    public enum Vertical {}
    public enum Size {}
}

public protocol CenterXAttributeCompatible {}

fileprivate func _setup<C, D>(_ lhs: ConvienceLayout.Attribute<C>?, _ rhs: ConvienceLayout.Attribute<D>?, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint? {
    guard let l = lhs, let r = rhs else {
        return nil
    }
    return setup(l, r, relation: relation)
}

fileprivate func setup<C, D>(_ lhs: ConvienceLayout.Attribute<C>, _ rhs: ConvienceLayout.Attribute<D>, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
    let result = NSLayoutConstraint(item: lhs.item as Any, attribute: lhs.type, relatedBy: relation, toItem: rhs.item, attribute: rhs.type, multiplier: rhs.multiplier / lhs.multiplier, constant: rhs.constant - lhs.constant)
    result.priority = min(lhs.priority, rhs.priority)
    let active = lhs.isActive && rhs.isActive
    if active {
        removeConflicts(lhs, rhs, with: result)
    }
    result.isActive = active
    return result
}

fileprivate func removeConflicts<C, D>(_ lhs: ConvienceLayout.Attribute<C>, _ rhs: ConvienceLayout.Attribute<D>?, with constraint: NSLayoutConstraint) {
    let lConstraints = (lhs.item as? UIView)?.constraints ?? []
    let rConstraints = (rhs?.item as? UIView)?.constraints ?? []
    let constraints = lConstraints + rConstraints
    constraints.filter({ constraint.willConflict(with: $0) }).forEach {
        $0.isActive = false
    }
}

fileprivate func _setup<N>(_ lhs: ConvienceLayout.Attribute<N>?, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint? {
    guard let l = lhs else {
        return nil
    }
    return setup(l, rhs, relation: relation)
}

fileprivate func setup<N>(_ lhs: ConvienceLayout.Attribute<N>, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
    let result: NSLayoutConstraint
    let active = lhs.isActive
    defer {
        result.priority = lhs.priority
        if active {
            removeConflicts(lhs, nil as ConvienceLayout.Attribute<N>?, with: result)
        }
        result.isActive = active
    }
    switch lhs.type {
    case .width, .height:
        result = NSLayoutConstraint(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1 / lhs.multiplier, constant: max(0, rhs - lhs.constant))
    case .notAnAttribute:
        result = NSLayoutConstraint(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: nil, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
    case .bottom, .trailing, .bottomMargin, .trailingMargin, .lastBaseline, .right, .rightMargin:
        result = NSLayoutConstraint(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: lhs.item.parent, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: -rhs - lhs.constant)
    default:
        result = NSLayoutConstraint(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: lhs.item.parent, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
    }
    return result
}

@discardableResult
public func =|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: ConvienceLayout.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: UILayoutable) -> NSLayoutConstraint {
    return setup(lhs, rhs.layout.attribute(as: lhs), relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>, _ rhs: ConvienceLayout.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: CGFloat) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: ClosedRange<CGFloat>) -> [NSLayoutConstraint] {
    return [setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual), setup(lhs, rhs.upperBound, relation: .lessThanOrEqual)]
}

@discardableResult
public func =|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: ClosedRange<CGFloat>) -> [NSLayoutConstraint]? {
    guard let lhs = lhs else { return nil }
    return [setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual), setup(lhs, rhs.upperBound, relation: .lessThanOrEqual)]
}

@discardableResult
public func =|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: ConvienceLayout.Attribute<T>?) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: UILayoutable?) -> NSLayoutConstraint? {
    var r: ConvienceLayout.Attribute<T>?
    if let l = lhs {
        r = rhs?.layout.attribute(as: l)
    }
    return _setup(lhs, r, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>?, _ rhs: ConvienceLayout.Attribute<T>?) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>?) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: CGFloat) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func <=|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: ConvienceLayout.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: UILayoutable) -> NSLayoutConstraint {
    return setup(lhs, rhs.layout.attribute(as: lhs), relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>, _ rhs: ConvienceLayout.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: CGFloat) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: ConvienceLayout.Attribute<T>?) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: UILayoutable?) -> NSLayoutConstraint? {
    var r: ConvienceLayout.Attribute<T>?
    if let l = lhs {
        r = rhs?.layout.attribute(as: l)
    }
    return _setup(lhs, r, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>?) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>?, _ rhs: ConvienceLayout.Attribute<T>?) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: CGFloat) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func >=|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: ConvienceLayout.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: UILayoutable) -> NSLayoutConstraint {
    return setup(lhs, rhs.layout.attribute(as: lhs), relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>, _ rhs: ConvienceLayout.Attribute<T>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T>(_ lhs: ConvienceLayout.Attribute<T>, _ rhs: CGFloat) -> NSLayoutConstraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: ConvienceLayout.Attribute<T>?) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: UILayoutable?) -> NSLayoutConstraint? {
    var r: ConvienceLayout.Attribute<T>?
    if let l = lhs {
        r = rhs?.layout.attribute(as: l)
    }
    return _setup(lhs, r, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>?, _ rhs: ConvienceLayout.Attribute<T>?) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: ConvienceLayout.Attribute<ConvienceLayout.CenterX>?) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T>(_ lhs: ConvienceLayout.Attribute<T>?, _ rhs: CGFloat) -> NSLayoutConstraint? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

public func *<T>(_ lhs: CGFloat, _ rhs: ConvienceLayout.Attribute<T>) -> ConvienceLayout.Attribute<T> {
    var result = rhs
    result.multiplier = lhs
    return result
}

public func *<T>(_ rhs: ConvienceLayout.Attribute<T>, _ lhs: CGFloat) -> ConvienceLayout.Attribute<T> {
    var result = rhs
    result.multiplier *= lhs
    return result
}

public func /<T>(_ rhs: ConvienceLayout.Attribute<T>, _ lhs: CGFloat) -> ConvienceLayout.Attribute<T> {
    var result = rhs
    result.multiplier /= lhs
    return result
}

public func +<T>(_ lhs: CGFloat, _ rhs: ConvienceLayout.Attribute<T>) -> ConvienceLayout.Attribute<T> {
    var result = rhs
    result.constant += lhs
    return result
}

public func +<T>(_ rhs: ConvienceLayout.Attribute<T>, _ lhs: CGFloat) -> ConvienceLayout.Attribute<T> {
    var result = rhs
    result.constant += lhs
    return result
}

public func -<T>(_ lhs: CGFloat, _ rhs: ConvienceLayout.Attribute<T>) -> ConvienceLayout.Attribute<T> {
    return lhs + rhs * (-1)
}

public func -<T>(_ rhs: ConvienceLayout.Attribute<T>, _ lhs: CGFloat) -> ConvienceLayout.Attribute<T> {
    var result = rhs
    result.constant -= lhs
    return result
}

public func *<T>(_ lhs: CGFloat, _ rhs: ConvienceLayout.Attribute<T>?) -> ConvienceLayout.Attribute<T>? {
    var result = rhs
    result?.multiplier = lhs
    return result
}

public func *<T>(_ rhs: ConvienceLayout.Attribute<T>?, _ lhs: CGFloat) -> ConvienceLayout.Attribute<T>? {
    var result = rhs
    result?.multiplier *= lhs
    return result
}

public func /<T>(_ rhs: ConvienceLayout.Attribute<T>?, _ lhs: CGFloat) -> ConvienceLayout.Attribute<T>? {
    var result = rhs
    result?.multiplier /= lhs
    return result
}

public func +<T>(_ lhs: CGFloat, _ rhs: ConvienceLayout.Attribute<T>?) -> ConvienceLayout.Attribute<T>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func +<T>(_ rhs: ConvienceLayout.Attribute<T>?, _ lhs: CGFloat) -> ConvienceLayout.Attribute<T>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func -<T>(_ lhs: CGFloat, _ rhs: ConvienceLayout.Attribute<T>?) -> ConvienceLayout.Attribute<T>? {
    return lhs + rhs * (-1)
}

public func -<T>(_ rhs: ConvienceLayout.Attribute<T>?, _ lhs: CGFloat) -> ConvienceLayout.Attribute<T>? {
    var result = rhs
    result?.constant -= lhs
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


public protocol LayoutValueProtocol {
    var _asLayoutValue: LayoutValue { get }
}
public protocol HorizontalLayoutableAttribute {}
public protocol HorizontalLayoutable: LayoutValueProtocol {}
public protocol VerticalLayoutable: LayoutValueProtocol {}
public typealias AxisLayoutable = VerticalLayoutable & HorizontalLayoutable

public struct ViewAndSize: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .view([self]) }
    fileprivate let view: UILayoutable

    fileprivate let size: LayoutValue.Number?
    fileprivate init(_ view: UILayoutable, _ size: LayoutValue.Number?) {
        self.view = view
        self.size = size
    }
    fileprivate func get(_ axe: NSLayoutConstraint.Axis) -> [NSLayoutConstraint]? {
        if let s = size {
            return view.setConstraint(axe, number: s)
        }
        return nil
    }
}

public enum LayoutValue: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return self }
    
    case view([ViewAndSize]), number(Number), attribute([ConvienceLayout.Attribute<Void>])
    
    fileprivate var asNumber: Number? {
        if case .number(let n) = self { return n }
        return nil
    }
    
    fileprivate var asView: [ViewAndSize]? {
        if case .view(let n) = self { return n }
        return nil
    }
    
    public enum Number {
        case value(CGFloat), range(min: CGFloat?, max: CGFloat?)
        
        static func +(_ lhs: Number, _ rhs: Number) -> Number {
            switch (lhs, rhs) {
            case (.value(let l), .value(let r)):
                return .value(l + r)
            case (.value(let l), .range(let min, let max)):
                return .range(min: min == nil ? nil : min! + l, max: max == nil ? nil : max! + l)
            case (.range, .value):
                return rhs + lhs
            case (.range(let lmin, let lmax), .range(let rmin, let rmax)):
                var _min: CGFloat?
                if lmin != nil || rmin != nil {
                    _min = (lmin ?? 0) + (rmin ?? 0)
                }
                var _max: CGFloat?
                if lmax != nil || rmax != nil {
                    _max = (lmax ?? 0) + (rmax ?? 0)
                }
                return .range(min: _min, max: _max)
            }
        }
    }
}

extension CGFloat: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .number(.value(self)) }
}
extension Double: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .number(.value(CGFloat(self))) }
}
extension Int: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .number(.value(CGFloat(self))) }
}
extension UIView: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .view([ViewAndSize(self, nil)]) }
}
extension UILayoutGuide: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .view([ViewAndSize(self, nil)]) }
}
extension UILayoutable {
    public func fixed(_ size: CGFloat) -> LayoutValue {
        return .view([ViewAndSize(self, .value(size))])
    }
    public func fixed(_ size: ClosedRange<CGFloat>) -> LayoutValue {
        return .view([ViewAndSize(self, .range(min: size.lowerBound, max: size.upperBound))])
    }
    public func fixed(_ size: PartialRangeThrough<CGFloat>) -> LayoutValue {
        return .view([ViewAndSize(self, .range(min: nil, max: size.upperBound))])
    }
    public func fixed(_ size: PartialRangeFrom<CGFloat>) -> LayoutValue {
        return .view([ViewAndSize(self, .range(min: size.lowerBound, max: nil))])
    }
}

extension ClosedRange: LayoutValueProtocol, AxisLayoutable where Bound == CGFloat {
    public var _asLayoutValue: LayoutValue { return .number(.range(min: lowerBound, max: upperBound)) }
}

extension PartialRangeThrough: LayoutValueProtocol, AxisLayoutable where Bound == CGFloat {
    public var _asLayoutValue: LayoutValue { return .number(.range(min: nil, max: upperBound)) }
}

extension PartialRangeFrom: LayoutValueProtocol, AxisLayoutable where Bound == CGFloat {
    public var _asLayoutValue: LayoutValue { return .number(.range(min: lowerBound, max: nil)) }
}

extension Array: LayoutValueProtocol, AxisLayoutable where Element == UILayoutable {
    public var _asLayoutValue: LayoutValue { return .view(map { ViewAndSize($0, nil) }) }
    
    public func fixed(_ size: CGFloat) -> LayoutValue {
        return .view(map { ViewAndSize($0, .value(size)) })
    }
//    public func fixed(_ size: ConvienceLayout.Attribute<ConvienceLayout.Size>) -> LayoutValue {
//        return .view(map { ViewAndSize($0, .value(size)) })
//    }
    public func fixed(_ size: ClosedRange<CGFloat>) -> LayoutValue {
        return .view(map { ViewAndSize($0, .range(min: size.lowerBound, max: size.upperBound)) })
    }
    public func fixed(_ size: PartialRangeThrough<CGFloat>) -> LayoutValue {
        return .view(map { ViewAndSize($0, .range(min: nil, max: size.upperBound)) })
    }
    public func fixed(_ size: PartialRangeFrom<CGFloat>) -> LayoutValue {
        return .view(map { ViewAndSize($0, .range(min: size.lowerBound, max: nil)) })
    }
    
}

public enum Axis {
    public static let vertical = VerticalAxe()
    public static let horizontal = HorizontalAxe()
    
    public struct VerticalAxe { fileprivate init() {} }
    public struct HorizontalAxe { fileprivate init() {} }
}

@discardableResult
public func =|(_ lhs: Axis.HorizontalAxe, _ rhs: [HorizontalLayoutable]) -> [NSLayoutConstraint] {
    return setByAxe(.horizontal, rhs)
}

@discardableResult
public func =|(_ lhs: Axis.VerticalAxe, _ rhs: [VerticalLayoutable]) -> [NSLayoutConstraint] {
    return setByAxe(.vertical, rhs)
}

fileprivate func setByAxe(_ lhs: NSLayoutConstraint.Axis, _ rhs: [LayoutValueProtocol]) -> [NSLayoutConstraint] {
    guard let first = rhs.first?._asLayoutValue else { return [] }
    guard rhs.count > 1 else {
        if case .view(let views) = first {
            return Array(views.compactMap({ $0.get(lhs) }).joined())
        }
        return []
    }
    var result: [NSLayoutConstraint] = []
    var last: [ConvienceLayout.Attribute<Void>]?
    var offset: LayoutValue.Number?
    let prevAtt: NSLayoutConstraint.Attribute = lhs == .vertical ? .top : .leading
    let nextAtt: NSLayoutConstraint.Attribute = lhs == .vertical ? .bottom : .trailing
    for i in 0..<rhs.count {
        switch rhs[i]._asLayoutValue {
        case .view(let array):
            let next = array.map { ConvienceLayout.Attribute<Void>(type: prevAtt, item: $0.view) }
            if let _last = last {
                result += set(next, _last, offset: offset ?? .value(0))
            } else if let value = offset {
                let views = array.map({ $0.view }).parents
                result += set(next, views.map { ConvienceLayout.Attribute<Void>(type: prevAtt, item: $0) }, offset: value)
            }
            let sizes = Array(array.compactMap({ $0.get(lhs) }).joined())
            result += sizes
            offset = nil
            last = array.map { ConvienceLayout.Attribute(type: nextAtt, item: $0.view) }
        case .number(let number):
            offset = (offset ?? .value(0)) + number
        case .attribute(let array):
            result += set(array, last ?? [], offset: offset ?? .value(0))
            last = array
            offset = nil
        }
    }
    if let value = offset, let views = last?.map({ $0.item }).parents {
        result += set(views.map { ConvienceLayout.Attribute<Void>(type: nextAtt, item: $0) }, last ?? [], offset: value)
    }
    return result
}

fileprivate func set(_ lhs: [ConvienceLayout.Attribute<Void>], _ rhs: [ConvienceLayout.Attribute<Void>], offset: LayoutValue.Number) -> [NSLayoutConstraint] {
    guard !lhs.isEmpty && !rhs.isEmpty else { return [] }
    var result: [NSLayoutConstraint] = []
    lhs.forEach { l in
        rhs.forEach { _r in
            var r = _r
            switch offset {
            case .value(let value):
                r.constant += value
                result.append(setup(l, r, relation: .equal))
            case .range(let min, let max):
                var result: [NSLayoutConstraint] = []
                if let value = min {
                    r.constant += value
                    result.append(setup(l, r, relation: .greaterThanOrEqual))
                }
                if let value = max {
                    r.constant += value
                    result.append(setup(l, r, relation: .lessThanOrEqual))
                }
            }
        }
    }
    return result
}

extension UILayoutable {
    
    fileprivate func setConstraint(_ axis: NSLayoutConstraint.Axis, number: LayoutValue.Number) -> [NSLayoutConstraint] {
        let att = axis == .vertical ? layout.height : layout.width
        return setConstraint(att, number: number)
    }
    
    fileprivate func setConstraint<S>(_ att: ConvienceLayout.Attribute<S>, number: LayoutValue.Number) -> [NSLayoutConstraint] {
        switch number {
        case .value(let value):
            return [setup(att, value, relation: .equal)]
        case .range(let min, let max):
            var result: [NSLayoutConstraint] = []
            if let value = min {
                result.append(setup(att, value, relation: .greaterThanOrEqual))
            }
            if let value = max {
                result.append(setup(att, value, relation: .lessThanOrEqual))
            }
            return result
        }
    }
    
}

extension ConvienceLayout.Attribute: LayoutValueProtocol {
    public var _asLayoutValue: LayoutValue {
        return .attribute([asAny()])
    }
}

extension UILayoutable {
    fileprivate var parent: UILayoutable? {
        if #available(iOS 11.0, *) {
            return (self as? UIView)?.superview?.safeAreaLayoutGuide
        } else {
            return (self as? UIView)?.superview
        }
    }
}

extension Array where Element == UILayoutable {
    
    fileprivate var parents: [UILayoutable] {
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

extension ConvienceLayout.Attribute: VerticalLayoutable where A == ConvienceLayout.Vertical {}
extension ConvienceLayout.Attribute: HorizontalLayoutable where A: HorizontalLayoutableAttribute {}
