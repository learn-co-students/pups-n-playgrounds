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
    
    var isAnonymous = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if FIRAuth.auth()?.currentUser?.isAnonymous == true {
            isAnonymous = true
        }
        
        let homeNC = UINavigationController(rootViewController: HomeViewController())
        homeNC.navigationBar.isTranslucent = false
        homeNC.navigationBar.barTintColor = UIColor.themeMediumBlue
        homeNC.navigationBar.tintColor = UIColor.themeWhite
        homeNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.themeWhite]
        homeNC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home Tab Bar"), selectedImage: nil)
        
        let feedNC = UINavigationController(rootViewController: FeedViewController())
        feedNC.navigationBar.isTranslucent = false
        feedNC.navigationBar.barTintColor = UIColor.themeMediumBlue
        feedNC.navigationBar.tintColor = UIColor.themeWhite
        feedNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.themeWhite]
        feedNC.tabBarItem = UITabBarItem(title: "Live Feed", image: #imageLiteral(resourceName: "Feed Tab Bar"), selectedImage: nil)
        
        if isAnonymous == true {
//          will change to a sign in page
            let profileNC = UINavigationController(rootViewController: ProfileViewController())
            profileNC.navigationBar.isTranslucent = false
            profileNC.navigationBar.barTintColor = UIColor.themeMediumBlue
            profileNC.navigationBar.tintColor = UIColor.themeWhite
            profileNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.themeWhite]
            profileNC.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile Tab Bar"), selectedImage: nil)
            
            viewControllers = [homeNC, feedNC, profileNC]
            tabBar.tintColor = UIColor.themeRed
        } else {
             let profileNC = UINavigationController(rootViewController: ProfileViewController())
            profileNC.navigationBar.isTranslucent = false
            profileNC.navigationBar.barTintColor = UIColor.themeMediumBlue
            profileNC.navigationBar.tintColor = UIColor.themeWhite
            profileNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.themeWhite]
            profileNC.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile Tab Bar"), selectedImage: nil)
            
            viewControllers = [homeNC, feedNC, profileNC]
            tabBar.tintColor = UIColor.themeRed
        }
    }
}
