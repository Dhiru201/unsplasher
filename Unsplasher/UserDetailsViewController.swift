//
//  UserDetailsViewController.swift
//  Unsplasher
//
//  Created by Dharmendra Verma on 29/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit


class UserDetailsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
  
  
  @IBOutlet weak var bio: UILabel!
  @IBOutlet weak var location: UILabel!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userImageView: UITableView!
  
  var profileImage:UIImage!
  var name:String!
  var username:String!
  var userBio:String!
  var userLocation:String!
  var currentPage = 1
  var photoList:Array<Photo>  = []
  var url:String!
  var segmentedControl: UISegmentedControl!
  var categoryID:Int?
  var userCollectionList:Array<Curation> = []
  let headerView = UIView()
  var loadedTill = 0
  override func viewDidLoad() {
      super.viewDidLoad()
      self.navigationController?.hidesBarsOnSwipe = false
      self.navigationItem.title = self.username
      self.userCollectionList.removeAll()
      self.photoList.removeAll()
      self.url = Constants.userPhotosURL(self.name)
      self.userImageView.estimatedSectionHeaderHeight = 40
      self.updateUserView()
      self.fetchUserPhotos(page: self.currentPage)
      self.setSegmentedControl()
    }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    self.headerView.backgroundColor = UIColor.white
    self.headerView.tintColor  = UIColor(netHex: Constants.themeColor)
    return self.headerView
  }

  func setSegmentedControl(){
    self.segmentedControl = UISegmentedControl(frame: CGRect(x: 0, y:0, width: (self.view.frame.width), height: 40))
    self.segmentedControl.insertSegment(withTitle: "Photos", at: 0, animated: false)
    self.segmentedControl.insertSegment(withTitle: "Liked", at: 1, animated: false)
    self.segmentedControl.insertSegment(withTitle: "Collections", at: 2, animated: false)
    self.segmentedControl.selectedSegmentIndex = 0
    self.segmentedControl.addTarget(self, action: #selector(UserDetailsViewController.changeData(_:)), for: .valueChanged)
    self.headerView.addSubview(self.segmentedControl)
  }
  
  
  func changeData(_ sender:UISegmentedControl) {
    self.currentPage = 1
    self.photoList.removeAll()
    self.userCollectionList.removeAll()
    self.userImageView.reloadData()
    self.segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
    switch sender.selectedSegmentIndex {
    case 0:
      self.userPhotos()
    case 1:
      self.likedPhotos()
    case 2:
      self.collections()
    default:
      break
    }
    if self.segmentedControl.selectedSegmentIndex == 2{
      self.fetchCollectionData(page:self.currentPage)
    }else{
      self.fetchUserPhotos(page:self.currentPage)
    }
  }
  
  func userPhotos() {
    self.url = Constants.userPhotosURL(self.name!)
  }
  
   func likedPhotos() {
    self.url = Constants.userLikedPhotosURL(self.name!)
  }
  
  func collections() {
    self.url = Constants.userCollectiosURL(self.name!)
  }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 370 : 128
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl != nil{
          if self.segmentedControl.selectedSegmentIndex == 2{
            return self.userCollectionList.count
          }
        }
        return self.photoList.count
    }
    
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserPhotosTableViewCell
    if self.segmentedControl.selectedSegmentIndex == 2{
      cell.userCollection = self.userCollectionList[indexPath.row]
      if indexPath.row > self.loadedTill {
        self.loadedTill = indexPath.row
        if indexPath.row == ((self.currentPage * 30) - 10){
          self.currentPage = self.currentPage + 1
       self.fetchCollectionData(page:self.currentPage)
        }
      }
    }else{
      cell.userImage = self.photoList[indexPath.row]
      self.loadedTill = 0
      if indexPath.row > self.loadedTill {
        self.loadedTill = indexPath.row
        if indexPath.row == ((self.currentPage * 30) - 10){
          self.currentPage = self.currentPage + 1
          self.fetchUserPhotos(page:self.currentPage)
        }
      }
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.userImageView.deselectRow(at: indexPath, animated: false)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    if self.segmentedControl.selectedSegmentIndex == 2 {
      let vc = storyboard.instantiateViewController(withIdentifier: "CuratedCollectionViewController") as! CuratedCollectionViewController
      vc.id = self.userCollectionList[indexPath.row].id
      vc.collectionTitle = self.userCollectionList[indexPath.row].title
      self.navigationController?.pushViewController(vc, animated: true)
    }else{
    let vc = storyboard.instantiateViewController(withIdentifier: "zoomview") as! ZoomViewController
    vc.zoomImage = self.photoList[indexPath.item]
    vc.name = self.photoList[indexPath.item].user.username
    vc.username = self.photoList[indexPath.item].user.name
    vc.profileImageURL = self.photoList[indexPath.item].user.userImage
    vc.bio = self.photoList[indexPath.item].user.bio
    vc.location = self.photoList[indexPath.item].user.location
    vc.id = self.photoList[indexPath.item].id
    self.navigationController?.pushViewController(vc, animated: true)
  }
  }

  func updateUserView(){
    self.userImage.toCircle()
    self.userImage.image = self.profileImage
    self.userName.text = self.name
    self.bio.text = self.userBio
    self.location.text =  (self.userLocation)
  }
  
  func fetchUserPhotos(page:Int) {
    Photo.fetchData(url: self.url, page: page, query: nil, callback: {
            photos, error  in
        if error != nil{
          Alert.error(message: error!.localizedDescription)
        }
        else if photos != nil && photos!.count > 0{
          for photo in photos! {
            self.photoList.append(photo)
          }
          self.userImageView.reloadData()
        }else{
          Alert.warning(message: "No Items found")
        }
      }
    )
    }

  
  func fetchCollectionData(page:Int){
      Curation.fetchData(url: self.url, page: page, callback:{
      collection, error  in
      if error != nil{
        Alert.error(message: error!.localizedDescription)
      }
      else if collection != nil && collection!.count > 0{
        for data in collection! {
          self.userCollectionList.append(data)
        }
        self.userImageView.reloadData()
      }
      else{
        Alert.warning(message: "No Item Found")
      }
    })
  }
 }


