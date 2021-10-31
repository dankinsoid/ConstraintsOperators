//
//  Attributes.swift
//  TestPr
//
//  Created by crypto_user on 10/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit
import VDUIKit

public struct LayoutAttribute<A, Item: UILayoutableArray, K: AttributeConvertable> {
    var type: K
    internal(set) public var item: Item
    var constant: CGFloat
    var multiplier: CGFloat
    var priority: UILayoutPriority
    var isActive = true
    var _ignoreSafeArea = false
    
    init(type: K, item: Item, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required, isActive: Bool = true) {
        self.type = type
        self.item = item
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
    }
    
//    public var ignoreSafeArea: LayoutAttribute {
//        return map(\._ignoreSafeArea, true)
//    }
    
    public func priority(_ _priority: UILayoutPriority) -> LayoutAttribute {
        return map(\.priority, _priority)
    }
    
    public func priority(_ _priority: Float) -> LayoutAttribute {
        return priority(UILayoutPriority(_priority))
    }
    
    public var deactivated: LayoutAttribute {
        return map(\.isActive, false)
    }
    
    func type(_ _type: K) -> LayoutAttribute {
        return map(\.type, _type)
    }
    
    func map<R>(_ keyPath: WritableKeyPath<LayoutAttribute, R>, _ value: R) -> LayoutAttribute {
        var result = self
        result[keyPath: keyPath] = value
        return result
    }
    
    func asType<T>(_ _type: T.Type) -> LayoutAttribute<T, Item, K> {
        LayoutAttribute<T, Item, K>(type: type, item: item, constant: constant, multiplier: multiplier, priority: priority, isActive: isActive)
    }
	
	
	func atts() -> LayoutAttribute<A, Item, [NSLayoutConstraint.Attribute]> {
		LayoutAttribute<A, Item, [NSLayoutConstraint.Attribute]>(type: type.attributes, item: item, constant: constant, multiplier: multiplier, priority: priority, isActive: isActive)
	}
	
}

public typealias EdgeAttribute<Item: UILayoutableArray> = LayoutAttribute<Attributes.Edges, Item, [NSLayoutConstraint.Attribute]>
public typealias SizeAttribute<Item: UILayoutableArray> = LayoutAttribute<Attributes.Size, Item, [NSLayoutConstraint.Attribute]>

public protocol Attributable {
	associatedtype Target: UILayoutableArray
	associatedtype Att: AttributeConvertable
	var target: Target { get }
}

public protocol AttributeConvertable {
	init(_ attribute: NSLayoutConstraint.Attribute)
	var attributes: [NSLayoutConstraint.Attribute] { get }
}

extension NSLayoutConstraint.Attribute: AttributeConvertable {
    public init(_ attribute: NSLayoutConstraint.Attribute) {
        self = attribute
    }
	public var attributes: [NSLayoutConstraint.Attribute] {
		[self]
	}
	
}

extension Array: AttributeConvertable where Element == NSLayoutConstraint.Attribute {
	
	public init(_ attribute: NSLayoutConstraint.Attribute) {
		self = [attribute]
	}
	
	public var attributes: [NSLayoutConstraint.Attribute] {
		self
	}
	
}

extension Attributable {
    public var width:                LayoutAttribute<Attributes.Size, Target, Att> { LayoutAttribute(type: Att(.width), item: target) }
    public var height:               LayoutAttribute<Attributes.Size, Target, Att> { LayoutAttribute(type: Att(.height), item: target) }
    
    public var top:                  LayoutAttribute<Attributes.Vertical, Target, Att> { LayoutAttribute(type: Att(.top), item: target) }
    public var bottom:               LayoutAttribute<Attributes.Vertical, Target, Att> { LayoutAttribute(type: Att(.bottom), item: target) }
    public var lastBaseline:         LayoutAttribute<Attributes.Vertical, Target, Att> { LayoutAttribute(type: Att(.lastBaseline), item: target) }
    public var firstBaseline:        LayoutAttribute<Attributes.Vertical, Target, Att> { LayoutAttribute(type: Att(.firstBaseline), item: target) }
    public var topMargin:            LayoutAttribute<Attributes.Vertical, Target, Att> { LayoutAttribute(type: Att(.topMargin), item: target) }
    public var bottomMargin:         LayoutAttribute<Attributes.Vertical, Target, Att> { LayoutAttribute(type: Att(.bottomMargin), item: target) }
    
