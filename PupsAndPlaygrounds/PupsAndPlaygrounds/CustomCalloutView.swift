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
  lazy var titleLabel = UILabel()
  lazy var ratingLabel = UILabel()
  lazy var distanceLabel = UILabel()
  lazy var goToLocationButton = UIButton()
  lazy var image = UIImage()
  
  // MARK: Initialization
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  override init(frame: CGRect) { super.init(frame: frame) }
  convenience init() {
    let width = UIScreen.main.bounds.width / 1.5
    let height = width / 2
    self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
      
    configure()
    constrain()
  }
  
  // MARK: Setup
  func configure() {
    
    // View
    backgroundColor = UIColor.themeWhite
    layer.cornerRadius = 20
    
    // Title
    titleLabel.font = UIFont.themeMediumLight
    titleLabel.textColor = UIColor.themeDarkBlue
    
    // Rating
    ratingLabel.font = UIFont.themeTinyLight
    ratingLabel.textColor = UIColor.themeRed
    
    // Distance
    distanceLabel.font = UIFont.themeTinyLight
    distanceLabel.textColor = UIColor.themeMediumBlue
    
    // Button
    goToLocationButton.setImage(#imageLiteral(resourceName: "Black Arrow"), for: .normal)
  }
  
  // MARK: Constrain
  func constrain() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(20)
    }
    
    addSubview(goToLocationButton)
    goToLocationButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalToSuperview().offset(20)
    }
    
    addSubview(ratingLabel)
    ratingLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(titleLabel.snp.bottom)
    }
    
    addSubview(distanceLabel)
    distanceLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(ratingLabel.snp.bottom)
    }
  }
}




