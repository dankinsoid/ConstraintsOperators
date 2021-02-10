//
//  Functions.swift
//  TestProject
//
//  Created by Daniil on 10.09.2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

extension LayoutAttribute {
	
	public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .equal), item: item)
	}
	
	public subscript<K: ConstraintsCreator>(_ rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		equal(to: rhs)
	}
	
	public func equal(to rhs: CGFloat) -> Constraints<C> {
		Constraints<C>(setup(deactivated, rhs, relation: .equal), item: item)
	}
	
	public subscript(_ rhs: CGFloat) -> Constraints<C> {
		equal(to: rhs)
	}
	
	public func within(_ rhs: ClosedRange<CGFloat>) -> Constraints<C> where C.Constraint == NSLayoutConstraint {
		Constraints<C>(C.array(for: [setup(deactivated, rhs.lowerBound, relation: .greaterThanOrEqual), setup(deactivated, rhs.upperBound, relation: .lessThanOrEqual)]), item: item)
	}
	
	public func within(_ rhs: ClosedRange<CGFloat>) -> Constraints<C> where C.Constraint == [NSLayoutConstraint] {
		Constraints<C>(C.array(for: [setup(deactivated, rhs.lowerBound, relation: .greaterThanOrEqual), setup(deactivated, rhs.upperBound, relation: .lessThanOrEqual)]), item: item)
	}
	
	public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		_setup(deactivated, rhs, relation: .equal).map { Constraints<C>($0, item: item) }
	}
	
	public subscript<K: ConstraintsCreator>(_ rhs: LayoutAttribute<A, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		equal(to: rhs)
	}
	
	public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
	}
	
	public func less(than rhs: CGFloat) -> Constraints<C> {
		Constraints<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
	}
	
	public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		rhs.map(less)
	}
	
	public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
	}
	
	public func greater(than rhs: CGFloat) -> Constraints<C> {
		Constraints<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
	}
	
	public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		rhs.map(greater)
	}
	
}

extension LayoutAttribute where C.Second: UILayoutable {
	
	public func equal(to rhs: C.Second) -> Constraints<C> {
		Constraints<C>(setup(deactivated, rhs, relation: .equal), item: item)
	}
	
	public subscript(_ rhs: C.Second) -> Constraints<C> {
		equal(to: rhs)
	}
	
	public func equal(to rhs: C.Second?) -> Constraints<C>? {
		_setup(deactivated, rhs, relation: .equal).map { Constraints<C>($0, item: item) }
	}
	
	public subscript(_ rhs: C.Second?) -> Constraints<C>? {
		equal(to: rhs)
	}
	
	public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
	}
	
	public func less(than rhs: C.Second) -> Constraints<C> {
		Constraints<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
	}
	
	public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
	}
	
	public func greater(than rhs: C.Second) -> Constraints<C> {
		Constraints<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
	}
	
}

extension LayoutAttribute where A == Attributes.CenterX {
	
	public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .equal), item: item)
	}
	
	public subscript<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		equal(to: rhs)
	}
	
	public func equal<T: CenterXAttributeCompatible, K: ConstraintsCreator>(to rhs: LayoutAttribute<T, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		_setup(deactivated, rhs, relation: .equal).map { Constraints<C>($0, item: item) }
	}
	
	public subscript<T: CenterXAttributeCompatible, K: ConstraintsCreator>(to rhs: LayoutAttribute<T, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		equal(to: rhs)
	}
	
	public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
	}
	
	public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		rhs.map(less)
	}
	
	public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
	}
	
	public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		rhs.map(greater)
	}
	
}

extension LayoutAttribute where A: CenterXAttributeCompatible {
	
	public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<Attributes.CenterX, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .equal), item: item)
	}
	
	public subscript<K: ConstraintsCreator>(to rhs: LayoutAttribute<Attributes.CenterX, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		equal(to: rhs)
	}
	
	public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<Attributes.CenterX, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		rhs.map(equal)
	}
	
	public subscript<K: ConstraintsCreator>(to rhs: LayoutAttribute<Attributes.CenterX, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		equal(to: rhs)
	}
	
	public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
	}
	
	public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		rhs.map(less)
	}
	
	public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>) -> Constraints<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		Constraints<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
	}
	
	public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>?) -> Constraints<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
		rhs.map(greater)
	}
}

extension LayoutAttribute where A == Attributes.Edges, C.A == [NSLayoutConstraint.Attribute] {
	
	public func equal(to rhs: UIEdgeInsets) -> Constraints<C> {
		map(rhs: rhs, operation: { $0.equal(to: $1) })
	}
	
	public subscript(to rhs: UIEdgeInsets) -> Constraints<C> {
		equal(to: rhs)
	}
	
	public func less(than rhs: UIEdgeInsets) -> Constraints<C> {
		map(rhs: rhs, operation: { $0.less(than: $1) })
	}
	
	public func greater(than rhs: UIEdgeInsets) -> Constraints<C> {
		map(rhs: rhs, operation: { $0.greater(than: $1) })
	}
	
	private func map(rhs: UIEdgeInsets, operation: @escaping (LayoutAttribute, CGFloat) -> Constraints<C>) -> Constraints<C> {
		return Constraints<C>({
			var result: [C.Constraint] = []
			if type.contains(.leading) { result.append(contentsOf: operation(type(C.A.init(.leading)), rhs.left).constraints) }
			if type.contains(.trailing) { result.append(contentsOf: operation(type(C.A.init(.trailing)), rhs.right).constraints) }
			if type.contains(.top) { result.append(contentsOf: operation(type(C.A.init(.top)), rhs.top).constraints) }
			if type.contains(.bottom) { result.append(contentsOf: operation(type(C.A.init(.bottom)), rhs.bottom).constraints) }
			return result
		}, item: item)
	}
	
}

extension LayoutAttribute where A == Attributes.Size {
	
	public func equal(to rhs: CGSize) -> Constraints<C> {
		map(rhs: rhs, operation: { $0.equal(to: $1) })
	}
	
	public subscript(to rhs: CGSize) -> Constraints<C> {
		equal(to: rhs)
	}
	
	public func less(than rhs: CGSize) -> Constraints<C> {
		map(rhs: rhs, operation: { $0.less(than: $1) })
	}
	
	public func greater(than rhs: CGSize) -> Constraints<C> {
		map(rhs: rhs, operation: { $0.greater(than: $1) })
	}
	
	private func map(rhs: CGSize, operation: @escaping (LayoutAttribute, CGFloat) -> Constraints<C>) -> Constraints<C> {
		Constraints<C>({
				operation(type(C.A.init(.width)).deactivated, rhs.width).constraints +
				operation(type(C.A.init(.height)).deactivated, rhs.height).constraints
		},
			item: item
		)
	}
}
