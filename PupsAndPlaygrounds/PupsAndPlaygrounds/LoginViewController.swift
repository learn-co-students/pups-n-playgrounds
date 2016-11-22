//
//  LoginViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

final class LoginViewController: UIViewController {
  
  // MARK: Properties
  var loginView: LoginView!
  var facebookLoginManager: FBSDKLoginManager!
  
  // MARK: Override Methods
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(true)
    
    isUserSignedIn()
  }
  
  // MARK: Logic Methods
  func isUserSignedIn() {
    
      }
  
  func configure() {
    loginView = LoginView()
    loginView.loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
    loginView.facebookButton.addTarget(self, action: #selector(facebookButtonTouched), for: .touchUpInside)
    loginView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTouched), for: .touchUpInside)
    
    facebookLoginManager = FBSDKLoginManager()
    
    view = loginView
  }
  
  // MARK: Action Methods
  func loginButtonTouched() {
    
    let firebaseView = FirebaseTestViewController()
    self.navigationController?.pushViewController(firebaseView, animated: true)
    
<<<<<<< HEAD
    FIRAuth.auth()?.signIn(withEmail: email, password: password) { self.handleSignIn(user: $0, error: $1) }
  }
  
  func facebookButtonTouched() {
    
    facebookLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { result, error in
      
      guard error == nil else { print("error signing user in with facebook"); return }
      
      guard let result = result else { print("error retrieving facebook login result"); return }
      result.isCancelled ? print("facebook sign in cancelled") : print("facebook login successful")
      
      let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
      FIRAuth.auth()?.signIn(with: credential) { self.handleSignIn(user: $0, error: $1) }
    }
=======
>>>>>>> 5f11df889a5a84c477b5e4be3f09f4ba77a2ca2d
  }
  
  func handleSignIn(user: FIRUser?, error: Error?) {
    
    guard error == nil else { print("error signing user in"); return }
    
    let profileVC = ProfileViewController()
    self.navigationController?.pushViewController(profileVC, animated: true)
  }

  func createAccountButtonTouched() {
    
    let createAccountVC = CreateAccountViewController()
    navigationController?.pushViewController(createAccountVC, animated: true)
  }
}
