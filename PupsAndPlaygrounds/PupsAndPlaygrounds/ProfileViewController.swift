//
//  ProfileViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  // MARK: Properties
  var profileView: ProfileView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = false
    
    profileView = ProfileView()
    view = profileView
  }
  
  
}
