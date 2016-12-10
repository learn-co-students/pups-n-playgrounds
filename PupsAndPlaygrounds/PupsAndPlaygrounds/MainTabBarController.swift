//
//  MainTabBarController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
  
  // MARK: Properties
  lazy var homeNC = UINavigationController(rootViewController: HomeViewController())
  lazy var feedNC = UINavigationController(rootViewController: FeedViewController())
  lazy var profileNC = UINavigationController()
  var currentTag = 0
  
  // MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    homeNC.navigationBar.isTranslucent = false
    homeNC.navigationBar.barTintColor = UIColor.themeCoral
    homeNC.navigationBar.tintColor = UIColor.white
    homeNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    homeNC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home Tab Bar"), tag: 0)
    
    feedNC.navigationBar.isTranslucent = false
    feedNC.navigationBar.barTintColor = UIColor.themeCoral
    feedNC.navigationBar.tintColor = UIColor.white
    feedNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    feedNC.tabBarItem = UITabBarItem(title: "Live Feed", image: #imageLiteral(resourceName: "Feed Tab Bar"), tag: 1)
    
    if let anonymousUser = FIRAuth.auth()?.currentUser?.isAnonymous, !anonymousUser {
      profileNC.viewControllers = [ProfileViewController()]
    } else {
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
      
      let createAccount = UIAlertAction(title: "Create account", style: .default) {
        _ in
      }
      
      let facebookSignIn = UIAlertAction(title: "Sign in with Facebook", style: .default) {
        _ in
      }
      
      let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        self.selectedViewController = self.viewControllers?[self.currentTag]
      }
      
      alert.addAction(createAccount)
      alert.addAction(facebookSignIn)
      alert.addAction(cancel)
      
      profileNC.viewControllers = [alert]
    }
    
   

    profileNC.navigationBar.isTranslucent = false
    profileNC.navigationBar.barTintColor = UIColor.themeCoral
    profileNC.navigationBar.tintColor = UIColor.white
    profileNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    
    
    profileNC.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile Tab Bar"), tag: 2)
    
    viewControllers = [homeNC, feedNC, profileNC]
    tabBar.tintColor = UIColor.themeCoral
  }
}
