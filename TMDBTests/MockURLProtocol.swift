//
//  TMDB
//
//  Copyright © 2019 Muhammad Bassio. All rights reserved.
//

import Foundation
import SwiftyJSON

class MockURLProtocol: URLProtocol {
  
  enum ResponseType {
    case error(Error)
    case success(HTTPURLResponse)
  }
  
  private(set) var activeTask: URLSessionTask?
  static var responseType: ResponseType!
  private lazy var session: URLSession = {
    let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
    return false
  }
  
  override func startLoading() {
    activeTask = session.dataTask(with: request.urlRequest!)
    activeTask?.cancel()
  }
  
  override func stopLoading() {
    activeTask?.cancel()
  }
}

extension MockURLProtocol: URLSessionDataDelegate {
    
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    client?.urlProtocol(self, didLoad: data)
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    switch MockURLProtocol.responseType {
    case .error(let error)?:
      client?.urlProtocol(self, didFailWithError: error)
    case .success(let response)?:
      let data = JSON(["total_pages":15, "results":[["poster_path":"/asc.jpg", "title":"Batman begins", "overview":"just a movie", "release_date":"2008-01-24"], ["poster_path":"/asc.jpg", "title":"Batman returns", "overview":"just a movie", "release_date":"2009-11-2"]]])
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
      try? client?.urlProtocol(self, didLoad: data.rawData())
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    default:
      break
    }
    client?.urlProtocolDidFinishLoading(self)
  }
}

extension MockURLProtocol {
    
    enum MockError: Error {
        case none
    }
    
    static func responseWithFailure() {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.error(MockError.none)
    }
    
    static func responseWithStatusCode(code: Int) {
      if let response = HTTPURLResponse(url: URL(string: "http://api.themoviedb.org")!, statusCode: code, httpVersion: nil, headerFields: ["Content-Type" : "application/json; charset=utf-8"]) {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(response)
      }
    }
}


