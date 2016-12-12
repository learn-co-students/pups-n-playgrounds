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
  var profileNC: UINavigationController?
  
  var currentTag = 0
  
  // MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    homeNC.navigationBar.isTranslucent = false
    homeNC.navigationBar.barTintColor = UIColor.themeMarine
    homeNC.navigationBar.tintColor = UIColor.white
    homeNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    homeNC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home Tab Bar"), tag: 0)
    
    feedNC.navigationBar.isTranslucent = false
    feedNC.navigationBar.barTintColor = UIColor.themeMarine
    feedNC.navigationBar.tintColor = UIColor.white
    feedNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    feedNC.tabBarItem = UITabBarItem(title: "Live Feed", image: #imageLiteral(resourceName: "Feed Tab Bar"), tag: 1)
    
    if let anonymous = FIRAuth.auth()?.currentUser?.isAnonymous {
      if anonymous {
        self.profileNC = UINavigationController(rootViewController: AnyonymousUserViewController())
      } else {
        let userProfileVC = UserProfileViewController()
        
        NotificationCenter.default.addObserver(userProfileVC, selector: #selector(userProfileVC.displayUserInfo), name: Notification.Name("userStored"), object: nil)
        NotificationCenter.default.addObserver(userProfileVC, selector: #selector(userProfileVC.displayUserReviews), name: Notification.Name("reviewsStored"), object: nil)
        WSRDataStore.shared.storeUser()
        
        self.profileNC = UINavigationController(rootViewController: userProfileVC)
      }
    } else {
      self.profileNC = UINavigationController(rootViewController: AnyonymousUserViewController())
    }
    
    guard let profileNC = self.profileNC else {
      print("error unwrapping profileNC")
      return
    }
    
    profileNC.navigationBar.isTranslucent = false
    profileNC.navigationBar.barTintColor = UIColor.themeMarine
    profileNC.navigationBar.tintColor = UIColor.white
    profileNC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    profileNC.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile Tab Bar"), tag: 2)
    
    viewControllers = [homeNC, feedNC, profileNC]
    tabBar.tintColor = UIColor.themeCoral
  }
}
