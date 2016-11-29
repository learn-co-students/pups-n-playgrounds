//
//  MapView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MapView: UIView {
  
  // MARK: Properties
  map
  
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
    
  }
  
  // MARK: View Constraints
  func constrain() {
    
  }
}
