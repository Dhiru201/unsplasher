//
//  CollectionTypeViewController.swift
//  UnsplashDemo
//
//  Created by Dhirendra Verma on 10/05/17.
//  Copyright © 2017 Dharmendra Verma. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CuratedCollectionViewCell"

class CuratedCollectionViewController: BaseCollectionViewController {
  var id: Int?
  var collectionTitle: String?
  var collectionType:CollectionType = .ALL
  

  override func viewDidLoad() {
    super.viewDidLoad()
    self.images.removeAll()
    self.collectionView?.showsVerticalScrollIndicator = false
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    self.navigationController?.hidesBarsOnSwipe = false
    self.title = self.collectionTitle
    self.collectionView?.collectionViewLayout = GridLayout()
    self.prepareURL()
    self.fetchImages(page: self.currentPage)
  }
  
  func prepareURL()  {
    switch self.collectionType {
    case .ALL:
      self.url = Constants.allCollectionDetailURL(id: self.id!)
    case .CURATED:
      self.url = Constants.curatedCollectionDetailURL(id: self.id!)
    case .FEATURED:
      self.url = Constants.featuredCollectionDetailURL(id: self.id!)
    }

  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CuratedCollectionViewCell
    cell.cellImage = self.images[indexPath.row]
    if indexPath.row == ((self.currentPage * 30) - 10){
      self.currentPage = self.currentPage + 1
      self.fetchImages(page: self.currentPage)
    }
    return cell
  }
}
