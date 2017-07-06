//
//  SearchViewController.swift
//  Unsplasher
//
//  Created by Dharmendra Verma on 22/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SearchCell"

class SearchViewController: BaseCollectionViewController, UISearchControllerDelegate, UISearchBarDelegate {
  var loadTill = 0
  var searchController:UISearchController!
  var backgroundImageView = UIImageView()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.images.removeAll()
    self.createSearchBar()
    self.navigationController?.navigationBar.tintColor = UIColor(netHex: Constants.themeColor)
    self.tabBarController?.tabBar.tintColor = UIColor(netHex: Constants.themeColor)
    self.collectionView?.showsVerticalScrollIndicator = false
    self.collectionView?.collectionViewLayout = GridLayout()
    self.definesPresentationContext = true

    }

  func createSearchBar(){
    self.searchController = UISearchController(searchResultsController:  nil)
    self.searchController.delegate = self
    self.searchController.searchBar.delegate = self
    self.searchController.searchBar.sizeToFit()
    self.searchController.hidesNavigationBarDuringPresentation = false
    self.searchController.dimsBackgroundDuringPresentation = true
    self.navigationItem.titleView = self.searchController.searchBar
  }
  

  func endSearch(searchBar: UISearchBar){
    searchBar.endEditing(true)
    self.resignFirstResponder()

  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    self.endSearch(searchBar: searchBar)
  }
 
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if searchBar.text != nil{
      self.images.removeAll()
      self.currentPage = 1
      self.endSearch(searchBar: searchBar)
      self.url = Constants.searchURL
      self.query = searchBar.text?.lowercased()
      self.fetchImages(page: self.currentPage)
      self.searchController.isActive = false
      self.collectionView?.reloadData()
    }else{
      self.endSearch(searchBar: searchBar)
    }
  }
  

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCollectionViewCell
    cell.cellImage = self.images[indexPath.row]
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
