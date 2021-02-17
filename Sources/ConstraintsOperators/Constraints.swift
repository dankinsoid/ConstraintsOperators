//
//  File.swift
//  
//
//  Created by Данил Войдилов on 10.02.2021.
//

import UIKit

public final class Constraints<Item: UILayoutableArray>: Attributable, ConstraintProtocol, UILayoutableArray {
	public typealias Target = Constraints
	public typealias W = Item
	public typealias Att = NSLayoutConstraint.Attribute
	private let block: () -> [NSLayoutConstraint]
	public var target: Constraints { self }
	public let item: Item
	public lazy var constraints = block()
	
	init(_ constraint: @autoclosure @escaping () -> NSLayoutConstraint, item target: Item) {
		self.block = { [constraint()] }
		self.item = target
	}
	
	init(_ constraints: @autoclosure @escaping () -> [NSLayoutConstraint], item target: Item) {
		self.block = constraints
		self.item = target
	}
	
	init(_ constraints: @escaping () -> [NSLayoutConstraint], item target: Item) {
		self.block = constraints
		self.item = target
	}
	
	public var isActive: Bool {
		get { constraints.isActive }
		set {
			(item as? ConstraintProtocol)?.isActive = newValue
			constraints.isActive = newValue
		}
	}
	
	public var priority: UILayoutPriority {
		get { constraints.priority }
		set {
			(item as? ConstraintProtocol)?.priority = newValue
			constraints.priority = newValue
		}
	}

	public func asLayoutableArray(for other: UILayoutableArray?) -> [UILayoutable] {
		if let layoutable = self as? UILayoutable {
			return [layoutable]
		}
		return item.asLayoutableArray(for: other)
	}
	
	func apply() -> Constraints {
		_ = constraints
		return self
	}
	
}

extension Constraints: UILayoutable where Item: UILayoutable {
	public var itemForConstraint: Any { item.itemForConstraint }
}
