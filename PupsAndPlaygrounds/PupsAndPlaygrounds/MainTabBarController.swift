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
    
    let homeNC = UINavigationController(rootViewController: )
    homeNC.title = "List View"
    homeNC.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
    
    let feedNC = UINavigationController(rootViewController: FeedViewController())
    feedNC.title = "Feed"
    feedNC.tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
    
    let profileNC = UINavigationController(rootViewController: ProfileViewController())
    profileNC.title = "Profile"
    profileNC.tabBarItem = UITabBarItem(title: "Profile", image: nil, selectedImage: nil)
    
    viewControllers = [homeNC, feedNC, profileNC]
    tabBar.isTranslucent = false
  }
}
