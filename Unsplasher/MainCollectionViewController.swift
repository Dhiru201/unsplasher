//
//  ViewController.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

class MainCollectionViewController: BaseCollectionViewController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "New"
    self.url = Constants.photosURL
    self.collectionView?.showsVerticalScrollIndicator = false
    self.collectionView?.collectionViewLayout = GridLayout()
    self.navigationController?.hidesBarsOnSwipe = false
   
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.hidesBarsOnSwipe = false
    self.fetchImages(page: self.currentPage)
    
  }
 
}
