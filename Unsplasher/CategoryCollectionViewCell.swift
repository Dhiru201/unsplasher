//
//  CategoryCollectionViewCell.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit
import SDWebImage
class CategoryCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet var processInd: UIActivityIndicatorView!
  @IBOutlet var collectionImage: UIImageView!
  
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
    self.collectionImage.roundCorner(radius: 5.0)
    self.collectionImage?.sd_setImage(with: URL(string: self.cellImage.smallUrl), completed: {
      image, error, imageCacheType, imageUrl in
      self.processInd.stopAnimating()
    })
  }
}
