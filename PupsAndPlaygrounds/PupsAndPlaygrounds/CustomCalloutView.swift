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
  lazy var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
  lazy var nameLabel = UILabel()
  lazy var addressLabel = UILabel()
  lazy var starReview = StarReview()
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
    nameLabel.textColor = UIColor.white
    nameLabel.numberOfLines = 0
    
    addressLabel.font = UIFont.themeTinyBold
    addressLabel.textColor = UIColor.white
    addressLabel.numberOfLines = 0
    
    distanceLabel.font = UIFont.themeTinyBold
    distanceLabel.textColor = UIColor.white
    
    starReview.starCount = 5
    starReview.starBackgroundColor = UIColor.lightGray
    starReview.starFillColor = UIColor.white
    starReview.isUserInteractionEnabled = false
    starReview.starMarginScale = 0.3
    starReview.contentMode = .scaleAspectFit
  }
  
  // MARK: Constrain
  func constrain() {
    let leadingTopOffset = 20
    let trailingBottomOffset = -leadingTopOffset
    
    addSubview(blurView)
    blurView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    blurView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(leadingTopOffset)
      $0.trailing.equalToSuperview().offset(trailingBottomOffset)
    }
    
    blurView.addSubview(addressLabel)
    addressLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(leadingTopOffset)
      $0.trailing.equalToSuperview().offset(trailingBottomOffset)
      $0.top.equalTo(nameLabel.snp.bottom)
    }
    
    blurView.addSubview(starReview)
    starReview.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(leadingTopOffset)
      $0.top.equalTo(addressLabel.snp.bottom)
      $0.bottom.equalToSuperview().offset(trailingBottomOffset)
      $0.width.equalToSuperview().dividedBy(3)
    }
  }
}




