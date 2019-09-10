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
    public var safeAreaLayout: ConvienceLayout<ConstraintBuilder> { return safeAreaLayoutGuide.layout }
}

extension UILayoutGuide: UILayoutable {}

extension UILayoutable {
    public var layout: ConvienceLayout<ConstraintBuilder> { return ConvienceLayout(self) }
}

extension Array where Element == UILayoutable {
    public var layout: ConvienceLayout<ConstraintsBuilder> { return ConvienceLayout(self) }
}

public protocol ConstraintProtocol {
    var isActive: Bool { get set }
    var priority: UILayoutPriority { get set }
}

extension NSLayoutConstraint: ConstraintProtocol {}

public protocol ConstraintsCreator {
    associatedtype First
    associatedtype Second
    associatedtype Constraint: ConstraintProtocol
    static func make(item: First, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, toItem: Second?, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> Constraint
    static func constraints(for constraint: Constraint) -> [NSLayoutConstraint]
    static func willConflict(_ constraint: Constraint, with other: NSLayoutConstraint) -> Bool
    static func makeToParent(item: First, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> Constraint
}

public struct ConstraintsBuilder: ConstraintsCreator {
    
    public static func make(item: [UILayoutable], attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, toItem: UILayoutable?, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        for first in item {
            result.append(NSLayoutConstraint(item: first, attribute: attribute1, relatedBy: relatedBy, toItem: toItem, attribute: attribute2, multiplier: multiplier, constant: constant))
        }
        return result
    }
    
    public static func makeToParent(item: [UILayoutable], attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        item.forEach {
            result += make(item: [$0], attribute: attribute1, relatedBy: relatedBy, toItem: $0.parent, attribute: attribute2, multiplier: multiplier, constant: constant)
        }
        return result
    }
    
    public static func constraints(for constraint: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        return Array(constraint.map(ConstraintBuilder.constraints).joined())
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

public struct ConstraintBuilder: ConstraintsCreator {
    public static func make(item: UILayoutable, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, toItem: UILayoutable?, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute1, relatedBy: relatedBy, toItem: toItem, attribute: attribute2, multiplier: multiplier, constant: constant)
    }
    
    public static func makeToParent(item: UILayoutable, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return make(item: item, attribute: attribute1, relatedBy: relatedBy, toItem: item.parent, attribute: attribute2, multiplier: multiplier, constant: constant)
    }
    
    public static func constraints(for constraint: NSLayoutConstraint) -> [NSLayoutConstraint] {
        return ((constraint.firstItem as? UILayoutable)?.constraints ?? []) +
        ((constraint.secondItem as? UILayoutable)?.constraints ?? [])
    }
    
    public static func willConflict(_ constraint: NSLayoutConstraint, with other: NSLayoutConstraint) -> Bool {
        return constraint.willConflict(with: other)
    }
    
}

extension Array: ConstraintProtocol where Element == NSLayoutConstraint {
    
    public var isActive: Bool {
        get { return reduce(false, { $0 || $1.isActive }) }
        set { forEach { $0.isActive = newValue } }
    }
    
    public var priority: UILayoutPriority {
        get { return UILayoutPriority(rawValue: self.reduce(0.0, { Swift.max($0, $1.priority.rawValue) })) }
        set { forEach { $0.priority = newValue } }
    }
    
}

public struct ConvienceLayout<C: ConstraintsCreator> {
    public typealias L = C.First
    private let item: L
    
    public var width:                Attribute<AttributeType.Size> { return Attribute(type: .width, item: item) }
    public var height:               Attribute<AttributeType.Size> { return Attribute(type: .height, item: item) }
    
    public var top:                  Attribute<AttributeType.Vertical> { return Attribute(type: .top, item: item) }
    public var bottom:               Attribute<AttributeType.Vertical> { return Attribute(type: .bottom, item: item) }
    public var lastBaseline:         Attribute<AttributeType.Vertical> { return Attribute(type: .lastBaseline, item: item) }
    public var firstBaseline:        Attribute<AttributeType.Vertical> { return Attribute(type: .firstBaseline, item: item) }
    public var topMargin:            Attribute<AttributeType.Vertical> { return Attribute(type: .topMargin, item: item) }
    public var bottomMargin:         Attribute<AttributeType.Vertical> { return Attribute(type: .bottomMargin, item: item) }
    
    public var leading:              Attribute<AttributeType.LeadTrail> { return Attribute(type: .leading, item: item) }
    public var trailing:             Attribute<AttributeType.LeadTrail> { return Attribute(type: .trailing, item: item) }
    public var leadingMargin:        Attribute<AttributeType.LeadTrail> { return Attribute(type: .leadingMargin, item: item) }
    public var trailingMargin:       Attribute<AttributeType.LeadTrail> { return Attribute(type: .trailingMargin, item: item) }
    
    public var left:                 Attribute<AttributeType.LeftRight> { return Attribute(type: .left, item: item) }
    public var right:                Attribute<AttributeType.LeftRight> { return Attribute(type: .right, item: item) }
    public var leftMargin:           Attribute<AttributeType.LeftRight> { return Attribute(type: .leftMargin, item: item) }
    public var rightMargin:          Attribute<AttributeType.LeftRight> { return Attribute(type: .rightMargin, item: item) }
    
    public var centerX:              Attribute<AttributeType.CenterX>  { return Attribute(type: .centerX, item: item) }
    public var centerY:              Attribute<AttributeType.Vertical> { return Attribute(type: .centerY, item: item) }
    public var centerXWithinMargins: Attribute<AttributeType.CenterX>  { return Attribute(type: .centerXWithinMargins, item: item) }
    public var centerYWithinMargins: Attribute<AttributeType.Vertical> { return Attribute(type: .centerYWithinMargins, item: item) }
    
    public func edges(_ edges: Edge.Set = .all) -> EdgeAttribute {
        return EdgeAttribute(type: edges.attributes, item: item)
    }
    
    fileprivate func attribute<T>(as other: ConvienceLayout<C>.Attribute<T>) -> Attribute<T> {
        return Attribute(type: other.type, item: item)
    }
    
    fileprivate func attribute<T>(type: NSLayoutConstraint.Attribute) -> Attribute<T> {
        return Attribute(type: type, item: item)
    }
    
    public init(_ item: L) {
        self.item = item
    }
    
    public struct Attributes<A, T, I> {
        fileprivate var type: T
        fileprivate var item: I
        fileprivate var constant: CGFloat
        fileprivate var multiplier: CGFloat
        fileprivate var priority: UILayoutPriority
        fileprivate var isActive = true
        
        fileprivate init(type: T, item: I, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required, isActive: Bool = true) {
            self.type = type
            self.item = item
            self.constant = constant
            self.multiplier = multiplier
            self.priority = priority
        }
        
        fileprivate func asAny() -> Attributes<Void, T, I> {
            return Attributes<Void, T, I>(type: type, item: item, constant: constant, multiplier: multiplier, priority: priority, isActive: isActive)
        }
        
        public func priority(_ _priority: UILayoutPriority) -> Attributes {
            return map(\.priority, _priority)
        }
        
        public func priority(_ _priority: Float) -> Attributes {
            return priority(UILayoutPriority(_priority))
        }
        
        public var deactivated: Attributes {
            return map(\.isActive, false)
        }
        
        fileprivate func type(_ _type: T) -> Attributes {
            return map(\.type, _type)
        }
        
        private func map<R>(_ keyPath: WritableKeyPath<Attributes, R>, _ value: R) -> Attributes {
            var result = self
            result[keyPath: keyPath] = value
            return result
        }
        
    }
    
    public typealias Attribute<A> = Attributes<A, NSLayoutConstraint.Attribute, L>
    fileprivate typealias Attribute2<A> = Attributes<A, NSLayoutConstraint.Attribute, C.Second>
    public typealias EdgeAttribute = Attributes<AttributeType.Edges, [NSLayoutConstraint.Attribute], L>
    
    fileprivate struct Properties {
        var constant: CGFloat
        var multiplier: CGFloat
        var priority: UILayoutPriority
        var isActive = true
    }
}

public enum AttributeType {
    public enum LeadTrail: CenterXAttributeCompatible, HorizontalLayoutableAttribute {}
    public enum LeftRight: CenterXAttributeCompatible {}
    public enum CenterX: HorizontalLayoutableAttribute {}
    public enum Vertical {}
    public enum Size {}
    public enum Edges {}
}

public protocol CenterXAttributeCompatible {}

fileprivate func _setup<A, D, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<A>?, _ rhs: ConvienceLayout<K>.Attribute<D>?, relation: NSLayoutConstraint.Relation) -> C.Constraint? where C.Second == K.First {
    guard let l = lhs, let r = rhs else {
        return nil
    }
    return setup(l, r, relation: relation)
}

fileprivate func setup<A, D, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<A>, _ rhs: ConvienceLayout<K>.Attribute<D>, relation: NSLayoutConstraint.Relation) -> C.Constraint where C.Second == K.First {
    var result = C.make(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: rhs.item, attribute: rhs.type, multiplier: rhs.multiplier / lhs.multiplier, constant: rhs.constant - lhs.constant)
    result.priority = min(lhs.priority, rhs.priority)
    let active = lhs.isActive && rhs.isActive
    if active {
        removeConflicts(C.self, with: result)
    }
    result.isActive = active
    return result
}

fileprivate func _setup<A, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<A>?, _ rhs: C.Second?, relation: NSLayoutConstraint.Relation) -> C.Constraint? where C.Second == UILayoutable {
    guard let l = lhs, let r = rhs else { return nil }
    return setup(l, r, relation: relation)
}

