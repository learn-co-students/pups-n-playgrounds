//
//  MapView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapView: UIView {
  
  // MARK: Properties
  lazy var map = MKMapView()
  lazy var goToLocationButton = UIButton()
  lazy var goToLocationButtonView = UIView()
  lazy var goToLocationButtonLabel = UILabel()
  lazy var goToLocationButtonImageView = UIImageView(image: #imageLiteral(resourceName: "Go"))
  var goToLocationButtonTopConstraint: Constraint?
  let goToLocationButtonHeight: CGFloat = 60
  
  // MARK: Initialization
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  override init(frame: CGRect) { super.init(frame: frame) }
  convenience init() { self.init(frame: CGRect.zero); configure(); constrain() }
  
  // MARK: View Configuration
  func configure() {
    goToLocationButtonLabel.text = "Go to location"
    goToLocationButtonLabel.font = UIFont.themeSmallBold
    goToLocationButtonLabel.textColor = UIColor.white
    goToLocationButtonImageView.contentMode = .scaleAspectFit
    goToLocationButtonView.isUserInteractionEnabled = false
    goToLocationButton.backgroundColor = UIColor.themeCoral
  }
  
  // MARK: View Constraints
  func constrain() {
    addSubview(map)
    map.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    goToLocationButtonView.addSubview(goToLocationButtonLabel)
    goToLocationButtonLabel.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
    }
    
    goToLocationButtonView.addSubview(goToLocationButtonImageView)
    goToLocationButtonImageView.snp.makeConstraints {
      $0.leading.equalTo(goToLocationButtonLabel.snp.trailing).offset(10)
      $0.trailing.top.bottom.equalToSuperview()
    }
    
    goToLocationButton.addSubview(goToLocationButtonView)
    goToLocationButtonView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    addSubview(goToLocationButton)
    goToLocationButton.snp.makeConstraints {
      self.goToLocationButtonTopConstraint = $0.top.equalTo(snp.bottom).constraint
      $0.centerX.width.equalToSuperview()
      $0.height.equalTo(goToLocationButtonHeight)
    }
  }
}
