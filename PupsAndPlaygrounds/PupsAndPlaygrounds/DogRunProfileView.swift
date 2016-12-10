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
    var dogRunProfileImage: UIImageView!
    var isDogRunIcon: UIImageView!
    var isOffLeashIcon: UIImageView!
    
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
        
        FirebaseData.calcAverageStarFor(location: location.dogRunID) { (averageStarValue) in
            print("AVERAGE STAR VALUE \(averageStarValue)")
            self.starReviews = StarReview(frame: CGRect(x: 15, y: 250, width: 150, height: 70))
            self.starReviews.starCount = 5
            self.starReviews.value = averageStarValue
            self.starReviews.allowAccruteStars = false
            self.starReviews.starFillColor = UIColor.themeSunshine
            self.starReviews.starBackgroundColor = UIColor.themeTeal
            self.starReviews.starMarginScale = 0.3
            self.starReviews.contentMode = .scaleAspectFit
        }
        
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
        backgroundColor = UIColor.themeWhite
        
        
        dogStreetView = UIView()
        dogPanoView = GMSPanoramaView()
        dogPanoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        dogPanoView.layer.cornerRadius = 5
        
        //configure dogDetailView 
        dogDetailView = UIView()
        
        
        //configure dogRunNameLabel
        dogRunNameLabel = UILabel()
        dogRunNameLabel.font = UIFont.themeMediumThin
        dogRunNameLabel.textColor = UIColor.themeGrass
        dogRunNameLabel.adjustsFontSizeToFitWidth = true
        dogRunNameLabel.numberOfLines = 2
        dogRunNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        // configure dogRunAddressLabel
        dogRunAddressLabel = UILabel()
        dogRunAddressLabel.font = UIFont.themeMediumLight
        dogRunAddressLabel.textColor = UIColor.themeGrass
        dogRunAddressLabel.adjustsFontSizeToFitWidth = true
        dogRunAddressLabel.numberOfLines = 2
        dogRunAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        //configure dogNotesView 
        dogNotesView = UIView()
        dogNotesView.backgroundColor = UIColor.themeSunshine
        
        //configure dogNotesLabel
        dogNotesLabel = UILabel()
        dogNotesLabel.font = UIFont.themeMediumBold
        dogNotesLabel.textColor = UIColor.themeGrass
        dogNotesLabel.adjustsFontSizeToFitWidth = true
        dogNotesLabel.numberOfLines = 3
        dogNotesLabel.lineBreakMode = NSLineBreakMode.byWordWrapping

        
        // TODO: Add dogRun icons
        //if dogrun.isOffLeash = true
        // display dogRun.offLeash icon
        // else //
        // display dogRun.Run icon
    
        //configure dogReviewView
        dogrunReviewView = UIView()
        dogrunReviewView.backgroundColor = UIColor.themeCoral
        
        
        //configure dogReviews tableview
        dogReviewsTableView = UITableView()
        dogReviewsTableView.rowHeight = 40
        dogReviewsTableView.backgroundColor = UIColor.themeWhite
        dogReviewsTableView.layer.cornerRadius = 5
        
        
        //configure submitReviewButton
        submitReviewButton = UIButton(frame: CGRect(x: 0, y: 0, width:700 , height: 120))
        submitReviewButton.setTitle("Submit a Review", for: .normal)
        submitReviewButton.layer.cornerRadius = 2
        submitReviewButton.titleLabel?.font = UIFont.themeSmallThin
        submitReviewButton.backgroundColor = UIColor.themeCoral
        submitReviewButton.setTitleColor(UIColor.themeWhite , for: .normal)
        
    }
    
    func constrain() {
        
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
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(dogDetailView)
        dogDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dogStreetView.snp.bottom)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(dogStreetView.snp.width).multipliedBy(0.2)
        }
        
        dogDetailView.addSubview(dogRunNameLabel)
        dogRunNameLabel.snp.makeConstraints {
            $0.top.equalTo(dogDetailView.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(scrollView.snp.width)
        }

        dogDetailView.addSubview(dogRunAddressLabel)
        dogRunAddressLabel.snp.makeConstraints {
            $0.top.equalTo(dogRunNameLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(dogDetailView.snp.bottom)
            $0.width.equalTo(scrollView.snp.width)
        }
     
        scrollView.addSubview(dogNotesView)
        dogNotesView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dogDetailView.snp.bottom)
        }
        
        
        

    
            
            

        
        // constrain() function finsihed
    }
    
}

