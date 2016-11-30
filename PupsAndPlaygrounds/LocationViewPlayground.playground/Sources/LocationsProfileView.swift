//
//  LocationProfileView.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit
//import GoogleMaps

class LocationProfileView: UIView /* , GMSMapViewDelegate */ {
    
    var location: Playground!
    var locationProfileImage: UIImageView!
    var locationNameLabel: UILabel!
    var locationAddressLabel: UILabel!
    var submitReviewButton: UIButton!
    var reviewsView: UIView!
    var reviewsTableView: UITableView!
    var streetView: UIView!
//    var panoView: GMSPanoramaView!
    
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
        
        backgroundColor = UIColor.themeLightBlue
        
        locationProfileImage = UIImageView()
        locationProfileImage.image = location.profileImage
        locationProfileImage.layer.cornerRadius = 20
        locationProfileImage.clipsToBounds = true
        
        streetView = UIView()
//        panoView = GMSPanoramaView()
//        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        streetView.layer.cornerRadius = 5
        streetView.backgroundColor = UIColor.blue
        
        locationNameLabel = UILabel()
        locationNameLabel.font = UIFont.themeMediumBold
        locationNameLabel.textColor = UIColor.themeDarkBlue
        locationNameLabel.text = location.name
        locationNameLabel.adjustsFontSizeToFitWidth = true
        locationNameLabel.numberOfLines = 2
        locationNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        locationAddressLabel = UILabel()
        locationAddressLabel.font = UIFont.themeSmallRegular
        locationAddressLabel.textColor = UIColor.themeDarkBlue
        locationAddressLabel.text = location.location
        locationAddressLabel.numberOfLines = 3
        locationAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        submitReviewButton = UIButton()
        submitReviewButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        submitReviewButton.setTitle("Review This Location", for: .normal)
        submitReviewButton.titleLabel?.font = UIFont.themeSmallBold
        submitReviewButton.setTitleColor(UIColor.themeWhite, for: .normal)
        submitReviewButton.layer.cornerRadius = 4
        submitReviewButton.layer.borderWidth = 2
        submitReviewButton.layer.borderColor = UIColor.themeWhite.cgColor
        
        reviewsView = UIView()
        reviewsTableView = UITableView()
        reviewsTableView.rowHeight = 40
        reviewsTableView.backgroundColor = UIColor.white
        reviewsTableView.layer.cornerRadius = 5
        
    }
    
    func constrain() {
        addSubview(locationProfileImage)
        locationProfileImage.snp.makeConstraints {
            $0.leadingMargin.equalToSuperview().offset(10)
            $0.topMargin.equalToSuperview().offset(10)
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(locationProfileImage.snp.width)
        }
        
        addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
            $0.topMargin.equalToSuperview().offset(10)
            $0.bottom.equalTo(locationProfileImage).dividedBy(3)
        }
        
        addSubview(locationAddressLabel)
        locationAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(5)
            $0.height.equalTo(locationNameLabel.snp.height).dividedBy(2)
        }
        
        addSubview(submitReviewButton)
        submitReviewButton.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalTo(locationProfileImage.snp.bottom)
        }
        
        addSubview(streetView)
        streetView.snp.makeConstraints {
            $0.top.equalTo(locationProfileImage.snp.bottom)
            $0.height.equalToSuperview().dividedBy(2)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
//        streetView.addSubview(panoView)
//        panoView.snp.makeConstraints {
//          $0.edges.equalTo(UIEdgeInsetsMake(20, 10, 10, 10))
//        }

        
        addSubview(reviewsView)
        reviewsView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(streetView.snp.bottom)
        }
        
        reviewsView.addSubview(reviewsTableView)
        reviewsTableView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(10, 20, 20, 20))
        }

    }
    
    
}