fileprivate func setup<A, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<A>, _ rhs: C.Second, relation: NSLayoutConstraint.Relation) -> C.Constraint where C.Second == UILayoutable {
    var result = C.make(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: rhs, attribute: lhs.type, multiplier: 1 / lhs.multiplier, constant: -lhs.constant)
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

fileprivate func _setup<N, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<N>?, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> C.Constraint? {
    guard let l = lhs else { return nil }
    return setup(l, rhs, relation: relation)
}

fileprivate func _setup<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute?, _ rhs: C.Second?, relation: NSLayoutConstraint.Relation) -> [C.Constraint]? where C.Second == UILayoutable {
    guard let l = lhs, let r = rhs else { return nil }
    return setup(l, r, relation: relation)
}

fileprivate func setup<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute, _ rhs: C.Second, relation: NSLayoutConstraint.Relation) -> [C.Constraint] where C.Second == UILayoutable {
    var result: [C.Constraint] = []
    let l = ConvienceLayout<C>.Attribute<AttributeType.Edges>(type: .notAnAttribute, item: lhs.item, constant: lhs.constant, multiplier: lhs.multiplier, priority: lhs.priority, isActive: lhs.isActive)
    lhs.type.forEach {
        result.append(setup(l.type($0), rhs, relation: relation))
    }
    return result
}

