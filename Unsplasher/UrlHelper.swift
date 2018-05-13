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
	let params = URLHelper.processParam(parameters: parameters)
    Alamofire.request(Constants.baseURL + url, method: .get, parameters: params, headers: headers).responseJSON(completionHandler: {
      response in
      callback(response)
    })
  }
  
  static func post(url: String, parameters: [String: Any]?, headers: [String: String]?, callback: @escaping (DataResponse<Any>) -> Void){
	let params = URLHelper.processParam(parameters: parameters)
    Alamofire.request(Constants.baseURL + url, method: .post, parameters: params, headers: headers).responseJSON(completionHandler: {
      response in
      callback(response)
    })
  }
  
  static func delete(url: String, parameters: [String: Any]?, headers: [String: String]?, callback: @escaping (DataResponse<Any>) -> Void){
	let params = URLHelper.processParam(parameters: parameters)
	Alamofire.request(Constants.baseURL + url, method: .delete, parameters: params, headers: headers).responseJSON(completionHandler: {
      response in
      callback(response)
    })
  }
	
  static func processParam(parameters: [String: Any]?) -> [String: Any]?{
	var params = parameters
	if params == nil{
		return nil
	}
	params!["utm_source"] = Constants.appName
	return params
  }
	
  
}

