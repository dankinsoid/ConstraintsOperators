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
public func =|<T, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>) -> Constraints<C> {
		setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: UILayoutableArray, A: AttributeConvertable, L: UILayoutableArray>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: L) -> Constraints<C> {
	setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.CenterX, C, A>, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>) -> Constraints<C> {
		setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: LayoutAttribute<Attributes.CenterX, K, NSLayoutConstraint.Attribute>) -> Constraints<C> {
		setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: CGFloat) -> Constraints<C> {
		setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: ClosedRange<CGFloat>) -> Constraints<C> {
	Constraints(setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual).constraints + setup(lhs, rhs.upperBound, relation: .lessThanOrEqual).constraints, item: lhs.item)
}

@discardableResult
public func =|<T, C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: ClosedRange<CGFloat>) -> Constraints<C>? {
	guard let lhs = lhs else { return nil }
	return Constraints(setup(lhs, rhs.lowerBound, relation: .greaterThanOrEqual).constraints + setup(lhs, rhs.upperBound, relation: .lessThanOrEqual).constraints, item: lhs.item)
}

@discardableResult
public func =|<T, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>?) -> Constraints<C>? {
		_setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: UILayoutableArray, A: AttributeConvertable, L: UILayoutableArray>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: L?) -> Constraints<C>? {
		_setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.CenterX, C, A>?, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>?) -> Constraints<C>? {
		_setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: LayoutAttribute<Attributes.CenterX, K, NSLayoutConstraint.Attribute>?) -> Constraints<C>? {
	_setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func =|<T, C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: CGFloat) -> Constraints<C>? {
		_setup(lhs, rhs, relation: .equal)
}

@discardableResult
public func <=|<T, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>) -> Constraints<C> {
		setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: UILayoutableArray, A: AttributeConvertable, L: UILayoutableArray>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: L) -> Constraints<C> {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: LayoutAttribute<Attributes.CenterX, K, NSLayoutConstraint.Attribute>) -> Constraints<C> {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.CenterX, C, A>, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>) -> Constraints<C> {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: CGFloat) -> Constraints<C> {
    return setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>?) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: UILayoutableArray, A: AttributeConvertable, L: UILayoutableArray>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: L?) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: LayoutAttribute<Attributes.CenterX, K, NSLayoutConstraint.Attribute>?) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.CenterX, C, A>?, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>?) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func <=|<T, C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: CGFloat) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .lessThanOrEqual)
}

@discardableResult
public func >=|<T, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>) -> Constraints<C> {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: UILayoutableArray, A: AttributeConvertable, L: UILayoutableArray>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: L) -> Constraints<C> {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.CenterX, C, A>, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>) -> Constraints<C> {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: LayoutAttribute<Attributes.CenterX, K, NSLayoutConstraint.Attribute>) -> Constraints<C> {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>, _ rhs: CGFloat) -> Constraints<C> {
    return setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>?) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: UILayoutableArray, A: AttributeConvertable, L: UILayoutableArray>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: L?) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.CenterX, C, A>?, _ rhs: LayoutAttribute<T, K, NSLayoutConstraint.Attribute>?) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T: CenterXAttributeCompatible, C: UILayoutableArray, K: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: LayoutAttribute<Attributes.CenterX, K, NSLayoutConstraint.Attribute>?) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func >=|<T, C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<T, C, A>?, _ rhs: CGFloat) -> Constraints<C>? {
    return _setup(lhs, rhs, relation: .greaterThanOrEqual)
}

@discardableResult
public func =|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>, _ rhs: UIEdgeInsets) -> Constraints<C> {
	lhs.map(rhs: rhs, operation: { $0 =| $1 })
}

@discardableResult
public func =|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>, _ rhs: (top: CGFloat, (left: CGFloat, right: CGFloat), bottom: CGFloat)) -> Constraints<C> {
	lhs =| UIEdgeInsets(top: rhs.top, left: rhs.1.left, bottom: rhs.bottom, right: rhs.1.right)
}

