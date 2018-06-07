//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

enum State {
  case typing
  case searchResults
  case none
}

class SearchPresenter: Presenter {
  
  var interactor: SearchInteractor?
  var viewController: SearchViewController?
  var state = State.none
  var searchText:String = ""
  var movies:[Movie] = []
  var history:[String] = []
  var currentPage:Int = 1
  var canFetchMore:Bool = false
  
  func viewDidLoad() {
    
    self.viewController?.searchController = UISearchController(searchResultsController:  nil)
    
    self.viewController?.searchController?.searchResultsUpdater = self
    self.viewController?.searchController?.delegate = self
    self.viewController?.searchController?.searchBar.delegate = self
    
    self.viewController?.searchController?.hidesNavigationBarDuringPresentation = false
    self.viewController?.searchController?.dimsBackgroundDuringPresentation = false
    self.viewController?.searchController?.searchBar.tintColor = UIColor.green
    
    self.viewController?.navigationItem.titleView = self.viewController?.searchController?.searchBar
    
    self.viewController?.definesPresentationContext = true
    
    self.viewController?.collectionView?.dataSource = self
    self.viewController?.collectionView?.delegate = self
    
    self.viewController?.collectionView?.register(UINib(nibName: "MessageCell", bundle: nil), forCellWithReuseIdentifier: "messageCell")
    self.viewController?.collectionView?.register(UINib(nibName: "HistoryCell", bundle: nil), forCellWithReuseIdentifier: "historyCell")
    self.viewController?.collectionView?.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
    self.viewController?.collectionView?.register(UINib(nibName: "LoadingCell", bundle: nil), forCellWithReuseIdentifier: "loadingCell")
    
    self.history = DataSource.getHistory()
  }
  
  func search() {
    self.canFetchMore = false
    self.state = .searchResults
    self.movies = []
    self.viewController?.spinner?.startAnimating()
    self.interactor?.searchMovies(query: self.searchText, page: 1)
    self.viewController?.collectionView?.reloadData()
  }
  
  func refreshResults() {
    self.viewController?.spinner?.stopAnimating()
    self.viewController?.collectionView?.reloadData()
  }
  
  func displayError(message: String) {
    self.viewController?.spinner?.stopAnimating()
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.viewController?.present(alert, animated: true, completion: nil)
  }
}


