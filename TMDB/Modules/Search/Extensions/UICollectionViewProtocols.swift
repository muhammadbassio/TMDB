//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit
import Nuke

extension SearchPresenter: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if self.state == .typing {
      if self.history.count > indexPath.item {
        self.searchText = self.history[indexPath.item]
        self.viewController?.searchController?.searchBar.text = self.searchText
        self.viewController?.searchController?.searchBar.resignFirstResponder()
        self.search()
      }
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    if (offset > (scrollView.contentSize.height - scrollView.bounds.height - 10)) && self.canFetchMore {
      self.canFetchMore = false
      self.interactor?.searchMovies(query: self.searchText, page: self.currentPage + 1)
      self.viewController?.collectionView?.reloadData()
    }
  }
}


extension SearchPresenter: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch self.state {
    case .none:
      return 1
    case .searchResults:
      if self.canFetchMore {
        return self.movies.count + 1
      }
      return self.movies.count
    case .typing:
      return min(10, self.history.count)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch self.state {
    case .searchResults:
      if indexPath.item < self.movies.count {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        let movie = self.movies[indexPath.item]
        cell.titleLabel?.text = movie.title
        cell.releaseDateLabel?.text = ""
        if let date = movie.releaseDate {
          cell.releaseDateLabel?.text = Movie.releaseDateFormatter.string(from: date)
        }
        cell.overviewLabel?.text = movie.overview
        cell.imageView?.image = nil
        if let im = cell.imageView, let url = URL(string: movie.thumbnailURL) {
          Nuke.loadImage(with: url, into: im)
        }
        return cell
      } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingCell
        cell.spinner?.startAnimating()
        return cell
      }
    case .typing:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCell
      if self.history.count > indexPath.item {
        cell.label?.text = self.history[indexPath.item]
      }
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
        return CGSize(width: collectionView.bounds.width, height: max(height, 160))
      }
      return CGSize(width: collectionView.bounds.width, height: 60)
    case .typing:
      return CGSize(width: collectionView.bounds.width, height: 50)
    }
  }
}
