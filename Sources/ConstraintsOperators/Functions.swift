//
//  Functions.swift
//  TestProject
//
//  Created by Daniil on 10.09.2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

extension LayoutAttribute {
	
	public func equal<T: LayoutAttributeType>(to rhs: T) -> Constraints<Item> where T.Attribute == A {
		rhs.constraints(with: self, relation: .equal)
	}
	
	public subscript<T: LayoutAttributeType>(_ rhs: T) -> Constraints<Item> where T.Attribute == A {
		equal(to: rhs)
	}
	
	public func callAsFunction<T: LayoutAttributeType>(_ rhs: T) -> Constraints<Item> where T.Attribute == A {
		equal(to: rhs)
	}
	
	public func within(_ rhs: ClosedRange<CGFloat>) -> Constraints<Item> {
		rhs.constraints(with: self, relation: .equal)
	}
	
	public func less<T: LayoutAttributeType>(than rhs: T) -> Constraints<Item> where T.Attribute == A {
		rhs.constraints(with: self, relation: .lessThanOrEqual)
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: T) -> Constraints<Item> where T.Attribute == A {
		rhs.constraints(with: self, relation: .greaterThanOrEqual)
	}
	
	public func equal<T: LayoutAttributeType>(to rhs: T) -> Constraints<Item> where T.Attribute == Attributes.Same {
		rhs.constraints(with: self, relation: .equal)
	}
	
	public subscript<T: LayoutAttributeType>(_ rhs: T) -> Constraints<Item> where T.Attribute == Attributes.Same {
		equal(to: rhs)
	}
	
	public func callAsFunction<T: LayoutAttributeType>(_ rhs: T) -> Constraints<Item> where T.Attribute == Attributes.Same {
		equal(to: rhs)
	}
	
	public func less<T: LayoutAttributeType>(than rhs: T) -> Constraints<Item> where T.Attribute == Attributes.Same {
		rhs.constraints(with: self, relation: .lessThanOrEqual)
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: T) -> Constraints<Item> where T.Attribute == Attributes.Same {
		rhs.constraints(with: self, relation: .greaterThanOrEqual)
	}
}

extension LayoutAttribute where Item: UITypedLayoutableArray {
	
	public func equal<T: LayoutAttributeType>(to rhs: @escaping (Item.Layoutable) -> T) -> Constraints<Item> where T.Attribute == A {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: self, relation: .equal)
	}
	
	public func equal<T: LayoutAttributeType>(to rhs: @escaping (Item.Layoutable) -> T) -> Constraints<Item> where T.Attribute == Attributes.Same {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: self, relation: .equal)
	}
	
	public func less<E: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> E) -> Constraints<Item> where E.Attribute == A {
		LazyLayoutAttribute<Item, E>(attribute: rhs).constraints(with: self, relation: .lessThanOrEqual)
	}
	
	public func less<E: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> E) -> Constraints<Item> where E.Attribute == Attributes.Same {
		LazyLayoutAttribute<Item, E>(attribute: rhs).constraints(with: self, relation: .lessThanOrEqual)
	}
	
	public func greater<E: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> E) -> Constraints<Item> where E.Attribute == A {
		LazyLayoutAttribute<Item, E>(attribute: rhs).constraints(with: self, relation: .greaterThanOrEqual)
	}
	
	public func greater<E: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> E) -> Constraints<Item> where E.Attribute == Attributes.Same {
		LazyLayoutAttribute<Item, E>(attribute: rhs).constraints(with: self, relation: .greaterThanOrEqual)
	}
	
}

extension LayoutAttribute where A == Attributes.CenterX {
	
	public func equal<T: LayoutAttributeType>(to rhs: T) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		rhs.constraints(with: self, relation: .equal)
	}
	
	public subscript<T: LayoutAttributeType>(_ rhs: T) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		equal(to: rhs)
	}
	
	public func callAsFunction<T: LayoutAttributeType>(_ rhs: T) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		equal(to: rhs)
	}
	
	public func less<T: LayoutAttributeType>(than rhs: T) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		rhs.constraints(with: self, relation: .lessThanOrEqual)
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: T) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		rhs.constraints(with: self, relation: .greaterThanOrEqual)
	}
}

extension LayoutAttribute where Item: UITypedLayoutableArray, A == Attributes.CenterX {
	
	public func equal<T: LayoutAttributeType>(to rhs: @escaping (Item.Layoutable) -> T) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: self, relation: .equal)
	}
	
	public func less<T: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> T) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: self, relation: .lessThanOrEqual)
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> T) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: self, relation: .greaterThanOrEqual)
	}
}

extension LayoutAttribute where A: CenterXAttributeCompatible {
	
	public func equal<T: LayoutAttributeType>(to rhs: T) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		rhs.constraints(with: self, relation: .equal)
	}
	
	public subscript<T: LayoutAttributeType>(_ rhs: T) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		equal(to: rhs)
	}
	
	public func callAsFunction<T: LayoutAttributeType>(_ rhs: T) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		equal(to: rhs)
	}
	
	public func less<T: LayoutAttributeType>(than rhs: T) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		rhs.constraints(with: self, relation: .lessThanOrEqual)
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: T) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		rhs.constraints(with: self, relation: .greaterThanOrEqual)
	}
	
}

extension LayoutAttribute where Item: UITypedLayoutableArray, A: CenterXAttributeCompatible {
	
	public func equal<T: LayoutAttributeType>(to rhs: @escaping (Item.Layoutable) -> T) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: self, relation: .equal)
	}
	
	public func less<T: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> T) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: self, relation: .lessThanOrEqual)
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> T) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: self, relation: .greaterThanOrEqual)
	}
	
}

extension LayoutAttribute where A == Attributes.Edges, K == [NSLayoutConstraint.Attribute] {
	
	public func equal(to rhs: UIEdgeInsets) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.equal(to: $1) })
	}
	
	public subscript(_ rhs: UIEdgeInsets) -> Constraints<Item> {
		equal(to: rhs)
	}
	
	public func callAsFunction(_ rhs: UIEdgeInsets) -> Constraints<Item> {
		equal(to: rhs)
	}
	
	public func less(than rhs: UIEdgeInsets) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.less(than: $1) })
	}
	
	public func greater(than rhs: UIEdgeInsets) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.greater(than: $1) })
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
	
	public subscript(_ rhs: CGSize) -> Constraints<Item> {
		equal(to: rhs)
	}
	
	public func callAsFunction(_ rhs: CGSize) -> Constraints<Item> {
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
