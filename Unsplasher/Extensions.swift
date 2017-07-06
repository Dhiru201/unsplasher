//
//  Extensions.swift
//  Unsplasher
//
//  Created by Dhirendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit


extension UIImageView{
  func toCircle(){
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = true;
  }
  
  func roundCorner(radius: Float){
    self.layer.cornerRadius = CGFloat(radius);
    self.clipsToBounds = true;
  }
  
}

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(netHex:Int) {
    self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
  }
}

extension String {
  
  var asDate:String {
    let styler = DateFormatter()
    styler.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
    let date: Date = styler.date(from: self)!
    styler.dateStyle = .medium
    styler.timeStyle = .medium
    return styler.string(from: date)
  }
  
}

extension UILabel {
  func toWhite(){
    self.textColor = UIColor.white
  }
  
  func toTheme(){
    self.textColor = UIColor(netHex: Constants.themeColor)
  }

}
