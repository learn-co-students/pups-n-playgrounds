//
//  ImagePickerView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

final class ImagePickerView: UIView {
  
  // MARK: Properties
  var cutoutView = UIView()
  let cutoutViewWidth = UIScreen.main.bounds.width
  let cutoutViewHeight = UIScreen.main.bounds.width * 4 / 3
  let circleCutoutRadius = UIScreen.main.bounds.width / 2
  
  var captureButtonView = UIView()
  var captureButton = UIButton()
  let captureButtonWidth: CGFloat = 80
  
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
    cutoutView.frame = CGRect(x: 0, y: 0, width: cutoutViewWidth, height: cutoutViewHeight)
    
    let bezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: cutoutViewWidth, height: cutoutViewHeight))
    bezierPath.append(UIBezierPath(ovalIn: CGRect(x: 0, y: cutoutViewHeight / 2 - circleCutoutRadius, width: circleCutoutRadius * 2, height: circleCutoutRadius * 2)))
    bezierPath.usesEvenOddFillRule = true
    
    let fillLayer = CAShapeLayer()
    fillLayer.path = bezierPath.cgPath
    fillLayer.fillRule = kCAFillRuleEvenOdd
    fillLayer.fillColor = UIColor.black.withAlphaComponent(0.8).cgColor
    
    cutoutView.layer.addSublayer(fillLayer)
    
    captureButtonView.backgroundColor = UIColor.themeDarkBlue

    captureButton.backgroundColor = UIColor.themeRed
    captureButton.layer.cornerRadius = captureButtonWidth / 2
  }
  
  // MARK: View Constraints
  func constrain() {
    addSubview(cutoutView)
    cutoutView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalTo(cutoutViewHeight)
    }
    
    addSubview(captureButtonView)
    captureButtonView.snp.makeConstraints {
      
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(cutoutView.snp.bottom)
    }

    captureButtonView.addSubview(captureButton)
    captureButton.snp.makeConstraints {
      
      $0.center.equalToSuperview()
      $0.width.height.equalTo(captureButtonWidth)
    }
  }
}
