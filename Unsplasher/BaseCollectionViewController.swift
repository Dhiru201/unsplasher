//
//  BaseCollectionViewController.swift
//  UnsplashDemo
//
//  Created by Dhirendra Verma on 07/05/17.
//  Copyright © 2017 Dharmendra Verma. All rights reserved.
//

import UIKit
import EZAlertController

private let reuseIdentifier = "MainCell"

class BaseCollectionViewController: UICollectionViewController {
  let refreshCtrl = UIRefreshControl()
  @IBOutlet weak var pageLoader: UIActivityIndicatorView!
  var images:[Photo] = []
  var currentPage = 1
  var query:String?
  var url:String?
  var loadedTill = 0

  func fetchImages(page: Int) -> Void{
    Photo.fetchData(url: self.url!, page: page, query: self.query, callback: {
      photos, error in
      if error != nil{
        Alert.error(message: (error?.localizedDescription)!)
      }
      else if photos != nil && photos!.count > 0{
        for photo in photos!{
          self.images.append(photo)
          if self.query == nil{
            self.pageLoader.stopAnimating()
            self.refresh()
          }
        }
        self.collectionView?.reloadData()
      }else{
        Alert.warning(message: "No items found")
      }
    })
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return self.images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
    
    cell.cellImage = self.images[indexPath.row]
    if indexPath.row > self.loadedTill {
      self.loadedTill = indexPath.row
      if indexPath.row == ((self.currentPage * 30) - 10){
        self.currentPage = self.currentPage + 1
         self.fetchImages(page: self.currentPage)
      }
    }
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.collectionView?.deselectItem(at: indexPath, animated: false)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "zoomview") as! ZoomViewController
    vc.zoomImage = self.images[indexPath.item]
    vc.name = self.images[indexPath.item].user.username
    vc.profileImageURL =  self.getUserImageUrl(user: self.images[indexPath.item].user)
    vc.bio = self.images[indexPath.item].user.bio
    vc.username = self.images[indexPath.item].user.name
    vc.location = self.images[indexPath.item].user.location
    vc.id = self.images[indexPath.item].id
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func refresh (){
    if self.pageLoader.isAnimating == false {
      refreshCtrl.addTarget(self, action: #selector(self.startRefresh), for: .valueChanged)
      refreshCtrl.attributedTitle = NSAttributedString(string: "Reloading", attributes: [NSForegroundColorAttributeName: UIColor(netHex: Constants.themeColor)])
      refreshCtrl.tintColor = UIColor(netHex: Constants.themeColor)
      self.collectionView?.alwaysBounceVertical = true
      self.collectionView?.addSubview(refreshCtrl)
    }
  }
  
  func startRefresh(){
    self.images.removeAll()
    self.currentPage = 1
    self.fetchImages(page: self.currentPage)
    self.collectionView?.reloadData()
    self.refreshCtrl.endRefreshing()
  }

	private func getUserImageUrl(user:User)-> String{
		if UIDevice.current.userInterfaceIdiom == .pad{
			return user.userLargeProfileImage
		}else{
			return user.userImage
		}
	}
}
