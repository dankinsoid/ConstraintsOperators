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

extension ConvienceLayout where B.First == UILayoutable {
    
    public subscript(_ attributes: NSLayoutConstraint.Attribute...) -> EdgeAttribute {
        return self[attributes]
    }
    
    public subscript(_ attributes: [NSLayoutConstraint.Attribute]) -> EdgeAttribute {
        return EdgeAttribute(type: attributes, item: [target])
    }
    
}

extension ConvienceLayout where B.First == [UILayoutable] {
    
    public subscript(_ attributes: NSLayoutConstraint.Attribute...) -> EdgeAttribute {
        return self[attributes]
    }
    
    public subscript(_ attributes: [NSLayoutConstraint.Attribute]) -> EdgeAttribute {
        return EdgeAttribute(type: attributes, item: target)
    }
}

public protocol CenterXAttributeCompatible {}

func _setup<A, D, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<A, C>?, _ rhs: Attribute<D, K>?, relation: NSLayoutConstraint.Relation) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    guard let l = lhs, let r = rhs else {
        return nil
    }
    return setup(l, r, relation: relation)
}

func setup<A, D, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<A, C>, _ rhs: Attribute<D, K>, relation: NSLayoutConstraint.Relation) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
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
    let result = C.makeToView(item: lhs.item, attribute: lhs.type, relatedBy: relation, itemTo: rhs, multiplier: 1 / lhs.multiplier, constant: -lhs.constant)
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
    let result = C.makeWithOffset(item: lhs.item, attribute: lhs.type, relatedBy: relation, multiplier: lhs.multiplier, constant: lhs.constant, offset: rhs)
    let active = lhs.isActive
    result.priority = lhs.priority
    if active {
        removeConflicts(C.self, with: result)
    }
    result.isActive = active
    return result
}

@discardableResult
public func =|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<AttributeType.CenterX, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
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
public func =|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<AttributeType.CenterX, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First, C.Second == UILayoutable, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<AttributeType.CenterX, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<AttributeType.CenterX, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>, _ rhs: Attribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: Attribute<AttributeType.CenterX, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<AttributeType.CenterX, C>?, _ rhs: Attribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: Attribute<T, C>?, _ rhs: Attribute<AttributeType.CenterX, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
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

