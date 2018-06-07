//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

class AppRouter {
  
  static var shared = AppRouter()
  
  func start(window: UIWindow) {
    let rootViewController = UINavigationController()
    rootViewController.navigationBar.tintColor = UIColor.green
    rootViewController.navigationBar.barTintColor = UIColor.black
    rootViewController.navigationBar.barStyle = .black
    let searchRouter = SearchRouter()
    searchRouter.start(navigationController: rootViewController)
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
  
}
