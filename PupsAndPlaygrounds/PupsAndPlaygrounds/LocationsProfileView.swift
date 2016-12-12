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
  var rating: String?
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
    
    self.starReviews = StarReview(frame: CGRect(x: 15, y: 250, width: 150, height: 70))
    self.starReviews.starCount = 5
    self.starReviews.allowAccruteStars = false
    self.starReviews.starFillColor = UIColor.themeSunshine
    self.starReviews.starBackgroundColor = UIColor.lightGray
    self.starReviews.starMarginScale = 0.3
    self.starReviews.contentMode = .scaleAspectFit
    
    FirebaseData.calcAverageStarFor(location: location.playgroundID) { (averageStarValue) in
      print("AVERAGE STAR VALUE \(averageStarValue)")
      self.starReviews.value = averageStarValue
      self.starReviews.isHidden = false
    }
    scrollView = UIScrollView()
    scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
    
    locationProfileImage = UIImageView()
    locationProfileImage.image = location.profileImage
    locationProfileImage.layer.cornerRadius = 20
    locationProfileImage.clipsToBounds = true
    
    streetView = UIView()
    panoView = GMSPanoramaView()
    panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
    
    locationNameLabel = UILabel()
    locationNameLabel.font = UIFont.themeMediumBold
    locationNameLabel.textColor = UIColor.themeDarkBlue
    locationNameLabel.text = location.name
    locationNameLabel.adjustsFontSizeToFitWidth = true
    locationNameLabel.numberOfLines = 0
    locationNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    
    locationAddressLabel = UILabel()
    locationAddressLabel.font = UIFont.themeSmallRegular
    locationAddressLabel.textColor = UIColor.themeDarkBlue
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
    submitReviewButton.layer.borderColor = UIColor.themeWhite.cgColor
    
    reviewsView = UIView()
    reviewsTableView = UITableView()
    reviewsTableView.rowHeight = 40
    reviewsTableView.layer.cornerRadius = 5
    
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
      $0.edges.equalToSuperview()
    }
    
    scrollView.addSubview(locationProfileImage)
    locationProfileImage.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.equalTo(streetView.snp.bottom).offset(10)
      $0.width.equalToSuperview().dividedBy(3)
      $0.height.equalTo(locationProfileImage.snp.width)
      scrollView.addSubview(streetView)
    }
    
    scrollView.addSubview(locationNameLabel)
    locationNameLabel.snp.makeConstraints {
      $0.leading.equalTo(locationProfileImage.snp.trailing).offset(10)
      $0.top.equalTo(streetView.snp.bottom).offset(12)
      $0.height.equalTo(locationProfileImage).dividedBy(2)
      $0.width.equalToSuperview().multipliedBy(0.66)
    }
    
    
    scrollView.addSubview(locationAddressLabel)
    locationAddressLabel.snp.makeConstraints {
      $0.leading.equalTo(locationProfileImage.snp.trailing).offset(10)
      $0.top.equalTo(locationNameLabel.snp.bottom).offset(10)
      $0.height.equalTo(locationNameLabel.snp.height)
      $0.width.equalToSuperview().multipliedBy(0.66)
    }
    
    scrollView.addSubview(starReviews)
    starReviews.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.equalTo(locationProfileImage.snp.bottom).offset(2)
      $0.width.equalTo(locationProfileImage.snp.width)
      $0.height.equalTo(starReviews.frame.height)
    }
    
    
    scrollView.addSubview(submitReviewButton)
    submitReviewButton.snp.makeConstraints {
      $0.centerX.equalTo(locationNameLabel.snp.centerX)
      $0.top.equalTo(locationAddressLabel.snp.bottom).offset(2)
      $0.height.lessThanOrEqualTo(60)
      $0.width.equalTo(locationNameLabel.snp.width).multipliedBy(0.75)
    }
    
    scrollView.addSubview(reviewsView)
    reviewsView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(starReviews.snp.bottom)
      $0.width.equalTo(scrollView.snp.width)
      $0.height.equalTo(locationProfileImage.snp.height).multipliedBy(5)
    }
    
    reviewsView.addSubview(reviewsTableView)
    reviewsTableView.snp.makeConstraints {
      $0.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10))
    }
    
  }
  
  
}
