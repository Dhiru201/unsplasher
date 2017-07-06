//
//  AppDelegate.swift
//  Unsplasher
//
//  Created by Dharmendra Verma on 15/05/17.
//  Copyright © 2017 Dhirendra kumar Verma. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      Fabric.with([Crashlytics.self])
      self.setBlurStatusBar()
      UINavigationBar.appearance().tintColor = UIColor(netHex: Constants.themeColor)
      UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-600, 0), for:UIBarMetrics.default)
      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(netHex: Constants.themeColor),
                                                          NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 22)!]
      
      UITabBar.appearance().tintColor = UIColor(netHex: Constants.themeColor)
    return true
  }
  
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
      return UIInterfaceOrientationMask.portrait
    }
    //      UINavigationBar.appearance().backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func setBlurStatusBar()  {
    let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
    view.backgroundColor = UIColor.clear
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    //always fill the view
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(blurEffectView)
    self.window?.rootViewController?.view.addSubview(view)
  }
}

