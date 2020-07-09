//
//  Functions.swift
//  TestProject
//
//  Created by Daniil on 10.09.2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

extension LayoutAttribute {
    
    @discardableResult
    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .equal)
    }
    
    @discardableResult
    public func equal(to rhs: CGFloat) -> C.Constraint {
        return setup(self, rhs, relation: .equal)
    }
    
    @discardableResult
    public func within(_ rhs: ClosedRange<CGFloat>) -> [NSLayoutConstraint] {
        return C.array(for: [setup(self, rhs.lowerBound, relation: .greaterThanOrEqual), setup(self, rhs.upperBound, relation: .lessThanOrEqual)])
    }
    
    @discardableResult
    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return _setup(self, rhs, relation: .equal)
    }
    
    @discardableResult
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func less(than rhs: CGFloat) -> C.Constraint {
        return setup(self, rhs, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return _setup(self, rhs, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .greaterThanOrEqual)
    }
    
    @discardableResult
    public func greater(than rhs: CGFloat) -> C.Constraint {
        return setup(self, rhs, relation: .greaterThanOrEqual)
    }
    
    @discardableResult
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return _setup(self, rhs, relation: .greaterThanOrEqual)
    }

}

extension LayoutAttribute where C.Second == UILayoutable {
    
    @discardableResult
    public func equal(to rhs: C.Second) -> C.Constraint {
        return setup(self, rhs, relation: .equal)
    }

    @discardableResult
    public func equal(to rhs: C.Second?) -> C.Constraint? {
        return _setup(self, rhs, relation: .equal)
    }
    
    @discardableResult
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func less(than rhs: C.Second) -> C.Constraint {
        return setup(self, rhs, relation: .lessThanOrEqual)
    }

    @discardableResult
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .greaterThanOrEqual)
    }
    
    @discardableResult
    public func greater(than rhs: C.Second) -> C.Constraint {
        return setup(self, rhs, relation: .greaterThanOrEqual)
    }
    
}

extension LayoutAttribute where A == Attributes.CenterX {

    @discardableResult
    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<A, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .equal)
    }

    @discardableResult
    public func equal<T: CenterXAttributeCompatible, K: ConstraintsCreator>(to rhs: LayoutAttribute<T, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return _setup(self, rhs, relation: .equal)
    }
    
    @discardableResult
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return _setup(self, rhs, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .greaterThanOrEqual)
    }
    
    @discardableResult
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<A, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return _setup(self, rhs, relation: .greaterThanOrEqual)
    }
    
}

extension LayoutAttribute where A: CenterXAttributeCompatible {
    
    @discardableResult
    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<Attributes.CenterX, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .equal)
    }
    
    @discardableResult
    public func equal<K: ConstraintsCreator>(to rhs: LayoutAttribute<Attributes.CenterX, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return _setup(self, rhs, relation: .equal)
    }
    
    @discardableResult
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func less<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return _setup(self, rhs, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>) -> C.Constraint where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return setup(self, rhs, relation: .greaterThanOrEqual)
    }
    
    @discardableResult
    public func greater<K: ConstraintsCreator>(than rhs: LayoutAttribute<Attributes.CenterX, K>?) -> C.Constraint? where C.Second == K.First, K.A == NSLayoutConstraint.Attribute {
        return _setup(self, rhs, relation: .greaterThanOrEqual)
    }
}

extension LayoutAttribute where A == Attributes.Edges {
    
    @discardableResult
    public func equal(to rhs: UIEdgeInsets) -> [C.Constraint] {
        map(rhs: rhs, operation: { $0.equal(to: $1) })
    }
    
    @discardableResult
    public func less(than rhs: UIEdgeInsets) -> [C.Constraint] {
        map(rhs: rhs, operation: { $0.less(than: $1) })
    }
    
    @discardableResult
    public func greater(than rhs: UIEdgeInsets) -> [C.Constraint] {
        map(rhs: rhs, operation: { $0.greater(than: $1) })
    }
    
    private func map(rhs: UIEdgeInsets, operation: (LayoutAttribute, CGFloat) -> C.Constraint) -> [C.Constraint] {
        [
            operation(type(C.A.init(.leading)), rhs.left),
            operation(type(C.A.init(.trailing)), rhs.right),
            operation(type(C.A.init(.top)), rhs.top),
            operation(type(C.A.init(.bottom)), rhs.bottom)
        ]
    }
    
}

extension LayoutAttribute where A == Attributes.Size {
    
    @discardableResult
    public func equal(to rhs: CGSize) -> [C.Constraint] {
        map(rhs: rhs, operation: { $0.equal(to: $1) })
    }
    
    @discardableResult
    public func less(than rhs: CGSize) -> [C.Constraint] {
        map(rhs: rhs, operation: { $0.less(than: $1) })
    }
    
    @discardableResult
    public func greater(than rhs: CGSize) -> [C.Constraint] {
        map(rhs: rhs, operation: { $0.greater(than: $1) })
    }
    
    private func map(rhs: CGSize, operation: (LayoutAttribute, CGFloat) -> C.Constraint) -> [C.Constraint] {
        [
            operation(type(C.A.init(.width)), rhs.width),
            operation(type(C.A.init(.height)), rhs.height)
        ]
    }
}
