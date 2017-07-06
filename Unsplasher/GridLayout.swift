//
//  GridLayout.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
  
  override init() {
    super.init()
    setupLayout()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupLayout()
  }

  
  func setupLayout() {
    minimumInteritemSpacing = 1
    minimumLineSpacing = 1
    scrollDirection = .vertical
  }
  
  
  override var itemSize: CGSize {
    set {
    }
    get {
      let numberOfColumns: CGFloat = 1
      
      let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1)) / numberOfColumns
      return CGSize(width: itemWidth, height: itemWidth * 0.5)
    }
  }
  
}

