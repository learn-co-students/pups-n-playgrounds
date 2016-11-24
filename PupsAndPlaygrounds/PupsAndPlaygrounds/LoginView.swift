//
//  LoginView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {
  
  // MARK: Properties
  var topView: UIView!
  var topMiddleDividerView: UIView!
  var middleView: UIView!
  var middleBottomDividerView: UIView!
  var bottomView: UIView!
  var titleLabel: UILabel!
  var emailField: CustomTextField!
  var passwordField: CustomTextField!
  var loginButton: UIButton!
  var orUseLabel: UILabel!
  var facebookButton: UIButton!
  var googleButton: UIButton!
  var twitterButton: UIButton!
  var loginOptionsStackView: UIStackView!
  var loginStackView: UIStackView!
  var createAccountButton: UIButton!
  var skipButton: UIButton!
  var noLoginStackView: UIStackView!
  
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
  private func configure() {
    
    topView = UIView()
    topView.backgroundColor = UIColor.themeMediumBlue
    
    topMiddleDividerView = UIView()
    topMiddleDividerView.backgroundColor = UIColor.themeWhite
    
    middleView = UIView()
    middleView.backgroundColor = UIColor.themeLightBlue
    
    middleBottomDividerView = UIView()
    middleBottomDividerView.backgroundColor = UIColor.themeWhite
    
    bottomView = UIView()
    bottomView.backgroundColor = UIColor.themeRed
    
    titleLabel = UILabel()
    titleLabel.text = "Pups &\nPlaygrounds"
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.themeOversizeThin
    titleLabel.textColor = UIColor.themeWhite
    
    emailField = CustomTextField()
    emailField.placeholder = "Email"
    emailField.textColor = UIColor.themeWhite
    emailField.layer.cornerRadius = 10
    emailField.layer.borderWidth = 1
    emailField.layer.borderColor = UIColor.themeWhite.cgColor
    
    passwordField = CustomTextField()
    passwordField.placeholder = "Password"
    passwordField.textColor = UIColor.themeWhite
    passwordField.layer.cornerRadius = 10
    passwordField.layer.borderWidth = 1
    passwordField.layer.borderColor = UIColor.themeWhite.cgColor
    
    loginButton = UIButton()
    loginButton.contentEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16)
    loginButton.setTitle("Log in", for: .normal)
    loginButton.titleLabel?.font = UIFont.themeSmallBold
    loginButton.setTitleColor(UIColor.themeWhite, for: .normal)
    loginButton.layer.cornerRadius = 20
    loginButton.layer.borderWidth = 2
    loginButton.layer.borderColor = UIColor.themeWhite.cgColor
    
    orUseLabel = UILabel()
    orUseLabel.text = "or use"
    orUseLabel.font = UIFont.themeSmallBold
    orUseLabel.textColor = UIColor.themeWhite
    
    facebookButton = UIButton()
    facebookButton.setImage(#imageLiteral(resourceName: "Facebook Logo"), for: .normal)
    
    googleButton = UIButton()
    googleButton.setTitle("G", for: .normal)
    googleButton.titleLabel?.font = UIFont.themeSmallBold
    googleButton.setTitleColor(UIColor.themeDarkBlue, for: .normal)
    googleButton.layer.borderWidth = 2
    googleButton.layer.borderColor = UIColor.themeDarkBlue.cgColor
    
    twitterButton = UIButton()
    twitterButton.setTitle("T", for: .normal)
    twitterButton.titleLabel?.font = UIFont.themeSmallBold
    twitterButton.setTitleColor(UIColor.themeDarkBlue, for: .normal)
    twitterButton.layer.borderWidth = 2
    twitterButton.layer.borderColor = UIColor.themeDarkBlue.cgColor
    
    loginOptionsStackView = UIStackView(arrangedSubviews: [loginButton, orUseLabel, facebookButton, googleButton, twitterButton])
    loginOptionsStackView.distribution = .equalSpacing
    
    loginStackView = UIStackView(arrangedSubviews: [emailField, passwordField, loginOptionsStackView])
    loginStackView.axis = .vertical
    loginStackView.spacing = 40
    loginStackView.alignment = .center
    
    createAccountButton = UIButton()
    createAccountButton.setTitle("Create account", for: .normal)
    createAccountButton.titleLabel?.font = UIFont.themeTinyBold
    createAccountButton.setTitleColor(UIColor.themeWhite, for: .normal)
    
    skipButton = UIButton()
    skipButton.setTitle("Skip for now", for: .normal)
    skipButton.titleLabel?.font = UIFont.themeTinyBold
    skipButton.setTitleColor(UIColor.themeWhite, for: .normal)
    
    noLoginStackView = UIStackView(arrangedSubviews: [createAccountButton, skipButton])
    noLoginStackView.axis = .vertical
  }
  
  // MARK: View Constraints
  private func constrain() {
    
    // Top View
    addSubview(topView)
    topView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalToSuperview().dividedBy(2.5)
    }
    
    topView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    // Middle View
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
    }
    
    facebookButton.snp.makeConstraints {
      $0.width.equalTo(facebookButton.snp.height)
    }
    
    googleButton.snp.makeConstraints {
      $0.width.equalTo(googleButton.snp.height)
    }
    
    twitterButton.snp.makeConstraints {
      $0.width.equalTo(twitterButton.snp.height)
    }
    
    // Bottom View
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
