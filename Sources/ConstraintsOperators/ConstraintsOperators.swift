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

extension UIView: UILayoutable, AttributesConvertable {
    @available(iOS 11.0, *)
    public var safeAreaLayout: ConvienceLayout<ConstraintBuilder> { return safeAreaLayoutGuide.layout }
}

extension UILayoutGuide: UILayoutable, AttributesConvertable {}

extension UILayoutable {
    public var _attributes: [NSLayoutConstraint.Attribute] { return [] }
    public var layout: ConvienceLayout<ConstraintBuilder> { return ConvienceLayout(self) }
}

extension Array where Element == UILayoutable {
    public var layout: ConvienceLayout<ConstraintsBuilder> { return ConvienceLayout(self) }
}

public struct ConvienceLayout<B: ConstraintsCreator>: Attributable {
    public let target: B.First
    
//    public func edges(_ edges: Edge.Set = .all) -> EdgeAttribute<C> {
//        return EdgeAttribute<C>(type: edges.attributes, item: target)
//    }
//
    public init(_ item: B.First) {
        target = item
    }

}

public protocol CenterXAttributeCompatible {}

func _setup<A, D, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<A, C>?, _ rhs: Attribute<D, K>?, relation: NSLayoutConstraint.Relation) -> C.Constraint? where C.Second == K.First {
    guard let l = lhs, let r = rhs else {
        return nil
    }
    return setup(l, r, relation: relation)
}

func setup<A, D, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<A, C>, _ rhs: Attribute<D, K>, relation: NSLayoutConstraint.Relation) -> C.Constraint where C.Second == K.First {
    let result = C.make(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: rhs.item, attribute: rhs.type, multiplier: rhs.multiplier / lhs.multiplier, constant: rhs.constant - lhs.constant)
    result.priority = min(lhs.priority, rhs.priority)
    let active = lhs.isActive && rhs.isActive
    if active {
        removeConflicts(C.self, with: result)
    }
    result.isActive = active
    return result
}

func _setup<A, C: ConstraintsCreator>(_ lhs: Attribute<A, C>?, _ rhs: C.Second?, relation: NSLayoutConstraint.Relation) -> C.Constraint? where C.Second == UILayoutable {
    guard let l = lhs, let r = rhs else { return nil }
    return setup(l, r, relation: relation)
}

func setup<A, C: ConstraintsCreator>(_ lhs: Attribute<A, C>, _ rhs: C.Second, relation: NSLayoutConstraint.Relation) -> C.Constraint where C.Second == UILayoutable {
    let result = C.make(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: rhs, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: -lhs.constant)
    result.priority = lhs.priority
    let active = lhs.isActive
    if active {
        removeConflicts(C.self, with: result)
    }
    result.isActive = active
    return result
}

fileprivate func removeConflicts<C: ConstraintsCreator>(_ lhs: C.Type, with constraint: C.Constraint) {
    let constraints = C.constraints(for: constraint)
    constraints.filter({ C.willConflict(constraint, with: $0) }).forEach {
        $0.isActive = false
    }
}

fileprivate func _setup<N, C: ConstraintsCreator>(_ lhs: Attribute<N, C>?, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> C.Constraint? {
    guard let l = lhs else { return nil }
    return setup(l, rhs, relation: relation)
}

func setup<N, C: ConstraintsCreator>(_ lhs: Attribute<N, C>, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> C.Constraint {
    var result: C.Constraint
    let active = lhs.isActive
    defer {
        result.priority = lhs.priority
        if active {
            removeConflicts(C.self, with: result)
        }
        result.isActive = active
    }
    switch lhs.type {
    case .width, .height:
        result = C.make(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1 / lhs.multiplier, constant: max(0, rhs - lhs.constant))
    case .notAnAttribute:
        result = C.make(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: nil, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
    case .bottom, .trailing, .bottomMargin, .trailingMargin, .lastBaseline, .right, .rightMargin:
        result = C.makeToParent(item: lhs.item, attribute: lhs.type, relatedBy: relation, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: lhs.constant - rhs)
    default:
        result = C.makeToParent(item: lhs.item, attribute: lhs.type, relatedBy: relation, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: rhs - lhs.constant)
    }
    return result
}

@discardableResult
public func =|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<AttributeType.CenterX, K>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: ClosedRange<CGFloat>) -> [C.Constraint] {
    return [setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual), setup(lhs, rhs.upperBound, relation: .lessThanOrEqual)]
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: ClosedRange<CGFloat>) -> [C.Constraint]? {
    guard let lhs = lhs else { return nil }
    return [setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual), setup(lhs, rhs.upperBound, relation: .lessThanOrEqual)]
}

@discardableResult
public func =|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<AttributeType.CenterX, K>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First, C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<AttributeType.CenterX, K>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<AttributeType.CenterX, K>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<AttributeType.CenterX, K>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<AttributeType.CenterX, K>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

public func *<A, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, L, C>) -> LayoutAttribute<A, L, C> {
    var result = rhs
    result.multiplier = lhs
    return result
}

public func *<A, C: ConstraintsCreator, L>(_ rhs: LayoutAttribute<A, L, C>, _ lhs: CGFloat) -> LayoutAttribute<A, L, C> {
    var result = rhs
    result.multiplier *= lhs
    return result
}

