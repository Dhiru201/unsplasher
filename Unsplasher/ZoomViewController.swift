//
//  ZoomViewController.swift
//  UnsplashDemo
//
//  Created by Dhirendra Verma on 02/05/17.
//  Copyright © 2017 Dharmendra Verma. All rights reserved.
//

import UIKit
import SDWebImage
import CRMotionView
import MessageUI

class ZoomViewController: UIViewController, MFMailComposeViewControllerDelegate{
  @IBOutlet weak var infoView: UIView!
  @IBOutlet weak var infoButtonView: UIView!
  @IBOutlet weak var baseImage: UIImageView!
  @IBOutlet var progressLabel: UILabel!
  @IBOutlet var imageIndicator: UIActivityIndicatorView!
  @IBOutlet weak var Like: UIButton!
  @IBOutlet weak var userView: UIView!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var totalViews: UILabel!
    @IBOutlet weak var totalDownloads: UILabel!
    @IBOutlet weak var totalLikes: UILabel!
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var aperture: UILabel!
    @IBOutlet weak var focalLength: UILabel!
    @IBOutlet weak var dimensions: UILabel!
    @IBOutlet weak var iso: UILabel!
    @IBOutlet weak var publishedOn: UILabel!
    
    var zoomImage: Photo!
    var motionView:CRMotionView!
    var isLiked:Bool = false
    var username:String!
    var name:String!
    var profileImageURL:String!
    var location:String!
    var bio:String!
    var tabShowing = false
    var id:String!
    var isDataFetched:Bool = false
    
  override func viewDidLoad() {
    super.viewDidLoad()
    self.infoView.isHidden = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(ZoomViewController.toUserDetails))
    self.userView.addGestureRecognizer(tap)
    self.userImage.toCircle()
    self.downloadProfilePic()
    self.userView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    self.bottomView.isHidden = true
    self.infoButtonView.isHidden = true
    self.userName.text = self.name
    self.navigationController?.hidesBarsOnSwipe = true
    motionView = CRMotionView(frame: self.view.frame)
    self.view.addSubview(motionView!)
    updateImage(motionView!)
    let gesture = UITapGestureRecognizer(target: self, action: #selector(ZoomViewController.toggleMotion))
    self.view.addGestureRecognizer(gesture)
    self.updateImage(motionView!)
    self.baseImage.isHidden = true

  }
  
   
  override func viewDidAppear(_ animated: Bool) {
    if isLiked == true {
      self.Like.setImage(#imageLiteral(resourceName: "LikeFill"), for: UIControlState())
    }
}
  
  func toggleMotion(){
    if self.motionView.isHidden{
      self.userView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
      self.motionView.isHidden = false
      self.baseImage.isHidden = true
    }else{
      self.userView.backgroundColor = UIColor.white
      self.baseImage.isHidden = false
      self.motionView.isHidden = true
    }
  }
  
  func updateImage(_ motionView: CRMotionView){
    
    let downloader: SDWebImageDownloader = SDWebImageDownloader.shared()
    
    downloader.downloadImage(with: URL(string: self.zoomImage.regularUrl), options: .continueInBackground, progress: {
      start, size -> Void in
      if size > 0{
        var barValue = Float(start)/Float(size)
        barValue = barValue * 100
        if barValue >= 100{
          self.bottomView.isHidden = false
          self.infoButtonView.isHidden = false
          self.progressLabel.isHidden = true
          self.imageIndicator.stopAnimating()
        }else{
          self.progressLabel.isHidden = false
          self.progressLabel.text = "\(Int(barValue)) %"
        }
      }
    }, completed: {
      image, imageCacheType, error, imageUrl in
      if error == nil{
        DispatchQueue.main.async {
          motionView.image = image
          self.baseImage.image = image
          self.imageIndicator.stopAnimating()
          self.progressLabel.isHidden = true
          self.motionView.image = image
          motionView.addSubview(self.bottomView)
          motionView.addSubview(self.infoButtonView)
          motionView.addSubview(self.infoView)
          self.view.addSubview(self.bottomView)
          self.view.addSubview(self.infoButtonView)
          self.view.addSubview(self.infoView)
          self.bottomView.isHidden = false
          self.infoButtonView.isHidden = false
          
        }
      }else{
        Alert.error(message: error!.localizedDescription)
      }
    })
    
  }
  
  @IBAction func shareButton(_ sender: UIButton) {
    if self.baseImage.image != nil{
      let shareItem = [self.baseImage.image!]
      let activityVC  = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
      if let popoverController = activityVC.popoverPresentationController{
        popoverController.sourceView = sender as UIView
        popoverController.sourceRect = (sender as UIView).bounds
      }
      self.present(activityVC, animated: true, completion: nil)
      }
  }

  @IBAction func likeButton(_ sender: Any) {
    if isLiked == false{
      isLiked = true
     like()
    }else{
      isLiked = false
      unlike()
    }
  }
  
  @IBAction func reportButton(_ sender: Any) {
    let mailComposeViewController = self.configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
      self.present(mailComposeViewController, animated: true, completion: nil)
    } else {
      self.showSendMailErrorAlert()
    }
  }

