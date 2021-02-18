import XCTest
@testable import ConstraintsOperators

final class ConstraintsOperatorsTests: XCTestCase {
    func testExample() {
			let view1 = UIView()
			let view2 = UIView()
			view1.height.equal { $0.superview?.safeArea }.isActive = true
			view1.size =| view2
			view1.height =| 4
			view1.width =| 0...34
			
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