fileprivate func _setup<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute?, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> [C.Constraint]? where C.Second == UILayoutable {
    guard let l = lhs else { return nil }
    return setup(l, rhs, relation: relation)
}

fileprivate func setup<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> [C.Constraint] where C.Second == UILayoutable {
    var result: [C.Constraint] = []
    let l = ConvienceLayout<C>.Attribute<AttributeType.Edges>(type: .notAnAttribute, item: lhs.item, constant: lhs.constant, multiplier: lhs.multiplier, priority: lhs.priority, isActive: lhs.isActive)
    lhs.type.forEach {
        result.append(setup(l.type($0), rhs, relation: relation))
    }
    return result
}

fileprivate func setup<N, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<N>, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> C.Constraint {
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
public func =|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: ConvienceLayout<K>.Attribute<T>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<AttributeType.CenterX>, _ rhs: ConvienceLayout<K>.Attribute<T>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: ConvienceLayout<K>.Attribute<AttributeType.CenterX>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: ClosedRange<CGFloat>) -> [C.Constraint] {
    return [setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual), setup(lhs, rhs.upperBound, relation: .lessThanOrEqual)]
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: ClosedRange<CGFloat>) -> [C.Constraint]? {
    guard let lhs = lhs else { return nil }
    return [setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual), setup(lhs, rhs.upperBound, relation: .lessThanOrEqual)]
}

