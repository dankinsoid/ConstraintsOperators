//
//  ConvienceLayout.swift
//  TestPr
//
//  Created by crypto_user on 11/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

public protocol UILayoutable: class {}

extension UIView: UILayoutable {
    @available(iOS 11.0, *)
    public var safeAreaLayout: ConvienceLayout<ConstraintBuilder> { return safeAreaLayoutGuide.layout }
}

extension Array where Element: UIView {
    @available(iOS 11.0, *)
    public var safeAreaLayout: ConvienceLayout<ConstraintsBuilder> { return ConvienceLayout(map({ $0.safeAreaLayoutGuide })) }
}

extension UILayoutGuide: UILayoutable {}

extension UILayoutable {
    public var layout: ConvienceLayout<ConstraintBuilder> { return ConvienceLayout(self) }
}

extension Array where Element == UILayoutable {
    public var layout: ConvienceLayout<ConstraintsBuilder> { return ConvienceLayout(self) }
}

public struct ConvienceLayout<B: ConstraintsCreator>: Attributable {
    public let target: B.First
    
    init(_ item: B.First) {
        target = item
    }
}

extension ConvienceLayout where B.First == UILayoutable {
    
    public subscript(_ attributes: NSLayoutConstraint.Attribute...) -> LayoutAttribute<Void, ConstraintsBuilder> {
        return self[attributes]
    }
    
    public subscript(_ attributes: [NSLayoutConstraint.Attribute]) -> LayoutAttribute<Void, ConstraintsBuilder> {
        return LayoutAttribute(type: attributes, item: [target])
    }
    
}

extension ConvienceLayout where B.First == [UILayoutable] {
    
    public subscript(_ attributes: NSLayoutConstraint.Attribute...) -> LayoutAttribute<Void, ConstraintsBuilder> {
        return self[attributes]
    }
    
    public subscript(_ attributes: [NSLayoutConstraint.Attribute]) -> LayoutAttribute<Void, ConstraintsBuilder> {
        return LayoutAttribute(type: attributes, item: target)
    }
}
