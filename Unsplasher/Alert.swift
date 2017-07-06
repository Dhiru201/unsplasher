//
//  Alert.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit

struct Alert{
  

  static func error(message: String){
   commonAlert(title: "Error", message: message)
  }
  
  static func warning(message: String){
    commonAlert(title: "Warning", message: message)
  }
  
  static func notification(message: String){
    commonAlert(title: "Notification", message: message)
  }
  
  static func commonAlert(title: String, message: String){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    if let window = UIApplication.shared.windows.first {
      window.rootViewController?.present(alertController, animated: true, completion: nil)
    }
  }
  
}

