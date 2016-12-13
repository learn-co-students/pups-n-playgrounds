//
//  ListViewTableViewCell.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 12/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class ListViewTableViewCell: UITableViewCell {
  enum LocationType {
    case dogPark, playground
  }
  
  var locationType: LocationType? {
    didSet {
      if let locationType = locationType {
        switch locationType {
        case .dogPark:
          locationTypeImageView.image = #imageLiteral(resourceName: "DogParkWhite")
        case .playground:
          locationTypeImageView.image = #imageLiteral(resourceName: "PlaygroundWhite")
        }
      }
    }
  }
  lazy var visibleView = UIView()
  lazy var innerView = UIView()
  lazy var titleLabel = UILabel()
  lazy var addressLabel = UILabel()
  lazy var circleView = UIView()
  let circleViewWidth = #imageLiteral(resourceName: "DogParkWhite").size.width * 1.5
  lazy var locationTypeImageView = UIImageView()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  
    configure()
    constrain()
  }
  
  // MARK: Setup
  private func configure() {
    backgroundColor = UIColor.clear
    selectionStyle = .none
    
    visibleView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    visibleView.layer.cornerRadius = 20
    
    titleLabel.numberOfLines = 0
    titleLabel.font = UIFont.themeMediumLight
    titleLabel.textColor = UIColor.white
    
    addressLabel.numberOfLines = 0
    addressLabel.textColor = UIColor.white
    addressLabel.font = UIFont.themeTinyBold
    
    circleView.layer.cornerRadius = circleViewWidth / 2
    circleView.layer.borderWidth = 2
    circleView.layer.borderColor = UIColor.white.cgColor
    
    locationTypeImageView.contentMode = .scaleAspectFit
  }
  
  private func constrain() {
    contentView.addSubview(visibleView)
    visibleView.snp.makeConstraints {
      $0.edges.equalTo(UIEdgeInsetsMake(10, 10, 0, 10))
    }
    
    visibleView.addSubview(innerView)
    innerView.snp.makeConstraints {
      $0.edges.equalTo(UIEdgeInsetsMake(20, 20, 20, 20))
    }
    
    innerView.addSubview(circleView)
    circleView.snp.makeConstraints {
      $0.trailing.top.equalToSuperview()
      $0.width.height.equalTo(circleViewWidth)
    }
    
    circleView.addSubview(locationTypeImageView)
    locationTypeImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(#imageLiteral(resourceName: "DogParkWhite").size.width)
    }
    
    innerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
      $0.trailing.equalTo(circleView.snp.leading).offset(-40)
    }
    
    innerView.addSubview(addressLabel)
    addressLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(circleView.snp.leading).offset(-40)
      $0.top.equalTo(titleLabel.snp.bottom)
    }
  }
}
