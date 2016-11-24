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
    loginView.emailField.delegate = self
    loginView.passwordField.delegate = self
    loginView.loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
    loginView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTouched), for: .touchUpInside)
    loginView.skipButton.addTarget(self, action: #selector(skipButtonTouched), for: .touchUpInside)
    
    view = loginView
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    _ = view.endEditing(true)
  }
  
  // MARK: Action Methods
  func loginButtonTouched() {
    
    guard let email = loginView.emailField.text else { print("error unwrapping user email"); return }
    guard let password = loginView.passwordField.text else { print("error unwrapping user password"); return }
    
    FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
      guard error == nil else { print("error signing user in"); return }
      
      let profileVC = ProfileViewController()
//      self.navigationController?.pushViewController(profileVC, animated: true)
    }
  }
  
  func createAccountButtonTouched() {
    let createAccountVC = CreateAccountViewController()
//    navigationController?.pushViewController(createAccountVC, animated: true)
  }
  
  func skipButtonTouched() {
    let homeVC = HomeViewController()
//    navigationController?.pushViewController(homeVC, animated: true)
  }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
}
