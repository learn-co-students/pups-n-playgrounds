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
    
    let homeNC = UINavigationController(rootViewController: FirebaseTableViewController())
    homeNC.navigationBar.isTranslucent = false
    homeNC.navigationBar.barTintColor = UIColor.themeMediumBlue
    homeNC.navigationBar.tintColor = UIColor.themeWhite
    homeNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.themeWhite]

    homeNC.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
    
    let feedNC = UINavigationController(rootViewController: FeedViewController())
    feedNC.navigationBar.isTranslucent = false
    feedNC.navigationBar.barTintColor = UIColor.themeMediumBlue
    feedNC.navigationBar.tintColor = UIColor.themeWhite
    feedNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.themeWhite]
    feedNC.tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
    
    let profileNC = UINavigationController(rootViewController: UserProfileViewController())
    profileNC.navigationBar.isTranslucent = false
    profileNC.navigationBar.barTintColor = UIColor.themeMediumBlue
    profileNC.navigationBar.tintColor = UIColor.themeWhite
    profileNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.themeWhite]
    profileNC.tabBarItem = UITabBarItem(title: "Profile", image: nil, selectedImage: nil)
    
    viewControllers = [homeNC, feedNC, profileNC]
    tabBar.isTranslucent = false
  }
}
