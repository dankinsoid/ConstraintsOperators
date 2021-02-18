//
//  ConvienceLayout.swift
//  TestPr
//
//  Created by crypto_user on 11/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

public protocol UILayoutable: UILayoutableArray {
	var itemForConstraint: Any { get }
}

public protocol UILayoutableArray {
	func asLayoutableArray() -> [UILayoutable]
}

public protocol EmptyInitable {
	init()
}

public protocol UITypedLayoutableArray {
	associatedtype Layoutable: UILayoutableArray & EmptyInitable
	var layoutable: Layoutable { get }
}

extension UILayoutable {
	public func asLayoutableArray() -> [UILayoutable] {
		[self]
	}
}

extension UILayoutable {
	var view: UIView? {
		(itemForConstraint as? UIView) ?? (itemForConstraint as? UILayoutGuide)?.owningView
	}
}

extension UIView: UILayoutable, Attributable, UITypedLayoutableArray, EmptyInitable {
	public typealias Att = NSLayoutConstraint.Attribute
	public var target: UIView { self }
	public var itemForConstraint: Any { self }
	public var layoutable: UIView { self }
	@available(iOS 11.0, *)
	public var safeArea: UILayoutGuide { safeAreaLayoutGuide }
}

extension Array where Element: UIView {
    @available(iOS 11.0, *)
    public var safeArea: [UILayoutGuide] { map({ $0.safeAreaLayoutGuide }) }
}

extension UILayoutGuide: UILayoutable, Attributable, UITypedLayoutableArray, EmptyInitable {
	public typealias Att = NSLayoutConstraint.Attribute
	public var target: UILayoutGuide { self }
	public var itemForConstraint: Any { self }
	public var layoutable: UILayoutGuide { self }
}

public struct ConvienceLayout<Item: UILayoutableArray, Att: AttributeConvertable>: UILayoutableArray, Attributable {
	public let target: Item
	init(_ item: Item) { target = item }
	public func asLayoutableArray() -> [UILayoutable] {
		target.asLayoutableArray()
	}
}

extension ConvienceLayout: UITypedLayoutableArray where Item: UITypedLayoutableArray {
	public var layoutable: Item.Layoutable { target.layoutable }
}

extension Array: UILayoutableArray, EmptyInitable where Element: UILayoutable {
	public func asLayoutableArray() -> [UILayoutable] {
		self
	}
}

extension Array: UITypedLayoutableArray where Element: UILayoutable {
	public typealias Layoutable = [Element]
	public var layoutable: [Element] { self }
}

extension Array: Attributable where Element: UILayoutable & Attributable & UITypedLayoutableArray {
	public typealias Att = Element.Att
	public var target: [Element] { self }
}

extension Attributable where Target: UILayoutableArray {
    
    public subscript(_ attributes: NSLayoutConstraint.Attribute...) -> LayoutAttribute<Void, Target, [NSLayoutConstraint.Attribute]> {
        return self[attributes]
    }
    
    public subscript(_ attributes: [NSLayoutConstraint.Attribute]) -> LayoutAttribute<Void, Target, [NSLayoutConstraint.Attribute]> {
        return LayoutAttribute(type: attributes, item: target)
    }
    
    public func ignoreAutoresizingMask() {
			target.asLayoutableArray().compactMap { $0.itemForConstraint as? UIView }.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
}
