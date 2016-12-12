//
//  AnyonymousUserViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 12/10/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class AnyonymousUserViewController: UIViewController {
  
  // MARK: Properties
  lazy var anonymousUserView = AnonymousUserView()
  lazy var containerVC = (UIApplication.shared.delegate as? AppDelegate)?.containerViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Profile"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .done, target: self, action: #selector(login))
    
    anonymousUserView.createAccountButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
    
    view.addSubview(anonymousUserView)
    anonymousUserView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func viewDidLayoutSubviews() {
    anonymousUserView.layer.sublayers?.first?.frame = anonymousUserView.frame
  }
}

// MARK: - Action Methods
extension AnyonymousUserViewController {
  func login() {
    let loginVC = LoginViewController()
    loginVC.view.layoutIfNeeded()
    
    containerVC?.childVC = loginVC
    containerVC?.setup(forAnimation: .slideUp)
  }
  
  func createAccount() {
    let createAccountVC = CreateAccountViewController()
    
    containerVC?.childVC = createAccountVC
    containerVC?.setup(forAnimation: .slideUp)
  }
}
