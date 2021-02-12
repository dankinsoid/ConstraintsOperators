//
//  File.swift
//  
//
//  Created by Данил Войдилов on 10.02.2021.
//

import UIKit

public final class Constraints<Item: UILayoutableArray>: Attributable, ConstraintProtocol, UILayoutableArray {
	public typealias Att = NSLayoutConstraint.Attribute
	private let block: () -> [NSLayoutConstraint]
	public let target: Item
	private(set) public lazy var constraints = block()
	
	init(_ constraint: @autoclosure @escaping () -> NSLayoutConstraint, item target: Item) {
		self.block = { [constraint()] }
		self.target = target
	}
	
	init(_ constraints: @autoclosure @escaping () -> [NSLayoutConstraint], item target: Item) {
		self.block = constraints
		self.target = target
	}
	
	init(_ constraints: @escaping () -> [NSLayoutConstraint], item target: Item) {
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
	
	public func asLayoutableArray() -> [UILayoutable] {
		target.asLayoutableArray()
	}
	
}

extension Constraints: UILayoutable where Item: UILayoutable {
	public var itemForConstraint: Any { target.itemForConstraint }
}
