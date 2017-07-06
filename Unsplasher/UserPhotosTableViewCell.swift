//
//  UserPhotosTableViewCell.swift
//  Unsplasher
//
//  Created by Dharmendra Verma on 30/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

class UserPhotosTableViewCell: UITableViewCell {

  @IBOutlet weak var BlurImage: UIVisualEffectView!

  @IBOutlet weak var userPhotos: UIImageView?
 
  @IBOutlet weak var collectionName: UILabel!
  var userImage:Photo?{
    didSet{
      self.updateCell()
    }
  }
  
  var userCollection: Curation?{
    didSet{
      self.updateCollectionCell()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.backgroundColor = UIColor(netHex: Constants.cellBackGround)
  }
  
  func updateCollectionCell(){
    self.BlurImage.alpha = 0.6
    self.collectionName.isHidden = false
    self.collectionName.text = userCollection?.title
    self.collectionName.toWhite()
    if self.userCollection?.collectionImage != nil {
     self.userPhotos?.sd_setImage(with: URL(string: (self.userCollection?.collectionImage)!), completed: nil)
  }
  }
  
  func updateCell(){
    self.BlurImage.alpha = 0
    self.collectionName.isHidden = true
    self.userPhotos?.isHidden = false
    self.userPhotos?.sd_setImage(with: URL(string: (self.userImage?.smallUrl)!), completed: nil)
  }
  
}


