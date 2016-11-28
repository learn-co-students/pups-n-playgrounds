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
    
    var location: Playground!
    var locationProfileImage: UIImageView!
    var locationNameLabel: UILabel!
    var locationAddressLabel: UILabel!
    var submitButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
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
        
        locationProfileImage = UIImageView()
        locationProfileImage.image = location.profileImage
        locationProfileImage.layer.cornerRadius = 20
        
        locationNameLabel = UILabel()
        locationNameLabel.font = UIFont.themeMediumBold
        locationNameLabel.textColor = UIColor.themeDarkBlue
        locationNameLabel.text = location.name
        locationNameLabel.adjustsFontSizeToFitWidth = true
        locationNameLabel.numberOfLines = 2
        locationNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        
        locationAddressLabel = UILabel()
        locationAddressLabel.font = UIFont.themeSmallRegular
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
        addSubview(locationProfileImage)
        locationProfileImage.snp.makeConstraints {
            $0.leadingMargin.equalToSuperview().offset(10)
            $0.topMargin.equalToSuperview().offset(35)
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(locationProfileImage.snp.width)
        }
        
        addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
        addSubview(locationAddressLabel)
        locationAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(10)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
        addSubview(submitButton)
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationProfileImage.snp.bottom).offset(10)
        }
    }
    
    
}
