//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
  
  static var shared = NetworkManager()
  
  func searchMovies(query: String, page: Int, success: @escaping (_ results:[Movie]) -> Void, failure: @escaping (_ message: String) -> Void) {
    let endpoint: String = "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(query)&page=\(page)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("\(endpoint)")
    request(endpoint)
      .responseJSON { response in
        // check for errors
        guard response.result.error == nil else {
          // got an error in getting the data, need to handle it
          print(response.result.error!)
          failure(response.result.error?.localizedDescription ?? "Network error")
          return
        }
        
        // make sure we got some JSON since that's what we expect
        guard let json = response.result.value as? [String: Any] else {
          failure("Error parsing response")
          return
        }
        
        // get results
        guard let results = json["results"] as? [[String: Any]] else {
          failure("No results found")
          return
        }
        
        var movies = [Movie]()
        for item in results {
          let movie = Movie(item: item)
          movies.append(movie)
        }
        success(movies)
        
    }
  }
  
}
