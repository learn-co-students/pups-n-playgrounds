//
//  AnonymousUserView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 12/10/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class AnonymousUserView: UIView {
  
  // MARK: Properties
  lazy var anonymousLabel = UILabel()
  lazy var createAccountButton = UIButton()
  
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
  func configure() {
    layer.addSublayer(CAGradientLayer([UIColor.themeTeal, UIColor.themeSunshine, UIColor.themeCoral]))
    
    anonymousLabel.text = "You're not signed up"
    anonymousLabel.numberOfLines = 0
    anonymousLabel.textAlignment = .center
    anonymousLabel.font = UIFont.themeOversizeThin
    anonymousLabel.textColor = UIColor.white
    
    createAccountButton.setTitle("Create account", for: .normal)
    createAccountButton.titleLabel?.font = UIFont.themeSmallBold
    createAccountButton.setTitleColor(UIColor.white, for: .normal)
    createAccountButton.contentEdgeInsets = UIEdgeInsetsMake(20, 0, 20, 0)
    createAccountButton.layer.borderWidth = 2
    createAccountButton.layer.borderColor = UIColor.white.cgColor
  }
  
  func constrain() {
    addSubview(anonymousLabel)
    anonymousLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(100)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(1.2)
    }
    
    addSubview(createAccountButton)
    createAccountButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-120)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(1.6)
    }
  }
}
