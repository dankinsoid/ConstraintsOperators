//
//  File.swift
//  
//
//  Created by Данил Войдилов on 23.07.2021.
//

import UIKit

extension NSLayoutConstraint.Relation: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .equal:                return "=="
		case .greaterThanOrEqual:   return ">="
		case .lessThanOrEqual:      return "<="
		@unknown default:           return "unknown"
		}
	}
	
	public var name: String {
		switch self {
		case .equal:                return "equal"
		case .greaterThanOrEqual:   return "greaterThanOrEqual"
		case .lessThanOrEqual:      return "lessThanOrEqual"
		@unknown default:           return "unknown"
		}
	}
}

extension NSLayoutConstraint.Attribute: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .notAnAttribute:       return "notAnAttribute"
		case .top:                  return "top"
		case .left:                 return "left"
		case .bottom:               return "bottom"
		case .right:                return "right"
		case .leading:              return "leading"
		case .trailing:             return "trailing"
		case .width:                return "width"
		case .height:               return "height"
		case .centerX:              return "centerX"
		case .centerY:              return "centerY"
		case .lastBaseline:         return "lastBaseline"
		case .firstBaseline:        return "firstBaseline"
		case .topMargin:            return "topMargin"
		case .leftMargin:           return "leftMargin"
		case .bottomMargin:         return "bottomMargin"
		case .rightMargin:          return "rightMargin"
		case .leadingMargin:        return "leadingMargin"
		case .trailingMargin:       return "trailingMargin"
		case .centerXWithinMargins: return "centerXWithinMargins"
		case .centerYWithinMargins: return "centerYWithinMargins"
		@unknown default:			return "unknown"
		}
	}
}
