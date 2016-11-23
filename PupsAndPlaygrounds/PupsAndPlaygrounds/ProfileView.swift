//
//  ProfileView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

final class ProfileView: UIView {
    
    // MARK: Properties
    var profileButton: UIButton!
    let profileButtonWidth: CGFloat = 200
    var userNameLabel: UILabel!
    
    var locationButton: UIButton!
    
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
    private func configure() {
        backgroundColor = UIColor.themeLightBlue
        
        profileButton = UIButton()
        profileButton.titleLabel?.font = UIFont.themeMediumBold
        profileButton.titleLabel?.numberOfLines = 2
        profileButton.titleLabel?.textAlignment = .center
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.layer.cornerRadius = profileButtonWidth / 2
        profileButton.layer.borderWidth = 4
        profileButton.layer.borderColor = UIColor.themeWhite.cgColor
        profileButton.clipsToBounds = true
        
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.themeMediumLight
        userNameLabel.textColor = UIColor.themeWhite
        
        locationButton = UIButton()
        locationButton.contentEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16)
        locationButton.setTitle("Review This Location", for: .normal)
        locationButton.titleLabel?.font = UIFont.themeSmallBold
        locationButton.setTitleColor(UIColor.themeWhite, for: .normal)
        locationButton.layer.cornerRadius = 20
        locationButton.layer.borderWidth = 2
        locationButton.layer.borderColor = UIColor.themeWhite.cgColor
    }
    
    // MARK: View Constraints
    private func constrain() {
        addSubview(profileButton)
        profileButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(80)
            $0.width.height.equalTo(profileButtonWidth)
        }
        
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileButton.snp.bottom).offset(40)
        }
        addSubview(locationButton)
        locationButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
}

