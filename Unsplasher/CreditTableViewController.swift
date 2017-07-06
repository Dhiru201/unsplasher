//
//  CreditTableViewController.swift
//  Unsplasher
//
//  Created by Dharmendra Verma on 18/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

class CreditTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView?.showsVerticalScrollIndicator = false
    self.tableView.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var url: String!
    
    switch indexPath.row{
    case 0:
      url = "https://unsplash.com/"
      break
    case 1:
      url = "https://icons8.com/"
      break
    case 2:
      url = "https://github.com/Alamofire/Alamofire"
      break
    case 3:
      url = "https://github.com/evermeer/AlamofireOauth2"
      break
    case 4:
      url = "https://github.com/rs/SDWebImage"
      break
    case 5:
      url = "https://github.com/chroman/CRMotionView"
      break
    default:
      break
    }
    if UIApplication.shared.canOpenURL(URL(string:url)!) {
      UIApplication.shared.open(URL(string: url)!)
    }
    self.tableView.deselectRow(at: indexPath, animated: false)
    
    
   }
  
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 6
  }
}
