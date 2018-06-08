//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

class SearchInteractor {
  
  var presenter: SearchPresenter?
  
  func searchMovies(query: String, page: Int) {
    NetworkManager.shared.searchMovies(query: query.lowercased(), page: page, success: { movies, hasMore in
      if page > 1 {
        self.presenter?.movies.append(contentsOf: movies)
      } else {
        self.presenter?.movies = movies
      }
      self.presenter?.canFetchMore = hasMore
      DataSource.saveQuery(query: query)
      self.presenter?.currentPage = page
      self.presenter?.refreshResults()
    }, failure: { message in
      self.presenter?.displayError(message: message)
    })
  }
}
