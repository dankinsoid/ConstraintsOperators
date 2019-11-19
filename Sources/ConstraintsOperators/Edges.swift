//
//  Edges.swift
//  TestPr
//
//  Created by crypto_user on 09/09/2019.
//  Copyright © 2019 crypto_user. All rights reserved.
//

import UIKit

public enum Edge: Int8, CaseIterable {
    
    case top = 1, leading = 2, bottom = 4, trailing = 8
    
    public struct Set: OptionSet {
        public static let top = Set(.top)
        public static let leading = Set(.leading)
        public static let bottom = Set(.bottom)
        public static let trailing = Set(.trailing)
        public static let all = Edges.Set(Edges.allCases)
        public static let horizontal: Edges.Set = [.leading, .trailing]
        public static let vertical: Edges.Set = [.top, .bottom]
        
        public let rawValue: Int8
        
        public init(_ e: Edges) {
            rawValue = e.rawValue
        }
        
        public init(_ e: [Edges]) {
            self = Edges.Set(e.map(Set.init))
        }
        
        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }
    }
    
}

extension Edges.Set {
    
    var attributes: [NSLayoutConstraint.Attribute] {
        var result: [NSLayoutConstraint.Attribute] = []
        if contains(.top) { result.append(.top) }
        if contains(.bottom) { result.append(.bottom) }
        if contains(.trailing) { result.append(.trailing) }
        if contains(.leading) { result.append(.leading) }
        return result
    }
    
}
