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

public struct LayoutAttribute<A, I, C: ConstraintsCreator> {
    var type: C.A//NSLayoutConstraint.Attribute
    var item: I
    var constant: CGFloat
    var multiplier: CGFloat
    var priority: UILayoutPriority
    var isActive = true
    //var _attributes: [NSLayoutConstraint.Attribute]
    
    init(type: C.A, item: I, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required, isActive: Bool = true) {
        self.type = type
        self.item = item
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
//        self._attributes = [type] + ((item as? AttributesConvertable)?._attributes ?? [])
    }
    
    func asAny() -> LayoutAttribute<Void, I, C> {
        return LayoutAttribute<Void, I, C>(type: type, item: item, constant: constant, multiplier: multiplier, priority: priority, isActive: isActive)
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
    
    func asType<T>(_ _type: T.Type) -> LayoutAttribute<T, I, C> {
        return LayoutAttribute<T, I, C>(type: type, item: item, constant: constant, multiplier: multiplier, priority: priority, isActive: isActive)
    }
    
}

public typealias Attribute<A, C> = LayoutAttribute<A, C.First, C> where C: ConstraintsCreator
typealias Attribute2<A, C> = LayoutAttribute<A, C.Second, C> where C: ConstraintsCreator
public typealias EdgeAttribute = LayoutAttribute<AttributeType.Edges, [UILayoutable], ConstraintsBuilder>
public typealias SizeAttribute = LayoutAttribute<AttributeType.Size, [UILayoutable], ConstraintsBuilder>

extension Attributable {
    public var width:                Attribute<AttributeType.Size, B> { return Attribute(type: B.A(.width), item: target) }
    public var height:               Attribute<AttributeType.Size, B> { return Attribute(type: B.A(.height), item: target) }
    
    public var top:                  Attribute<AttributeType.Vertical, B> { return Attribute(type: B.A(.top), item: target) }
    public var bottom:               Attribute<AttributeType.Vertical, B> { return Attribute(type: B.A(.bottom), item: target) }
    public var lastBaseline:         Attribute<AttributeType.Vertical, B> { return Attribute(type: B.A(.lastBaseline), item: target) }
    public var firstBaseline:        Attribute<AttributeType.Vertical, B> { return Attribute(type: B.A(.firstBaseline), item: target) }
    public var topMargin:            Attribute<AttributeType.Vertical, B> { return Attribute(type: B.A(.topMargin), item: target) }
    public var bottomMargin:         Attribute<AttributeType.Vertical, B> { return Attribute(type: B.A(.bottomMargin), item: target) }
    
    public var leading:              Attribute<AttributeType.LeadTrail, B> { return Attribute(type: B.A(.leading), item: target) }
    public var trailing:             Attribute<AttributeType.LeadTrail, B> { return Attribute(type: B.A(.trailing), item: target) }
    public var leadingMargin:        Attribute<AttributeType.LeadTrail, B> { return Attribute(type: B.A(.leadingMargin), item: target) }
    public var trailingMargin:       Attribute<AttributeType.LeadTrail, B> { return Attribute(type: B.A(.trailingMargin), item: target) }
    
    public var left:                 Attribute<AttributeType.LeftRight, B> { return Attribute(type: B.A(.left), item: target) }
    public var right:                Attribute<AttributeType.LeftRight, B> { return Attribute(type: B.A(.right), item: target) }
    public var leftMargin:           Attribute<AttributeType.LeftRight, B> { return Attribute(type: B.A(.leftMargin), item: target) }
    public var rightMargin:          Attribute<AttributeType.LeftRight, B> { return Attribute(type: B.A(.rightMargin), item: target) }
    
    public var centerX:              Attribute<AttributeType.CenterX, B>  { return Attribute(type: B.A(.centerX), item: target) }
    public var centerY:              Attribute<AttributeType.Vertical, B> { return Attribute(type: B.A(.centerY), item: target) }
    public var centerXWithinMargins: Attribute<AttributeType.CenterX, B>  { return Attribute(type: B.A(.centerXWithinMargins), item: target) }
    public var centerYWithinMargins: Attribute<AttributeType.Vertical, B> { return Attribute(type: B.A(.centerYWithinMargins), item: target) }
    
    func attribute<T>(as other: Attribute<T, B>) -> Attribute<T, B> {
        return Attribute(type: other.type, item: target)
    }
    
    func attribute<T>(type: NSLayoutConstraint.Attribute) -> Attribute<T, B> {
        return Attribute(type: B.A(type), item: target)
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
