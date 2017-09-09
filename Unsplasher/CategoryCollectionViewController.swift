//
//  CategoryCollectionViewController.swift
//  UnsplashDemo
//
//  Created by Dhirendra Verma on 06/05/17.
//  Copyright © 2017 Dharmendra Verma. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CategoryCell"

class CategoryCollectionViewController: BaseCollectionViewController {
	
	var categoryID: Int?
	var navtitle: String!
	var loadTill = 0

  @IBOutlet weak var activity: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView?.showsVerticalScrollIndicator = false
    self.navigationItem.title = self.navtitle
    self.navigationController?.hidesBarsOnSwipe = true
    self.collectionView?.collectionViewLayout = GridLayout()
    if self.url == nil{
      self.url = Constants.categoryDetailURL(id: self.categoryID!)
    }
    self.fetchImages(page: 1)
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
    cell.backgroundColor = UIColor(netHex: Constants.userBaseColor)
    cell.cellImage = self.images[indexPath.row]
   // self.activity.stopAnimating()
    if indexPath.row > self.loadTill {
      self.loadTill = indexPath.row
      if indexPath.row == ((self.currentPage * 30) - 10){
        self.currentPage = self.currentPage + 1
        self.fetchImages(page: self.currentPage)
      }
    }
    return cell
  }
  
  
  
}
