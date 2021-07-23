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
public func =|<T, C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<T, C, K>?, _ rhs: A) -> Constraints<C> where T == A.Attribute {
	rhs.constraints(with: .init(first: lhs, relation: .equal, location: nil)).apply()
}

@discardableResult
public func =|<T, C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<T, C, K>?, _ rhs: A) -> Constraints<C> where A.Attribute == Attributes.Same {
	rhs.constraints(with: .init(first: lhs, relation: .equal, location: nil)).apply()
}

@discardableResult
public func =|<C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<Attributes.CenterX, C, K>?, _ rhs: A) -> Constraints<C> where A.Attribute: CenterXAttributeCompatible {
	rhs.constraints(with: .init(first: lhs, relation: .equal, location: nil)).apply()
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<T, C, K>?, _ rhs: A) -> Constraints<C> where A.Attribute == Attributes.CenterX {
	rhs.constraints(with: .init(first: lhs, relation: .equal, location: nil)).apply()
}


@discardableResult
public func <=|<T, C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<T, C, K>?, _ rhs: A) -> Constraints<C> where T == A.Attribute {
	rhs.constraints(with: .init(first: lhs, relation: .lessThanOrEqual, location: nil)).apply()
}

@discardableResult
public func <=|<T, C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<T, C, K>?, _ rhs: A) -> Constraints<C> where A.Attribute == Attributes.Same {
	rhs.constraints(with: .init(first: lhs, relation: .lessThanOrEqual, location: nil)).apply()
}

@discardableResult
public func <=|<C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<Attributes.CenterX, C, K>, _ rhs: A) -> Constraints<C> where A.Attribute: CenterXAttributeCompatible {
	rhs.constraints(with: .init(first: lhs, relation: .lessThanOrEqual, location: nil)).apply()
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<T, C, K>?, _ rhs: A) -> Constraints<C> where A.Attribute == Attributes.CenterX {
	rhs.constraints(with: .init(first: lhs, relation: .lessThanOrEqual, location: nil)).apply()
}


@discardableResult
public func >=|<T, C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<T, C, K>?, _ rhs: A) -> Constraints<C> where T == A.Attribute {
	rhs.constraints(with: .init(first: lhs, relation: .greaterThanOrEqual, location: nil)).apply()
}

@discardableResult
public func >=|<T, C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<T, C, K>?, _ rhs: A) -> Constraints<C> where A.Attribute == Attributes.Same {
	rhs.constraints(with: .init(first: lhs, relation: .greaterThanOrEqual, location: nil)).apply()
}

@discardableResult
public func >=|<C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<Attributes.CenterX, C, K>?, _ rhs: A) -> Constraints<C> where A.Attribute: CenterXAttributeCompatible {
	rhs.constraints(with: .init(first: lhs, relation: .greaterThanOrEqual, location: nil)).apply()
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: AttributeConvertable, A: LayoutAttributeType>(_ lhs: LayoutAttribute<T, C, K>?, _ rhs: A) -> Constraints<C> where A.Attribute == Attributes.CenterX {
	rhs.constraints(with: .init(first: lhs, relation: .greaterThanOrEqual, location: nil)).apply()
}

///EDGES
@discardableResult
public func =|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>?, _ rhs: UIEdgeInsets) -> Constraints<C> {
	lhs?.map(rhs: rhs, operation: { $0 =| $1 }).apply() ?? .empty
}

@discardableResult
public func <=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>?, _ rhs: UIEdgeInsets) -> Constraints<C> {
	lhs?.map(rhs: rhs, operation: { $0 <=| $1 }).apply() ?? .empty
}

@discardableResult
public func >=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>?, _ rhs: UIEdgeInsets) -> Constraints<C> {
	lhs?.map(rhs: rhs, operation: { $0 >=| $1 }).apply() ?? .empty
}

///SIZE
@discardableResult
public func =|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Size, C, A>?, _ rhs: CGSize) -> Constraints<C> {
	lhs?.map(rhs: rhs, operation: { $0 =| $1 }).apply() ?? .empty
}

@discardableResult
public func <=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Size, C, A>?, _ rhs: CGSize) -> Constraints<C> {
	lhs?.map(rhs: rhs, operation: { $0 <=| $1 }).apply() ?? .empty
}

@discardableResult
public func >=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Size, C, A>?, _ rhs: CGSize) -> Constraints<C> {
	lhs?.map(rhs: rhs, operation: { $0 >=| $1 }).apply() ?? .empty
}

