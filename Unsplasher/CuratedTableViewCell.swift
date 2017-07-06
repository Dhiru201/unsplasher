//
//  CuratedTableViewCell.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

class CuratedTableViewCell: UITableViewCell {
  
  @IBOutlet var published_at: UILabel!
  @IBOutlet var title: UILabel!
  @IBOutlet var userName: UILabel!
  @IBOutlet var bio: UILabel!
  
  @IBOutlet var userImage: UIImageView!
  
  var cellData:Curation!{
    didSet{
      self.updateCell()
    }
  }
  
  func updateCell(){
    self.published_at.text = self.cellData.published_at
    self.bio.text = self.cellData.user.bio
    self.title.textColor = UIColor(netHex: Constants.themeColor)
    self.title.text = self.cellData.title
    self.userName.text = self.cellData.user.name
    if self.cellData.user.userImage != nil{
      self.userImage.toCircle()
      self.userImage?.sd_setImage(with: URL(string:self.cellData.user.userImage), completed: {
        image, error, imageCacheType, imageUrl in
      })
    }
  }
}


