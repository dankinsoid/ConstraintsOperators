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

@discardableResult
public func =|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: LayoutAttribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.CenterX, C>, _ rhs: LayoutAttribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: LayoutAttribute<Attributes.CenterX, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: ClosedRange<CGFloat>) -> [NSLayoutConstraint] {
    return C.array(for: [setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual), setup(lhs, rhs.upperBound, relation: .lessThanOrEqual)])
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: ClosedRange<CGFloat>) -> [NSLayoutConstraint]? {
    guard let lhs = lhs else { return nil }
    return C.array(for: [setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual), setup(lhs, rhs.upperBound, relation: .lessThanOrEqual)])
}

@discardableResult
public func =|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: LayoutAttribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.CenterX, C>?, _ rhs: LayoutAttribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: LayoutAttribute<Attributes.CenterX, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: LayoutAttribute<T, K>) -> C.Constraint where C.Second == K.First, C.Second == UILayoutable, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: LayoutAttribute<Attributes.CenterX, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.CenterX, C>, _ rhs: LayoutAttribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: LayoutAttribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: LayoutAttribute<Attributes.CenterX, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.CenterX, C>?, _ rhs: LayoutAttribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: LayoutAttribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: C.Second) -> C.Constraint where C.Second == UILayoutable {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.CenterX, C>, _ rhs: LayoutAttribute<T, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: LayoutAttribute<Attributes.CenterX, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>, _ rhs: CGFloat) -> C.Constraint {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: LayoutAttribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: C.Second?) -> C.Constraint? where C.Second == UILayoutable {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.CenterX, C>?, _ rhs: LayoutAttribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: LayoutAttribute<Attributes.CenterX, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: ConstraintsCreator>(_ lhs: LayoutAttribute<T, C>?, _ rhs: CGFloat) -> C.Constraint? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func =|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Edges, C>, _ rhs: UIEdgeInsets) -> [C.Constraint] {
    lhs.equal(to: rhs)
}

@discardableResult
public func <=|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Edges, C>, _ rhs: UIEdgeInsets) -> [C.Constraint] {
    lhs.less(than: rhs)
}

@discardableResult
public func >=|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Edges, C>, _ rhs: UIEdgeInsets) -> [C.Constraint] {
    lhs.greater(than: rhs)
}

@discardableResult
public func =|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Edges, C>?, _ rhs: UIEdgeInsets) -> [C.Constraint]? {
    lhs?.equal(to: rhs)
}

@discardableResult
public func <=|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Edges, C>?, _ rhs: UIEdgeInsets) -> [C.Constraint]? {
    lhs?.less(than: rhs)
}

@discardableResult
public func >=|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Edges, C>?, _ rhs: UIEdgeInsets) -> [C.Constraint]? {
    lhs?.greater(than: rhs)
}

@discardableResult
public func =|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Size, C>, _ rhs: CGSize) -> [C.Constraint] {
    lhs.equal(to: rhs)
}

@discardableResult
public func <=|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Size, C>, _ rhs: CGSize) -> [C.Constraint] {
    lhs.less(than: rhs)
}

@discardableResult
public func >=|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Size, C>, _ rhs: CGSize) -> [C.Constraint] {
    lhs.greater(than: rhs)
}

@discardableResult
public func =|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Size, C>?, _ rhs: CGSize) -> [C.Constraint]? {
    lhs?.equal(to: rhs)
}

@discardableResult
public func <=|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Size, C>?, _ rhs: CGSize) -> [C.Constraint]? {
    lhs?.less(than: rhs)
}

@discardableResult
public func >=|<C: ConstraintsCreator>(_ lhs: LayoutAttribute<Attributes.Size, C>?, _ rhs: CGSize) -> [C.Constraint]? {
    lhs?.greater(than: rhs)
}

public func *<A, C: ConstraintsCreator>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C>) -> LayoutAttribute<A, C> {
    var result = rhs
    result.multiplier = lhs
    return result
}

public func *<A, C: ConstraintsCreator>(_ rhs: LayoutAttribute<A, C>, _ lhs: CGFloat) -> LayoutAttribute<A, C> {
    var result = rhs
    result.multiplier *= lhs
    return result
}

public func /<A, C: ConstraintsCreator>(_ rhs: LayoutAttribute<A, C>, _ lhs: CGFloat) -> LayoutAttribute<A, C> {
    var result = rhs
    result.multiplier /= lhs
    return result
}

public func +<A, C: ConstraintsCreator>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C>) -> LayoutAttribute<A, C> {
    var result = rhs
    result.constant += lhs
    return result
}

public func +<A, C: ConstraintsCreator>(_ rhs: LayoutAttribute<A, C>, _ lhs: CGFloat) -> LayoutAttribute<A, C> {
    var result = rhs
    result.constant += lhs
    return result
}

public func -<A, C: ConstraintsCreator>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C>) -> LayoutAttribute<A, C> {
    return lhs + rhs * (-1)
}

public func -<A, C: ConstraintsCreator>(_ rhs: LayoutAttribute<A, C>, _ lhs: CGFloat) -> LayoutAttribute<A, C> {
    var result = rhs
    result.constant -= lhs
    return result
}

public func *<A, C: ConstraintsCreator>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C>?) -> LayoutAttribute<A, C>? {
    var result = rhs
    result?.multiplier = lhs
    return result
}

public func *<A, C: ConstraintsCreator>(_ rhs: LayoutAttribute<A, C>?, _ lhs: CGFloat) -> LayoutAttribute<A, C>? {
    var result = rhs
    result?.multiplier *= lhs
    return result
}

public func /<A, C: ConstraintsCreator>(_ rhs: LayoutAttribute<A, C>?, _ lhs: CGFloat) -> LayoutAttribute<A, C>? {
    var result = rhs
    result?.multiplier /= lhs
    return result
}

public func +<A, C: ConstraintsCreator>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C>?) -> LayoutAttribute<A, C>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func +<A, C: ConstraintsCreator>(_ rhs: LayoutAttribute<A, C>?, _ lhs: CGFloat) -> LayoutAttribute<A, C>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func -<A, C: ConstraintsCreator>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C>?) -> LayoutAttribute<A, C>? {
    return lhs + rhs * (-1)
}

public func -<A, C: ConstraintsCreator>(_ rhs: LayoutAttribute<A, C>?, _ lhs: CGFloat) -> LayoutAttribute<A, C>? {
    var result = rhs
    result?.constant -= lhs
    return result
}
