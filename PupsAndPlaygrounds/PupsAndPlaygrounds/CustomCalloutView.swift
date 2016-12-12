//
//  CustomCalloutView.swift
//
//
//  Created by William Robinson on 12/5/16.
//
//

import UIKit
import SnapKit

class CustomCalloutView: UIView {
  
  // MARK: Properties
  lazy var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
  lazy var nameLabel = UILabel()
  lazy var addressLabel = UILabel()
  lazy var ratingLabel = UILabel()
  lazy var distanceLabel = UILabel()
  
  // MARK: Initialization
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  override init(frame: CGRect) { super.init(frame: frame) }
  convenience init() {
    let width = UIScreen.main.bounds.width / 1.1
    let height = width / 2
    self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    
    configure()
    constrain()
  }
  
  // MARK: Setup
  func configure() {
    layer.cornerRadius = 20
    clipsToBounds = true
  
    nameLabel.font = UIFont.themeMediumLight
    nameLabel.textColor = UIColor.themeWhite
    nameLabel.numberOfLines = 0
    
    addressLabel.font = UIFont.themeTinyBold
    addressLabel.textColor = UIColor.themeWhite
    addressLabel.numberOfLines = 0
    
    ratingLabel.font = UIFont.themeTinyBold
    ratingLabel.textColor = UIColor.themeWhite
    ratingLabel.numberOfLines = 0
    
    distanceLabel.font = UIFont.themeTinyBold
    distanceLabel.textColor = UIColor.themeMediumBlue
  }
  
  // MARK: Constrain
  func constrain() {
    addSubview(blurView)
    blurView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    blurView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    blurView.addSubview(addressLabel)
    addressLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(nameLabel.snp.bottom)
    }
    
    blurView.addSubview(ratingLabel)
    ratingLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(addressLabel.snp.bottom)
    }
    
    blurView.addSubview(distanceLabel)
    distanceLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(ratingLabel.snp.bottom)
    }
  }
}




