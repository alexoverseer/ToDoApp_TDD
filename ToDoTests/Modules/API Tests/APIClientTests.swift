import XCTest
@testable import ToDo

class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        
        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Login_UsesExpectedHost() {
        
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName:"alex", password: "1234", completion: completion)
        
        XCTAssertEqual(mockURLSession.urlComponents?.host, "awesometodos.com")
    }
    
    func test_Login_UsesExpectedPath() {
        
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName:"alex", password: "1234", completion: completion)
       
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    func test_Login_UsesExpectedQuery() {
        
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName:"dasdöm", password: "%&34", completion: completion)

        XCTAssertEqual(mockURLSession.urlComponents?.percentEncodedQuery,"username=dasdo%CC%88m&password=%25%2634")
    }
}

extension APIClientTests {
    class MockURLSession: SessionProtocol {
        var url: URL?
        
        var urlComponents: URLComponents? {
            guard let url = url else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            return URLSession.shared.dataTask(with: url)
        }
    }
    
    class MockTask: URLSessionDataTask {
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.error)
            }
        }
    }
}
