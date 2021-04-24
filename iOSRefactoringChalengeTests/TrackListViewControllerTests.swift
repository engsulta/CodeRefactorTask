
import XCTest
@testable import iOSRefactoringChallenge

class TrackListViewControllerTests: XCTestCase {

    var viewController: TrackListViewController!
    var viewModel: TrackListViewModelProtocol!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "PlayList", bundle: Bundle.main)
        let storyboardVC = storyboard.instantiateViewController(withIdentifier: "TrackListViewController") as! TrackListViewController
        viewController = storyboardVC
        viewModel = MockViewModel(provider: NetworkClient(baseURL: "",
                                                          session: MockSession()))
        viewController.viewModel = viewModel
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
        super.tearDown()
    }

}
struct MockViewModel: TrackListViewModelProtocol {
    var provider: NetworkClientProtocol

    var tracks: [Track] = []

    var loadingErrorClosure: (() -> Void)?

    func fetchTracks(completion: (([Track]) -> Void)?) {
        completion?([])
    }

    func trackTitle(for indexPath: IndexPath) -> String {
        return ""
    }


}
