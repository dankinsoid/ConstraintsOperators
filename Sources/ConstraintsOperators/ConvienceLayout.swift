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

extension UILayoutable {
	public func asLayoutableArray() -> [UILayoutable] {
		[self]
	}
}

extension UIView: UILayoutable, Attributable {
    public typealias B = ConstraintBuilder<UIView>
    public var target: UIView { self }
		public var itemForConstraint: Any { self }
    
    @available(iOS 11.0, *)
    public var safeArea: UILayoutGuide { safeAreaLayoutGuide }
}

extension Array where Element: UIView {
    @available(iOS 11.0, *)
    public var safeArea: [UILayoutGuide] { map({ $0.safeAreaLayoutGuide }) }
}

extension UILayoutGuide: UILayoutable, Attributable {
	public typealias B = ConstraintBuilder<UILayoutGuide>
    public var target: UILayoutGuide { self }
		public var itemForConstraint: Any { self }
}

public struct ConvienceLayout<B: ConstraintsCreator>: Attributable {
    public let target: B.First
    
    init(_ item: B.First) {
        target = item
    }
    
}

extension Array: Attributable where Element: UILayoutable {
    public typealias B = ConstraintsBuilder
    public var target: [UILayoutable] { self }
}

extension Attributable where B.First: UILayoutable {
    
    public subscript(_ attributes: NSLayoutConstraint.Attribute...) -> LayoutAttribute<Void, ConstraintsBuilder> {
        return self[attributes]
    }
    
    public subscript(_ attributes: [NSLayoutConstraint.Attribute]) -> LayoutAttribute<Void, ConstraintsBuilder> {
        return LayoutAttribute(type: attributes, item: [target])
    }
    
    public func ignoreAutoresizingMask() {
        (target as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
    }
    
}


extension Attributable where B.First == [UILayoutable] {
    
    public subscript(_ attributes: NSLayoutConstraint.Attribute...) -> LayoutAttribute<Void, ConstraintsBuilder> {
        return self[attributes]
    }
    
    public subscript(_ attributes: [NSLayoutConstraint.Attribute]) -> LayoutAttribute<Void, ConstraintsBuilder> {
        return LayoutAttribute(type: attributes, item: target)
    }
    
    public func ignoreAutoresizingMask() {
        target.compactMap { $0 as? UIView }.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
}
