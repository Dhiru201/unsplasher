//
//  Category.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

class Category {
  var title:String
  var photo_count:Int
  var id:Int
  
  init(data:Dictionary<String, Any>) {
    self.title = data["title"] as! String
    self.photo_count = data["photo_count"] as! Int
    self.id = data["id"] as! Int
    
  }
  
  static func fetchData(url: String, callback:@escaping ([Category]?, Error?)-> Void){
    var result:[Category] = []
    URLHelper.get(url: url,  parameters: ["client_id": Constants.clientId], headers: nil, callback: {
      response in
		print("response", response)
      if response.error != nil{
        callback(nil, response.error)
      }else{
        for data in response.result.value as! Array<Any> {
          result.append(Category(data: data as! Dictionary<String, Any>))
        }
        callback(result, nil)
      }
    })
  }
}

