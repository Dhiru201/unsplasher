//
//  UserTableViewController.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 17/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit
import SDWebImage
import KeychainAccess
import MessageUI


class UserTableViewController: UITableViewController, MFMailComposeViewControllerDelegate{

  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userEmail: UILabel!
  @IBOutlet weak var bio: UILabel!
  @IBOutlet weak var nickName: UILabel!
  @IBOutlet weak var enterButton: UILabel!
  @IBOutlet weak var instagramCell: UITableView!
  var user: User?
  var instagram: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sizeHeaderToFit()
        self.hideUserDetails()
        self.getUser()
        self.tableView.showsVerticalScrollIndicator = false
        self.clearsSelectionOnViewWillAppear = true
    }
  
    func sizeHeaderToFit() {
        let headerView = self.tableView.tableHeaderView!
        var headerHeight: CGFloat!
        if UIDevice.current.userInterfaceIdiom == .pad{
            headerHeight = 400
        }else{
            headerHeight = 195
        }
        headerView.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerHeight)
    }

  func getUser(){
    if LoginManager.showLoginAlert(){
      self.setLogoutView()
      Alert.notification(message: "Login to fetch user details")
    }else{
      self.fetchUser()
    }
  }
  
  func fetchUser(){
    LoginManager.login(callback: {
      result, error in
      if error == nil && result != nil{
        self.setView(user: result!)
        self.enterButton.text = "LogOut"
      }else{
        Alert.error(message: (error?.localizedDescription)!)
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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      if section == 0{
        if LoginManager.isLoggedin(){
            return 2
        }else{
          return 0
        }
      }else if section == 1{
        return 2
      }else{
        return 1
      }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0{
      if LoginManager.isLoggedin(){
        return "Personal"
      }else{
        return nil
      }
    }else if section == 1{
      return "Help"
    }else{
      return "Account"
    }
    
  }
  
  

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch indexPath.section{
    case 0:
      switch indexPath.row{
      case 0:
        self.likedPhotos()
        break;
      case 1:
        self.openInstagram()
        break;
      default:
        break;
      }
      break;
    case 1:
      switch indexPath.row{
      case 0:
        self.techSupport()
        break;
      case 1:
        break;
      default:
        break;
      }
      break;
    case 2:
          switch indexPath.row {
          case 0:
            if LoginManager.isLoggedin(){
              self.logOut()
            }else{
              self.fetchUser()
            }
            break;
        default:
          break;
  }
    
    break;
    default:
    break;
  }
  }

  func likedPhotos(){
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "CategoryCollectionViewController") as! CategoryCollectionViewController
      vc.navtitle = "Liked Photos"
      vc.url = Constants.userLikeURL((self.user?.username)!)
      self.navigationController?.pushViewController(vc, animated: true)
     }

  func openInstagram () {
    if let user = self.instagram{
      let url = "https://www.instagram.com/\(user)"
      if UIApplication.shared.canOpenURL(URL(string: url)!) {
        UIApplication.shared.open(URL(string: url)!)
      }
    }
  }
  
  func switchUserDetails(value: Bool){
    self.userName.isHidden = value
    self.nickName.isHidden = value
    self.userEmail.isHidden = value
    self.userImage.isHidden = value
    self.bio.isHidden = value
  }
  
  func hideUserDetails(){
    self.switchUserDetails(value: true)
  }
  
  func showUserDetails(){
    self.switchUserDetails(value: false)
  }
  
  func toggleUserDetails(){
    let value:Bool = LoginManager.showLoginAlert()
    switch value {
    case true:
      self.hideUserDetails()
    default:
      self.showUserDetails()
    }
  }
  
  func setLogoutView(){
    self.toggleUserDetails()
    self.bio.text = "Please loging to access user profile"
  }
  
  
  func setView(user: User){
    let instagram = user.instagramUsername
    if instagram != nil {
      self.instagram = instagram!
    }
    self.user = user
    self.userName.text =  "(\(String(describing: user.username!)))"
    self.nickName.text = user.name
    self.userEmail.text = user.email
    self.bio.text = user.bio
    let url = URL(string: self.urlSelector())
    self.userImage.sd_setImage(with: url, completed:{
      image, error, imageCacheType, imageUrl in
      self.userImage.toCircle()
      self.userImage.image = image
    })
    self.enterButton.textColor = UIColor(netHex: Constants.themeColor)
    self.enterButton.text = "Logout"
    self.toggleUserDetails()
    self.tableView.reloadData()
  }
  
    func urlSelector()->String{
        let url:String
        let horizontalClass = self.traitCollection.horizontalSizeClass
        let verticalClass = self.traitCollection.verticalSizeClass
        if (horizontalClass == UIUserInterfaceSizeClass.regular) && (verticalClass == UIUserInterfaceSizeClass.regular){
            url = (user?.userLargeProfileImage)!
        }else{
            url = (user?.userImage)!
        }
        return url
    }

    
  func logOut(){
    LoginManager.logout()
    self.setLogoutView()
    self.enterButton.textColor = UIColor.black
    self.enterButton.text = "Login"
    self.tableView.reloadData()
  }

  func techSupport(){
      let mailComposeViewController = configuredMailComposeViewController()
      if MFMailComposeViewController.canSendMail() {
        self.present(mailComposeViewController, animated: true, completion: nil)
      } else {
        self.showSendMailErrorAlert()
      }
  }

  
  
  func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    mailComposerVC.setToRecipients(Constants.supportMailRecepient)
    mailComposerVC.setSubject(Constants.supportMailSubject)
    mailComposerVC.setMessageBody(Constants.supportMailDefaultBody, isHTML: false)
    
    return mailComposerVC
  }
  
  func showSendMailErrorAlert() {
    Alert.error(message:"Your device could not send e-mail.  Please check e-mail configuration and try again.")
  }
  
  // MARK: MFMailComposeViewControllerDelegate Method
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }

}

