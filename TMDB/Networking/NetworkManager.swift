//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
  
  static var shared = NetworkManager()
  let apiKey = "2696829a81b1b5827d515ff121700838"
  let apiURL = "http://api.themoviedb.org/3/search/movie"
  
  private let manager: SessionManager
  
  public init(manager: SessionManager = SessionManager.default) {
      self.manager = manager
  }
  
  func searchMovies(query: String, page: Int, success: @escaping (_ results:[Movie],_ hasMoreResults: Bool) -> Void, failure: @escaping (_ message: String) -> Void) {
    let endpoint: String = "\(self.apiURL)?api_key=\(self.apiKey)&query=\(query)&page=\(page)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    manager.request(endpoint).responseJSON { response in
        // check for errors
        guard response.result.error == nil else {
          // got an error in getting the data, Alamofire takes care of network errors
          failure(response.result.error?.localizedDescription ?? "Network error")
          return
        }
        
        // make sure we got some JSON since that's what we expect
        guard let json = response.result.value as? [String: Any] else {
          failure("Couldn't parse response")
          return
        }
        
        // get results
        guard let results = json["results"] as? [[String: Any]] else {
          guard let errors = json["errors"] as? [String] else {
            // Counldn't get the error
            failure("No results found")
            return
          }
          // API error returned in response
          failure(errors[0])
          return
        }
        
        // In case there is no results
        if results.count < 1 {
          failure("No results found")
          return
        }
        var movies = [Movie]()
        for item in results {
          let movie = Movie(item: item)
          movies.append(movie)
        }
        var hasMore = false
        if let totalPages = json["total_pages"] as? Int, totalPages > page {
          hasMore = true
        }
        success(movies, hasMore)
        
    }
  }
  
}
