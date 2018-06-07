//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
  
  @IBOutlet var imageView: UIImageView?
  @IBOutlet var titleLabel: UILabel?
  @IBOutlet var releaseDateLabel: UILabel?
  @IBOutlet var overviewLabel: UILabel?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
}