@discardableResult
public func <=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>, _ rhs: UIEdgeInsets) -> Constraints<C> {
	lhs.map(rhs: rhs, operation: { $0 <=| $1 })
}

@discardableResult
public func <=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>, _ rhs: (top: CGFloat, (left: CGFloat, right: CGFloat), bottom: CGFloat)) -> Constraints<C> {
	lhs <=| UIEdgeInsets(top: rhs.top, left: rhs.1.left, bottom: rhs.bottom, right: rhs.1.right)
}

@discardableResult
public func >=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>, _ rhs: UIEdgeInsets) -> Constraints<C> {
	lhs.map(rhs: rhs, operation: { $0 >=| $1 })
}

@discardableResult
public func >=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>, _ rhs: (top: CGFloat, (left: CGFloat, right: CGFloat), bottom: CGFloat)) -> Constraints<C> {
	lhs >=| UIEdgeInsets(top: rhs.top, left: rhs.1.left, bottom: rhs.bottom, right: rhs.1.right)
}

@discardableResult
public func =|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>?, _ rhs: UIEdgeInsets) -> Constraints<C>? {
	lhs?.map(rhs: rhs, operation: { $0 =| $1 })
}

@discardableResult
public func =|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>?, _ rhs: (top: CGFloat, (left: CGFloat, right: CGFloat), bottom: CGFloat)) -> Constraints<C>? {
	lhs =| UIEdgeInsets(top: rhs.top, left: rhs.1.left, bottom: rhs.bottom, right: rhs.1.right)
}

@discardableResult
public func <=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>?, _ rhs: UIEdgeInsets) -> Constraints<C>? {
	lhs?.map(rhs: rhs, operation: { $0 <=| $1 })
}

@discardableResult
public func <=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>?, _ rhs: (top: CGFloat, (left: CGFloat, right: CGFloat), bottom: CGFloat)) -> Constraints<C>? {
	lhs <=| UIEdgeInsets(top: rhs.top, left: rhs.1.left, bottom: rhs.bottom, right: rhs.1.right)
}

@discardableResult
public func >=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>?, _ rhs: UIEdgeInsets) -> Constraints<C>? {
	lhs?.map(rhs: rhs, operation: { $0 >=| $1 })
}

@discardableResult
public func >=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Edges, C, A>?, _ rhs: (top: CGFloat, (left: CGFloat, right: CGFloat), bottom: CGFloat)) -> Constraints<C>? {
	lhs >=| UIEdgeInsets(top: rhs.top, left: rhs.1.left, bottom: rhs.bottom, right: rhs.1.right)
}

@discardableResult
public func =|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Size, C, A>, _ rhs: CGSize) -> Constraints<C> {
	lhs.map(rhs: rhs, operation: { $0 =| $1 })
}

@discardableResult
public func <=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Size, C, A>, _ rhs: CGSize) -> Constraints<C> {
	lhs.map(rhs: rhs, operation: { $0 <=| $1 })
}

@discardableResult
public func >=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Size, C, A>, _ rhs: CGSize) -> Constraints<C> {
	lhs.map(rhs: rhs, operation: { $0 >=| $1 })
}

@discardableResult
public func =|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Size, C, A>?, _ rhs: CGSize) -> Constraints<C>? {
	lhs?.map(rhs: rhs, operation: { $0 =| $1 })
}

@discardableResult
public func <=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Size, C, A>?, _ rhs: CGSize) -> Constraints<C>? {
	lhs?.map(rhs: rhs, operation: { $0 <=| $1 })
}

@discardableResult
public func >=|<C: UILayoutableArray, A: AttributeConvertable>(_ lhs: LayoutAttribute<Attributes.Size, C, A>?, _ rhs: CGSize) -> Constraints<C>? {
	lhs?.map(rhs: rhs, operation: { $0 >=| $1 })
}

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
