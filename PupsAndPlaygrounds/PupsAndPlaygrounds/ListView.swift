//
//  ListView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class ListView: UIView {
  
  // MARK: Properties
  let locationsTableView = UITableView()
  
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
    locationsTableView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
  }
  
  // MARK: View Constraints
  func constrain() {
    addSubview(locationsTableView)
    locationsTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
