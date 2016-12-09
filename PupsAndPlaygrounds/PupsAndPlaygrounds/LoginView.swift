//
//  LoginView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit
import FBSDKLoginKit

class LoginView: UIView {
  
  // MARK: Properties
  lazy var topView = UIView()
  lazy var middleView = UIView()
  lazy var bottomView = UIView()
  lazy var titleLabel = UILabel()
  lazy var emailField: CustomTextField = CustomTextField()
  lazy var passwordField: CustomTextField = CustomTextField()
  lazy var loginButton = UIButton()
  lazy var orUseLabel = UILabel()
  lazy var facebookButton = FBSDKLoginButton()
  lazy var loginOptionsStackView = UIStackView()
  lazy var loginStackView = UIStackView()
  lazy var createAccountButton = UIButton()
  lazy var skipButton = UIButton()
  lazy var noLoginStackView = UIStackView()
    lazy var forgotPasswordButton = UIButton()
  
  // MARK: Initialization
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init() {
    self.init(frame: CGRect.zero)
    
    configure()
    constrain()
  }
  
  // MARK: View Configuration
  private func configure() {
    topView.backgroundColor = UIColor.themeMediumBlue
    middleView.backgroundColor = UIColor.themeLightBlue
    bottomView.backgroundColor = UIColor.themeRed
    
    titleLabel.text = "Pups &\nPlaygrounds"
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.themeOversizeThin
    titleLabel.textColor = UIColor.themeWhite
    
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
    
    loginButton.contentEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16)
    loginButton.setTitle("Log in", for: .normal)
    loginButton.titleLabel?.font = UIFont.themeSmallBold
    loginButton.setTitleColor(UIColor.themeWhite, for: .normal)
    loginButton.layer.cornerRadius = 20
    loginButton.layer.borderWidth = 2
    loginButton.layer.borderColor = UIColor.themeWhite.cgColor
    
    orUseLabel.text = "or use"
    orUseLabel.font = UIFont.themeSmallBold
    orUseLabel.textColor = UIColor.themeWhite
    
    loginOptionsStackView.addArrangedSubview(loginButton)
    loginOptionsStackView.addArrangedSubview(orUseLabel)
    loginOptionsStackView.addArrangedSubview(facebookButton)
    loginOptionsStackView.distribution = .equalSpacing
    loginOptionsStackView.alignment = .fill
    loginOptionsStackView.spacing = 10
    
    forgotPasswordButton.setTitle("Forgot password?", for: .normal)
    forgotPasswordButton.titleLabel?.font = UIFont.themeTinyBold
    forgotPasswordButton.setTitleColor(UIColor.themeWhite, for: .normal)
    
    loginStackView.addArrangedSubview(emailField)
    loginStackView.addArrangedSubview(passwordField)
    loginStackView.addArrangedSubview(loginOptionsStackView)
    loginStackView.axis = .vertical
    loginStackView.spacing = 40
    loginStackView.alignment = .center
    
    createAccountButton.setTitle("Create account", for: .normal)
    createAccountButton.titleLabel?.font = UIFont.themeTinyBold
    createAccountButton.setTitleColor(UIColor.themeWhite, for: .normal)
    
    skipButton.setTitle("Skip for now", for: .normal)
    skipButton.titleLabel?.font = UIFont.themeTinyBold
    skipButton.setTitleColor(UIColor.themeWhite, for: .normal)
    
    noLoginStackView.addArrangedSubview(createAccountButton)
    noLoginStackView.addArrangedSubview(skipButton)
    noLoginStackView.axis = .vertical
    noLoginStackView.spacing = 3
  }
  
  // MARK: View Constraints
  private func constrain() {
    
    // Top view
    addSubview(topView)
    topView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalToSuperview().dividedBy(2.5)
    }
    
    topView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    // Middle view
    addSubview(middleView)
    middleView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(topView.snp.bottom)
      $0.height.equalToSuperview().dividedBy(2.1)
    }
    
    middleView.addSubview(loginStackView)
    loginStackView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(1.3)
    }
    
    emailField.snp.makeConstraints {
      $0.width.equalToSuperview()
    }
    
    passwordField.snp.makeConstraints {
      $0.width.equalToSuperview()
    }
    
    loginOptionsStackView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(40)
    }

    middleView.addSubview(forgotPasswordButton)
    forgotPasswordButton.snp.makeConstraints {
        $0.top.equalTo(loginOptionsStackView.snp.bottom).offset(10)
        $0.centerX.equalToSuperview()
    }
    
    
    //    facebookButton.snp.makeConstraints {
    //      $0.width.equalTo(facebookButton.snp.height)
    //    }
    
    
    // Bottom view
    addSubview(bottomView)
    bottomView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(middleView.snp.bottom)
    }
    
    bottomView.addSubview(noLoginStackView)
    noLoginStackView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
