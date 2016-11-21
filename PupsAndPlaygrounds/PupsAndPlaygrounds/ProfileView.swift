//
//  ProfileView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class ProfileView: UIView {
  
  // MARK: Properties
  var profileButton: UIButton!
  var userNameLabel: UILabel!

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
    backgroundColor = UIColor.themeDarkBlue
    
    profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    profileButton.layer.cornerRadius = profileButton.frame.width / 2
    profileButton.layer.borderWidth = 2
    profileButton.layer.borderColor = UIColor.themeWhite.cgColor
    
    userNameLabel = UILabel()
    userNameLabel.font = UIFont.themeMediumThin
    userNameLabel.textColor = UIColor.themeWhite
  }
  
  // MARK: View Constraints
  func constrain() {
    
    addSubview(profileButton)
    profileButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(80)
    }
    
    addSubview(userNameLabel)
    userNameLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(profileButton.snp.bottom).offset(40)
    }
  }
}
