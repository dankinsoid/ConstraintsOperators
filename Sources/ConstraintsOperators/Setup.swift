//
//  Setup.swift
//  TestPr
//
//  Created by crypto_user on 11/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

func _setup<A, D, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<A, C>?, _ rhs: LayoutAttribute<D, K>?, relation: NSLayoutConstraint.Relation) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    guard let l = lhs, let r = rhs else {
        return nil
    }
    return setup(l, r, relation: relation)
}

func setup<A, D, C: ConstraintsCreator, K: ConstraintsCreator>(_ lhs: LayoutAttribute<A, C>, _ rhs: LayoutAttribute<D, K>, relation: NSLayoutConstraint.Relation) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
    let result = C.make(item: lhs.item, attribute: lhs.type, relatedBy: relation, toItem: rhs.item, attribute: rhs.type, multiplier: rhs.multiplier / lhs.multiplier, constant: rhs.constant - lhs.constant)
    result.priority = min(lhs.priority, rhs.priority)
    let active = lhs.isActive && rhs.isActive
    if active {
        removeConflicts(C.self, with: result)
    }
    result.isActive = active
    return result
}

func _setup<A, C: ConstraintsCreator>(_ lhs: LayoutAttribute<A, C>?, _ rhs: C.Second?, relation: NSLayoutConstraint.Relation) -> C.Constraint? where C.Second: UILayoutable {
    guard let l = lhs, let r = rhs else { return nil }
    return setup(l, r, relation: relation)
}

func setup<A, C: ConstraintsCreator>(_ lhs: LayoutAttribute<A, C>, _ rhs: C.Second, relation: NSLayoutConstraint.Relation) -> C.Constraint where C.Second: UILayoutable {
    let result = C.makeToView(item: lhs.item, attribute: lhs.type, relatedBy: relation, itemTo: rhs, multiplier: 1 / lhs.multiplier, constant: -lhs.constant)
    result.priority = lhs.priority
    let active = lhs.isActive
    if active {
        removeConflicts(C.self, with: result)
    }
    result.isActive = active
    return result
}

func removeConflicts<C: ConstraintsCreator>(_ lhs: C.Type, with constraint: C.Constraint) {
    let constraints = C.constraints(for: constraint)
    constraints.filter({ C.willConflict(constraint, with: $0) }).forEach {
        $0.isActive = false
    }
}

func _setup<N, C: ConstraintsCreator>(_ lhs: LayoutAttribute<N, C>?, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> C.Constraint? {
    guard let l = lhs else { return nil }
    return setup(l, rhs, relation: relation)
}

func setup<N, C: ConstraintsCreator>(_ lhs: LayoutAttribute<N, C>, _ rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> C.Constraint {
    let result = C.makeWithOffset(item: lhs.item, attribute: lhs.type, relatedBy: relation, multiplier: lhs.multiplier, constant: lhs.constant, offset: rhs)
    let active = lhs.isActive
    result.priority = lhs.priority
    if active {
        removeConflicts(C.self, with: result)
    }
    result.isActive = active
    return result
}
