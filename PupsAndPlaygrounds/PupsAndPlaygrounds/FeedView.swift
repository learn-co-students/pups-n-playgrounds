//
//  FeedView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class FeedView: UIView {
  
  // MARK: Properties
  let feedTableView = UITableView()
//    var flagButton: UIButton!
    
  
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
  func configure() {
    feedTableView.rowHeight = 80
    
    
//    flagButton = UIButton()
//    flagButton.contentEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16)
//    flagButton.setTitle("Flag Review", for: .normal)
//    flagButton.titleLabel?.font = UIFont.themeSmallBold
//    flagButton.setTitleColor(UIColor.themeRed, for: .normal)
//    flagButton.layer.cornerRadius = 20
//    flagButton.layer.borderWidth = 2
//    flagButton.layer.borderColor = UIColor.themeWhite.cgColor
//
    
  }
  
  // MARK: View Constraints
  func constrain() {
    addSubview(feedTableView)
    feedTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
