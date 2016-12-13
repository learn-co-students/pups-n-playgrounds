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
  let store = DataStore.shared
  
  // MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createAccountView.scrollView.delegate = self
    
    createAccountView.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    
    createAccountView.firstNameField.delegate = self
    createAccountView.lastNameField.delegate = self
    createAccountView.emailField.delegate = self
    createAccountView.passwordField.delegate = self
    
    view.addSubview(createAccountView)
    createAccountView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func viewDidLayoutSubviews() {
    createAccountView.layer.sublayers?.first?.frame = createAccountView.bounds
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { _ = view.endEditing(true) }
  
  func cancel() {
    containerVC?.childVC = containerVC?.previousChildVC
    containerVC?.setup(forAnimation: .slideDown)
  }
}

// MARK: - UIScrollViewDelegate
extension CreateAccountViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    createAccountView.pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
  }
}

// MARK: - UITextFieldDelegate
extension CreateAccountViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    switch textField {
    case createAccountView.firstNameField:
      createAccountView.pageControl.currentPage = 0
    case createAccountView.lastNameField:
      createAccountView.pageControl.currentPage = 1
    case createAccountView.emailField:
      createAccountView.pageControl.currentPage = 2
    case createAccountView.passwordField:
      createAccountView.pageControl.currentPage = 3
    default:
      break
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if createAccountView.pageControl.currentPage == 3 {
      guard let firstName = createAccountView.firstNameField.text else {
        print("error unwrapping first name")
        return
      }
      
      guard let lastName = createAccountView.lastNameField.text else {
        print("error unwrapping last name")
        return
      }
      
      guard let email = createAccountView.emailField.text else {
        print("error unwrapping email")
        return
      }
      
      guard let password = createAccountView.passwordField.text else {
        print("error unwrapping password")
        return
      }
      
      FIRClient.createAccount(firstName: firstName, lastName: lastName, email: email, password: password) {
        self.containerVC?.childVC = MainTabBarController()
        self.containerVC?.setup(forAnimation: .slideLeft)
      }
    }
  }
}
