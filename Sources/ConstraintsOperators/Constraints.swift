//
//  File.swift
//  
//
//  Created by Данил Войдилов on 10.02.2021.
//

import UIKit

public final class Constraints<B: ConstraintsCreator>: Attributable, ConstraintProtocol {
	private let block: () -> [B.Constraint]
	public let target: B.First
	private(set) public lazy var constraints = block()
	
	init(_ constraint: @autoclosure @escaping () -> B.Constraint, item target: B.First) {
		self.block = { [constraint()] }
		self.target = target
	}
	
	init(_ constraints: @autoclosure @escaping () -> [B.Constraint], item target: B.First) {
		self.block = constraints
		self.target = target
	}
	
	init(_ constraints: @escaping () -> [B.Constraint], item target: B.First) {
		self.block = constraints
		self.target = target
	}
	
	public var isActive: Bool {
		get { constraints.isActive }
		set {
			constraints.isActive = newValue
		}
	}
	
	public var priority: UILayoutPriority {
		get { constraints.priority }
		set {
			constraints.priority = newValue
		}
	}
	
}

extension Constraints: UILayoutableArray where B.First: UILayoutableArray {
	public func asLayoutableArray() -> [AnyLayoutable] {
		target.asLayoutableArray()
	}
}

extension Constraints: UILayoutable where B.First: UILayoutable {
	public var itemForConstraint: Any { target.itemForConstraint }
}
