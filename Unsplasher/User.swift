//
//  User.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

class User{
    var name:String
    var bio:String?
    var userImage: String!
    var userLargeProfileImage:String!
    var likes:Int!
    var location: String?
    var username: String?
    var email: String?
    var likePhotos: String?
    var instagramUsername: String?
  
  
    init(data: Dictionary<String, Any>){
        self.name = data["name"] as! String
    
        if let bio = data["bio"]{
        self.bio = bio as? String
        }
        if let location = data["location"]{
            self.location = location as? String
        }
        if let username = data["username"]{
            self.username = username as? String
        }
        if let instagramUsername = data["instagram_username"]{
            self.instagramUsername = instagramUsername as? String
        }
        self.userImage = (data["profile_image"] as! Dictionary<String, String>)["medium"]
        self.userLargeProfileImage = (data["profile_image"] as! Dictionary<String, String>)["large"]
        self.likes = data["total_likes"] as! Int!
        self.email = data["email"] as? String
        self.likePhotos = (data["links"]as! Dictionary<String, String>)["photos"]
    }
}

