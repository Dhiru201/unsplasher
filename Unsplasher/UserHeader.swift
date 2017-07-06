//
//  UserHeader.swift
//  Unsplasher
//
//  Created by Dharmendra Verma on 01/06/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

class UserHeader: UICollectionReusableView {

  @IBOutlet weak var userBio: UILabel!
  @IBOutlet weak var userLocation: UILabel!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
