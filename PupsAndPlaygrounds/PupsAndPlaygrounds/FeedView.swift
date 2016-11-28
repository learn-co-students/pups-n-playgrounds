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
  }
  
  // MARK: View Constraints
  func constrain() {
    addSubview(feedTableView)
    feedTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
