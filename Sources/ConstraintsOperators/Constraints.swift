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
	public let item: Item?
	public lazy var constraints = block()
	
	static var empty: Constraints { Constraints() }
	
	private init() {
		block = { [] }
		item = nil
	}
	
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
	
	public var constant: CGFloat {
		get { constraints.constant }
		set {
			(item as? ConstraintProtocol)?.constant = newValue
			constraints.constant = newValue
		}
	}

	public func asLayoutableArray() -> [UILayoutable] {
		if let layoutable = self as? UILayoutable {
			return [layoutable]
		}
		return item?.asLayoutableArray() ?? []
	}
	
	func apply() -> Constraints {
		_ = constraints
		return self
	}
	
}

extension Constraints: UILayoutable where Item: UILayoutable {
	public var itemForConstraint: Any { item?.itemForConstraint as Any }
}

extension Constraints: UITypedLayoutableArray where Item: UITypedLayoutableArray {
	public typealias Layoutable = Item.Layoutable
	public var layoutable: Item.Layoutable { item?.layoutable ?? Item.Layoutable.init() }
}

extension Optional: UILayoutableArray where Wrapped: UILayoutableArray {
	public func asLayoutableArray() -> [UILayoutable] {
		self?.asLayoutableArray() ?? []
	}
}

extension UIView {
	
	
}
