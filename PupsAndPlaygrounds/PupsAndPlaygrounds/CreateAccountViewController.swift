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
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  
  // MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createAccountView = CreateAccountView()
    createAccountView.createAccountButton.addTarget(self, action: #selector(createButtonTouched), for: .touchUpInside)
    createAccountView.cancelButton.addTarget(self, action: #selector(cancelButtonTouched), for: .touchUpInside)
    createAccountView.firstNameField.delegate = self
    createAccountView.lastNameField.delegate = self
    createAccountView.emailField.delegate = self
    createAccountView.passwordField.delegate = self
    createAccountView.retypePasswordField.delegate = self
    
    view = createAccountView
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    _ = view.endEditing(true)
  }
  
  func createButtonTouched() {
    guard let firstName = createAccountView.firstNameField.text else { print("error unwrapping first name"); return }
    guard let lastName = createAccountView.lastNameField.text else { print("error unwrapping last name"); return }
    guard let email = createAccountView.emailField.text else { print("error unwrapping email"); return }
    guard let password = createAccountView.passwordField.text else { print("error unwrapping password"); return }
    guard let retypePassword = createAccountView.retypePasswordField.text else { print("error unwrapping retyped password"); return }
    
    guard password == retypePassword else { print("passwords do not match"); return }
    
    FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
      guard error == nil else { print("error creating firebase user"); return }
      guard let user = user else { print("error unwrapping user data"); return }
      
      let newUserRef = FIRDatabase.database().reference().child("users").child(user.uid)
      
      newUserRef.child("firstName").setValue(firstName)
      newUserRef.child("lastName").setValue(lastName)
      newUserRef.child("email").setValue(email)
      newUserRef.child("profileImage")
      newUserRef.child("photos")
      newUserRef.child("visitedLocations")
      
      self.appDelegate?.window?.rootViewController = MainTabBarController()
    }
  }
  
  func cancelButtonTouched() {
    appDelegate?.window?.rootViewController = LoginViewController()
  }
}

// MARK: - UITextFieldDelegate
extension CreateAccountViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
}
