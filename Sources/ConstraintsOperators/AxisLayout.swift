//
//  AxisLayout.swift
//  TestPr
//
//  Created by crypto_user on 11/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

public protocol LayoutValueProtocol {
    var _asLayoutValue: LayoutValue { get }
}
public protocol HorizontalLayoutableAttribute {}
public protocol HorizontalLayoutable: LayoutValueProtocol {}
public protocol VerticalLayoutable: LayoutValueProtocol {}
public typealias AxisLayoutable = VerticalLayoutable & HorizontalLayoutable

public struct ViewAndSize: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .view([self]) }
    fileprivate let view: UILayoutable
    
    fileprivate let size: LayoutValue.Number?
    fileprivate init(_ view: UILayoutable, _ size: LayoutValue.Number?) {
				self.view = view
        self.size = size
    }
    fileprivate func get(_ axe: NSLayoutConstraint.Axis) -> [NSLayoutConstraint]? {
        if let s = size {
            return view.setConstraint(axe, number: s)
        }
        return nil
    }
}

public enum LayoutValue: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return self }
    
    case view([ViewAndSize]), number(Number), attribute([AnyAttribute1])
    
    fileprivate var asNumber: Number? {
        if case .number(let n) = self { return n }
        return nil
    }
    
    fileprivate var asView: [ViewAndSize]? {
        if case .view(let n) = self { return n }
        return nil
    }
    
    public enum Number {
        case value(CGFloat), range(min: CGFloat?, max: CGFloat?)
        
        static func +(_ lhs: Number, _ rhs: Number) -> Number {
            switch (lhs, rhs) {
            case (.value(let l), .value(let r)):
                return .value(l + r)
            case (.value(let l), .range(let min, let max)):
                return .range(min: min == nil ? nil : min! + l, max: max == nil ? nil : max! + l)
            case (.range, .value):
                return rhs + lhs
            case (.range(let lmin, let lmax), .range(let rmin, let rmax)):
                var _min: CGFloat?
                if lmin != nil || rmin != nil {
                    _min = (lmin ?? 0) + (rmin ?? 0)
                }
                var _max: CGFloat?
                if lmax != nil || rmax != nil {
                    _max = (lmax ?? 0) + (rmax ?? 0)
                }
                return .range(min: _min, max: _max)
            }
        }
    }
}

extension CGFloat: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .number(.value(self)) }
}
extension Double: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .number(.value(CGFloat(self))) }
}
extension Int: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .number(.value(CGFloat(self))) }
}
extension UIView: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .view([ViewAndSize(self, nil)]) }
}
extension UILayoutGuide: AxisLayoutable {
    public var _asLayoutValue: LayoutValue { return .view([ViewAndSize(self, nil)]) }
}
extension UILayoutable {
    public func fixed(_ size: CGFloat) -> LayoutValue {
        return .view([ViewAndSize(self, .value(size))])
    }
    public func fixed(_ size: ClosedRange<CGFloat>) -> LayoutValue {
        return .view([ViewAndSize(self, .range(min: size.lowerBound, max: size.upperBound))])
    }
    public func fixed(_ size: PartialRangeThrough<CGFloat>) -> LayoutValue {
        return .view([ViewAndSize(self, .range(min: nil, max: size.upperBound))])
    }
    public func fixed(_ size: PartialRangeFrom<CGFloat>) -> LayoutValue {
        return .view([ViewAndSize(self, .range(min: size.lowerBound, max: nil))])
    }
    
//    public func fixed(_ size: LayoutAttribute<Attributes.Size, ConstraintBuilder>) -> LayoutValue {
//        return .attribute([size.asAny()])
//    }
}

extension ClosedRange: LayoutValueProtocol, AxisLayoutable where Bound == CGFloat {
    public var _asLayoutValue: LayoutValue { return .number(.range(min: lowerBound, max: upperBound)) }
}

extension PartialRangeThrough: LayoutValueProtocol, AxisLayoutable where Bound == CGFloat {
    public var _asLayoutValue: LayoutValue { return .number(.range(min: nil, max: upperBound)) }
}

extension PartialRangeFrom: LayoutValueProtocol, AxisLayoutable where Bound == CGFloat {
    public var _asLayoutValue: LayoutValue { return .number(.range(min: lowerBound, max: nil)) }
}

extension Array: LayoutValueProtocol, AxisLayoutable where Element == UILayoutable {
    public var _asLayoutValue: LayoutValue { return .view(map { ViewAndSize($0, nil) }) }
    
    public func fixed(_ size: CGFloat) -> LayoutValue {
        return .view(map { ViewAndSize($0, .value(size)) })
    }
    
//    public func fixed(_ size: LayoutAttribute<Attributes.Size, ConstraintBuilder>) -> LayoutValue {
//        return .attribute( map { size.map(\.item, $0).asAny() })
//    }
    
    public func fixed(_ size: ClosedRange<CGFloat>) -> LayoutValue {
        return .view(map { ViewAndSize($0, .range(min: size.lowerBound, max: size.upperBound)) })
    }
    public func fixed(_ size: PartialRangeThrough<CGFloat>) -> LayoutValue {
        return .view(map { ViewAndSize($0, .range(min: nil, max: size.upperBound)) })
    }
    public func fixed(_ size: PartialRangeFrom<CGFloat>) -> LayoutValue {
        return .view(map { ViewAndSize($0, .range(min: size.lowerBound, max: nil)) })
    }
    
}

public enum Axis {
    public static let vertical = VerticalAxe()
    public static let horizontal = HorizontalAxe()
    public struct VerticalAxe { fileprivate init() {} }
    public struct HorizontalAxe { fileprivate init() {} }
}

