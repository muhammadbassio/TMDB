//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import XCTest
@testable import TMDB

class NormalTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testNormalBehavior() {
    let promise = expectation(description: "Completion handler invoked")
    var results:[Movie]?
    var more:Bool = false
    var error:String?
    
    NetworkManager.shared.searchMovies(query: "batman", page: 1, success: { (movies, hasMore) in
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
}

