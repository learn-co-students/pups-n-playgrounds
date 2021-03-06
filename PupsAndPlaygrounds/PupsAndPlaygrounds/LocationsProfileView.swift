//
//  LocationProfileView.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaps

class LocationProfileView: UIView, GMSMapViewDelegate {
    
    
    var location: Playground!
    var locationProfileImage: UIImageView!
    var locationNameLabel: UILabel!
    var locationAddressLabel: UILabel!
    var submitReviewButton: UIButton!
    var reviewsView: UIView!
    var reviewsTableView: UITableView!
    var streetView: UIView!
    var panoView: GMSPanoramaView!
    var starReviews: StarReview!
    var scrollView: UIScrollView!
    var contentView: UIView!
    
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
        
        starReviews = StarReview(frame: CGRect(x: 15, y: 250, width: 150, height: 70))
        starReviews.starCount = 5
        starReviews.allowAccruteStars = false
        starReviews.starFillColor = UIColor.themeSunshine
        starReviews.starBackgroundColor = UIColor.lightGray
        starReviews.starMarginScale = 0.3
        starReviews.contentMode = .scaleAspectFit
        
        starReviews.allowEdit = false
        starReviews.value = FIRClient.calcAverageStarFor(location: location.id)
        
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
        
        locationProfileImage = UIImageView()
        locationProfileImage.image = location.profileImage
        locationProfileImage.layer.cornerRadius = 20
        locationProfileImage.clipsToBounds = true
        
        streetView = UIView()
        streetView.layer.cornerRadius = 10
        
        panoView = GMSPanoramaView()
        panoView.layer.cornerRadius = 10
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        
        locationNameLabel = UILabel()
        locationNameLabel.font = UIFont.themeMediumThin
        locationNameLabel.textColor = UIColor.themeWhite
        locationNameLabel.text = location.name
        locationNameLabel.adjustsFontSizeToFitWidth = true
        locationNameLabel.numberOfLines = 0
        locationNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        locationNameLabel.textAlignment = .center

        locationAddressLabel = UILabel()
        locationAddressLabel.font = UIFont.themeSmallLight
        locationAddressLabel.textColor = UIColor.themeWhite
        locationAddressLabel.text = location.address
        locationNameLabel.adjustsFontSizeToFitWidth = true
        locationAddressLabel.numberOfLines = 0
        locationAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        submitReviewButton = UIButton()
        submitReviewButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        submitReviewButton.setTitle("Review This Location", for: .normal)
        submitReviewButton.titleLabel?.font = UIFont.themeSmallBold
        submitReviewButton.setTitleColor(UIColor.themeWhite, for: .normal)
        submitReviewButton.layer.borderWidth = 2
        submitReviewButton.layer.cornerRadius = 10
        submitReviewButton.layer.borderColor = UIColor.themeWhite.cgColor
        submitReviewButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        reviewsView = UIView()
        reviewsTableView = UITableView()
        reviewsTableView.rowHeight = 80
        reviewsTableView.layer.cornerRadius = 20
        
    }
    
    func constrain() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(streetView)
        streetView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.top)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(streetView.snp.width).multipliedBy(0.6)
        }
        
        streetView.addSubview(panoView)
        panoView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
        scrollView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints {
            $0.top.equalTo(streetView.snp.bottom)
            $0.width.equalToSuperview()
        }
        
        scrollView.addSubview(locationProfileImage)
        locationProfileImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(locationProfileImage.snp.width)
        }

        scrollView.addSubview(locationAddressLabel)
        locationAddressLabel.snp.makeConstraints {
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(13)
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(10)
            $0.width.equalToSuperview().multipliedBy(0.66)
        }
        
        scrollView.addSubview(starReviews)
        starReviews.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(10)
            $0.bottom.equalTo(locationProfileImage.snp.bottom)
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(starReviews.frame.height)
        }


        
        
        scrollView.addSubview(submitReviewButton)
        submitReviewButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationProfileImage.snp.bottom).offset(5)
            $0.height.lessThanOrEqualTo(60)
            $0.width.equalToSuperview().multipliedBy(0.6)
        }
        
        scrollView.addSubview(reviewsView)
        reviewsView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(submitReviewButton.snp.bottom)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(locationProfileImage.snp.height).multipliedBy(5)
        }

        reviewsView.addSubview(reviewsTableView)
        reviewsTableView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
    }
    
    
}
