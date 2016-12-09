//
//  CreateAccountViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class CreateAccountViewController: UIViewController {
  
  // MARK: Properties
  lazy var createAccountView = CreateAccountView()
  let containerVC = (UIApplication.shared.delegate as? AppDelegate)?.containerViewController
  
  // MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createAccountView.scrollView.delegate = self
    
    createAccountView.firstNameField.delegate = self
    createAccountView.lastNameField.delegate = self
    createAccountView.emailField.delegate = self
    createAccountView.passwordField.delegate = self
    
    createAccountView.checkButton.addTarget(self, action: #selector(checkButtonTouched), for: .touchUpInside)
    
    view.addSubview(createAccountView)
    createAccountView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { _ = view.endEditing(true) }
  
  func checkButtonTouched() {
    guard let firstName = createAccountView.firstNameField.text else { print("error unwrapping first name"); return }
    guard let lastName = createAccountView.lastNameField.text else { print("error unwrapping last name"); return }
    guard let email = createAccountView.emailField.text else { print("error unwrapping email"); return }
    guard let password = createAccountView.passwordField.text else { print("error unwrapping password"); return }
    
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
      
      let mainTBC = MainTabBarController()
      self.containerVC?.childVC = mainTBC
      self.containerVC?.setup(forAnimation: .slideLeft)
    }
  }
}

// MARK: - UIScrollViewDelegate
extension CreateAccountViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    createAccountView.pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
    print(createAccountView.pageControl.currentPage)
  }
}

// MARK: - UITextFieldDelegate
extension CreateAccountViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
}
