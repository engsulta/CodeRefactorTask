
import XCTest
@testable import iOSRefactoringChallenge

class TrackListViewControllerTests: XCTestCase {

    var viewController: TrackListViewController!
    var mockNetworkManager: NetworkClient!
    var mockSession: MockSession!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "PlayList", bundle: Bundle.main)
        let storyboardVC = storyboard.instantiateViewController(withIdentifier: "TrackListViewController") as! TrackListViewController
        viewController = storyboardVC
        mockSession = MockSession()
        mockNetworkManager = NetworkClient(baseURL: Constants.baseURL, session: mockSession)
        viewController.viewModel.provider = mockNetworkManager
        viewController.loadViewIfNeeded()
    }

    func testInitVM() {
        let exp = expectation(description: #function)
        viewController.initVM {
            XCTAssert(true)
            exp.fulfill()
        }
         wait(for: [exp], timeout: 2.0)
    }

    override func tearDown() {
        viewController = nil
        mockNetworkManager = nil
        mockSession = nil
        super.tearDown()
    }

}
