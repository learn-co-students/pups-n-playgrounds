//
//  UserProfileView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

final class UserProfileView: UIView {
    
    // MARK: Properties
    var profileButton: UIButton!
    var userNameLabel: UILabel!
    var reviewsView: UIView!
    var reviewsTableView: UITableView!
    var savingView: UIVisualEffectView!
    var savingActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        configure()
        constrain()
    }
    
    // MARK: Setup
    private func configure() {
        layer.addSublayer(CAGradientLayer([UIColor.themeTeal, UIColor.themeGrass]))
        
        profileButton = UIButton()
        profileButton.clipsToBounds = true
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.layer.borderWidth = 4
        profileButton.layer.borderColor = UIColor.themeWhite.cgColor
        
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.themeMediumLight
        userNameLabel.textColor = UIColor.themeWhite
        
        reviewsView = UIView()
        reviewsTableView = UITableView()
        reviewsTableView.separatorStyle = .none
        reviewsTableView.rowHeight = 40
        reviewsTableView.layer.cornerRadius = 20
        
        savingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        savingActivityIndicator = UIActivityIndicatorView()

        savingView.isHidden = true
        
    }
    
    private func constrain() {
        addSubview(profileButton)
        profileButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(profileButton.snp.width)
        }
        
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(reviewsView)
        reviewsView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(userNameLabel.snp.bottom).offset(40)
            $0.bottom.equalToSuperview().offset(-49)
        }
        
        reviewsView.addSubview(reviewsTableView)
        reviewsTableView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
        addSubview(savingView)
        savingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        savingView.addSubview(savingActivityIndicator)
        savingActivityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}








