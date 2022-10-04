#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
extension Edge.Set {
    
    var attributes: [NSLayoutConstraint.Attribute] {
        var result: [NSLayoutConstraint.Attribute] = []
        if contains(.top) { result.append(.top) }
        if contains(.bottom) { result.append(.bottom) }
        if contains(.trailing) { result.append(.trailing) }
        if contains(.leading) { result.append(.leading) }
        return result
    }
    
}
#endif
