//
//  CustomTextField.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 7, 0)))
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 7, 0)))
  }
}
