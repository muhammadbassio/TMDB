//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import XCTest
@testable import TMDB
import Alamofire

class MockedTests: XCTestCase {
  
  private var mockedManager: NetworkManager!
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let manager: SessionManager = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            return configuration
        }()
        
        return SessionManager(configuration: configuration)
    }()
    mockedManager = NetworkManager(manager: manager)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testResponseStatusCode200() {
    let promise = expectation(description: "Completion handler invoked")
    var results:[Movie]?
    var more:Bool = false
    var error:String?
    
    MockURLProtocol.responseWithStatusCode(code: 200)
    
    mockedManager.searchMovies(query: "batman", page: 1, success: { (movies, hasMore) in
      results = movies
      more = hasMore
      promise.fulfill()
    }) { (message) in
      error = message
      promise.fulfill()
    }
    waitForExpectations(timeout: 10, handler: nil)
    // then
    XCTAssertNil(error)
    XCTAssertNotNil(results)
    XCTAssertTrue(more)
  }
  
  func testUnexpectedResponse() {
    let promise = expectation(description: "Completion handler invoked")
    var error:String?
    var results:[Movie]?
    var more:Bool = false
    
    MockURLProtocol.responseWithFailure()
    
    mockedManager.searchMovies(query: "batman", page: 1, success: { (movies, hasMore) in
      //shouldn't be reached
      results = movies
      more = hasMore
      promise.fulfill()
    }) { (message) in
      error = message
      promise.fulfill()
    }
    waitForExpectations(timeout: 10, handler: nil)
    // then
    XCTAssertNotNil(error)
    XCTAssertNil(results)
    XCTAssertFalse(more)
  }
}