public func /<A, C: ConstraintsCreator, L>(_ rhs: LayoutAttribute<A, L, C>, _ lhs: CGFloat) -> LayoutAttribute<A, L, C> {
    var result = rhs
    result.multiplier /= lhs
    return result
}

public func +<A, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, L, C>) -> LayoutAttribute<A, L, C> {
    var result = rhs
    result.constant += lhs
    return result
}

public func +<A, C: ConstraintsCreator, L>(_ rhs: LayoutAttribute<A, L, C>, _ lhs: CGFloat) -> LayoutAttribute<A, L, C> {
    var result = rhs
    result.constant += lhs
    return result
}

public func -<A, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, L, C>) -> LayoutAttribute<A, L, C> {
    return lhs + rhs * (-1)
}

public func -<A, C: ConstraintsCreator, L>(_ rhs: LayoutAttribute<A, L, C>, _ lhs: CGFloat) -> LayoutAttribute<A, L, C> {
    var result = rhs
    result.constant -= lhs
    return result
}

public func *<A, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, L, C>?) -> LayoutAttribute<A, L, C>? {
    var result = rhs
    result?.multiplier = lhs
    return result
}

public func *<A, C: ConstraintsCreator, L>(_ rhs: LayoutAttribute<A, L, C>?, _ lhs: CGFloat) -> LayoutAttribute<A, L, C>? {
    var result = rhs
    result?.multiplier *= lhs
    return result
}

public func /<A, C: ConstraintsCreator, L>(_ rhs: LayoutAttribute<A, L, C>?, _ lhs: CGFloat) -> LayoutAttribute<A, L, C>? {
    var result = rhs
    result?.multiplier /= lhs
    return result
}

public func +<A, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, L, C>?) -> LayoutAttribute<A, L, C>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func +<A, C: ConstraintsCreator, L>(_ rhs: LayoutAttribute<A, L, C>?, _ lhs: CGFloat) -> LayoutAttribute<A, L, C>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func -<A, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, L, C>?) -> LayoutAttribute<A, L, C>? {
    return lhs + rhs * (-1)
}

public func -<A, C: ConstraintsCreator, L>(_ rhs: LayoutAttribute<A, L, C>?, _ lhs: CGFloat) -> LayoutAttribute<A, L, C>? {
    var result = rhs
    result?.constant -= lhs
    return result
}

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
    
    case view([ViewAndSize]), number(Number), attribute([Attribute<Void, ConstraintBuilder>])
    
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
//    public func fixed(_ size: Attribute<Size>) -> LayoutValue {
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
    var last: [Attribute<Void, ConstraintBuilder>]?
    var offset: LayoutValue.Number?
    let prevAtt: NSLayoutConstraint.Attribute = lhs == .vertical ? .top : .leading
    let nextAtt: NSLayoutConstraint.Attribute = lhs == .vertical ? .bottom : .trailing
    for i in 0..<rhs.count {
        switch rhs[i]._asLayoutValue {
        case .view(let array):
            let next = array.map { Attribute<Void, ConstraintBuilder>(type: prevAtt, item: $0.view) }
            if let _last = last {
                result += set(next, _last, offset: offset ?? .value(0))
            } else if let value = offset {
                result += set(array.compactMap({ $0.view.layout.attribute(type: prevAtt) }), value: value, type: prevAtt)
            }
            let sizes = Array(array.compactMap({ $0.get(lhs) }).joined())
            result += sizes
            offset = nil
            last = array.map { .init(type: nextAtt, item: $0.view) }
        case .number(let number):
            offset = (offset ?? .value(0)) + number
        case .attribute(let array):
            if let _last = last {
                result += set(array, _last, offset: offset ?? .value(0))
            } else if let value = offset {
                result += set(array, value: value, type: prevAtt)
            }
            last = array
            offset = nil
        }
    }
    if let value = offset, let array = last {
        result += set(array, value: value, type: nextAtt)
    }
    return result
}


fileprivate func set(_ array: [Attribute<Void, ConstraintBuilder>], value: LayoutValue.Number, type: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
    var result: [NSLayoutConstraint] = []
    array.forEach {
        guard let parent = $0.item.parent else { return }
        let att: Attribute<Void, ConstraintBuilder> = parent.layout.attribute(type: type)
        if type == .leading || type == .top {
            result += set([$0.item.layout.attribute(type: type)], [att], offset: value)
        } else {
            result += set([att], [$0.item.layout.attribute(type: type)], offset: value)
        }
    }
    return result
}

fileprivate func set(_ lhs: [Attribute<Void, ConstraintBuilder>], _ rhs: [Attribute<Void, ConstraintBuilder>], offset: LayoutValue.Number) -> [NSLayoutConstraint] {
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
    
    fileprivate func setConstraint<S>(_ att: Attribute<S, ConstraintBuilder>, number: LayoutValue.Number) -> [NSLayoutConstraint] {
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

extension LayoutAttribute: LayoutValueProtocol where C == ConstraintBuilder, I == UILayoutable {
    public var _asLayoutValue: LayoutValue {
        return .attribute([asAny()])
    }
}

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

extension LayoutAttribute: VerticalLayoutable where A == AttributeType.Vertical, C == ConstraintBuilder, I == UILayoutable {}
extension LayoutAttribute: HorizontalLayoutable where A: HorizontalLayoutableAttribute, C == ConstraintBuilder, I == UILayoutable {}
