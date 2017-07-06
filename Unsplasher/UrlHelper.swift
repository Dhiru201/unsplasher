//
//  UrlHelper.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//


import Alamofire

class URLHelper{
  
  static func get(url: String, parameters: [String: Any]?, headers: [String: String]?, callback: @escaping (DataResponse<Any>) -> Void){
    Alamofire.request(Constants.baseURL + url, method: .get, parameters: parameters, headers: headers).responseJSON(completionHandler: {
      response in
      callback(response)
    })
  }
  
  static func post(url: String, parameters: [String: Any]?, headers: [String: String]?, callback: @escaping (DataResponse<Any>) -> Void){
    Alamofire.request(Constants.baseURL + url, method: .post, parameters: parameters, headers: headers).responseJSON(completionHandler: {
      response in
      callback(response)
    })
  }
  
  static func delete(url: String, parameters: [String: Any]?, headers: [String: String]?, callback: @escaping (DataResponse<Any>) -> Void){
    Alamofire.request(Constants.baseURL + url, method: .delete, parameters: parameters, headers: headers).responseJSON(completionHandler: {
      response in
      callback(response)
    })
  }
  
}

