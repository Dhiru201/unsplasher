//
//  Photo.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import Alamofire
import AlamofireOauth2


class Photo {
    var smallUrl:String
    var regularUrl:String
    var thumbUrl:String
    var user:User
    var id: String
    
  
  init(data:Dictionary<String, Any>) {
    self.id = (data["id"] as! String)
    self.smallUrl = (data["urls"] as! Dictionary<String, String>)["small"]!
    self.regularUrl = (data["urls"] as! Dictionary<String, String>)["regular"]!
    self.thumbUrl = (data["urls"] as! Dictionary<String, String>)["thumb"]!
    self.user = User(data:data["user"] as! Dictionary<String,Any>)
    
    }
  
  
  func like(callback: @escaping (DataResponse<Any>?) -> Void){
    UsingOauth2(LoginManager.oauthSetting(), performWithToken: {
      token in
        URLHelper.post(url: Constants.likePath(self.id), parameters: nil, headers: ["Authorization": "Bearer \(token)"], callback: { (resp) in
          callback(resp)
        })
    }, errorHandler: {
      callback(nil)
    })
  }
  
  func unlike(callback: @escaping (DataResponse<Any>?) -> Void){
    UsingOauth2(LoginManager.oauthSetting(), performWithToken: {
      token in
      URLHelper.delete(url: Constants.likePath(self.id), parameters: nil, headers: ["Authorization": "Bearer \(token)"], callback: { (resp) in
        callback(resp)
      })
    }, errorHandler: {
      callback(nil)
    })
  }

  
  static func fetchData(url: String, page: Int, query: String?,  callback: @escaping ([Photo]?,Error?) -> Void){
    
    var isSearch = false
    var parameters = ["client_id": Constants.clientId, "per_page":30, "page": page] as [String : Any]
    if (query != nil){
      isSearch = true
      parameters["query"] = query
    }
    var result:[Photo] = []
    URLHelper.get(url: url, parameters: parameters, headers: nil, callback: {
      response in
      if (response.error != nil){
        callback(nil, response.error)
      }else{
        var respData = response.result.value
        if isSearch{
          respData = (respData as! Dictionary<String, Any>)["results"]
        }
        for data in respData! as! Array<Any> {
          result.append(Photo(data: data as! Dictionary<String, Any>))
        }
        callback(result, nil)
      }
    })
  }
}

