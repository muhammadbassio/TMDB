//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation
import UIKit

class SearchRouter: Router {
  
  var interactor:SearchInteractor?
  var presenter: SearchPresenter?
  
  
  func start(navigationController: UINavigationController) {
    self.interactor = SearchInteractor()
    self.presenter = SearchPresenter()
    self.interactor?.presenter = self.presenter
    self.presenter?.interactor = self.interactor
    self.presenter?.viewController = SearchViewController()
    self.presenter?.viewController?.presenter = self.presenter
    navigationController.pushViewController((self.presenter?.viewController)!, animated: true)
  }
}
