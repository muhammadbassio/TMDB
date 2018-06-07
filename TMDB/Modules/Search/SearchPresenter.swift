//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit
import Nuke

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
    print("\(text)")
    print("updateSearchResults")
    self.searchText = text
    self.viewController?.collectionView?.reloadData()
  }
  
}

extension SearchPresenter: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.state = .typing
    self.viewController?.collectionView?.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.state = .searchResults
    self.movies = []
    self.viewController?.spinner?.startAnimating()
    self.interactor?.searchMovies(query: self.searchText, page: 1)
    self.viewController?.collectionView?.reloadData()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.state = .none
    self.viewController?.collectionView?.reloadData()
  }
}

extension SearchPresenter: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if self.state == .typing {
      
    }
  }
}

extension SearchPresenter: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch self.state {
    case .none:
      return 1
    case .searchResults:
      return self.movies.count
    case .typing:
      return 3
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch self.state {
    case .searchResults:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
      if indexPath.item < self.movies.count {
        let movie = self.movies[indexPath.item]
        cell.titleLabel?.text = movie.title
        cell.releaseDateLabel?.text = ""
        if let date = movie.releaseDate {
          cell.releaseDateLabel?.text = Movie.releaseDateFormatter.string(from: date)
        }
        cell.overviewLabel?.text = movie.overview
        Nuke.loadImage(with: URL(string: movie.thumbnailURL)!, into: cell.imageView!)
      }
      
      return cell
    case .typing:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCell
      
      return cell
    case .none:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCell
      
      return cell
    }
  }
}

extension SearchPresenter: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch self.state {
    case .none:
      return CGSize(width: collectionView.bounds.width, height: 250)
    case .searchResults:
      var height:CGFloat = 0
      if indexPath.item < self.movies.count {
        let movie = self.movies[indexPath.item]
        height = movie.title.height(with: collectionView.bounds.width - 122, font: UIFont.systemFont(ofSize: 14, weight: .semibold)) + movie.overview.height(with: collectionView.bounds.width - 122, font: UIFont.systemFont(ofSize: 14, weight: .regular)) + 45
      }
      return CGSize(width: collectionView.bounds.width, height: max(height, 160))
    case .typing:
      return CGSize(width: collectionView.bounds.width, height: 50)
    }
  }
}
