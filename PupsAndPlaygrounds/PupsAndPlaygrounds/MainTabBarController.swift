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
    
    let homeViewController = HomeViewController()
    homeViewController.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
    
    let feedViewController = FeedViewController()
    feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
    
    let profileViewController = ProfileViewController()
    profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: nil, selectedImage: nil)
    
    viewControllers = [homeViewController, feedViewController, profileViewController]
    tabBar.isTranslucent = false
  }
}
