//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import XCTest
@testable import TMDB
import OHHTTPStubs

class TMDBTests: XCTestCase {
  
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
  
  func testNetworkError() {
    let promise = expectation(description: "Completion handler invoked")
    var error:String?
    var results:[Movie]?
    var more:Bool = false
    
    stub(condition: isHost("api.themoviedb.org")) { (request) -> OHHTTPStubsResponse in
      let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
      return OHHTTPStubsResponse(error:notConnectedError)
    }
    
    NetworkManager.shared.searchMovies(query: "batman", page: 1, success: { (movies, hasMore) in
      // shouldn't get here
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
  
  
  func testSuccessfulResultOnePage() {
    let promise = expectation(description: "Completion handler invoked")
    var error:String?
    var results:[Movie]?
    var more:Bool = false
    var movie1:Movie?
    
    stub(condition: isHost("api.themoviedb.org")) { (request) -> OHHTTPStubsResponse in
      let obj = ["total_pages":1, "results":[["poster_path":"/asc.jpg", "title":"Batman begins", "overview":"just a movie", "release_date":"2008-01-24"], ["poster_path":"/asc.jpg", "title":"Batman returns", "overview":"just a movie", "release_date":"2009-11-2"]]] as [String : Any]
      return OHHTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
    }
    
    NetworkManager.shared.searchMovies(query: "batman", page: 1, success: { (movies, hasMore) in
      results = movies
      more = hasMore
      promise.fulfill()
    }) { (message) in
      // shouldn't be reached
      error = message
      promise.fulfill()
    }
    waitForExpectations(timeout: 10, handler: nil)
    if let movies = results {
      movie1 = movies[0]
    }
    
    // then
    XCTAssertNil(error)
    XCTAssertNotNil(results)
    XCTAssertEqual(movie1?.title, "Batman begins")
    XCTAssertFalse(more)
  }
  
  
  func testSuccessfulResultManyPages() {
    let promise = expectation(description: "Completion handler invoked")
    var error:String?
    var results:[Movie]?
    var more:Bool = false
    var movie1:Movie?
    
    stub(condition: isHost("api.themoviedb.org")) { (request) -> OHHTTPStubsResponse in
      let obj = ["total_pages":15, "results":[["poster_path":"/asc.jpg", "title":"Batman begins", "overview":"just a movie", "release_date":"2008-01-24"], ["poster_path":"/asc.jpg", "title":"Batman returns", "overview":"just a movie", "release_date":"2009-11-2"]]] as [String : Any]
      return OHHTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
    }
    
    NetworkManager.shared.searchMovies(query: "batman", page: 1, success: { (movies, hasMore) in
      results = movies
      more = hasMore
      promise.fulfill()
    }) { (message) in
      error = message
    }
    waitForExpectations(timeout: 10, handler: nil)
    if let movies = results {
      movie1 = movies[0]
    }
    
    // then
    XCTAssertNil(error)
    XCTAssertNotNil(results)
    XCTAssertEqual(movie1?.title, "Batman begins")
    XCTAssertTrue(more)
  }
  
  
  func testUnexpectedResponse() {
    let promise = expectation(description: "Completion handler invoked")
    var error:String?
    var results:[Movie]?
    var more:Bool = false
    
    stub(condition: isHost("api.themoviedb.org")) { (request) -> OHHTTPStubsResponse in
      let obj = ["what":"what the hell?"] as [String : Any]
      return OHHTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
    }
    
    NetworkManager.shared.searchMovies(query: "batman", page: 1, success: { (movies, hasMore) in
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

