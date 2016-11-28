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
import FBSDKCoreKit
import FBSDKLoginKit

final class LoginViewController: UIViewController {
  
  // MARK: Properties
  let loginView = LoginView()
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  
  // MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loginView.emailField.delegate = self
    loginView.passwordField.delegate = self
    loginView.facebookButton.delegate = self
    loginView.loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
//    loginView.facebookButton.addTarget(self, action: #selector(facebookButtonTouched), for: .touchUpInside)
    loginView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTouched), for: .touchUpInside)
    loginView.skipButton.addTarget(self, action: #selector(skipButtonTouched), for: .touchUpInside)
    
    view.addSubview(loginView)
    loginView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    if FBSDKAccessToken.current() != nil {
      appDelegate?.window?.rootViewController = MainTabBarController()
    }
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
      
      self.appDelegate?.window?.rootViewController = MainTabBarController()
    }
  }
  
  
  func createAccountButtonTouched() {
    self.appDelegate?.window?.rootViewController = CreateAccountViewController()
  }
  
  func skipButtonTouched() {
    FIRAuth.auth()?.signInAnonymously { user, error in
      self.appDelegate?.window?.rootViewController = MainTabBarController()
    }
    
  }
}

// MARK: FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
  func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

    FIRAuth.auth()?.signIn(with: credential) { user, error in
      self.appDelegate?.window?.rootViewController = MainTabBarController()
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    try? FIRAuth.auth()?.signOut()
  }
  
//  func facebookButtonTouched() {
//    FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { result, error in
//      print("ok")
//    }
//  }
  
  
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
}
