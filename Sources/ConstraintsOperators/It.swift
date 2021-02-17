//
//  File.swift
//  
//
//  Created by Данил Войдилов on 17.02.2021.
//

import UIKit

public struct SelfLayoutReference: Attributable, UILayoutableArray {
	public typealias Att = NSLayoutConstraint.Attribute
	fileprivate let map: (UILayoutable) -> UILayoutable
	public var target: SelfLayoutReference { self }
	public var superview: SelfLayoutReference { SelfLayoutReference(map: { $0.parent ?? $0 }) }
	public var safeArea: SelfLayoutReference { SelfLayoutReference(map: { $0._safeArea ?? $0 }) }
	
	public func asLayoutableArray(for other: UILayoutableArray?) -> [UILayoutable] {
		guard let item = other else { return [] }
		return item.asLayoutableArray(for: nil).map(map)
	}
}

public var its: SelfLayoutReference { SelfLayoutReference(map: { $0 }) }

extension UILayoutable {
	
	var _safeArea: UILayoutGuide? {
		if #available(iOS 11.0, *) {
			return (itemForConstraint as? UIView)?.safeAreaLayoutGuide
		} else {
			return nil
		}
	}
	
}