    public var leading:              LayoutAttribute<Attributes.LeadTrail, Target, Att> { LayoutAttribute(type: Att(.leading), item: target) }
    public var trailing:             LayoutAttribute<Attributes.LeadTrail, Target, Att> { LayoutAttribute(type: Att(.trailing), item: target) }
    public var leadingMargin:        LayoutAttribute<Attributes.LeadTrail, Target, Att> { LayoutAttribute(type: Att(.leadingMargin), item: target) }
    public var trailingMargin:       LayoutAttribute<Attributes.LeadTrail, Target, Att> { LayoutAttribute(type: Att(.trailingMargin), item: target) }
    
    public var left:                 LayoutAttribute<Attributes.LeftRight, Target, Att> { LayoutAttribute(type: Att(.left), item: target) }
    public var right:                LayoutAttribute<Attributes.LeftRight, Target, Att> { LayoutAttribute(type: Att(.right), item: target) }
    public var leftMargin:           LayoutAttribute<Attributes.LeftRight, Target, Att> { LayoutAttribute(type: Att(.leftMargin), item: target) }
    public var rightMargin:          LayoutAttribute<Attributes.LeftRight, Target, Att> { LayoutAttribute(type: Att(.rightMargin), item: target) }
    
    public var centerX:              LayoutAttribute<Attributes.CenterX, Target, Att> { LayoutAttribute(type: Att(.centerX), item: target) }
    public var centerY:              LayoutAttribute<Attributes.Vertical, Target, Att> { LayoutAttribute(type: Att(.centerY), item: target) }
    public var centerXWithinMargins: LayoutAttribute<Attributes.CenterX, Target, Att> { LayoutAttribute(type: Att(.centerXWithinMargins), item: target) }
    public var centerYWithinMargins: LayoutAttribute<Attributes.Vertical, Target, Att> { LayoutAttribute(type: Att(.centerYWithinMargins), item: target) }
    
	
	public func edges(_ edges: Edges.Set = .all) -> EdgeAttribute<Target> {
		return EdgeAttribute(type: edges.attributes, item: target)
	}
	
	public var edges: EdgeAttribute<Target> { edges() }
	
	public var size: SizeAttribute<Target> {
		SizeAttribute(type: [.width, .height], item: target)
	}
	
	public var center: LayoutAttribute<Void, Target, [NSLayoutConstraint.Attribute]> {
		LayoutAttribute(type: [.centerX, .centerY], item: target)
	}
	
    func attribute<T>(as other: LayoutAttribute<T, Target, Att>) -> LayoutAttribute<T, Target, Att> {
        LayoutAttribute(type: other.type, item: target)
    }
    
    func attribute<T>(type: NSLayoutConstraint.Attribute) -> LayoutAttribute<T, Target, Att> {
        LayoutAttribute(type: Att(type), item: target)
    }

}

public protocol CenterXAttributeCompatible {}
public protocol HorizontalLayoutableAttribute {}

public enum Attributes {
    public enum LeadTrail: CenterXAttributeCompatible, HorizontalLayoutableAttribute {}
    public enum LeftRight: CenterXAttributeCompatible {}
    public enum CenterX: HorizontalLayoutableAttribute {}
    public enum Vertical {}
    public enum Size {}
    public enum Edges {}
		public enum Same {}
}

public struct AnyLayoutable: UILayoutable {
	public var itemForConstraint: ConstraintItem
}

extension UILayoutable {
	var any: AnyLayoutable {
		AnyLayoutable(itemForConstraint: itemForConstraint)
	}
}
