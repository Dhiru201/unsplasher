//
//  SearchCollectionViewCell.swift
//  Unsplasher
//
//  Created by Dharmendra Verma on 22/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var searchImage: UIImageView!
  @IBOutlet weak var actInd: UIActivityIndicatorView!
 
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
    self.searchImage.roundCorner(radius: 5.0)
    self.searchImage?.sd_setImage(with: URL(string: self.cellImage.smallUrl), completed: {
      image, error, imageCacheType, imageUrl in
      self.actInd.stopAnimating()
    })
  }
}
