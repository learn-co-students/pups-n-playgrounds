//
//  CreateAccountView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class CreateAccountView: UIView {
  
  // MARK: Properties
  var firstNameField = CustomTextField()
  var lastNameField = CustomTextField()
  var emailField = CustomTextField()
  var passwordField = CustomTextField()
  var retypePasswordField = CustomTextField()
  var fieldStackView = UIStackView()
  var createAccountButton = UIButton()
  var cancelButton = UIButton()
  
  // MARK: Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init() {
    self.init(frame: CGRect.zero)
    
    configure()
    constrain()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: View Configuration
  func configure() {
    backgroundColor = UIColor.themeLightBlue
    
    firstNameField.placeholder = "First name"
    firstNameField.textColor = UIColor.themeWhite
    firstNameField.layer.cornerRadius = 10
    firstNameField.layer.borderWidth = 1
    firstNameField.layer.borderColor = UIColor.themeWhite.cgColor
    
    lastNameField.placeholder = "Last name"
    lastNameField.textColor = UIColor.themeWhite
    lastNameField.layer.cornerRadius = 10
    lastNameField.layer.borderWidth = 1
    lastNameField.layer.borderColor = UIColor.themeWhite.cgColor
    
    emailField.placeholder = "Email"
    emailField.textColor = UIColor.themeWhite
    emailField.layer.cornerRadius = 10
    emailField.layer.borderWidth = 1
    emailField.layer.borderColor = UIColor.themeWhite.cgColor
    
    passwordField.placeholder = "Password"
    passwordField.textColor = UIColor.themeWhite
    passwordField.layer.cornerRadius = 10
    passwordField.layer.borderWidth = 1
    passwordField.layer.borderColor = UIColor.themeWhite.cgColor
    
    retypePasswordField.placeholder = "Password"
    retypePasswordField.textColor = UIColor.themeWhite
    retypePasswordField.layer.cornerRadius = 10
    retypePasswordField.layer.borderWidth = 1
    retypePasswordField.layer.borderColor = UIColor.themeWhite.cgColor
    
    fieldStackView.addArrangedSubview(firstNameField)
    fieldStackView.addArrangedSubview(lastNameField)
    fieldStackView.addArrangedSubview(emailField)
    fieldStackView.addArrangedSubview(passwordField)
    fieldStackView.addArrangedSubview(retypePasswordField)
    fieldStackView.axis = .vertical
    fieldStackView.distribution = .equalSpacing
    
    createAccountButton.contentEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16)
    createAccountButton.setTitle("Create account", for: .normal)
    createAccountButton.titleLabel?.font = UIFont.themeSmallBold
    createAccountButton.setTitleColor(UIColor.themeWhite, for: .normal)
    createAccountButton.layer.cornerRadius = 20
    createAccountButton.layer.borderWidth = 2
    createAccountButton.layer.borderColor = UIColor.themeWhite.cgColor
    
    cancelButton.setTitle("x", for: .normal)
    cancelButton.titleLabel?.font = UIFont.themeMediumRegular
    cancelButton.setTitleColor(UIColor.themeWhite, for: .normal)
  }
  
  // MARK: View Constraints
  func constrain() {
    addSubview(fieldStackView)
    fieldStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(80)
      $0.width.equalToSuperview().dividedBy(1.3)
      $0.height.equalToSuperview().dividedBy(1.5)
    }
    
    addSubview(createAccountButton)
    createAccountButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(fieldStackView.snp.bottom).offset(40)
    }
    
    addSubview(cancelButton)
    cancelButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-15)
    }
  }
}
