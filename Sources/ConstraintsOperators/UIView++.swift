//
//  File.swift
//  
//
//  Created by Данил Войдилов on 25.01.2021.
//

import UIKit

extension UIView {
	
	public var contentPriority: ContentLayoutPriority { ContentLayoutPriority(view: self) }
	
	public struct ContentLayoutPriority {
		fileprivate let view: UIView
		public var vertical: AxisLayoutPriority { self[for: .vertical] }
		public var horizontal: AxisLayoutPriority { self[for: .horizontal] }
		
		
		public subscript(for axis: NSLayoutConstraint.Axis) -> AxisLayoutPriority {
			switch axis {
			case .horizontal:	return AxisLayoutPriority(view: view, axis: .horizontal)
			case .vertical:		return AxisLayoutPriority(view: view, axis: .vertical)
			@unknown default:	return AxisLayoutPriority(view: view, axis: .vertical)
			}
		}
		
		public subscript(_ direction: AxisLayoutPriority.Direction, for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
			get { self[for: axis][direction] }
			nonmutating set { self[for: axis][direction] = newValue }
		}
		
		public struct AxisLayoutPriority {
			fileprivate let view: UIView
			fileprivate let axis: NSLayoutConstraint.Axis
			
			public var hugging: UILayoutPriority {
				get { self[.hugging] }
				nonmutating set { self[.hugging] = newValue }
			}
			public var compression: UILayoutPriority {
				get { self[.compression] }
				nonmutating set { self[.compression] = newValue }
			}
			
			public subscript(_ direction: Direction) -> UILayoutPriority {
				get {
					switch direction {
					case .compression: 	return view.contentCompressionResistancePriority(for: axis)
					case .hugging: 			return view.contentHuggingPriority(for: axis)
					}
				}
				nonmutating set {
					switch direction {
					case .compression: 	return view.setContentCompressionResistancePriority(newValue, for: axis)
					case .hugging: 			return view.setContentHuggingPriority(newValue, for: axis)
					}
				}
			}
			
			@frozen
			public enum Direction {
				case hugging, compression
			}
		}
	}
	
}

extension UILayoutPriority: ExpressibleByFloatLiteral {
	
	public init(floatLiteral value: Float) {
		self = UILayoutPriority(value)
	}
	
	public static func custom(_ raw: Float) -> UILayoutPriority {
		UILayoutPriority(raw)
	}
	
}
