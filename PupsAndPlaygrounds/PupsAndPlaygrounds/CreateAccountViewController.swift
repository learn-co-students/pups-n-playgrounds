//
//  CreateAccountViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
  
  // MARK: Properties
  var createAccountView: CreateAccountView!
  
  
  // MARK: Override Methods
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    createAccountView = CreateAccountView()
    createAccountView.createAccountButton.addTarget(self, action: #selector(createAccountTouched), for: .touchUpInside)
    
    view = createAccountView
  }
  
  deinit { print("deinitialized CreateAccountViewController") }
  
  
  func createAccountTouched() {
    
    guard let firstName = createAccountView.firstNameField.text else { return }
    guard let lastName = createAccountView.lastNameField.text else { return }
    guard let email = createAccountView.emailField.text else { return }
    guard let password = createAccountView.passwordField.text else { return }
    guard let checkedPassword = createAccountView.retypePasswordField.text else { return }
    
    FirebaseData.createAccountTouched(firstName: firstName, lastName: lastName, email: email, password: password, checkedPassword: checkedPassword)
    
    let profileVC = ProfileViewController()
    self.navigationController?.pushViewController(profileVC, animated: true)
    
  }
  
}


