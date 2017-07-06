//
//  PhotoInfo.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 04/07/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//



class PhotoInfo {
    var downloads:String?
    var likes:String?
    var view:String?
    var make:String?
    var model:String?
    var height:String?
    var width:String?
    var aperture:String?
    var foculLength:String?
    var iso:String?
    var publishedOn:String?
    
    init(data:Dictionary<String, Any>) {
        
        if let downloads = data["downloads"] {
            self.downloads = "\(downloads)"
        }
        if let likes = data["likes"] {
            self.likes = "\(likes)"
        }
        if let view = data["views"] {
            self.view = "\(view)"
        }
        if let make = (data["exif"] as! Dictionary<String, Any>)["make"] {
            self.make = (make as? String)
        }
        if let model = (data["exif"] as! Dictionary<String, Any>)["model"] {
            self.model = (model as? String)
        }
        
        if let aperture = (data["exif"] as! Dictionary<String, Any>)["aperture"] {
            self.aperture = (aperture as? String)
        }
        if let foculLength = (data["exif"] as! Dictionary<String, Any>)["focal_length"] {
            self.foculLength = (foculLength as? String)
        }
        if let iso = (data["exif"] as! Dictionary<String, Any>)["iso"] {
            self.iso = "\(iso)"
        }
        if let publishedOn = data["created_at"] {
            self.publishedOn = (publishedOn as! String).asDate
        }
        if  let height = (data["height"]) {
            self.height = "\(height)"
        }
        if let width = (data["width"]) {
            self.width = "\(width)"
        }
    }
    
    static func fetchPhotoInfo(url: String, callback:@escaping (PhotoInfo?, Error?)-> Void){
        var result:PhotoInfo!
        URLHelper.get(url: url,  parameters: ["client_id": Constants.clientId], headers: nil, callback: {
            response in
            if response.error != nil{
                callback(nil, response.error)
            }else{
                let data = response.result.value
                    result = PhotoInfo(data: data as! Dictionary<String, Any>)
                }
                callback(result, nil)
            })
        }
    }


