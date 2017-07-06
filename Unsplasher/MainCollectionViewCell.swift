//
//  MainCollectionViewCell.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit
import SDWebImage

class MainCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet var imageLoader: UIActivityIndicatorView!
  @IBOutlet var cellPhoto: UIImageView!
  
  
  var cellImage:Photo!{
    didSet{
      self.updateCell()
    }
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.backgroundColor = UIColor(netHex: Constants.cellBackGround)
  }

  func updateCell(){
    self.cellPhoto.roundCorner(radius: 5.0)
    self.cellPhoto?.sd_setImage(with: URL(string: self.cellImage.smallUrl), completed: {
      image, error, imageCacheType, imageUrl in
      self.imageLoader.stopAnimating()
    })
  }
}



