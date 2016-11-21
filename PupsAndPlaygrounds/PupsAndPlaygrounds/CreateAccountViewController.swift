//
//  CreateAccountViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
  var createAccountView: CreateAccountView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createAccountView = CreateAccountView()
    view = createAccountView
  }
}
