//
//  LocationProfileView.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class LocationProfileView: UIView {
    
    let store = LocationsDataStore.sharedInstance
    
    var location: Playground!
    var locationNameLabel: UILabel!
    var locationAddressLabel: UILabel!
    var submitButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    let temporaryLocation = Playground(ID: "B001", name: "American Playground", location: "Noble, Franklin, Milton Sts", handicap: "No", latitude: "40.7288", longitude: "-73.9579")
    
    convenience init(playground: Playground) {
        self.init(frame: CGRect.zero)
        location = playground
        configure()
        constrain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        backgroundColor = UIColor.themeLightBlue
        
        locationNameLabel = UILabel()
        locationNameLabel.font = UIFont.themeMediumBold
        locationNameLabel.textColor = UIColor.themeDarkBlue
        locationNameLabel.text = location.name
        
        locationAddressLabel = UILabel()
        locationAddressLabel.font = UIFont.themeSmallBold
        locationAddressLabel.textColor = UIColor.themeDarkBlue
        locationAddressLabel.text = location.location
        
        submitButton = UIButton()
        submitButton.contentEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16)
        submitButton.setTitle("Review This Location", for: .normal)
        submitButton.titleLabel?.font = UIFont.themeSmallBold
        submitButton.setTitleColor(UIColor.themeWhite, for: .normal)
        submitButton.layer.cornerRadius = 20
        submitButton.layer.borderWidth = 2
        submitButton.layer.borderColor = UIColor.themeWhite.cgColor
        
    }
    
    func constrain() {
        addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(10)
        }
    
        addSubview(locationAddressLabel)
        locationAddressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
        addSubview(submitButton)
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationAddressLabel.snp.bottom).offset(40)
        }
    }

    
}
