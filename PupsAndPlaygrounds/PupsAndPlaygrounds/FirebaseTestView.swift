//
//  FirebaseTestView.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class FirebaseTestView: UIView {
    
    let store = LocationsDataStore.sharedInstance

    
    var location: Location!
    var locationNameLabel: UILabel!
    
    var reviewTextField: UITextField!
    var ratingTextField: UITextField!
    var submitButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        location = store.playgrounds[0]
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
        
        reviewTextField = CustomTextField()
        reviewTextField.placeholder = "Type review here"
        reviewTextField.textColor = UIColor.themeWhite
        reviewTextField.layer.cornerRadius = 10
        reviewTextField.layer.borderWidth = 1
        reviewTextField.layer.borderColor = UIColor.themeWhite.cgColor
        
        ratingTextField = CustomTextField()
        ratingTextField.placeholder = "Enter rating here"
        ratingTextField.textColor = UIColor.themeWhite
        ratingTextField.layer.cornerRadius = 10
        ratingTextField.layer.borderWidth = 1
        ratingTextField.layer.borderColor = UIColor.themeWhite.cgColor
        
        submitButton = UIButton()
        submitButton.contentEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16)
        submitButton.setTitle("Submit Review", for: .normal)
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
        
        addSubview(reviewTextField)
        reviewTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationNameLabel.snp.bottom)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(3)
        }
        
        addSubview(ratingTextField)
        ratingTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(reviewTextField.snp.bottom)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(3)
        }
        
        addSubview(submitButton)
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(ratingTextField.snp.bottom).offset(40)
        }
    }
    
}
