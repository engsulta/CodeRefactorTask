
import XCTest
@testable import iOSRefactoringChallenge

class NetworkLayerTests: XCTestCase {
    var mockNetworkManager: NetworkClient!
    var mockSession: MockSession!

    override func setUp() {
        super.setUp()
        mockSession = MockSession()
        mockNetworkManager = NetworkClient(baseURL: Constants.baseURL, session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testRequestSucceed() {
        let exp = expectation(description: #function)
        mockNetworkManager.fetch(endPoint: PlaylistEndPoint.playlist(playlistId: ""),
                                 model: TestModel.self){ [weak self] (response, error)  in

            if error == nil {
                XCTAssertEqual((response as? TestModel)?.name , self?.mockSession.model.name)
                XCTAssertEqual(self?.mockSession.urlSessionDataTaskMock.isResumedCalled, true)
            } else {
                XCTFail("decoding not work successfully")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }

    func testRequestFailed() {
        let exp = expectation(description: #function)
        mockNetworkManager.fetch(endPoint: PlaylistEndPoint.playlist(playlistId: ""),
                                 model: String.self) {(response, error)  in
            if error != nil {
                XCTAssertEqual(error, NetworkError.faildToDecode)
            } else {
                XCTFail("decoding not work successfully")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }

    func testMissingURL() {
        mockNetworkManager.baseURL = ""
        let exp = expectation(description: #function)
        mockNetworkManager.fetch(endPoint: PlaylistEndPoint.playlist(playlistId: ""),
                                 model: TestModel.self) {(response, error)  in
            if error != nil {
                XCTAssertEqual(error, NetworkError.missingURL)
                exp.fulfill()
            }

        }
        wait(for: [exp], timeout: 2.0)
    }
    func testCancellingTask() {
        let exp = expectation(description: #function)
        mockNetworkManager.fetch(endPoint: PlaylistEndPoint.playlist(playlistId: ""), model: String.self) {(response, error)  in
            if error != nil {
                XCTAssertEqual(self.mockSession.urlSessionDataTaskMock.isCancelledCalled, true)
            } else {
                XCTFail("decoding not work successfully")
            }
            exp.fulfill()
            }?.cancel()
        wait(for: [exp], timeout: 2.0)
    }

    func testEndPointRequestBuilder() {
        let endPoint = PlaylistEndPoint.playlist(playlistId: "id")
        guard let urlRequest = try? endPoint.buildRequest(for: URL(string: Constants.baseURL)!) else {
            XCTFail("could not build request")
            return
        }

        XCTAssertEqual(urlRequest.httpMethod, "GET")
        let queryItems = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)?.queryItems?.first
        XCTAssertTrue(["client_id","client_secret"].contains(queryItems?.name))
    }

    func testErrorLocalizedDescription() {
        let expected: [String] = ["missing URL",
                                  "unable to decode the response",
                                  "unknown"]

        for (index, testError) in [
            NetworkError.missingURL,
            NetworkError.faildToDecode,
            NetworkError.noNetwork].enumerated() {
                XCTAssertEqual(testError.rawValue, expected[index])
        }
    }
}

//MARK:- Mock Session
typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
class MockSession: URLSessionProtocol {

    var urlSessionDataTaskMock =  URLSessionDataTaskMock()
    var model = TestModel(name: "myName")
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let testData = try? JSONEncoder().encode(model)
        completionHandler(testData,nil,nil)

        return urlSessionDataTaskMock
    }

}

//MARK:- Mock Model
struct TestModel: Codable {
    var name: String?
}

//MARK:- Mock Data Task
class URLSessionDataTaskMock: URLSessionDataTaskProtocol {

    var isResumedCalled = false
    var isCancelledCalled = false
    func resume() {
        isResumedCalled = true
    }
    func cancel() {
        isCancelledCalled = true
    }
}
