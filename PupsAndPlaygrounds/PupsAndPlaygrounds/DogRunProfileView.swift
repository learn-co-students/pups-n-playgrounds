//
//  DogRunProfileView.swift
//  PupsAndPlaygrounds
//
//  Created by Missy Allan on 12/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import GoogleMaps


class DogRunProfileView: UIView, GMSMapViewDelegate {
    
    var location: Dogrun!
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var dogTypeView: UIView!
    var dogTypeLabel: UILabel!
    
    var dogStreetView: UIView!
    var dogPanoView: GMSPanoramaView!
    
    var dogDetailView: UIView!
    var dogRunNameLabel: UILabel!
    var dogRunAddressLabel: UILabel!
    
    var dogNotesView: UIView!
    var dogNotesLabel: UILabel!
    
    var dogrunReviewView: UIView!
    var dogReviewsTableView: UITableView!
    var submitReviewButton: UIButton!
    
    
    var starReviews: StarReview!
    var rating: String?
    
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
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure() {
        starReviews = StarReview(frame: CGRect(x: 15, y: 250, width: 150, height: 70))
        starReviews.starCount = 5
        starReviews.allowAccruteStars = false
        starReviews.allowEdit = false
        starReviews.starFillColor = UIColor.themeSunshine
        starReviews.starBackgroundColor = UIColor.lightGray
        starReviews.starMarginScale = 0.3
        starReviews.contentMode = .scaleAspectFit
        starReviews.allowEdit = false
        starReviews.value = FIRClient.calcAverageStarFor(location: location.id)
  
        
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
        
//        contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height))
//        contentView.backgroundColor = UIColor.themeSunshine
        
        dogStreetView = UIView()
        dogPanoView = GMSPanoramaView()
        dogPanoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        dogPanoView.layer.cornerRadius = 10
        
        //configure dogDetailView
        dogDetailView = UIView()
        
        
        //configure dogRunNameLabel
        dogRunNameLabel = UILabel()
        dogRunNameLabel.font = UIFont.themeMediumThin
        dogRunNameLabel.textColor = UIColor.themeWhite
        dogRunNameLabel.adjustsFontSizeToFitWidth = true
        dogRunNameLabel.numberOfLines = 0
        dogRunNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        // configure dogRunAddressLabel
        dogRunAddressLabel = UILabel()
        dogRunAddressLabel.font = UIFont.themeSmallLight
        dogRunAddressLabel.textColor = UIColor.themeWhite
        dogRunAddressLabel.adjustsFontSizeToFitWidth = true
        dogRunAddressLabel.numberOfLines = 0
        dogRunAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        //configure dogNotesView
        dogNotesView = UIView()
//        dogNotesView.backgroundColor = UIColor.magenta
        
        //configure dogNotesLabel
        dogNotesLabel = UILabel()
        dogNotesLabel.font = UIFont.themeSmallThin
        dogNotesLabel.textColor = UIColor.themeWhite
        dogNotesLabel.adjustsFontSizeToFitWidth = true
        dogNotesLabel.numberOfLines = 0
        dogNotesLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //configre dogTypeView
        dogTypeView = UIView()
        dogTypeView.layer.cornerRadius = 20

        
        dogTypeLabel = UILabel()
        dogTypeLabel.font = UIFont.themeMediumBold
        dogTypeLabel.textColor = UIColor.themeWhite
        dogTypeLabel.adjustsFontSizeToFitWidth = true
        dogTypeLabel.numberOfLines = 0
        dogTypeLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //configure dogReviewView
        dogrunReviewView = UIView()
        
        
        //configure dogReviews tableview
        dogReviewsTableView = UITableView()
        dogReviewsTableView.rowHeight = 40
        dogReviewsTableView.layer.cornerRadius = 20
        
        
        //configure submitReviewButton
        submitReviewButton = UIButton()
        submitReviewButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        submitReviewButton.setTitle("Review This Dogrun!", for: .normal)
        submitReviewButton.layer.cornerRadius = 10
        submitReviewButton.titleLabel?.font = UIFont.themeMediumRegular
        submitReviewButton.backgroundColor = UIColor.themeTeal.withAlphaComponent(0.3)
        submitReviewButton.layer.borderColor = UIColor.themeWhite.cgColor
        submitReviewButton.layer.borderWidth = 4
        submitReviewButton.setTitleColor(UIColor.themeWhite , for: .normal)
        submitReviewButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    func constrain() {
        let leadingTopOffset = 10
        let trailingBottomOffset = -10
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(dogStreetView)
        dogStreetView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.top)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(dogStreetView.snp.width).multipliedBy(0.6)
        }
        
        dogStreetView.addSubview(dogPanoView)
        dogPanoView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
        scrollView.addSubview(dogDetailView)
        dogDetailView.snp.makeConstraints {
            $0.top.equalTo(dogStreetView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(5)
        }

        dogDetailView.addSubview(dogRunNameLabel)
        dogRunNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(leadingTopOffset)
            $0.trailing.equalToSuperview().offset(trailingBottomOffset)
            $0.height.equalToSuperview().dividedBy(2)
        }
        
        dogDetailView.addSubview(dogRunAddressLabel)
        dogRunAddressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(leadingTopOffset)
            $0.trailing.equalToSuperview().offset(trailingBottomOffset)
            $0.top.equalTo(dogRunNameLabel.snp.bottom).offset(leadingTopOffset)
            $0.height.equalTo(dogRunNameLabel.snp.height).dividedBy(2)
        }
        
//        scrollView.addSubview(dogNotesView)
//        dogNotesView.snp.makeConstraints {
//            $0.top.equalTo(dogDetailView.snp.bottom)
//            $0.width.equalToSuperview()
//            $0.height.equalTo(dogDetailView).offset(-20)
//        }

        dogDetailView.addSubview(dogNotesLabel)
        dogNotesLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(leadingTopOffset)
            $0.trailing.equalToSuperview().offset(trailingBottomOffset)
            $0.top.equalTo(dogRunAddressLabel.snp.bottom).offset(leadingTopOffset)
            $0.bottom.equalToSuperview().offset(trailingBottomOffset)
        }
        
        scrollView.addSubview(dogTypeView)
        dogTypeView.snp.makeConstraints {
            $0.top.equalTo(dogDetailView.snp.bottom)
            $0.height.equalTo(dogRunAddressLabel.snp.height)
            $0.width.equalToSuperview()
        }

        dogTypeView.addSubview(dogTypeLabel)
        dogTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalToSuperview().multipliedBy(0.4)
        }

        dogTypeView.addSubview(starReviews)
        starReviews.snp.makeConstraints {
            $0.leading.equalTo(dogTypeLabel.snp.trailing)
            $0.top.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(starReviews.frame.height)
            
        }
        
        scrollView.addSubview(submitReviewButton)
        submitReviewButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dogTypeView.snp.bottom).offset(5)
            $0.width.equalToSuperview().dividedBy(1.5)
        }

        scrollView.addSubview(dogrunReviewView)
        dogrunReviewView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(submitReviewButton.snp.bottom).offset(5)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(dogStreetView.snp.height).multipliedBy(3)
        }

        dogrunReviewView.addSubview(dogReviewsTableView)
        dogReviewsTableView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10))
            
        }
        
    }
    
}
