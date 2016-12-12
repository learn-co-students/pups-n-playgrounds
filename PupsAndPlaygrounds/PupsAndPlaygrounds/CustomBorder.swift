//
//  CustomBorder.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 12/10/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class CustomBorder: CALayer {
  enum Position {
    case leading, trailing, top, bottom
  }
  
  convenience init(_ position: Position, _ color: UIColor, _ thickness: CGFloat, _ viewFrame: CGRect) {
    self.init()
    
    switch position {
    case .leading:
      frame = CGRect(x: 0, y: 0, width: thickness, height: viewFrame.height)
    case .trailing:
      frame = CGRect(x: viewFrame.width - thickness, y: 0, width: thickness, height: viewFrame.height)
    case .top:
      frame = CGRect(x: 0, y: 0, width: viewFrame.width, height: thickness)
    case .bottom:
      frame = CGRect(x: 0, y: viewFrame.height - thickness, width: viewFrame.width, height: thickness)
    }
    
    backgroundColor = color.cgColor
  }
}
