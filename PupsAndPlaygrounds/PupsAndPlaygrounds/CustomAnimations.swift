//
//  CustomAnimations.swift
//  Form
//
//  Created by William Robinson on 10/24/16.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit

// MARK: - Add Key Frame Animation Options
extension UIViewKeyframeAnimationOptions {
  init(animationOptions: UIViewAnimationOptions) {
    rawValue = animationOptions.rawValue
  }
}


