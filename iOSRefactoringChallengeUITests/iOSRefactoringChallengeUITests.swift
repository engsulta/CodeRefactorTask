import XCTest

class iOSRefactoringChallengeTestsUITests: XCTestCase {


    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testExample() throws {
        app.launch()
        XCTAssertTrue(app.tables["tableId"].exists)
    }
}
