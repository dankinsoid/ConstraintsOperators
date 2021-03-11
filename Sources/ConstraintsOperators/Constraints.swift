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
	public var target: Constraints { self }
	public let item: Item?
	public var constraints: [NSLayoutConstraint] {
		onlyConstraints.constraints
	}
	public let onlyConstraints: OnlyConstraints
	
	public static var empty: Constraints { Constraints() }
	
	private init() {
		onlyConstraints = OnlyConstraints()
		item = nil
	}
	
	public init(_ constraint: @autoclosure @escaping () -> NSLayoutConstraint, item target: Item) {
		onlyConstraints = OnlyConstraints { [constraint()] }
		self.item = target
	}
	
	public init(_ constraints: @autoclosure @escaping () -> [NSLayoutConstraint], item target: Item) {
		onlyConstraints = OnlyConstraints(constraints)
		self.item = target
	}
	
	public init(_ constraints: @escaping () -> [NSLayoutConstraint], item target: Item) {
		onlyConstraints = OnlyConstraints(constraints)
		self.item = target
	}
	
	public var isActive: Bool {
		get { onlyConstraints.isActive }
		set {
			(item as? ConstraintProtocol)?.isActive = newValue
			onlyConstraints.isActive = newValue
		}
	}
	
	public var priority: UILayoutPriority {
		get { onlyConstraints.priority }
		set {
			(item as? ConstraintProtocol)?.priority = newValue
			onlyConstraints.priority = newValue
		}
	}
	
	public var constant: CGFloat {
		get { onlyConstraints.constant }
		set {
			(item as? ConstraintProtocol)?.constant = newValue
			onlyConstraints.constant = newValue
		}
	}

	public func update(_ constraints: Constraints) {
		onlyConstraints.update(constraints.onlyConstraints)
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
	
	public final class OnlyConstraints {
		private var block: () -> [NSLayoutConstraint]
		private var _constraints: [NSLayoutConstraint]?
		public var constraints: [NSLayoutConstraint] {
			let result = _constraints ?? block()
			if _constraints == nil {
				_constraints = result
			}
			return result
		}
		
		static var empty: Constraints { Constraints() }
		
		fileprivate init() {
			block = { [] }
		}
		
		public init(_ constraints: @escaping () -> [NSLayoutConstraint]) {
			self.block = constraints
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
		
		public var constant: CGFloat {
			get { constraints.constant }
			set {
				constraints.constant = newValue
			}
		}
		
		public func update(_ constraints: OnlyConstraints) {
			if let current = _constraints {
				let isActive = current.isActive
				current.isActive = false
				constraints.isActive = isActive
			}
			block = constraints.block
			_constraints = constraints._constraints
		}
		
		func apply() {
			_ = constraints
		}
	}
}

extension Constraints: UILayoutable where Item: UILayoutable {
	public var itemForConstraint: ConstraintItem { ConstraintItem(item?.itemForConstraint) }
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