@discardableResult
public func =|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: ConvienceLayout<K>.Attribute<T>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<AttributeType.CenterX>?, _ rhs: ConvienceLayout<K>.Attribute<T>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: ConvienceLayout<K>.Attribute<AttributeType.CenterX>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute, _ rhs: C.Second) -> [C.Constraint] where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute, _ rhs: CGFloat) -> [C.Constraint] where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute?, _ rhs: C.Second?) -> [C.Constraint]? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute?, _ rhs: CGFloat) -> [C.Constraint]? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: ConvienceLayout<K>.Attribute<T>) -> C.Constraint where C.Second == K.First, C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: ConvienceLayout<K>.Attribute<AttributeType.CenterX>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<AttributeType.CenterX>, _ rhs: ConvienceLayout<K>.Attribute<T>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: ConvienceLayout<K>.Attribute<T>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: ConvienceLayout<K>.Attribute<AttributeType.CenterX>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<AttributeType.CenterX>?, _ rhs: ConvienceLayout<K>.Attribute<T>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute, _ rhs: C.Second) -> [C.Constraint] where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute, _ rhs: CGFloat) -> [C.Constraint] where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute?, _ rhs: C.Second?) -> [C.Constraint]? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute?, _ rhs: CGFloat) -> [C.Constraint]? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: ConvienceLayout<K>.Attribute<T>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<AttributeType.CenterX>, _ rhs: ConvienceLayout<K>.Attribute<T>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: ConvienceLayout<K>.Attribute<AttributeType.CenterX>) -> C.Constraint where C.Second == K.First {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: ConvienceLayout<K>.Attribute<T>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<AttributeType.CenterX>?, _ rhs: ConvienceLayout<K>.Attribute<T>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: ConvienceLayout<K>.Attribute<AttributeType.CenterX>?) -> C.Constraint? where C.Second == K.First {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.Attribute<T>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute, _ rhs: C.Second) -> [C.Constraint] where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute, _ rhs: CGFloat) -> [C.Constraint] where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute?, _ rhs: C.Second?) -> [C.Constraint]? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<C: ConstraintsCreator>(_ lhs: ConvienceLayout<C>.EdgeAttribute?, _ rhs: CGFloat) -> [C.Constraint]? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

public func *<A, T, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: ConvienceLayout<C>.Attributes<A, T, L>) -> ConvienceLayout<C>.Attributes<A, T, L> {
    var result = rhs
    result.multiplier = lhs
    return result
}

public func *<A, T, C: ConstraintsCreator, L>(_ rhs: ConvienceLayout<C>.Attributes<A, T, L>, _ lhs: CGFloat) -> ConvienceLayout<C>.Attributes<A, T, L> {
    var result = rhs
    result.multiplier *= lhs
    return result
}

public func /<A, T, C: ConstraintsCreator, L>(_ rhs: ConvienceLayout<C>.Attributes<A, T, L>, _ lhs: CGFloat) -> ConvienceLayout<C>.Attributes<A, T, L> {
    var result = rhs
    result.multiplier /= lhs
    return result
}

public func +<A, T, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: ConvienceLayout<C>.Attributes<A, T, L>) -> ConvienceLayout<C>.Attributes<A, T, L> {
    var result = rhs
    result.constant += lhs
    return result
}

public func +<A, T, C: ConstraintsCreator, L>(_ rhs: ConvienceLayout<C>.Attributes<A, T, L>, _ lhs: CGFloat) -> ConvienceLayout<C>.Attributes<A, T, L> {
    var result = rhs
    result.constant += lhs
    return result
}

public func -<A, T, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: ConvienceLayout<C>.Attributes<A, T, L>) -> ConvienceLayout<C>.Attributes<A, T, L> {
    return lhs + rhs * (-1)
}

public func -<A, T, C: ConstraintsCreator, L>(_ rhs: ConvienceLayout<C>.Attributes<A, T, L>, _ lhs: CGFloat) -> ConvienceLayout<C>.Attributes<A, T, L> {
    var result = rhs
    result.constant -= lhs
    return result
}

public func *<A, T, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: ConvienceLayout<C>.Attributes<A, T, L>?) -> ConvienceLayout<C>.Attributes<A, T, L>? {
    var result = rhs
    result?.multiplier = lhs
    return result
}

public func *<A, T, C: ConstraintsCreator, L>(_ rhs: ConvienceLayout<C>.Attributes<A, T, L>?, _ lhs: CGFloat) -> ConvienceLayout<C>.Attributes<A, T, L>? {
    var result = rhs
    result?.multiplier *= lhs
    return result
}

