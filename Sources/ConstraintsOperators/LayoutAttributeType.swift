//
//  File.swift
//  
//
//  Created by Данил Войдилов on 17.02.2021.
//

import UIKit

public struct LayoutAttributeInfo<T, L: UILayoutableArray, A: AttributeConvertable> {
	
	public var first: LayoutAttribute<T, L, A>?
	public var relation: NSLayoutConstraint.Relation
	public var location: (String, UInt)?
	
	public init(first: LayoutAttribute<T, L, A>?, relation: NSLayoutConstraint.Relation, location: (String, UInt)?) {
		self.first = first
		self.relation = relation
		self.location = location
	}
}

public protocol LayoutAttributeType {
	associatedtype Attribute
	func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L>
}

extension LayoutAttribute: LayoutAttributeType where K == NSLayoutConstraint.Attribute {
	public typealias Attribute = A
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		guard let first = info.first else { return .empty }
		return Constraints(
			{
				let result = ConstraintsBuilder.make(item: first.item.asLayoutableArray(), attribute: first.type.attributes, relatedBy: info.relation, toItem: self.item.asLayoutableArray(), attribute: self.type, multiplier: self.multiplier / first.multiplier, constant: self.constant - first.constant, location: info.location)
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
	
	func _constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		guard let first = info.first else { return .empty }
		return Constraints(
			{
				let result = ConstraintsBuilder.makeToView(item: first.item.asLayoutableArray(), attribute: first.type.attributes, relatedBy: info.relation, itemTo: self.asLayoutableArray(), multiplier: 1 / first.multiplier, constant: -first.constant, location: info.location)
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

	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		_constraints(with: info)
	}

}

extension UILayoutGuide: LayoutAttributeType {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		_constraints(with: info)
	}
	
}

extension Optional: LayoutAttributeType where Wrapped: LayoutAttributeType {
	public typealias Attribute = Wrapped.Attribute
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		self?.constraints(with: info) ?? .empty
	}
}

extension CGFloat: LayoutAttributeType {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		guard let first = info.first else { return .empty }
		return Constraints(
			{
				let result = ConstraintsBuilder.makeWithOffset(item: first.item.asLayoutableArray(), attribute: first.type.attributes, relatedBy: info.relation, multiplier: first.multiplier, constant: first.constant, offset: self, location: info.location)
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
	
	func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		guard let first = info.first, L.self == A.self else { return .empty }
		return Constraints(
			{
				((first.item as? A)?.layoutable ?? (first.item as? A.Layoutable))
					.map { self.attribute($0).constraints(with: info).constraints } ?? []
			},
			item: first.item
		)
	}
	
}

extension Double: LayoutAttributeType {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		CGFloat(self).constraints(with: info)
	}
}

extension Int: LayoutAttributeType {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		CGFloat(self).constraints(with: info)
	}
	
}

extension ClosedRange: LayoutAttributeType where Bound: BinaryFloatingPoint {
	public typealias Attribute = Attributes.Same
	
	public func constraints<B, L: UILayoutableArray, Q: AttributeConvertable>(with info: LayoutAttributeInfo<B, L, Q>) -> Constraints<L> {
		guard let first = info.first else { return .empty }
		switch info.relation {
		case .greaterThanOrEqual: return CGFloat(upperBound).constraints(with: info)
		case .lessThanOrEqual:    return CGFloat(lowerBound).constraints(with: info)
		case .equal: 							return Constraints(
			{
				CGFloat(lowerBound).constraints(with: .init(first: first, relation: .greaterThanOrEqual, location: info.location)).constraints +
				CGFloat(upperBound).constraints(with: .init(first: first, relation: .lessThanOrEqual, location: info.location)).constraints
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
