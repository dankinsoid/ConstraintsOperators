import XCTest
@testable import ConstraintsOperators

final class ConstraintsOperatorsTests: XCTestCase {
    func testExample() {
			UIButton().height =| its.superview.safeArea
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
