//
//  File.swift
//  
//
//  Created by Данил Войдилов on 17.02.2021.
//

import UIKit

//struct SelfLayoutReference<Item: UILayoutable>: Attributable, UILayoutableArray {
//	typealias Att = NSLayoutConstraint.Attribute
//	let map: (UILayoutable) -> UILayoutable
//	var target: SelfLayoutReference { self }
//
//	public func asLayoutableArray(for other: UILayoutableArray?) -> [UILayoutable] {
//		guard let item = other else { return [] }
//		return item.asLayoutableArray(for: nil).map(map)
//	}
//}

//public protocol LayoutAttributeConvertable {
//	associatedtype A
//	associatedtype Item: UILayoutableArray
//	associatedtype K: AttributeConvertable
//	func attribute<B, L: UILayoutableArray, Q: AttributeConvertable>(for other: LayoutAttribute<B, L, Q>) -> LayoutAttribute<A, Item, K>
//}
//
//extension UIView: LayoutAttributeConvertable {
//
//	public func attribute<B, L: UILayoutableArray, Q: AttributeConvertable>(for other: LayoutAttribute<B, L, Q>) -> LayoutAttribute<NonAttribute, UIView, NSLayoutConstraint.Attribute> {
//		LayoutAttribute(type: other.type as! NSLayoutConstraint.Attribute, item: self, constant: 0, multiplier: 1, priority: other.priority, isActive: other.isActive)
//	}
//
//}
//
//public enum NonAttribute {}