public func /<A, T, C: ConstraintsCreator, L>(_ rhs: ConvienceLayout<C>.Attributes<A, T, L>?, _ lhs: CGFloat) -> ConvienceLayout<C>.Attributes<A, T, L>? {
    var result = rhs
    result?.multiplier /= lhs
    return result
}

public func +<A, T, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: ConvienceLayout<C>.Attributes<A, T, L>?) -> ConvienceLayout<C>.Attributes<A, T, L>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func +<A, T, C: ConstraintsCreator, L>(_ rhs: ConvienceLayout<C>.Attributes<A, T, L>?, _ lhs: CGFloat) -> ConvienceLayout<C>.Attributes<A, T, L>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func -<A, T, C: ConstraintsCreator, L>(_ lhs: CGFloat, _ rhs: ConvienceLayout<C>.Attributes<A, T, L>?) -> ConvienceLayout<C>.Attributes<A, T, L>? {
    return lhs + rhs * (-1)
}

public func -<A, T, C: ConstraintsCreator, L>(_ rhs: ConvienceLayout<C>.Attributes<A, T, L>?, _ lhs: CGFloat) -> ConvienceLayout<C>.Attributes<A, T, L>? {
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
    
    case view([ViewAndSize]), number(Number), attribute([ConvienceLayout<ConstraintBuilder>.Attribute<Void>])
    
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
//    public func fixed(_ size: ConvienceLayout<C>.Attribute<ConvienceLayout<C>.Size>) -> LayoutValue {
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
    var last: [ConvienceLayout<ConstraintBuilder>.Attribute<Void>]?
    var offset: LayoutValue.Number?
    let prevAtt: NSLayoutConstraint.Attribute = lhs == .vertical ? .top : .leading
    let nextAtt: NSLayoutConstraint.Attribute = lhs == .vertical ? .bottom : .trailing
    for i in 0..<rhs.count {
        switch rhs[i]._asLayoutValue {
        case .view(let array):
            let next = array.map { ConvienceLayout<ConstraintBuilder>.Attribute<Void>(type: prevAtt, item: $0.view) }
            if let _last = last {
                result += set(next, _last, offset: offset ?? .value(0))
            } else if let value = offset {
                result += set(array.compactMap({ $0.view.layout.attribute(type: prevAtt) }), value: value, type: prevAtt)
            }
            let sizes = Array(array.compactMap({ $0.get(lhs) }).joined())
            result += sizes
            offset = nil
            last = array.map { ConvienceLayout<ConstraintBuilder>.Attribute(type: nextAtt, item: $0.view) }
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


fileprivate func set(_ array: [ConvienceLayout<ConstraintBuilder>.Attribute<Void>], value: LayoutValue.Number, type: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
    var result: [NSLayoutConstraint] = []
    array.forEach {
        guard let parent = $0.item.parent else { return }
        let att: ConvienceLayout<ConstraintBuilder>.Attribute<Void> = parent.layout.attribute(type: type)
        result += set([att], [$0.item.layout.attribute(type: type)], offset: value)
    }
    return result
}

fileprivate func set(_ lhs: [ConvienceLayout<ConstraintBuilder>.Attribute<Void>], _ rhs: [ConvienceLayout<ConstraintBuilder>.Attribute<Void>], offset: LayoutValue.Number) -> [NSLayoutConstraint] {
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
    
    fileprivate func setConstraint<S>(_ att: ConvienceLayout<ConstraintBuilder>.Attribute<S>, number: LayoutValue.Number) -> [NSLayoutConstraint] {
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

extension ConvienceLayout.Attributes: LayoutValueProtocol where T == NSLayoutConstraint.Attribute, C == ConstraintBuilder, I == UILayoutable {
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
    fileprivate var constraints: [NSLayoutConstraint] {
        return (self as? UIView)?.constraints ?? (self as? UILayoutGuide)?.owningView?.constraints ?? []
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

extension ConvienceLayout.Attributes: VerticalLayoutable where A == AttributeType.Vertical, T == NSLayoutConstraint.Attribute, C == ConstraintBuilder, I == UILayoutable {}
extension ConvienceLayout.Attributes: HorizontalLayoutable where A: HorizontalLayoutableAttribute, T == NSLayoutConstraint.Attribute, C == ConstraintBuilder, I == UILayoutable {}
