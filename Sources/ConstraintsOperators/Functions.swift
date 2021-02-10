//
//  Functions.swift
//  TestProject
//
//  Created by Daniil on 10.09.2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

extension LayoutAttribute {
    
    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
			ConstraintWrapper<C>(setup(deactivated, rhs, relation: .equal), item: item)
    }
    
    public func equal(to rhs: CGFloat) -> ConstraintWrapper<C> {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .equal), item: item)
    }
    
	  public func within(_ rhs: ClosedRange<CGFloat>) -> ConstraintWrapper<C> where C.Constraint == NSLayoutConstraint {
        ConstraintWrapper<C>(C.array(for: [setup(deactivated, rhs.lowerBound, relation: .greaterThanOrEqual), setup(deactivated, rhs.upperBound, relation: .lessThanOrEqual)]), item: item)
    }
    
    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>?) -> ConstraintWrapper<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
			_setup(deactivated, rhs, relation: .equal).map { ConstraintWrapper<C>($0, item: item) }
    }
    
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
    }
    
    public func less(than rhs: CGFloat) -> ConstraintWrapper<C> {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
    }
    
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> ConstraintWrapper<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
			_setup(deactivated, rhs, relation: .lessThanOrEqual).map { ConstraintWrapper<C>($0, item: item) }
    }
    
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
    }
    
    public func greater(than rhs: CGFloat) -> ConstraintWrapper<C> {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
    }
    
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> ConstraintWrapper<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
			_setup(deactivated, rhs, relation: .greaterThanOrEqual).map { ConstraintWrapper<C>($0, item: item) }
    }

}

extension LayoutAttribute where C.Second == UILayoutable {
    
    public func equal(to rhs: C.Second) -> ConstraintWrapper<C> {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .equal), item: item)
    }

    public func equal(to rhs: C.Second?) -> ConstraintWrapper<C>? {
			_setup(deactivated, rhs, relation: .equal).map { ConstraintWrapper<C>($0, item: item) }
    }
    
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
    }
    
    public func less(than rhs: C.Second) -> ConstraintWrapper<C> {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
    }

    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
    }
    
    public func greater(than rhs: C.Second) -> ConstraintWrapper<C> {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
    }
    
}

extension LayoutAttribute where A == Attributes.CenterX {

    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .equal), item: item)
    }

    public func equal<T: CenterXAttributeCompatible, K: ConstraintsCreator>(to rhs: LayoutAttribute<T, K>?) -> ConstraintWrapper<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
			_setup(deactivated, rhs, relation: .equal).map { ConstraintWrapper<C>($0, item: item) }
    }
    
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
    }
    
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> ConstraintWrapper<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(_setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
    }
    
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
    }
    
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> ConstraintWrapper<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(_setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
    }
    
}

extension LayoutAttribute where A: CenterXAttributeCompatible {
    
    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<Attributes.CenterX, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .equal), item: item)
    }
    
    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<Attributes.CenterX, K>?) -> ConstraintWrapper<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(_setup(deactivated, rhs, relation: .equal), item: item)
    }
    
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
    }
    
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>?) -> ConstraintWrapper<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(_setup(deactivated, rhs, relation: .lessThanOrEqual), item: item)
    }
    
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>) -> ConstraintWrapper<C> where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
    }
    
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>?) -> ConstraintWrapper<C>? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        ConstraintWrapper<C>(_setup(deactivated, rhs, relation: .greaterThanOrEqual), item: item)
    }
}

extension LayoutAttribute where A == Attributes.Edges, C.A == [NSLayoutConstraint.Attribute] {
    
    public func equal(to rhs: UIEdgeInsets) -> ConstraintWrapper<C> {
			map(rhs: rhs, operation: { $0.equal(to: $1).constraints })
    }
    
    public func less(than rhs: UIEdgeInsets) -> ConstraintWrapper<C> {
			map(rhs: rhs, operation: { $0.less(than: $1).constraints })
    }
    
    public func greater(than rhs: UIEdgeInsets) -> ConstraintWrapper<C> {
			map(rhs: rhs, operation: { $0.greater(than: $1).constraints })
    }
    
	private func map(rhs: UIEdgeInsets, operation: (LayoutAttribute, CGFloat) -> [C.Constraint]) -> ConstraintWrapper<C> {
			var result: [C.Constraint] = []
			if type.contains(.leading) { result.append(contentsOf: operation(type(C.A.init(.leading)).deactivated, rhs.left)) }
			if type.contains(.trailing) { result.append(contentsOf: operation(type(C.A.init(.trailing)).deactivated, rhs.right)) }
			if type.contains(.top) { result.append(contentsOf: operation(type(C.A.init(.top)).deactivated, rhs.top)) }
			if type.contains(.bottom) { result.append(contentsOf: operation(type(C.A.init(.bottom)).deactivated, rhs.bottom)) }
			return ConstraintWrapper<C>(result, item: item)
    }
    
}

extension LayoutAttribute where A == Attributes.Size {
    
    public func equal(to rhs: CGSize) -> ConstraintWrapper<C> {
			map(rhs: rhs, operation: { $0.equal(to: $1).constraints })
    }
    
    public func less(than rhs: CGSize) -> ConstraintWrapper<C> {
			map(rhs: rhs, operation: { $0.less(than: $1).constraints })
    }
    
    public func greater(than rhs: CGSize) -> ConstraintWrapper<C> {
			map(rhs: rhs, operation: { $0.greater(than: $1).constraints })
    }
    
		private func map(rhs: CGSize, operation: (LayoutAttribute, CGFloat) -> [C.Constraint]) -> ConstraintWrapper<C> {
			ConstraintWrapper<C>(
				operation(type(C.A.init(.width)).deactivated, rhs.width) +
				operation(type(C.A.init(.height)).deactivated, rhs.height),
				item: item
			)
    }
}

public struct ConstraintWrapper<B: ConstraintsCreator>: Attributable {
	public let constraints: [B.Constraint]
	public let target: B.First
	
	init(_ constraint: B.Constraint, item target: B.First) {
		self.constraints = [constraint]
		self.target = target
	}
	
	init(_ constraints: [B.Constraint], item target: B.First) {
		self.constraints = constraints
		self.target = target
	}
	
	init?(_ constraint: B.Constraint?, item target: B.First) {
		guard let c = constraint else { return nil }
		self.constraints = [c]
		self.target = target
	}
	
	init?(_ constraints: [B.Constraint]?, item target: B.First) {
		guard let c = constraints else { return nil }
		self.constraints = c
		self.target = target
	}
	
	public var isActive: Bool {
		get { constraints.isActive }
		nonmutating set {
			constraints.isActive = newValue
		}
	}
	
}
