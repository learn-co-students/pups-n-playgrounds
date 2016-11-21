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

    var reviewTextField: UITextField!
    var ratingTextField: UITextField!
    var submitButton: UIButton!
    
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        backgroundColor = UIColor.themeLightBlue
        
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
        addSubview(reviewTextField)
        reviewTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
            $0.width.equalToSuperview().dividedBy(1.3)
            $0.height.equalToSuperview().dividedBy(1.5)
        }
        
        addSubview(ratingTextField)
        ratingTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
            $0.width.equalToSuperview().dividedBy(1.3)
            $0.height.equalToSuperview().dividedBy(1.5)
        }
        
        addSubview(submitButton)
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(reviewTextField.snp.bottom).offset(40)
        }
    }
    
}
