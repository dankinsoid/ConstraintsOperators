//
//  Functions.swift
//  TestProject
//
//  Created by Daniil on 10.09.2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

extension LayoutAttribute {
	
	public func equal<T: LayoutAttributeType>(to rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == A {
		rhs.constraints(with: .init(first: self, relation: .equal, location: (file, line)))
	}
	
	public subscript<T: LayoutAttributeType>(_ rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == A {
		equal(to: rhs, file, line)
	}
	
	public func callAsFunction<T: LayoutAttributeType>(_ rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == A {
		equal(to: rhs, file, line)
	}
	
	public func within(_ rhs: ClosedRange<CGFloat>, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		rhs.constraints(with: .init(first: self, relation: .equal, location: (file, line)))
	}
	
	public func less<T: LayoutAttributeType>(than rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == A {
		rhs.constraints(with: .init(first: self, relation: .lessThanOrEqual, location: (file, line)))
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == A {
		rhs.constraints(with: .init(first: self, relation: .greaterThanOrEqual, location: (file, line)))
	}
	
	public func equal<T: LayoutAttributeType>(to rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.Same {
		rhs.constraints(with: .init(first: self, relation: .equal, location: (file, line)))
	}
	
	public subscript<T: LayoutAttributeType>(_ rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.Same {
		equal(to: rhs, file, line)
	}
	
	public func callAsFunction<T: LayoutAttributeType>(_ rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.Same {
		equal(to: rhs, file, line)
	}
	
	public func less<T: LayoutAttributeType>(than rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.Same {
		rhs.constraints(with: .init(first: self, relation: .lessThanOrEqual, location: (file, line)))
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.Same {
		rhs.constraints(with: .init(first: self, relation: .greaterThanOrEqual, location: (file, line)))
	}
}

extension LayoutAttribute where Item: UITypedLayoutableArray {
	
	public func equal<T: LayoutAttributeType>(to rhs: @escaping (Item.Layoutable) -> T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == A {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: .init(first: self, relation: .equal, location: (file, line)))
	}
	
	public func equal<T: LayoutAttributeType>(to rhs: @escaping (Item.Layoutable) -> T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.Same {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: .init(first: self, relation: .equal, location: (file, line)))
	}
	
	public func less<E: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> E, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where E.Attribute == A {
		LazyLayoutAttribute<Item, E>(attribute: rhs).constraints(with: .init(first: self, relation: .lessThanOrEqual, location: (file, line)))
	}
	
	public func less<E: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> E, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where E.Attribute == Attributes.Same {
		LazyLayoutAttribute<Item, E>(attribute: rhs).constraints(with: .init(first: self, relation: .lessThanOrEqual, location: (file, line)))
	}
	
	public func greater<E: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> E, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where E.Attribute == A {
		LazyLayoutAttribute<Item, E>(attribute: rhs).constraints(with: .init(first: self, relation: .greaterThanOrEqual, location: (file, line)))
	}
	
	public func greater<E: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> E, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where E.Attribute == Attributes.Same {
		LazyLayoutAttribute<Item, E>(attribute: rhs).constraints(with: .init(first: self, relation: .greaterThanOrEqual, location: (file, line)))
	}
	
}

extension LayoutAttribute where A == Attributes.CenterX {
	
	public func equal<T: LayoutAttributeType>(to rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		rhs.constraints(with: .init(first: self, relation: .equal, location: (file, line)))
	}
	
	public subscript<T: LayoutAttributeType>(_ rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		equal(to: rhs, file, line)
	}
	
	public func callAsFunction<T: LayoutAttributeType>(_ rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		equal(to: rhs, file, line)
	}
	
	public func less<T: LayoutAttributeType>(than rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		rhs.constraints(with: .init(first: self, relation: .lessThanOrEqual, location: (file, line)))
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		rhs.constraints(with: .init(first: self, relation: .greaterThanOrEqual, location: (file, line)))
	}
}

extension LayoutAttribute where Item: UITypedLayoutableArray, A == Attributes.CenterX {
	
	public func equal<T: LayoutAttributeType>(to rhs: @escaping (Item.Layoutable) -> T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: .init(first: self, relation: .equal, location: (file, line)))
	}
	
	public func less<T: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: .init(first: self, relation: .lessThanOrEqual, location: (file, line)))
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute: CenterXAttributeCompatible {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: .init(first: self, relation: .greaterThanOrEqual, location: (file, line)))
	}
}

extension LayoutAttribute where A: CenterXAttributeCompatible {
	
	public func equal<T: LayoutAttributeType>(to rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		rhs.constraints(with: .init(first: self, relation: .equal, location: (file, line)))
	}
	
	public subscript<T: LayoutAttributeType>(_ rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		equal(to: rhs, file, line)
	}
	
	public func callAsFunction<T: LayoutAttributeType>(_ rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		equal(to: rhs, file, line)
	}
	
	public func less<T: LayoutAttributeType>(than rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		rhs.constraints(with: .init(first: self, relation: .lessThanOrEqual, location: (file, line)))
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		rhs.constraints(with: .init(first: self, relation: .greaterThanOrEqual, location: (file, line)))
	}
	
}

extension LayoutAttribute where Item: UITypedLayoutableArray, A: CenterXAttributeCompatible {
	
	public func equal<T: LayoutAttributeType>(to rhs: @escaping (Item.Layoutable) -> T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: .init(first: self, relation: .equal, location: (file, line)))
	}
	
	public func less<T: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: .init(first: self, relation: .lessThanOrEqual, location: (file, line)))
	}
	
	public func greater<T: LayoutAttributeType>(than rhs: @escaping (Item.Layoutable) -> T, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> where T.Attribute == Attributes.CenterX {
		LazyLayoutAttribute<Item, T>(attribute: rhs).constraints(with: .init(first: self, relation: .greaterThanOrEqual, location: (file, line)))
	}
	
}

extension LayoutAttribute where A == Attributes.Edges, K == [NSLayoutConstraint.Attribute] {
	
	public func equal(to rhs: UIEdgeInsets, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.equal(to: $1, file, line) })
	}
	
	public subscript(_ rhs: UIEdgeInsets, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		equal(to: rhs, file, line)
	}
	
	public func callAsFunction(_ rhs: UIEdgeInsets, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		equal(to: rhs, file, line)
	}
	
	public func less(than rhs: UIEdgeInsets, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.less(than: $1, file, line) })
	}
	
	public func greater(than rhs: UIEdgeInsets, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.greater(than: $1, file, line) })
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
	
