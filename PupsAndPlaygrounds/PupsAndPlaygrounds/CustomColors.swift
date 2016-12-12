//
//  CustomColors.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

// MARK: Theme Colors
extension UIColor {
  public static let themeLightBlue = UIColor(red: 106 / 255, green: 138 / 255, blue: 166 / 255, alpha: 1)
  public static let themeMediumBlue = UIColor(red: 59 / 255, green: 75 / 255, blue: 89 / 255, alpha: 1)
  public static let themeDarkBlue = UIColor(red: 20 / 255, green: 31 / 255, blue: 38 / 255, alpha: 1)
  public static let themeRed = UIColor(red: 242 / 255, green: 82 / 255, blue: 68 / 255, alpha: 1)
  
  public static let themeMarine = UIColor(red: 34 / 255, green: 91 / 255, blue: 102 / 255, alpha: 1)
  public static let themeTeal = UIColor(red: 23 / 255, green: 163 / 255, blue: 165 / 255, alpha: 1)
  public static let themeGrass = UIColor(red: 141 / 255, green: 191 / 255, blue: 103 / 255, alpha: 1)
  public static let themeSunshine = UIColor(red: 252 / 255, green: 203 / 255, blue: 95 / 255, alpha: 1)
  public static let themeCoral = UIColor(red: 252 / 255, green: 110 / 255, blue: 89 / 255, alpha: 1)
  public static let themeWhite = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
}

// MARK: Gradients
extension CAGradientLayer {
  convenience init(_ colors: [UIColor]) {
    self.init()
    
    self.colors = colors.map { $0.cgColor }
  }
}

extension CALayer {
  public static func makeGradient(firstColor: UIColor, secondColor: UIColor) -> CAGradientLayer {
    let backgroundGradient = CAGradientLayer()
    
    backgroundGradient.colors = [firstColor.cgColor, secondColor.cgColor]
    backgroundGradient.locations = [0, 1]
    backgroundGradient.startPoint = CGPoint(x: 0, y: 0)
    backgroundGradient.endPoint = CGPoint(x: 0, y: 1)
    
    return backgroundGradient
  }
}
