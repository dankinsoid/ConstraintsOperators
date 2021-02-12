//
//  Functions.swift
//  TestProject
//
//  Created by Daniil on 10.09.2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

extension LayoutAttribute {
	
	public func equal<E: UILayoutableArray>(to rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<E: UILayoutableArray>(_ rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		equal(to: rhs)
	}
	
	public func equal(to rhs: CGFloat) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript(_ rhs: CGFloat) -> Constraints<Item, K> {
		equal(to: rhs)
	}
	
	public func within(_ rhs: ClosedRange<CGFloat>) -> Constraints<Item, K> {
		Constraints(setup(deactivated, rhs.lowerBound, relation: .greaterThanOrEqual).constraints + setup(deactivated, rhs.upperBound, relation: .lessThanOrEqual).constraints, item: item)
	}
	
	public func equal<R: UILayoutableArray>(to rhs: LayoutAttribute<A, R, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		_setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<E: UILayoutableArray>(_ rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		equal(to: rhs)
	}
	
	public func less<E: UILayoutableArray>(than rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less(than rhs: CGFloat) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less<R: UILayoutableArray>(than rhs: LayoutAttribute<A, R, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		rhs.map(less)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater(than rhs: CGFloat) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater<R: UILayoutableArray>(than rhs: LayoutAttribute<A, R, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		rhs.map(greater)
	}
	
	public func equal<R: UILayoutableArray>(to rhs: R) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<R: UILayoutableArray>(_ rhs: R) -> Constraints<Item, K> {
		equal(to: rhs)
	}
	
	public func equal<R: UILayoutableArray>(to rhs: R?) -> Constraints<Item, K>? {
		_setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<R: UILayoutableArray>(_ rhs: R?) -> Constraints<Item, K>? {
		equal(to: rhs)
	}
	
	public func less<R: UILayoutableArray>(than rhs: R) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func greater<R: UILayoutableArray>(than rhs: R) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
}

extension LayoutAttribute where A == Attributes.CenterX {
	
	public func equal<E: UILayoutableArray>(to rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<E: UILayoutableArray>(to rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		equal(to: rhs)
	}
	
	public func equal<T: CenterXAttributeCompatible, E: UILayoutableArray>(to rhs: LayoutAttribute<T, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		_setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<T: CenterXAttributeCompatible, E: UILayoutableArray>(to rhs: LayoutAttribute<T, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		equal(to: rhs)
	}
	
	public func less<E: UILayoutableArray>(than rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less<R: UILayoutableArray>(than rhs: LayoutAttribute<A, R, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		rhs.map(less)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater<R: UILayoutableArray>(than rhs: LayoutAttribute<A, R, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		rhs.map(greater)
	}
	
}

extension LayoutAttribute where A: CenterXAttributeCompatible {
	
	public func equal<E: UILayoutableArray>(to rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<E: UILayoutableArray>(to rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		equal(to: rhs)
	}
	
	public func equal<E: UILayoutableArray>(to rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		rhs.map(equal)
	}
	
	public subscript<E: UILayoutableArray>(to rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		equal(to: rhs)
	}
	
	public func less<E: UILayoutableArray>(than rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less<E: UILayoutableArray>(than rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		rhs.map(less)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item, K> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item, K>? {
		rhs.map(greater)
	}
}

extension LayoutAttribute where A == Attributes.Edges, K == [NSLayoutConstraint.Attribute] {
	
	public func equal(to rhs: UIEdgeInsets) -> Constraints<Item, K> {
		map(rhs: rhs, operation: { $0.equal(to: $1) })
	}
	
	public subscript(to rhs: UIEdgeInsets) -> Constraints<Item, K> {
		equal(to: rhs)
	}
	
	public func less(than rhs: UIEdgeInsets) -> Constraints<Item, K> {
		map(rhs: rhs, operation: { $0.less(than: $1) })
	}
	
	public func greater(than rhs: UIEdgeInsets) -> Constraints<Item, K> {
		map(rhs: rhs, operation: { $0.greater(than: $1) })
	}
	
	private func map(rhs: UIEdgeInsets, operation: @escaping (LayoutAttribute, CGFloat) -> Constraints<Item, K>) -> Constraints<Item, K> {
		return Constraints<Item, K>({
			var result: [NSLayoutConstraint] = []
			if type.attributes.contains(.leading) { result += operation(type(K(.leading)), rhs.left).constraints }
			if type.attributes.contains(.trailing) { result += operation(type(K(.trailing)), rhs.right).constraints }
			if type.attributes.contains(.top) { result += operation(type(K(.top)), rhs.top).constraints }
			if type.attributes.contains(.bottom) { result += operation(type(K(.bottom)), rhs.bottom).constraints }
			return result
		}, item: item)
	}
	
}

extension LayoutAttribute where A == Attributes.Size {
	
	public func equal(to rhs: CGSize) -> Constraints<Item, K> {
		map(rhs: rhs, operation: { $0.equal(to: $1) })
	}
	
	public subscript(to rhs: CGSize) -> Constraints<Item, K> {
		equal(to: rhs)
	}
	
	public func less(than rhs: CGSize) -> Constraints<Item, K> {
		map(rhs: rhs, operation: { $0.less(than: $1) })
	}
	
	public func greater(than rhs: CGSize) -> Constraints<Item, K> {
		map(rhs: rhs, operation: { $0.greater(than: $1) })
	}
	
	private func map(rhs: CGSize, operation: @escaping (LayoutAttribute, CGFloat) -> Constraints<Item, K>) -> Constraints<Item, K> {
		Constraints<Item, K>({
				operation(type(K(.width)).deactivated, rhs.width).constraints +
				operation(type(K(.height)).deactivated, rhs.height).constraints
		},
			item: item
		)
	}
}

extension Attributable where Att == NSLayoutConstraint.Attribute {
	
	public func widthToHeight(equal multiplier: CGFloat, constant: CGFloat = 0) -> Constraints<Target, Att> {
		width.equal(to: height * multiplier + constant)
	}
	
	public func widthToHeight(less multiplier: CGFloat, constant: CGFloat = 0) -> Constraints<Target, Att> {
		width.less(than: height * multiplier + constant)
	}
	
	public func widthToHeight(greater multiplier: CGFloat, constant: CGFloat = 0) -> Constraints<Target, Att> {
		width.greater(than: height * multiplier + constant)
	}
	
}
