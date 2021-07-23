//
//  File.swift
//  
//
//  Created by Данил Войдилов on 23.07.2021.
//

import UIKit

final class LayoutConstraint: NSLayoutConstraint {
	
	var sourceLocation: (String, UInt)?
	
	override var description: String {
		var description = "<"
		
		description += descriptionForObject(self)
		
		if let firstItem = conditionalOptional(from: self.firstItem) {
			description += " \(descriptionForObject(firstItem))"
		}
		
		if self.firstAttribute != .notAnAttribute {
			description += ".\(firstAttribute.description)"
		}
		
		description += " \(relation.description)"
		
		if let secondItem = self.secondItem {
			description += " \(descriptionForObject(secondItem))"
		}
		
		if secondAttribute != .notAnAttribute {
			description += ".\(secondAttribute.description)"
		}
		
		if self.multiplier != 1.0 {
			description += " * \(self.multiplier)"
		}
		
		if self.secondAttribute == .notAnAttribute {
			description += " \(self.constant)"
		} else {
			if self.constant > 0.0 {
				description += " + \(self.constant)"
			} else if self.constant < 0.0 {
				description += " - \(abs(self.constant))"
			}
		}
		
		if self.priority.rawValue != 1000.0 {
			description += " ^\(self.priority)"
		}
		
		description += ">"
		
		return description
	}
	
	private func conditionalOptional<T>(from object: Optional<T>) -> Optional<T> {
		object
	}
	
	private func descriptionForObject(_ object: AnyObject) -> String {
		if let object = object as? LayoutConstraint, let file = object.sourceLocation?.0, let line = object.sourceLocation?.1 {
			return "\((file as NSString).lastPathComponent), \(line)"
		}
		var desc = ""
		desc += type(of: object).description()
		let pointerDescription = String(format: "%p", UInt(bitPattern: ObjectIdentifier(object)))
		desc += ":\(pointerDescription)"
		desc += ""
		return desc
	}
}
