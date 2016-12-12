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
  lazy var titleLabel = UILabel()
  
  lazy var middleView = UIView()
  lazy var loginStackView = UIStackView()
  lazy var emailField: CustomTextField = CustomTextField()
  lazy var passwordField: CustomTextField = CustomTextField()
  lazy var loginButton = UIButton()
  
  lazy var bottomView = UIView()
  lazy var noLoginStackView = UIStackView()
  lazy var createAccountButton = UIButton()
  lazy var skipButton = UIButton()
  
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
  
  // MARK: Setup
  private func configure() {
    topView.backgroundColor = UIColor.themeMarine
    middleView.backgroundColor = UIColor.themeTeal
    bottomView.backgroundColor = UIColor.themeCoral
    
    titleLabel.text = "Pups &\nPlaygrounds"
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.themeOversizeThin
    titleLabel.textColor = UIColor.white
    
    emailField.placeholder = "Email"
    emailField.font = UIFont.themeMediumThin
    emailField.textColor = UIColor.white
    
    passwordField.placeholder = "Password"
    passwordField.font = UIFont.themeMediumThin
    passwordField.textColor = UIColor.white
    
    loginButton.backgroundColor = UIColor.white
    loginButton.contentEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16)
    loginButton.setTitle("Log in", for: .normal)
    loginButton.titleLabel?.font = UIFont.themeSmallBold
    loginButton.setTitleColor(UIColor.themeTeal, for: .normal)
    loginButton.layer.cornerRadius = 20
    
    loginStackView.addArrangedSubview(emailField)
    loginStackView.addArrangedSubview(passwordField)
    loginStackView.addArrangedSubview(loginButton)
    loginStackView.axis = .vertical
    loginStackView.distribution = .equalCentering
    loginStackView.alignment = .center
    
    createAccountButton.setTitle("Create account", for: .normal)
    createAccountButton.titleLabel?.font = UIFont.themeTinyBold
    createAccountButton.setTitleColor(UIColor.white, for: .normal)
    
    skipButton.setTitle("Skip for now", for: .normal)
    skipButton.titleLabel?.font = UIFont.themeTinyBold
    skipButton.setTitleColor(UIColor.white, for: .normal)
    
    noLoginStackView.addArrangedSubview(createAccountButton)
    noLoginStackView.addArrangedSubview(skipButton)
    noLoginStackView.axis = .vertical
    noLoginStackView.spacing = 3
  }
  
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
      $0.height.equalToSuperview().dividedBy(1.5)
    }
    
    emailField.snp.makeConstraints {
      $0.width.equalToSuperview()
    }
    
    passwordField.snp.makeConstraints {
      $0.width.equalToSuperview()
    }
    
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
