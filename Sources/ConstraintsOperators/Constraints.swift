//
//  File.swift
//  
//
//  Created by Данил Войдилов on 10.02.2021.
//

import UIKit
import VDKit

@dynamicMemberLookup
public final class Constraints<Item: UILayoutableArray>: Attributable, ConstraintProtocol, UILayoutableArray, ValueChainingProtocol {
	public typealias W = Item
	public typealias Att = NSLayoutConstraint.Attribute
	private let block: () -> [NSLayoutConstraint]
	public let target: Item
	public var wrappedValue: Item { target }
	private(set) public lazy var constraints = block()
	private(set) public var action: (Item) -> Item = { $0 }
	
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
		set { constraints.isActive = newValue }
	}
	
	public var priority: UILayoutPriority {
		get { constraints.priority }
		set { constraints.priority = newValue }
	}
	
	public func asLayoutableArray() -> [UILayoutable] {
		target.asLayoutableArray()
	}
	
	public func copy(with action: @escaping (Item) -> Item) -> Constraints {
		self.action = action
		return self
	}
	
	public subscript<A>(dynamicMember keyPath: KeyPath<W, A>) -> ChainingProperty<Constraints, A, KeyPath<W, A>> {
		ChainingProperty<Constraints, A, KeyPath<W, A>>(self, getter: keyPath)
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<W, A>) -> ChainingProperty<Constraints, A, WritableKeyPath<W, A>> {
		ChainingProperty<Constraints, A, WritableKeyPath<W, A>>(self, getter: keyPath)
	}
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<Constraints, A, ReferenceWritableKeyPath<W, A>> {
		ChainingProperty<Constraints, A, ReferenceWritableKeyPath<W, A>>(self, getter: keyPath)
	}
	
}

extension Constraints: UILayoutable where Item: UILayoutable {
	public var itemForConstraint: Any { target.itemForConstraint }
}