	public func equal(to rhs: CGSize, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.equal(to: $1, file, line) })
	}
	
	public subscript(_ rhs: CGSize, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		equal(to: rhs, file, line)
	}
	
	public func callAsFunction(_ rhs: CGSize, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		equal(to: rhs, file, line)
	}
	
	public func less(than rhs: CGSize, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.less(than: $1, file, line) })
	}
	
	public func greater(than rhs: CGSize, _ file: String = #file, _ line: UInt = #line) -> Constraints<Item> {
		map(rhs: rhs, operation: { $0.greater(than: $1, file, line) })
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
	
	public func widthToHeight(equal multiplier: CGFloat, constant: CGFloat = 0, priority: UILayoutPriority = .required, _ file: String = #file, _ line: UInt = #line) -> Constraints<Target> {
		width.priority(priority).equal(to: height * multiplier + constant, file, line)
	}
	
	public func widthToHeight(less multiplier: CGFloat, constant: CGFloat = 0, priority: UILayoutPriority = .required, _ file: String = #file, _ line: UInt = #line) -> Constraints<Target> {
		width.priority(priority).less(than: height * multiplier + constant, file, line)
	}
	
	public func widthToHeight(greater multiplier: CGFloat, constant: CGFloat = 0, priority: UILayoutPriority = .required, _ file: String = #file, _ line: UInt = #line) -> Constraints<Target> {
		width.priority(priority).greater(than: height * multiplier + constant, file, line)
	}
}
