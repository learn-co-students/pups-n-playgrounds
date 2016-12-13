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
    let gradient = CAGradientLayer([UIColor.themeTeal, UIColor.themeSunshine])
    gradient.frame = UIScreen.main.bounds
    layer.addSublayer(gradient)
    
    locationsTableView.separatorStyle = .none
    locationsTableView.rowHeight = 180
    locationsTableView.backgroundColor = UIColor.clear
  }
  
  // MARK: View Constraints
  func constrain() {
    addSubview(locationsTableView)
    locationsTableView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-49)
    }
  }
}
