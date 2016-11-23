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
  
  deinit {
    
    print("deinitialized CreateAccountViewController")
  }
  
  func createAccountTouched() {
    
    guard let firstName = createAccountView.firstNameField.text else { print("error unwrapping first name"); return }
    guard let lastName = createAccountView.lastNameField.text else { print("error unwrapping last name"); return }
    guard let email = createAccountView.emailField.text else { print("error unwrapping email"); return }
    guard let password = createAccountView.passwordField.text else { print("error unwrapping password"); return }
    guard let retypePassword = createAccountView.retypePasswordField.text else { print("error unwrapping retyped password"); return }
    
    guard password == retypePassword else { print("passwords do not match"); return }
    
    FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
      
      guard error == nil else { print("error creating firebase user"); return }
      guard let user = user else { print("error unwrapping user data"); return }
      
      let changeRequest = user.profileChangeRequest()
      changeRequest.displayName = firstName + lastName
      
      changeRequest.commitChanges { error in
        
        guard error == nil else { print("error commiting changes for user profile change request"); return }
        
        let profileVC = ProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
      }
    }
  }
}
