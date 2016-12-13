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
    self.starReviews = StarReview(frame: CGRect(x: 15, y: 250, width: 150, height: 70))
    self.starReviews.starCount = 5
    self.starReviews.allowAccruteStars = false
    self.starReviews.starFillColor = UIColor.themeSunshine
    self.starReviews.starBackgroundColor = UIColor.themeTeal
    self.starReviews.starMarginScale = 0.3
    self.starReviews.contentMode = .scaleAspectFit
    
    FIRClient.calcAverageStarFor(location: location.id) { (averageStarValue) in
      print("AVERAGE STAR VALUE \(averageStarValue)")
      self.starReviews.value = averageStarValue
      
    }
    
    scrollView = UIScrollView()
    scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
    backgroundColor = UIColor.themeWhite
    
    contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height))
    
    dogStreetView = UIView()
    dogPanoView = GMSPanoramaView()
    dogPanoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
    dogPanoView.layer.cornerRadius = 5
    
    //configure dogDetailView
    dogDetailView = UIView()
    
    
    //configure dogRunNameLabel
    dogRunNameLabel = UILabel()
    dogRunNameLabel.font = UIFont.themeSmallBold
    dogRunNameLabel.textColor = UIColor.themeMarine
    dogRunNameLabel.adjustsFontSizeToFitWidth = true
    dogRunNameLabel.numberOfLines = 0
    dogRunNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    
    // configure dogRunAddressLabel
    dogRunAddressLabel = UILabel()
    dogRunAddressLabel.font = UIFont.themeSmallRegular
    dogRunAddressLabel.textColor = UIColor.themeMarine
    dogRunAddressLabel.adjustsFontSizeToFitWidth = true
    dogRunAddressLabel.numberOfLines = 0
    dogRunAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    
    
    //configure dogNotesView
    dogNotesView = UIView()
    dogNotesView.backgroundColor = UIColor.themeWhite
    
    //configure dogNotesLabel
    dogNotesLabel = UILabel()
    dogNotesLabel.font = UIFont.themeSmallRegular
    dogNotesLabel.textColor = UIColor.themeMarine
    dogNotesLabel.adjustsFontSizeToFitWidth = true
    dogNotesLabel.numberOfLines = 0
    dogNotesLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    
    //configre dogTypeView
    dogTypeView = UIView()
    dogTypeView.backgroundColor = UIColor.themeWhite
    
    dogTypeLabel = UILabel()
    dogTypeLabel.font = UIFont.themeMediumBold
    dogTypeLabel.textColor = UIColor.themeTeal
    dogTypeLabel.adjustsFontSizeToFitWidth = true
    dogTypeLabel.numberOfLines = 0
    dogTypeLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    
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
    submitReviewButton.setTitle("Review this dogrun!", for: .normal)
    submitReviewButton.layer.cornerRadius = 2
    submitReviewButton.titleLabel?.font = UIFont.themeSmallBold
    submitReviewButton.backgroundColor = UIColor.themeCoral
    submitReviewButton.setTitleColor(UIColor.themeWhite , for: .normal)
    
  }
  
  func constrain() {
    let leadingTopOffset = 10
    let trailingBottomOffset = -10
    
    addSubview(scrollView)
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    scrollView.addSubview(contentView)
    
    contentView.addSubview(dogStreetView)
    dogStreetView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalToSuperview().dividedBy(4)
    }
    
    dogStreetView.addSubview(dogPanoView)
    dogPanoView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    contentView.addSubview(dogDetailView)
    dogDetailView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(dogStreetView.snp.bottom)
      $0.height.equalToSuperview().dividedBy(10)
    }
    
    dogDetailView.addSubview(dogRunNameLabel)
    dogRunNameLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(leadingTopOffset)
      $0.trailing.equalToSuperview().offset(trailingBottomOffset)
    }
    
    dogDetailView.addSubview(dogRunAddressLabel)
    dogRunAddressLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(leadingTopOffset)
      $0.trailing.equalToSuperview().offset(trailingBottomOffset)
      $0.top.equalTo(dogRunNameLabel.snp.bottom).offset(leadingTopOffset)
      $0.bottom.equalToSuperview().offset(-20)
      
    }
    
    contentView.addSubview(dogNotesView)
    dogNotesView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(dogDetailView.snp.bottom)
      $0.height.equalTo(dogDetailView).offset(-20)
    }
    
    dogNotesView.addSubview(dogNotesLabel)
    dogNotesLabel.snp.makeConstraints {
      $0.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10))
    }
    
    contentView.addSubview(dogTypeView)
    dogTypeView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview().dividedBy(2)
      $0.top.equalTo(dogNotesView.snp.bottom)
      $0.height.equalTo(dogDetailView).offset(-20)
    }
    
    dogTypeView.addSubview(dogTypeLabel)
    dogTypeLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalToSuperview().offset(leadingTopOffset)
      $0.bottom.equalToSuperview().offset(trailingBottomOffset)
      $0.leading.equalToSuperview().offset(20)
      
    }
    
    contentView.addSubview(starReviews)
    starReviews.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(trailingBottomOffset)
      $0.leading.equalTo(dogTypeView.snp.trailing).offset(leadingTopOffset)
      $0.top.equalTo(dogNotesView.snp.bottom)
      $0.height.equalTo(dogDetailView).offset(-20)
      
    }
    
    contentView.addSubview(submitReviewButton)
    submitReviewButton.snp.makeConstraints {
      $0.top.equalTo(dogTypeView.snp.bottom)
      $0.trailing.equalToSuperview().offset(trailingBottomOffset)
      $0.leading.equalToSuperview().offset(leadingTopOffset)
      $0.bottom.equalTo(dogReviewsTableView.snp.top).offset(trailingBottomOffset)
      
      
      contentView.addSubview(dogReviewsTableView)
      dogReviewsTableView.snp.makeConstraints {
        $0.top.equalTo(submitReviewButton.snp.bottom)
        $0.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(contentView.snp.bottom).offset(trailingBottomOffset)
        
      }
      
    }
    
  }
  
}
