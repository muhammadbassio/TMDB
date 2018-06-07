//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation
import UIKit

class Movie {
  
  static var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    return df
  }
  
  static var releaseDateFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "dd MMM yyyy"
    return df
  }
  
  var title = ""
  var releaseDate: Date?
  var thumbnailURL = ""
  var overview = ""
  
  init(item:[String: Any]) {
    if let t = item["title"] as? String {
      self.title = t
    }
    if let o = item["overview"] as? String {
      self.overview = o
    }
    if let r = item["release_date"] as? String {
      self.releaseDate = Movie.dateFormatter.date(from: r)
    }
    if let p = item["poster_path"] as? String {
      switch UIScreen.main.scale {
      case 2:
        self.thumbnailURL = "http://image.tmdb.org/t/p/w185\(p)"
      case 3:
        self.thumbnailURL = "http://image.tmdb.org/t/p/w500\(p)"
      default:
        self.thumbnailURL = "http://image.tmdb.org/t/p/w92\(p)"
      }
      
    }
  }
}

extension String {
  func height(with maxWidth: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
    return boundingBox.height
  }
}
