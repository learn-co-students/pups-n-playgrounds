//
//  DogrunReviewView.swift
//  PupsAndPlaygrounds
//
//  Created by Missy Allan on 12/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class DogrunReviewView: UIView {
    
    //MARK: Properties
    lazy var doginnerView = UIView()
    var submitReviewButton: UIButton!
    var starReviews: StarReview!
    var rating: String?
    var dogCancelButton: UIButton!
    var dogReviewTextField: UITextField!
    var location: Dogrun!
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(dogrun: Dogrun) {
        self.init(frame: CGRect.zero)
        location = dogrun
        configure()
        constrain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Configure View 
    
    private func configure() {
        
        backgroundColor = UIColor.themeLightBlue.withAlphaComponent(0.7)
       
        doginnerView.backgroundColor = UIColor.themeLightBlue
        doginnerView.layer.cornerRadius = 20
        
        submitReviewButton = UIButton()
        submitReviewButton.titleLabel?.font = UIFont.themeMediumThin
        submitReviewButton.titleLabel?.textAlignment = .center
        submitReviewButton.layer.borderWidth = 4
        submitReviewButton.layer.borderColor = UIColor.themeWhite.cgColor
        submitReviewButton.clipsToBounds = true
        submitReviewButton.setTitle("Submit", for: .normal)
        submitReviewButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        submitReviewButton.layer.cornerRadius = 10

        
        dogReviewTextField = CustomTextField()
        dogReviewTextField.placeholder = "Please write your review here."
        dogReviewTextField.font = UIFont.themeSmallLight
        dogReviewTextField.textColor = UIColor.themeWhite
        
        starReviews = StarReview()
        self.starReviews = StarReview(frame: CGRect(x: 15, y: 250, width: 150, height: 70))
        self.starReviews.starCount = 5
        self.starReviews.value = 1
        self.starReviews.allowAccruteStars = false
        self.starReviews.starFillColor = UIColor.themeSunshine
        self.starReviews.starBackgroundColor = UIColor.themeMarine
        self.starReviews.starMarginScale = 0.3
        
        dogCancelButton = UIButton()
        dogCancelButton.setTitle("X", for: .normal)
        dogCancelButton.titleLabel?.font = UIFont.themeMediumBold
        dogCancelButton.titleLabel?.textAlignment = .center
        dogCancelButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)

    }
    
    //MARK: DogReview View Constraints
    
    private func constrain() {
        addSubview(doginnerView)
        doginnerView.snp.makeConstratints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview().dividedBy(1.5)
        }
        
        doginnerView.addSubview(submitReviewButton)
        submitReviewButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
        }
        
        doginnerView.addSubview(dogReviewTextField)
        dogReviewTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.centerX.equalToSuperview()
        }
        
        doginnerView.addSubview(starReviews)
        starReviews.snp.makeConstraints {
            $0.top.equalTo(dogReviewTextField.snp.bottom).offset(20)
            $0.width.height.equalTo(submitReviewButton)
            $0.centerX.equalToSuperview()
        }
        
        doginnerView.addSubview(dogCancelButton)
        dogCancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
            
    }
    
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
