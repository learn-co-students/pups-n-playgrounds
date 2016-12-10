//
//  FilterView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 12/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class FilterView: UIView {
  
  // MARK: Properties
  lazy var stackView = UIStackView()
  lazy var radiusView = UIView()
  lazy var radiusLabel = UILabel()
  lazy var radiusValueLabel = UILabel()
  lazy var dogParksButton = UIButton()
  lazy var playgroundsButton = UIButton()
  
  // MARK: Initialization
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  override init(frame: CGRect) { super.init(frame: frame) }
  convenience init() { self.init(frame: CGRect.zero); configure(); constrain() }
  
  // MARK: View Configuration
  func configure() {
    
    // View
    backgroundColor = UIColor.white.withAlphaComponent(0.8)
    
    // Stack view
    stackView.distribution = .fillEqually
    stackView.spacing = 20
    stackView.alignment = .center
    
    // Radius label
    radiusLabel.text = "Radius:"
    radiusLabel.font = UIFont.themeSmallBold
    radiusLabel.textColor = UIColor.themeCoral
    
    // Radius value label
    radiusValueLabel.font = UIFont.themeSmallBold
    radiusValueLabel.textColor = UIColor.themeMarine
    
    // Dog parks button
    dogParksButton.setTitle("Dog Parks", for: .normal)
    dogParksButton.titleLabel?.font = UIFont.themeTinyBold
    dogParksButton.setTitleColor(UIColor.themeMarine, for: .normal)
    dogParksButton.contentEdgeInsets = UIEdgeInsetsMake(5, 8, 5, 8)
    dogParksButton.layer.cornerRadius = 12
    dogParksButton.layer.borderWidth = 2
    dogParksButton.layer.borderColor = UIColor.themeMarine.cgColor
    
    // Playgrounds button
    playgroundsButton.setTitle("Playground", for: .normal)
    playgroundsButton.titleLabel?.font = UIFont.themeTinyBold
    playgroundsButton.setTitleColor(UIColor.themeMarine, for: .normal)
    playgroundsButton.contentEdgeInsets = UIEdgeInsetsMake(5, 8, 5, 8)
    playgroundsButton.layer.cornerRadius = 12
    playgroundsButton.layer.borderWidth = 2
    playgroundsButton.layer.borderColor = UIColor.themeMarine.cgColor
  }
  
  // MARK: View Constraints
  func constrain() {
    let padding: CGFloat = 15
    
    // Radius label
    radiusView.addSubview(radiusLabel)
    radiusLabel.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
    }
  
    // Radius value label
    radiusView.addSubview(radiusValueLabel)
    radiusValueLabel.snp.makeConstraints {
      $0.leading.equalTo(radiusLabel.snp.trailing)
      $0.trailing.top.bottom.equalToSuperview()
    }
    
    // Stack view
    stackView.addArrangedSubview(radiusView)
    stackView.addArrangedSubview(dogParksButton)
    stackView.addArrangedSubview(playgroundsButton)
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.edges.equalTo(UIEdgeInsetsMake(padding, padding, padding, padding))
    }
  }
}