@discardableResult
public func =|(_ lhs: Axis.HorizontalAxe, _ rhs: [HorizontalLayoutable]) -> [NSLayoutConstraint] {
    return setByAxe(.horizontal, rhs)
}

@discardableResult
public func =|(_ lhs: Axis.VerticalAxe, _ rhs: [VerticalLayoutable]) -> [NSLayoutConstraint] {
    return setByAxe(.vertical, rhs)
}

fileprivate func setByAxe(_ lhs: NSLayoutConstraint.Axis, _ rhs: [LayoutValueProtocol]) -> [NSLayoutConstraint] {
    guard let first = rhs.first?._asLayoutValue else { return [] }
    guard rhs.count > 1 else {
        if case .view(let views) = first {
            return Array(views.compactMap({ $0.get(lhs) }).joined())
        }
        return []
    }
    var result: [NSLayoutConstraint] = []
    var last: [AnyAttribute1]?
    var offset: LayoutValue.Number?
    let prevAtt: NSLayoutConstraint.Attribute = lhs == .vertical ? .top : .leading
    let nextAtt: NSLayoutConstraint.Attribute = lhs == .vertical ? .bottom : .trailing
    for i in 0..<rhs.count {
        switch rhs[i]._asLayoutValue {
        case .view(let array):
					let next = array.map { AnyAttribute1(type: prevAtt, item: AnyLayoutable(itemForConstraint: $0.view.itemForConstraint)) }
            if let _last = last {
                result += set(next, _last, offset: offset ?? .value(0))
            } else if let value = offset {
							result += set(array.compactMap({ AnyLayoutable(itemForConstraint: $0.view.itemForConstraint).layout.attribute(type: prevAtt).atts() }), value: value, type: prevAtt)
            }
            let sizes = Array(array.compactMap({ $0.get(lhs) }).joined())
            result += sizes
            offset = nil
					last = array.map { .init(type: nextAtt, item: AnyLayoutable(itemForConstraint: $0.view.itemForConstraint)) }
        case .number(let number):
            offset = (offset ?? .value(0)) + number
        case .attribute(let array):
            if let _last = last {
                result += set(array, _last, offset: offset ?? .value(0))
            } else if let value = offset {
							result += set(array.map { $0.atts() }, value: value, type: prevAtt)
            }
            last = array
            offset = nil
        }
    }
    if let value = offset, let array = last {
			result += set(array.map { $0.atts() }, value: value, type: nextAtt)
    }
    return result
}


fileprivate func set(_ array: [AnyAttribute], value: LayoutValue.Number, type: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
    var result: [NSLayoutConstraint] = []
    array.forEach {
        guard let parent = $0.item.parent else { return }
				let att = AnyAttribute1(type: type, item: AnyLayoutable(itemForConstraint: parent.itemForConstraint))
        if type == .leading || type == .top {
					result += set([$0.item.layout.attribute(type: type)], [att], offset: value)
        } else {
            result += set([att], [$0.item.layout.attribute(type: type)], offset: value)
        }
    }
    return result
}

fileprivate func set(_ lhs: [AnyAttribute1], _ rhs: [AnyAttribute1], offset: LayoutValue.Number) -> [NSLayoutConstraint] {
    guard !lhs.isEmpty && !rhs.isEmpty else { return [] }
    var result: [NSLayoutConstraint] = []
    lhs.forEach { l in
        rhs.forEach { _r in
            var r = _r
            switch offset {
            case .value(let value):
                r.constant += value
							result += setup(l, r, relation: .equal).constraints
            case .range(let min, let max):
                if let value = min {
                    r.constant += value
									result += setup(l, r, relation: .greaterThanOrEqual).constraints
                }
                if let value = max {
                    r.constant += value
									result += setup(l, r, relation: .lessThanOrEqual).constraints
                }
            }
        }
    }
    return result
}

extension UILayoutable {
    
	public var layout: ConvienceLayout<Self, NSLayoutConstraint.Attribute> { ConvienceLayout(self) }
    
    fileprivate func setConstraint(_ axis: NSLayoutConstraint.Axis, number: LayoutValue.Number) -> [NSLayoutConstraint] {
        let att = axis == .vertical ? layout.height : layout.width
        return setConstraint(att, number: number)
    }
    
	fileprivate func setConstraint<S>(_ att: LayoutAttribute<S, Self, NSLayoutConstraint.Attribute>, number: LayoutValue.Number) -> [NSLayoutConstraint] {
        switch number {
        case .value(let value):
					return setup(att, value, relation: .equal).constraints
        case .range(let min, let max):
            var result: [NSLayoutConstraint] = []
            if let value = min {
							result += setup(att, value, relation: .greaterThanOrEqual).constraints
            }
            if let value = max {
							result += setup(att, value, relation: .lessThanOrEqual).constraints
            }
            return result
        }
    }
    
}

extension LayoutAttribute: LayoutValueProtocol where Item: UILayoutable, K == NSLayoutConstraint.Attribute {
    public var _asLayoutValue: LayoutValue {
			return .attribute([asAny()])
    }
}

extension LayoutAttribute: VerticalLayoutable where A == Attributes.Vertical, Item: UILayoutable, K == NSLayoutConstraint.Attribute {}
extension LayoutAttribute: HorizontalLayoutable where A: HorizontalLayoutableAttribute, Item: UILayoutable, K == NSLayoutConstraint.Attribute {}

public typealias AnyAttribute = LayoutAttribute<Void, AnyLayoutable, [NSLayoutConstraint.Attribute]>
public typealias AnyAttribute1 = LayoutAttribute<Void, AnyLayoutable, NSLayoutConstraint.Attribute>
