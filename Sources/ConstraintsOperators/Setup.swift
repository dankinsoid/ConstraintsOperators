//
//  Setup.swift
//  TestPr
//
//  Created by crypto_user on 11/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

func _setup<A, D, C: UILayoutableArray, K: UILayoutableArray, T: AttributeConvertable>(_ lhs: LayoutAttribute<A, C, T>?, _ rhs: LayoutAttribute<D, K, NSLayoutConstraint.Attribute>?, relation: NSLayoutConstraint.Relation) -> Constraints<C>? {
    guard let l = lhs, let r = rhs else {
        return nil
    }
    return setup(l, r, relation: relation)
}

func setup<A, D, C: UILayoutableArray, K: UILayoutableArray, T: AttributeConvertable>(_ lhs: LayoutAttribute<A, C, T>, _ rhs: LayoutAttribute<D, K, NSLayoutConstraint.Attribute>, relation: NSLayoutConstraint.Relation) -> Constraints<C> {
	Constraints(
		{
			let result = ConstraintsBuilder.make(item: lhs.item.asLayoutableArray(), attribute: lhs.type.attributes, relatedBy: relation, toItem: rhs.item.asLayoutableArray(), attribute: rhs.type, multiplier: rhs.multiplier / lhs.multiplier, constant: rhs.constant - lhs.constant)
			result.priority = min(lhs.priority, rhs.priority)
			let active = lhs.isActive && rhs.isActive
			if active {
				removeConflicts(with: result)
			}
			result.isActive = active
			return result
		},
		item: lhs.item
	)
}

func _setup<A, C: UILayoutableArray, T: AttributeConvertable, V: UILayoutableArray>(_ lhs: LayoutAttribute<A, C, T>?, _ rhs: V?, relation: NSLayoutConstraint.Relation) -> Constraints<C>? {
    guard let l = lhs, let r = rhs else { return nil }
    return setup(l, r, relation: relation)
}

func setup<A, C: UILayoutableArray, T: AttributeConvertable, V: UILayoutableArray>(_ lhs: LayoutAttribute<A, C, T>, _ rhs: V, relation: NSLayoutConstraint.Relation) -> Constraints<C> {
	Constraints(
		{
			let result = ConstraintsBuilder.makeToView(item: lhs.item.asLayoutableArray(), attribute: lhs.type.attributes, relatedBy: relation, itemTo: rhs.asLayoutableArray(), multiplier: 1 / lhs.multiplier, constant: -lhs.constant)
			result.priority = lhs.priority
			let active = lhs.isActive
			if active {
				removeConflicts(with: result)
			}
			result.isActive = active
			return result
		},
		item: lhs.item
	)
}

func removeConflicts(with constraint: [NSLayoutConstraint]) {
    let constraints = ConstraintsBuilder.constraints(for: constraint)
    constraints.filter({ ConstraintsBuilder.willConflict(constraint, with: $0) }).forEach {
        $0.isActive = false
    }
}

func _setup<N, C: UILayoutableArray, T: AttributeConvertable>(_ lhs: LayoutAttribute<N, C, T>?, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> Constraints<C>? {
    guard let l = lhs else { return nil }
    return setup(l, rhs, relation: relation)
}

func setup<N, C: UILayoutableArray, T: AttributeConvertable>(_ lhs: LayoutAttribute<N, C, T>, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> Constraints<C> {
	Constraints(
		{
			let result = ConstraintsBuilder.makeWithOffset(item: lhs.item.asLayoutableArray(), attribute: lhs.type.attributes, relatedBy: relation, multiplier: lhs.multiplier, constant: lhs.constant, offset: rhs)
			let active = lhs.isActive
			result.priority = lhs.priority
			if active {
				removeConflicts(with: result)
			}
			result.isActive = active
			return result
		},
		item: lhs.item
	)
}
