//
//  ReviewView.swift
//  PupsAndPlaygrounds
//
//  Created by Felicity Johnson on 12/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class ReviewView: UIView {

    // MARK: Properties
    lazy var innerView = UIView()
    var submitReviewButton: UIButton!
    var starReviews: StarReview!
    var rating: String?
    var cancelButton: UIButton!
    var reviewTextView: UITextView!
    var location: Playground!
    
    // MARK: Initialization
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
    }
    
    // MARK: View Configuration
    private func configure() {
        
        backgroundColor = UIColor.themeDarkBlue.withAlphaComponent(0.7)
        
        innerView.backgroundColor = UIColor.themeTeal
        innerView.layer.cornerRadius = 20
        
        submitReviewButton = UIButton()
        submitReviewButton.titleLabel?.font = UIFont.themeMediumBold
        submitReviewButton.titleLabel?.textAlignment = .center
        submitReviewButton.layer.borderWidth = 4
        submitReviewButton.layer.borderColor = UIColor.themeWhite.cgColor
        submitReviewButton.clipsToBounds = true
        submitReviewButton.setTitle("Submit", for: .normal)
        submitReviewButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        submitReviewButton.layer.cornerRadius = 10
        
        reviewTextView = UITextView()
        reviewTextView.placeholderText = "Please write review here"
        reviewTextView.font = UIFont.themeSmallRegular
        reviewTextView.textColor = UIColor.themeWhite
        reviewTextView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        reviewTextView.layer.cornerRadius = 15
        
        starReviews = StarReview()
        self.starReviews = StarReview(frame: CGRect(x: 15, y: 250, width: 300, height: 140))
        self.starReviews.starCount = 5
        self.starReviews.value = 1
        self.starReviews.allowAccruteStars = false
        self.starReviews.starFillColor = UIColor.themeWhite
        self.starReviews.starBackgroundColor = UIColor.themeDarkBlue
        self.starReviews.starMarginScale = 0.3
        
        
        cancelButton = UIButton()
        cancelButton.setTitle("X", for: .normal)
        cancelButton.titleLabel?.font = UIFont.themeMediumBold
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    // MARK: View Constraints
    private func constrain() {
        addSubview(innerView)
        innerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().dividedBy(1.7)
            $0.height.equalToSuperview().dividedBy(2)
            $0.width.equalToSuperview().dividedBy(1.2)
        }
        
        innerView.addSubview(reviewTextView)
        reviewTextView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.height.equalToSuperview().dividedBy(2)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            
        }

        
        innerView.addSubview(submitReviewButton)
        submitReviewButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
        }
        
        innerView.addSubview(starReviews)
        starReviews.snp.makeConstraints {
            $0.top.equalTo(reviewTextView.snp.bottom).offset(20)
            $0.width.height.equalTo(submitReviewButton)
            $0.centerX.equalToSuperview()
        }
        
        innerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
    }
}
