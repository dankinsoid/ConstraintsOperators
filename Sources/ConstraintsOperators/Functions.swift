//
//  Functions.swift
//  TestProject
//
//  Created by Daniil on 10.09.2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

extension LayoutAttribute {
	
	public func equal<E: UILayoutableArray>(to rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public func equal<E: UILayoutableArray>(to rhs: @escaping (Item) -> LayoutAttribute<A, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<E: UILayoutableArray>(_ rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		equal(to: rhs)
	}
	
	public func equal(to rhs: CGFloat) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript(_ rhs: CGFloat) -> Constraints<Item> {
		equal(to: rhs)
	}
	
	public func within(_ rhs: ClosedRange<CGFloat>) -> Constraints<Item> {
		Constraints(setup(deactivated, rhs.lowerBound, relation: .greaterThanOrEqual).constraints + setup(deactivated, rhs.upperBound, relation: .lessThanOrEqual).constraints, item: item)
	}
	
	public func equal<R: UILayoutableArray>(to rhs: LayoutAttribute<A, R, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		_setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<E: UILayoutableArray>(_ rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		equal(to: rhs)
	}
	
	public func less<E: UILayoutableArray>(than rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less<E: UILayoutableArray>(than rhs: @escaping (Item) -> LayoutAttribute<A, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less(than rhs: CGFloat) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less<R: UILayoutableArray>(than rhs: LayoutAttribute<A, R, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		rhs.map(less)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: LayoutAttribute<A, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: @escaping (Item) -> LayoutAttribute<A, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater(than rhs: CGFloat) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater<R: UILayoutableArray>(than rhs: LayoutAttribute<A, R, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		rhs.map(greater)
	}
	
	public func equal<R: UILayoutableArray>(to rhs: R) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public func equal<E: UILayoutableArray>(to rhs: @escaping (Item) -> E?) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<R: UILayoutableArray>(_ rhs: R) -> Constraints<Item> {
		equal(to: rhs)
	}
	
	public func equal<R: UILayoutableArray>(to rhs: R?) -> Constraints<Item>? {
		_setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<R: UILayoutableArray>(_ rhs: R?) -> Constraints<Item>? {
		equal(to: rhs)
	}
	
	public func less<R: UILayoutableArray>(than rhs: R) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less<E: UILayoutableArray>(than rhs: @escaping (Item) -> E?) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func greater<R: UILayoutableArray>(than rhs: R) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: @escaping (Item) -> E?) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
}

extension LayoutAttribute where A == Attributes.CenterX {
	
	public func equal<T: CenterXAttributeCompatible, E: UILayoutableArray>(to rhs: LayoutAttribute<T, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public func equal<T: CenterXAttributeCompatible, E: UILayoutableArray>(to rhs: LayoutAttribute<T, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		_setup(deactivated, rhs, relation: .equal)
	}
	
	public func equal<T: CenterXAttributeCompatible, E: UILayoutableArray>(to rhs: @escaping (Item) -> LayoutAttribute<T, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		__setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<T: CenterXAttributeCompatible, E: UILayoutableArray>(to rhs: LayoutAttribute<T, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		equal(to: rhs)
	}
	
	public func less<T: CenterXAttributeCompatible, E: UILayoutableArray>(than rhs: LayoutAttribute<T, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less<T: CenterXAttributeCompatible, E: UILayoutableArray>(than rhs: LayoutAttribute<T, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		_setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less<T: CenterXAttributeCompatible, E: UILayoutableArray>(than rhs: @escaping (Item) -> LayoutAttribute<T, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func greater<T: CenterXAttributeCompatible, E: UILayoutableArray>(than rhs: LayoutAttribute<T, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater<T: CenterXAttributeCompatible, R: UILayoutableArray>(than rhs: LayoutAttribute<T, R, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		_setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater<T: CenterXAttributeCompatible, E: UILayoutableArray>(than rhs: @escaping (Item) -> LayoutAttribute<T, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
}

extension LayoutAttribute where A: CenterXAttributeCompatible {
	
	public func equal<E: UILayoutableArray>(to rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<E: UILayoutableArray>(to rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		equal(to: rhs)
	}
	
	public func equal<E: UILayoutableArray>(to rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		rhs.map(equal)
	}
	
	public func equal<E: UILayoutableArray>(to rhs: @escaping (Item) -> LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .equal)
	}
	
	public subscript<E: UILayoutableArray>(to rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		equal(to: rhs)
	}
	
	public func less<E: UILayoutableArray>(than rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func less<E: UILayoutableArray>(than rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		rhs.map(less)
	}
	
	public func less<E: UILayoutableArray>(than rhs: @escaping (Item) -> LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .lessThanOrEqual)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>?) -> Constraints<Item>? {
		rhs.map(greater)
	}
	
	public func greater<E: UILayoutableArray>(than rhs: @escaping (Item) -> LayoutAttribute<Attributes.CenterX, E, NSLayoutConstraint.Attribute>) -> Constraints<Item> {
		__setup(deactivated, rhs, relation: .greaterThanOrEqual)
	}
}

extension LayoutAttribute where A == Attributes.Edges, K == [NSLayoutConstraint.Attribute] {
	
	public func equal(to rhs: UIEdgeInsets) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.equal(to: $1) })
	}
	
	public func equal(to rhs: (top: CGFloat, (left: CGFloat, right: CGFloat), bottom: CGFloat)) -> Constraints<Item> {
		equal(to: UIEdgeInsets(top: rhs.top, left: rhs.1.left, bottom: rhs.bottom, right: rhs.1.right))
	}
	
	public subscript(to rhs: UIEdgeInsets) -> Constraints<Item> {
		equal(to: rhs)
	}
	
	public func less(than rhs: UIEdgeInsets) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.less(than: $1) })
	}
	
	public func less(than rhs: (top: CGFloat, (left: CGFloat, right: CGFloat), bottom: CGFloat)) -> Constraints<Item> {
		less(than: UIEdgeInsets(top: rhs.top, left: rhs.1.left, bottom: rhs.bottom, right: rhs.1.right))
	}
	
	public func greater(than rhs: UIEdgeInsets) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.greater(than: $1) })
	}
	
	public func greater(than rhs: (top: CGFloat, (left: CGFloat, right: CGFloat), bottom: CGFloat)) -> Constraints<Item> {
		greater(than: UIEdgeInsets(top: rhs.top, left: rhs.1.left, bottom: rhs.bottom, right: rhs.1.right))
	}
	
	private func map(rhs: UIEdgeInsets, operation: @escaping (LayoutAttribute, CGFloat) -> Constraints<Item>) -> Constraints<Item> {
		return Constraints<Item>({
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
	
	public func equal(to rhs: CGSize) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.equal(to: $1) })
	}
	
	public subscript(to rhs: CGSize) -> Constraints<Item> {
		equal(to: rhs)
	}
	
	public func less(than rhs: CGSize) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.less(than: $1) })
	}
	
	public func greater(than rhs: CGSize) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.greater(than: $1) })
	}
	
	private func map(rhs: CGSize, operation: @escaping (LayoutAttribute, CGFloat) -> Constraints<Item>) -> Constraints<Item> {
		Constraints<Item>({
				operation(type(K(.width)).deactivated, rhs.width).constraints +
				operation(type(K(.height)).deactivated, rhs.height).constraints
		},
			item: item
		)
	}
}

extension Attributable where Att == NSLayoutConstraint.Attribute {
	
	public func widthToHeight(equal multiplier: CGFloat, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> Constraints<Target> {
		width.priority(priority).equal(to: height * multiplier + constant)
	}
	
	public func widthToHeight(less multiplier: CGFloat, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> Constraints<Target> {
		width.priority(priority).less(than: height * multiplier + constant)
	}
	
	public func widthToHeight(greater multiplier: CGFloat, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> Constraints<Target> {
		width.priority(priority).greater(than: height * multiplier + constant)
	}
	
}
