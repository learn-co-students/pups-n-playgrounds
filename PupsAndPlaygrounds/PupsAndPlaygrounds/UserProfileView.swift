//
//  UserProfileView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

final class UserProfileView: UIView {
  
  // MARK: Properties
  lazy var profileButton = UIButton()
  lazy var userNameLabel = UILabel()
  lazy var reviewsTableView = UITableView()
  
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
    layer.addSublayer(CAGradientLayer([UIColor.themeTeal, UIColor.themeGrass]))
  
    profileButton.imageView?.contentMode = .scaleAspectFill
    profileButton.layer.borderWidth = 4
    profileButton.layer.borderColor = UIColor.themeWhite.cgColor
    
    // User name label
    userNameLabel.font = UIFont.themeMediumLight
    userNameLabel.textColor = UIColor.themeWhite
    
    // User reviews table view
    reviewsTableView.rowHeight = 40
    reviewsTableView.layer.cornerRadius = 5
    reviewsTableView.backgroundColor = UIColor.clear
  }
  
  private func constrain() {
    addSubview(profileButton)
    profileButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(2)
      $0.height.equalTo(profileButton.snp.width)
    }
    
    addSubview(userNameLabel)
    userNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileButton.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
    
    addSubview(reviewsTableView)
    reviewsTableView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(userNameLabel.snp.bottom)
    }
  }
}








