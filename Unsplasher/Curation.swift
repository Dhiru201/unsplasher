//
//  Curation.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import Alamofire


enum CollectionType {
  case ALL, CURATED, FEATURED
}

class Curation {
  var title:String
  var id:Int
  var user: User
  var published_at: String
  var collectionImage:String?
  
  init(data:Dictionary<String, Any>) {
    self.title = data["title"] as! String
    self.id = data["id"] as! Int
    self.user = User(data: data["user"]! as! Dictionary<String, Any>)
    self.published_at = (data["published_at"] as! String).asDate
    if let collCoverPhoto = ((data["cover_photo"] as? Dictionary<String,Any>)?["urls"] as? Dictionary<String, String>)?["small"]{
      self.collectionImage = collCoverPhoto as String!
    }
  }
  
  static func fetchData(url: String, page: Int, callback: @escaping ([Curation]?, Error?) -> Void){
    let parameters = ["client_id": Constants.clientId, "per_page":30, "page": page] as [String : Any]
    var result:[Curation] = []
    URLHelper.get(url: url, parameters: parameters, headers: nil, callback: {
      response in
      if (response.error != nil){
        callback(nil, response.error)
      }else{
        if response.result.value is Array<Any>{
          for data in response.result.value! as! Array<Any> {
            result.append(Curation(data: data as! Dictionary<String, Any>))
          }
        }
        callback(result, nil)
      }
    })
  }
}

