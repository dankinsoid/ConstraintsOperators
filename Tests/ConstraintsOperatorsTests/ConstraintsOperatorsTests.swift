import XCTest
@testable import ConstraintsOperators

final class ConstraintsOperatorsTests: XCTestCase {
    func testExample() {
			UIButton().edges().equal(to: 2)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