///MATH
public func *<A, C: UILayoutableArray, B: AttributeConvertable>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C, B>) -> LayoutAttribute<A, C, B> {
    var result = rhs
    result.multiplier = lhs
    return result
}

public func *<A, C: UILayoutableArray, B: AttributeConvertable>(_ rhs: LayoutAttribute<A, C, B>, _ lhs: CGFloat) -> LayoutAttribute<A, C, B> {
    var result = rhs
    result.multiplier *= lhs
    return result
}

public func /<A, C: UILayoutableArray, B: AttributeConvertable>(_ rhs: LayoutAttribute<A, C, B>, _ lhs: CGFloat) -> LayoutAttribute<A, C, B> {
    var result = rhs
    result.multiplier /= lhs
    return result
}

public func +<A, C: UILayoutableArray, B: AttributeConvertable>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C, B>) -> LayoutAttribute<A, C, B> {
    var result = rhs
    result.constant += lhs
    return result
}

public func +<A, C: UILayoutableArray, B: AttributeConvertable>(_ rhs: LayoutAttribute<A, C, B>, _ lhs: CGFloat) -> LayoutAttribute<A, C, B> {
    var result = rhs
    result.constant += lhs
    return result
}

public func -<A, C: UILayoutableArray, B: AttributeConvertable>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C, B>) -> LayoutAttribute<A, C, B> {
    return lhs + rhs * (-1)
}

public func -<A, C: UILayoutableArray, B: AttributeConvertable>(_ rhs: LayoutAttribute<A, C, B>, _ lhs: CGFloat) -> LayoutAttribute<A, C, B> {
    var result = rhs
    result.constant -= lhs
    return result
}

public func *<A, C: UILayoutableArray, B: AttributeConvertable>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C, B>?) -> LayoutAttribute<A, C, B>? {
    var result = rhs
    result?.multiplier = lhs
    return result
}

public func *<A, C: UILayoutableArray, B: AttributeConvertable>(_ rhs: LayoutAttribute<A, C, B>?, _ lhs: CGFloat) -> LayoutAttribute<A, C, B>? {
    var result = rhs
    result?.multiplier *= lhs
    return result
}

public func /<A, C: UILayoutableArray, B: AttributeConvertable>(_ rhs: LayoutAttribute<A, C, B>?, _ lhs: CGFloat) -> LayoutAttribute<A, C, B>? {
    var result = rhs
    result?.multiplier /= lhs
    return result
}

public func +<A, C: UILayoutableArray, B: AttributeConvertable>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C, B>?) -> LayoutAttribute<A, C, B>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func +<A, C: UILayoutableArray, B: AttributeConvertable>(_ rhs: LayoutAttribute<A, C, B>?, _ lhs: CGFloat) -> LayoutAttribute<A, C, B>? {
    var result = rhs
    result?.constant += lhs
    return result
}

public func -<A, C: UILayoutableArray, B: AttributeConvertable>(_ lhs: CGFloat, _ rhs: LayoutAttribute<A, C, B>?) -> LayoutAttribute<A, C, B>? {
    return lhs + rhs * (-1)
}

public func -<A, C: UILayoutableArray, B: AttributeConvertable>(_ rhs: LayoutAttribute<A, C, B>?, _ lhs: CGFloat) -> LayoutAttribute<A, C, B>? {
    var result = rhs
    result?.constant -= lhs
    return result
}


extension LayoutAttribute {
	
	fileprivate func map(rhs: UIEdgeInsets, operation: @escaping (LayoutAttribute, CGFloat) -> Constraints<Item>) -> Constraints<Item> {
		var result: [NSLayoutConstraint] = []
		if type.attributes.contains(.leading) { result += operation(type(K(.leading)), rhs.left).constraints }
		if type.attributes.contains(.trailing) { result += operation(type(K(.trailing)), rhs.right).constraints }
		if type.attributes.contains(.top) { result += operation(type(K(.top)), rhs.top).constraints }
		if type.attributes.contains(.bottom) { result += operation(type(K(.bottom)), rhs.bottom).constraints }
		return Constraints(result, item: item)
	}
}


extension LayoutAttribute {
	fileprivate func map(rhs: CGSize, operation: @escaping (LayoutAttribute, CGFloat) -> Constraints<Item>) -> Constraints<Item> {
		Constraints(
			operation(type(K(.width)), rhs.width).constraints +
			operation(type(K(.height)), rhs.height).constraints,
			item: item
		)
	}
}
