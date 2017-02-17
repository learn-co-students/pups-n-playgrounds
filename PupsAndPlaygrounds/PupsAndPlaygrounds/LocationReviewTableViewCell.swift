//
//  ReviewsTableViewCell.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 12/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class LocationReviewTableViewCell: UITableViewCell {
  
    lazy var visibleView = UIView()
    lazy var innerView = UIView()
    lazy var userNameLabel = UILabel()
    lazy var commentsLabel = UILabel()
    lazy var starReview = StarReview()
    
    
    var review: Review? {
        didSet {
            configure()
            constrain()
        }
    }
    
    private func configure() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        visibleView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        guard let review = review else {
            print("error unwrapping user review in table view cell")
            return
        }
        
        userNameLabel.textColor = UIColor.white
        userNameLabel.font = UIFont.themeSmallBold
        
        commentsLabel.text = review.comment
        commentsLabel.textColor = UIColor.white
        commentsLabel.font = UIFont.themeTinyRegular
        
        starReview.value = Float(review.rating)
        starReview.starCount = 5
        starReview.starBackgroundColor = UIColor.lightGray
        starReview.starFillColor = UIColor.white
        starReview.isUserInteractionEnabled = false
        starReview.starMarginScale = 0.3
        starReview.contentMode = .scaleAspectFit
        
        layer.addSublayer(CustomBorder(.bottom, UIColor.white.withAlphaComponent(0.2), 2, frame))
    }
    
    private func constrain() {
        contentView.addSubview(visibleView)
        visibleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        visibleView.addSubview(innerView)
        innerView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(15, 15, 15, 15))
        }
        
        innerView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        innerView.addSubview(commentsLabel)
        commentsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
        }
        
        innerView.addSubview(starReview)
        starReview.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
            $0.width.equalToSuperview().dividedBy(3)
        }
    }

}

