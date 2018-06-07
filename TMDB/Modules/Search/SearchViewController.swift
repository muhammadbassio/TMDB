//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  var searchController : UISearchController?
  var presenter: SearchPresenter?
  @IBOutlet var collectionView: UICollectionView?
  @IBOutlet var spinner: UIActivityIndicatorView?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter?.viewDidLoad()
    
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
