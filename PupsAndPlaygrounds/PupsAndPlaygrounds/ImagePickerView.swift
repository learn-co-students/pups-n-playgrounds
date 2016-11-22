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
  var blurView: UIVisualEffectView!
  let blurViewHeight = UIScreen.main.bounds.width * 4 / 3
  
  var circleView: UIView!
  let circleViewWidth = UIScreen.main.bounds.width
  
  var vibrancyView: UIView!
  
  var captureButtonView: UIView!
  var captureButton: UIButton!
  let captureButtonWidth: CGFloat = 80
  
  // MARK: Initialization
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    
  }
  
  convenience init() {
    
    self.init(frame: CGRect.zero)
    
    configure()
    constrain()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
    
  }
  
  // MARK: View Configuration
  func configure() {
    
    blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    circleView = UIView()
    circleView.backgroundColor = UIColor.themeWhite
    circleView.clipsToBounds = true
    circleView.layer.cornerRadius = circleViewWidth / 2
    
    vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark)))
    
    captureButtonView = UIView()
    captureButtonView.backgroundColor = UIColor.themeDarkBlue
    
    captureButton = UIButton()
    captureButton.backgroundColor = UIColor.themeRed
    captureButton.layer.cornerRadius = captureButtonWidth / 2
    
  }
  
  // MARK: View Constraints
  func constrain() {
    
    addSubview(blurView)
    blurView.snp.makeConstraints {
      
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalTo(blurViewHeight)
      
    }
    
    blurView.contentView.addSubview(circleView)
    circleView.snp.makeConstraints {
      
      $0.center.equalToSuperview()
      $0.width.height.equalTo(circleViewWidth)
      
    }
    
    circleView.addSubview(vibrancyView)
    vibrancyView.snp.makeConstraints {
      
      $0.edges.equalToSuperview()
      
    }
    
    addSubview(captureButtonView)
    captureButtonView.snp.makeConstraints {
      
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(blurView.snp.bottom)
      
    }
    
    captureButtonView.addSubview(captureButton)
    captureButton.snp.makeConstraints {
      
      $0.center.equalToSuperview()
      $0.width.height.equalTo(captureButtonWidth)
      
    }
    
  }

}
