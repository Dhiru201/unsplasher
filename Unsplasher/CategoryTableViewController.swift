//
//  CategoryTableViewController.swift
//  UnsplashDemo
//
//  Created by Dhirendra Verma on 05/05/17.
//  Copyright © 2017 Dharmendra Verma. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
  var categoryID:Int?
  var categoryList:Array<Category> = []
  

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = UIColor(netHex: Constants.userBaseColor)
    self.tableView?.showsVerticalScrollIndicator = false
    self.tableView.tableFooterView = UIView()
    self.navigationController?.navigationBar.tintColor = UIColor(netHex: Constants.themeColor)
    self.tabBarController?.tabBar.tintColor = UIColor(netHex: Constants.themeColor)
    self.navigationItem.titleView?.tintColor = UIColor(netHex: Constants.themeColor)
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    fetchCattegoryList()
    self.refreshControl?.attributedTitle = NSAttributedString(string: "Reloading", attributes: [NSForegroundColorAttributeName: UIColor(netHex: Constants.themeColor)])
    self.refreshControl?.tintColor = UIColor(netHex: Constants.themeColor)
    self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
  }
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
		self.navigationController?.hidesBarsOnSwipe = false
		self.tableView.reloadData()
	}
    
  func refresh(_ sender:AnyObject){
    self.categoryList.removeAll()
    self.fetchCattegoryList()
    self.tableView.reloadData()
  }
  
  func fetchCattegoryList(){
    Category.fetchData(url: Constants.categoryURL, callback:{
      categories, error  in
      
      if error != nil{
        Alert.error(message: error!.localizedDescription)
      }
      else if categories != nil && categories!.count > 0{
        for cat in categories! {
          self.categoryList.append(cat)
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
      }else{
        Alert.warning(message: "No Items found")
      }
    }
    )}
  
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
    return self.categoryList.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
    cell.backgroundColor = UIColor(netHex: Constants.userBaseColor)
    cell.catData = self.categoryList[indexPath.row]
	return cell
  }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.cellSize();//Choose your custom row height
    }
    
    func cellSize()-> CGFloat {
        let cellHeight:CGFloat
        let horizontalClass = self.traitCollection.horizontalSizeClass
        let verticalClass = self.traitCollection.verticalSizeClass
        if (horizontalClass == UIUserInterfaceSizeClass.regular) && (verticalClass == UIUserInterfaceSizeClass.regular){
             cellHeight = 120.0
        }else{
            cellHeight = 65.0
        }
        return cellHeight
    }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: false)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "CategoryCollectionViewController") as! CategoryCollectionViewController
    vc.categoryID = self.categoryList[indexPath.row].id
    vc.navtitle = self.categoryList[indexPath.row].title
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
