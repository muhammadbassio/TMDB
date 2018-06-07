//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

class SearchInteractor {
  
  var presenter: SearchPresenter?
  
  func searchMovies(query: String, page: Int) {
    NetworkManager.shared.searchMovies(query: query, page: page, success: { movies in
      if page > 1 {
        self.presenter?.movies.append(contentsOf: movies)
      } else {
        self.presenter?.movies = movies
      }
      self.presenter?.refreshResults()
    }, failure: { message in
      self.presenter?.displayError(message: message)
    })
  }
}
