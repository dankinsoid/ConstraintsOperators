//
//  File.swift
//  
//
//  Created by Данил Войдилов on 17.02.2021.
//

import UIKit

public protocol LayoutAttributeType {
	associatedtype Attribute
	func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L>
}

extension LayoutAttribute: LayoutAttributeType where K == NSLayoutConstraint.Attribute {
	public typealias Attribute = A
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		guard let first = first else { return .empty }
		return Constraints(
			{
				let result = ConstraintsBuilder.make(item: first.item.asLayoutableArray(), attribute: first.type.attributes, relatedBy: relation, toItem: self.item.asLayoutableArray(), attribute: self.type, multiplier: self.multiplier / first.multiplier, constant: self.constant - first.constant)
				result.priority = min(first.priority, self.priority)
				let active = first.isActive && self.isActive
				if active {
					removeConflicts(with: result)
				}
				result.isActive = active
				return result
			},
			item: first.item
		)
	}
	
}

extension UILayoutable {
	
	func _constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		guard let first = first else { return .empty }
		return Constraints(
			{
				let result = ConstraintsBuilder.makeToView(item: first.item.asLayoutableArray(), attribute: first.type.attributes, relatedBy: relation, itemTo: self.asLayoutableArray(), multiplier: 1 / first.multiplier, constant: -first.constant)
				result.priority = first.priority
				let active = first.isActive
				if active {
					removeConflicts(with: result)
				}
				result.isActive = active
				return result
			},
			item: first.item
		)
	}
	
}

extension UIView: LayoutAttributeType {
	public typealias Attribute = Attributes.Same

	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		_constraints(with: first, relation: relation)
	}

}

extension UILayoutGuide: LayoutAttributeType {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		_constraints(with: first, relation: relation)
	}
	
}

extension Optional: LayoutAttributeType where Wrapped: LayoutAttributeType {
	public typealias Attribute = Wrapped.Attribute
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		self?.constraints(with: first, relation: relation) ?? .empty
	}
}

extension CGFloat: LayoutAttributeType {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		guard let first = first else { return .empty }
		return Constraints(
			{
				let result = ConstraintsBuilder.makeWithOffset(item: first.item.asLayoutableArray(), attribute: first.type.attributes, relatedBy: relation, multiplier: first.multiplier, constant: first.constant, offset: self)
				let active = first.isActive
				result.priority = first.priority
				if active {
					removeConflicts(with: result)
				}
				result.isActive = active
				return result
			},
			item: first.item
		)
	}
}

struct LazyLayoutAttribute<A: UITypedLayoutableArray, C: LayoutAttributeType>: LayoutAttributeType {
	public typealias Attribute = C.Attribute
	let attribute: (A.Layoutable) -> C
	
	func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		guard let first = first, L.self == A.self else { return .empty }
		return Constraints(
			{
				((first.item as? A)?.layoutable ?? (first.item as? A.Layoutable))
					.map { self.attribute($0).constraints(with: first, relation: relation).constraints } ?? []
			},
			item: first.item
		)
	}
	
}

extension Double: LayoutAttributeType {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		CGFloat(self).constraints(with: first, relation: relation)
	}
}

extension Int: LayoutAttributeType {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		CGFloat(self).constraints(with: first, relation: relation)
	}
	
}

extension ClosedRange: LayoutAttributeType where Bound: BinaryFloatingPoint {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with first: LayoutAttribute<B, L, Q>?, relation: NSLayoutConstraint.Relation) -> Constraints<L> {
		guard let first = first else { return .empty }
		switch relation {
		case .greaterThanOrEqual: return CGFloat(upperBound).constraints(with: first, relation: relation)
		case .lessThanOrEqual:    return CGFloat(lowerBound).constraints(with: first, relation: relation)
		case .equal: 							return Constraints(
			{
				CGFloat(lowerBound).constraints(with: first, relation: .greaterThanOrEqual).constraints +
				CGFloat(upperBound).constraints(with: first, relation: .lessThanOrEqual).constraints
			},
			item: first.item
		)
		@unknown default:					return Constraints([], item: first.item)
		}
	}
	
}

func removeConflicts(with constraint: [NSLayoutConstraint]) {
	let constraints = ConstraintsBuilder.constraints(for: constraint)
	constraints.filter({ ConstraintsBuilder.willConflict(constraint, with: $0) }).forEach {
		$0.isActive = false
	}
}
