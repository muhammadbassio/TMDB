//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

extension SearchPresenter: UISearchControllerDelegate {
  func didPresentSearchController(_ searchController: UISearchController) {
    print("didPresentSearchController")
  }
}

extension SearchPresenter: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text, text != ""  else {
      print("empty")
      return
    }
    self.searchText = text
  }
  
}

extension SearchPresenter: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.state = .typing
    self.history = DataSource.getTopTen()
    self.viewController?.collectionView?.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.search()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.state = .none
    self.viewController?.collectionView?.reloadData()
  }
}
