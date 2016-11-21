//
//  LoginViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

final class LoginViewController: UIViewController {
  
  // MARK: Properties
  var loginView: LoginView!
  
  // MARK: Override Methods
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    loginView = LoginView()
    loginView.loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
    loginView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTouched), for: .touchUpInside)
    
    view = loginView
  }
  
  deinit {
    print("deinitialized LoginViewController")
  }
  
  // MARK: Action Methods
  func loginButtonTouched() {
    
    guard let email = loginView.emailField.text else { print("error unwrapping user email"); return }
    guard let password = loginView.passwordField.text else { print("error unwrapping user password"); return }
    
    FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
      
      guard error == nil else { print("error signing user in"); return }
      
      let homeVC = HomeViewController()
      self.navigationController?.pushViewController(homeVC, animated: true)
    }
  }
  
  func createAccountButtonTouched() {
    
    let createAccountVC = CreateAccountViewController()
    navigationController?.pushViewController(createAccountVC, animated: true)
  }
}
