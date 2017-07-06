//
//  Login.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 17/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import Foundation
import AlamofireOauth2
import Alamofire
import KeychainAccess

class LoginManager {
  
  class func oauthSetting() -> Oauth2Settings{
    return Oauth2Settings(
        baseURL: Constants.baseURL,
        authorizeURL: Constants.authorizeURL,
        tokenURL: Constants.tokenURL,
        redirectURL: Constants.redirectURL,
        clientID: Constants.clientId,
        clientSecret: Constants.clientSecret,
        scope: Constants.scope
      )
    }
  
  static func login(callback: @escaping (User?, Error?) -> Void){
      UsingOauth2(LoginManager.oauthSetting(), performWithToken: { token in
        print(token)
        URLHelper.get(url: Constants.meURL, parameters: nil, headers: ["Authorization": "Bearer \(token)"], callback: {
          response in
          if response.error != nil{
            callback(nil, response.error)
          }else{
            callback(User(data: response.result.value as! Dictionary<String, Any>), nil)
          }
        }
        )}, errorHandler: {
          print("Some error occurred")
      })
  }
  
  class func logout(){
    Oauth2ClearTokensFromKeychain(LoginManager.oauthSetting())
    let appDomain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: appDomain)
    let cookies = HTTPCookieStorage.shared.cookies
    if (cookies?.count)! > 0{
      for cookie in cookies!{
        if cookie.domain == "unsplash.com" || cookie.domain == "api.unsplash.com" || cookie.domain == ".unsplash.com" || cookie.domain == ".facebook.com"{
          HTTPCookieStorage.shared.deleteCookie(cookie)
        }
      }
    }
  }
  
  class func showLoginAlert() -> Bool{
    let keychain = Keychain(service: Constants.baseURL)
    do {
      return (try keychain.get("OAuth2AccessToken") == nil)
    } catch {
      return true
    }
}
  
  class func isLoggedin() -> Bool{
      return !(self.showLoginAlert())
  }
  
  }






