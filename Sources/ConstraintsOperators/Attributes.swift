//
//  Attributes.swift
//  TestPr
//
//  Created by crypto_user on 10/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

public protocol Attributable {
    associatedtype B: ConstraintsCreator
    var target: B.First { get }
}

public protocol AttributeConvertable {
    init(_ attribute: NSLayoutConstraint.Attribute)
}

extension NSLayoutConstraint.Attribute: AttributeConvertable {
    public init(_ attribute: NSLayoutConstraint.Attribute) {
        self = attribute
    }
}

extension Array: AttributeConvertable where Element == NSLayoutConstraint.Attribute {
    public init(_ attribute: NSLayoutConstraint.Attribute) {
        self = [attribute]
    }
}

protocol ItemedType {
    associatedtype T
    var item: T { get }
}

public struct LayoutAttribute<A, C: ConstraintsCreator> {
    var type: C.A//NSLayoutConstraint.Attribute
    var item: C.First
    var constant: CGFloat
    var multiplier: CGFloat
    var priority: UILayoutPriority
    var isActive = true
    //var _attributes: [NSLayoutConstraint.Attribute]
    
    init(type: C.A, item: C.First, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required, isActive: Bool = true) {
        self.type = type
        self.item = item
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
//        self._attributes = [type] + ((item as? AttributesConvertable)?._attributes ?? [])
    }
    
    func asAny() -> LayoutAttribute<Void, C> {
        return LayoutAttribute<Void, C>(type: type, item: item, constant: constant, multiplier: multiplier, priority: priority, isActive: isActive)
    }
    
    public func priority(_ _priority: UILayoutPriority) -> LayoutAttribute {
        return map(\.priority, _priority)
    }
    
    public func priority(_ _priority: Float) -> LayoutAttribute {
        return priority(UILayoutPriority(_priority))
    }
    
    public var deactivated: LayoutAttribute {
        return map(\.isActive, false)
    }
    
    func type(_ _type: C.A) -> LayoutAttribute {
        return map(\.type, _type)
    }
    
    func map<R>(_ keyPath: WritableKeyPath<LayoutAttribute, R>, _ value: R) -> LayoutAttribute {
        var result = self
        result[keyPath: keyPath] = value
        return result
    }
    
    func asType<T>(_ _type: T.Type) -> LayoutAttribute<T, C> {
        return LayoutAttribute<T, C>(type: type, item: item, constant: constant, multiplier: multiplier, priority: priority, isActive: isActive)
    }
    
}

public typealias EdgeAttribute = LayoutAttribute<AttributeType.Edges, ConstraintsBuilder>
public typealias SizeAttribute = LayoutAttribute<AttributeType.Size, ConstraintsBuilder>

extension Attributable {
    public var width:                LayoutAttribute<AttributeType.Size, B> { return LayoutAttribute(type: B.A(.width), item: target) }
    public var height:               LayoutAttribute<AttributeType.Size, B> { return LayoutAttribute(type: B.A(.height), item: target) }
    
    public var top:                  LayoutAttribute<AttributeType.Vertical, B> { return LayoutAttribute(type: B.A(.top), item: target) }
    public var bottom:               LayoutAttribute<AttributeType.Vertical, B> { return LayoutAttribute(type: B.A(.bottom), item: target) }
    public var lastBaseline:         LayoutAttribute<AttributeType.Vertical, B> { return LayoutAttribute(type: B.A(.lastBaseline), item: target) }
    public var firstBaseline:        LayoutAttribute<AttributeType.Vertical, B> { return LayoutAttribute(type: B.A(.firstBaseline), item: target) }
    public var topMargin:            LayoutAttribute<AttributeType.Vertical, B> { return LayoutAttribute(type: B.A(.topMargin), item: target) }
    public var bottomMargin:         LayoutAttribute<AttributeType.Vertical, B> { return LayoutAttribute(type: B.A(.bottomMargin), item: target) }
    
    public var leading:              LayoutAttribute<AttributeType.LeadTrail, B> { return LayoutAttribute(type: B.A(.leading), item: target) }
    public var trailing:             LayoutAttribute<AttributeType.LeadTrail, B> { return LayoutAttribute(type: B.A(.trailing), item: target) }
    public var leadingMargin:        LayoutAttribute<AttributeType.LeadTrail, B> { return LayoutAttribute(type: B.A(.leadingMargin), item: target) }
    public var trailingMargin:       LayoutAttribute<AttributeType.LeadTrail, B> { return LayoutAttribute(type: B.A(.trailingMargin), item: target) }
    
    public var left:                 LayoutAttribute<AttributeType.LeftRight, B> { return LayoutAttribute(type: B.A(.left), item: target) }
    public var right:                LayoutAttribute<AttributeType.LeftRight, B> { return LayoutAttribute(type: B.A(.right), item: target) }
    public var leftMargin:           LayoutAttribute<AttributeType.LeftRight, B> { return LayoutAttribute(type: B.A(.leftMargin), item: target) }
    public var rightMargin:          LayoutAttribute<AttributeType.LeftRight, B> { return LayoutAttribute(type: B.A(.rightMargin), item: target) }
    
    public var centerX:              LayoutAttribute<AttributeType.CenterX, B>  { return LayoutAttribute(type: B.A(.centerX), item: target) }
    public var centerY:              LayoutAttribute<AttributeType.Vertical, B> { return LayoutAttribute(type: B.A(.centerY), item: target) }
    public var centerXWithinMargins: LayoutAttribute<AttributeType.CenterX, B>  { return LayoutAttribute(type: B.A(.centerXWithinMargins), item: target) }
    public var centerYWithinMargins: LayoutAttribute<AttributeType.Vertical, B> { return LayoutAttribute(type: B.A(.centerYWithinMargins), item: target) }
    
    func attribute<T>(as other: LayoutAttribute<T, B>) -> LayoutAttribute<T, B> {
        return LayoutAttribute(type: other.type, item: target)
    }
    
    func attribute<T>(type: NSLayoutConstraint.Attribute) -> LayoutAttribute<T, B> {
        return LayoutAttribute(type: B.A(type), item: target)
    }
    
}

extension Attributable where B.First == [UILayoutable] {
    
    public func edges(_ edges: Edge.Set = .all) -> EdgeAttribute {
        return EdgeAttribute(type: edges.attributes, item: target)
    }
    
    public var size: SizeAttribute {
        return SizeAttribute(type: [.width, .height], item: target)
    }
    
}

extension Attributable where B.First == UILayoutable {
    
    public func edges(_ edges: Edge.Set = .all) -> SizeAttribute {
        return SizeAttribute(type: edges.attributes, item: [target])
    }
    
    public var size: SizeAttribute {
        return SizeAttribute(type: [.width, .height], item: [target])
    }
    
}

public enum AttributeType {
    public enum LeadTrail: CenterXAttributeCompatible, HorizontalLayoutableAttribute {}
    public enum LeftRight: CenterXAttributeCompatible {}
    public enum CenterX: HorizontalLayoutableAttribute {}
    public enum Vertical {}
    public enum Size {}
    public enum Edges {}
}
