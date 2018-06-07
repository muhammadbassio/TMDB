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
  @IBOutlet var bottomConstraint: NSLayoutConstraint?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter?.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyBoardWillAppear(notification:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyBoardWillDisappear(notification:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func keyBoardWillAppear(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      UIView.animate(withDuration: 0.4) {
        self.bottomConstraint?.constant = -keyboardSize.height
        self.view.layoutIfNeeded()
      }
    }
    
  }
  
  @objc func keyBoardWillDisappear(notification: Notification) {
    UIView.animate(withDuration: 0.4) {
      self.bottomConstraint?.constant = 0
      self.view.layoutIfNeeded()
    }
  }
  
}