  func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    mailComposerVC.setToRecipients(Constants.unsplashSupportEmail)
    mailComposerVC.setSubject("Report photo abuse")
    mailComposerVC.setMessageBody("Hi Unsplash support \n \n The following photo may be an objectionable content. \n Could you please have a look to the photo? \n \n photo url : \(self.zoomImage.smallUrl)", isHTML: false)
    
    return mailComposerVC
  }
  
  func showSendMailErrorAlert() {
    Alert.error(message:"Your device could not send e-mail.  Please check e-mail configuration and try again.")
  }
  
  // MARK: MFMailComposeViewControllerDelegate Method
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
  


  fileprivate func like() {
    if LoginManager.isLoggedin() {
    self.zoomImage.like(callback: {
      resp in
      if resp != nil{
        if resp?.error != nil{
          Alert.error(message: (resp?.error?.localizedDescription)!)
        }else{
          self.Like.setImage(#imageLiteral(resourceName: "LikeFill"), for: UIControlState())
        }
        
      }else{
        Alert.error(message: "Like Action Failed")
      }
      
    })
    }else{
     Alert.warning(message: "Login Required For This Action")
    }
  }
  
 fileprivate func unlike() {
  if LoginManager.isLoggedin() {
    self.zoomImage.unlike(callback: {
      resp in
      if resp != nil{
        if resp?.error != nil{
          Alert.error(message: (resp?.error?.localizedDescription)!)
        }else{
          self.Like.setImage(#imageLiteral(resourceName: "Like"), for: UIControlState())
          
        }
      }else{
        Alert.error(message: "Like Action Failed")
      }
    })
  }else{
    Alert.warning(message: "Login For Action")
  }
  }
  
  func downloadProfilePic(){
    let url = URL(string: self.profileImageURL)
    self.userImage.sd_setImage(with: url )
}
  
  func toUserDetails(){
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        vc.name = self.name
        vc.profileImage = self.userImage.image
        vc.userBio = self.bio
        vc.username = self.username
        vc.userLocation = self.location
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  @IBAction func infoButton(_ sender: Any) {
    if tabShowing {
   self.infoView.isHidden = true
    }else{
        if self.isDataFetched == true {
            self.infoView.isHidden = false
        }else{
            self.fetchImageInfo()
            }
        }
    tabShowing = !tabShowing
    }
    
    func setInfo(_ info: PhotoInfo){
        if info.downloads != nil {
            self.totalDownloads.text = info.downloads
        }else{
            self.totalDownloads.text = "--"
        }
        if info.likes != nil {
            self.totalLikes.text = info.likes
        }else{
            self.totalLikes.text = "--"
        }
        if info.view != nil {
            self.totalViews.text = info.view
        }else{
            self.totalViews.text = "--"
        }
        if info.aperture != nil {
            self.aperture.text = info.aperture
        }else{
            self.aperture.text = "--"
        }
        if info.foculLength != nil {
            self.focalLength.text = "\(String(describing: info.foculLength!))mm"
        }else{
            self.focalLength.text = "--"
        }
        if (info.height != nil) && info.width != nil {
            self.dimensions.text = "\(info.height!) x \(info.width!)"
        }else{
            self.dimensions.text = "--"
        }
        if info.make != nil {
            self.make.text = info.make
        }else{
            self.make.text = "--"
        }
        if info.model != nil {
            self.model.text = info.model
        }else{
            self.model.text = "--"
        }
        if info.publishedOn != nil {
            self.publishedOn.text = info.publishedOn
        }else{
            self.publishedOn.text = "--"
        }
        if info.iso != nil {
            self.iso.text = info.iso
        }else{
            self.iso.text = "--"
        }
    }
    
   func fetchImageInfo(){
    PhotoInfo.fetchPhotoInfo(url: Constants.photoInfo(self.id), callback: {
        result, error in
        if error != nil{
            Alert.error(message: (error?.localizedDescription)!)
        }else{
            if result != nil {
                self.setInfo(result!)
                self.isDataFetched = true
                self.infoView.isHidden = false
            }else{
                Alert.warning(message:"No Image Info Found" )
            }
            }
            
    })
 }
}
