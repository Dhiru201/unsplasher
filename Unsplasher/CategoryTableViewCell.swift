//
//  CategoryTableViewCell.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

  @IBOutlet var imageCount: UILabel!
  @IBOutlet var catName: UILabel!
  
  
  var catData:Category! {
    didSet {
      updateCell()
    }
  }
  func updateCell() {
    self.catName.text = self.catData.title
    self.catName.textColor = UIColor(netHex: Constants.themeColor)
    self.imageCount.text = "\(self.catData.photo_count) Photos"
    
  }
  
}
