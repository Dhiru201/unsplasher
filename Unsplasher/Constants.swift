//
//  Constants.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}

class Constants{
  
  static let clientId: String = "***REMOVED***"
  
  static let baseURL: String = "https://api.unsplash.com"
  
  static let categoryURL:String = "/categories"
  
  static let searchURL:String = "/search/photos"
  
  static let photosURL:String = "/photos"
  
  static let allCollectionURL:String = "/collections"
  
  static let curatedCollectionURL:String = "/collections/curated"
  
  static let featuredCollectionURL:String = "/collections/featured"
  
  static let meURL:String = "/me"
  
  class var supportMailRecepient : [String]{
    return ["applers.in@gmail.com"]
  }
  
  class var mailReport : [String]{
    return ["support@unsplash.com"]
  }
  
  
  class var supportMailDefaultBody : String{
    return "Please write your query here."
  }
  
  class var supportMailSubject : String{
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    return "Support for 'Unsplasher - Version : \(version!)'"
  }

  
  class var clientSecret: String{
    return "***REMOVED***"
  }
  
  class func userLikeURL(_ username: String) -> String{
    return "/users/\(username)/likes"
  }
  
  class func likePath(_ id: String) -> String{
    return "/photos/\(id)/like/"
  }
    
  class func photoInfo(_ id: String) -> String{
        return "/photos/\(id)"
    }
    
  class var scope: String{
    return "public+read_user+write_user+read_photos+write_photos+write_likes"
  }
  
  class var redirectURL: String{
    return "splasher://oauth/callback"
  }
  
  class var tokenURL: String{
    return "https://unsplash.com/oauth/token"
  }
  
  class var authorizeURL: String{
    return "https://unsplash.com/oauth/authorize"
  }

  static func allCollectionDetailURL(id:Int) -> String{
    return "/collections/\(id)/photos"
  }
  
  static func curatedCollectionDetailURL(id:Int) -> String{
    return "/collections/curated/\(id)/photos"
  }
  
  static func featuredCollectionDetailURL(id:Int) -> String{
    return "/collections/\(id)/photos"
  }
  
  static func categoryDetailURL(id: Int) -> String{
    return  "/categories/\(id)/photos"
  }
  
  class func userPhotosURL(_ username: String) -> String{
    return "/users/\(username)/photos"
  }
  
  class func userLikedPhotosURL(_ username: String) -> String{
    return "/users/\(username)/likes"
  }
  
  class func userCollectiosURL(_ username: String) -> String{
    return "/users/\(username)/collections"
  }
  
  class var themeColor: Int{
    return 0xFF4981
  }
  
  class var userBaseColor: Int{
    return 0xf5f4f4
  }
  
  class var cellBackGround: Int{
    return 0xF2F2F2
  }
  
  
}

