//
//  MainTabBarController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let homeNC = UINavigationController(rootViewController: HomeViewController())
    homeNC.navigationBar.isTranslucent = false
    homeNC.navigationBar.barTintColor = UIColor.themeCoral
    homeNC.navigationBar.tintColor = UIColor.white
    homeNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    homeNC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home Tab Bar"), selectedImage: nil)
    
    let feedNC = UINavigationController(rootViewController: FeedViewController())
    feedNC.navigationBar.isTranslucent = false
    feedNC.navigationBar.barTintColor = UIColor.themeCoral
    feedNC.navigationBar.tintColor = UIColor.white
    feedNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    feedNC.tabBarItem = UITabBarItem(title: "Live Feed", image: #imageLiteral(resourceName: "Feed Tab Bar"), selectedImage: nil)
    
    let profileNC = UINavigationController(rootViewController: ProfileViewController())
    profileNC.navigationBar.isTranslucent = false
    profileNC.navigationBar.barTintColor = UIColor.themeCoral
    profileNC.navigationBar.tintColor = UIColor.white
    profileNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    profileNC.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile Tab Bar"), selectedImage: nil)
    
    viewControllers = [homeNC, feedNC, profileNC]
    tabBar.tintColor = UIColor.themeCoral
  }
}
