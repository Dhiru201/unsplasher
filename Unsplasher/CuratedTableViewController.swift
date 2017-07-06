//
//  CurationTableViewController.swift
//  UnsplashDemo
//
//  Created by Dhirendra Verma on 10/05/17.
//  Copyright © 2017 Dharmendra Verma. All rights reserved.
//

import UIKit

class CuratedTableViewController: UITableViewController {
  var segmentedControl: UISegmentedControl!
  let refreshCtrl = UIRefreshControl()
  var id:Int?
  var collectionList:Array<Curation> = []
  var currentPage = 1
  var loadedTill = 0
  var url:String!
  var collectionType:CollectionType!
  
  @IBOutlet weak var activity: UIActivityIndicatorView!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.allCollection()
    self.activity.isHidden = true
    self.title = "Collection"
    self.tableView?.showsVerticalScrollIndicator = false
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    self.navigationController?.isNavigationBarHidden = false
    self.navigationController?.navigationBar.tintColor = UIColor(netHex: Constants.themeColor)
    self.tabBarController?.tabBar.tintColor = UIColor(netHex: Constants.themeColor)
    
    self.tableView?.showsVerticalScrollIndicator = false
    self.setSegmentedControl()
    self.fetchCollectionList(page:self.currentPage)
    self.tableView.estimatedSectionHeaderHeight = 40.0
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 300

      }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.hidesBarsOnSwipe = false
    self.segmentedControl.isHidden = false
  
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.segmentedControl.isHidden = true
  }
  
 
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor.white
    return view
  }
  
  func setSegmentedControl(){
    self.segmentedControl = UISegmentedControl(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + 20, width: self.view.frame.width, height: 40))
    self.segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
    self.segmentedControl.insertSegment(withTitle: "Curated", at: 1, animated: false)
    self.segmentedControl.insertSegment(withTitle: "Featured", at: 2, animated: false)
    self.segmentedControl.selectedSegmentIndex = 0
    self.segmentedControl.addTarget(self, action: #selector(UserDetailsViewController.changeData(_:)), for: .valueChanged)
    self.segmentedControl.backgroundColor = UIColor.white
    self.segmentedControl.tintColor = UIColor(netHex: Constants.themeColor)
    self.navigationController?.view.addSubview(self.segmentedControl)
  }

  func changeData(_ sender:UISegmentedControl) {
    self.currentPage = 1
    self.collectionList.removeAll()
    self.segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
    self.prepareURL(sender.selectedSegmentIndex)
    self.activity.startAnimating()
    self.fetchCollectionList(page: self.currentPage)
    self.tableView.reloadData()
  }
  
  func prepareURL(_ selectedindex:Int){
    switch selectedindex {
    case 0:
      self.allCollection()
    case 1:
      self.CuratedCollectoin()
    case 2:
      self.FeaturedCollection()
    default:
      break
    }
  }
  
  
  func allCollection() {
    self.collectionType = .ALL
    self.url = Constants.allCollectionURL
  }
  
  func CuratedCollectoin() {
    self.collectionType = .CURATED
    self.url = Constants.curatedCollectionURL
  }
  
  func FeaturedCollection() {
    self.collectionType = .FEATURED
    self.url = Constants.featuredCollectionURL
  }

  func refreshStart(){
    if self.activity.isAnimating == false {
      self.refreshCtrl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
      self.refreshCtrl.attributedTitle = NSAttributedString(string: "Reloading", attributes: [NSForegroundColorAttributeName: UIColor(netHex: Constants.themeColor)])
      self.refreshCtrl.tintColor = UIColor(netHex: Constants.themeColor)
      self.tableView?.alwaysBounceVertical = true
      self.tableView?.addSubview(refreshCtrl)
    }
  }
  
  func refresh(_ sender:AnyObject){
    let index = self.segmentedControl.selectedSegmentIndex
    self.prepareURL(index)
    self.collectionList.removeAll()
    self.tableView.reloadData()
    self.currentPage = 1
    self.fetchCollectionList(page: self.currentPage)
    self.refreshCtrl.endRefreshing()
  }
 
  func fetchCollectionList(page: Int){
    self.segmentedControl.isUserInteractionEnabled = false
    Curation.fetchData(url: self.url,page: page, callback:{
      collection, error  in
      if error != nil{
        Alert.error(message: error!.localizedDescription)
      }
      else if collection != nil && collection!.count > 0{
        for data in collection! {
          self.collectionList.append(data)
        }
        self.tableView.reloadData()
        self.activity.stopAnimating()
        self.segmentedControl.isUserInteractionEnabled = true
        self.refreshControl?.endRefreshing()
        self.refreshStart()
      }
      else{
        Alert.warning(message: "No Item Found")
      }
    })
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.collectionList.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CuratedTableViewCell", for: indexPath) as! CuratedTableViewCell
    cell.backgroundColor = UIColor(netHex: Constants.userBaseColor)
    cell.cellData = self.collectionList[indexPath.row]
    if indexPath.row > self.loadedTill{
      self.loadedTill = indexPath.row
      if indexPath.row == ((self.currentPage * 30) - 10){
        self.currentPage = self.currentPage + 1
        self.fetchCollectionList(page: self.currentPage)
      }
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: false)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "CuratedCollectionViewController") as! CuratedCollectionViewController
    vc.collectionType = self.collectionType
    vc.id = self.collectionList[indexPath.row].id
    vc.collectionTitle = self.collectionList[indexPath.row].title
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
}
