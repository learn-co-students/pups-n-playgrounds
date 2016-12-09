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
    //var dogrunProfileImage: UIImageView!
    var isDogRunIcon: UIImageView!
    var isOffLeashIcon: UIImageView!
    var dogStreetView: UIView!
    var dogPanoView: GMSPanoramaView!
    var dogDetailView: UIView!
    var dogRunNameLabel: UILabel!
    var dogRunAddressLabel: UILabel!
    var dogNotesView: UIView!
    var dogNotesLabel: UILabel!
    var dogReviewView: UIView!
    var dogReviewTableView: UITableView!
    var submitReviewButton: UIButton!
    var starReviews: StarReview!
    var rating: String?
   
    var scrollView: UIScrollView!
    var currentUser: User?
    var dogReviewsArray: [Review?] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(dogrun: Dogrun) {
        self.init(frame: CGRect.zero)
        location = dogrun
        
        // TODO: call configure() to configure view here
        //TODO:  call constrain() to constrain view objects here
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func configure() {
        
        //TODO:  call calculate average star for location here
        
        
        backgroundColor = UIColor.themeWhite
        
        //configure dogStreetView & dogPanoView
        dogStreetView = UIView()
        dogPanoView = GMSPanoramaView()
        dogPanoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        dogPanoView.layer.cornerRadius = 5
        
        //configure dogDetailView 
        dogDetailView = UIView()
        
        
        //configure dogRunNameLabel
        dogRunNameLabel = UILabel()
        dogRunNameLabel.font = UIFont.themeMediumThin
        dogRunNameLabel.textColor = UIColor.themeDarkBlue
        dogRunNameLabel.adjustsFontSizeToFitWidth = true
        dogRunNameLabel.numberOfLines = 2
        dogRunNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        // configure dogRunAddressLabel
        dogRunAddressLabel = UILabel()
        dogRunAddressLabel.font = UIFont.themeMediumLight
        dogRunAddressLabel.textColor = UIColor.themeDarkBlue
        dogRunAddressLabel.adjustsFontSizeToFitWidth = true
        dogRunAddressLabel.numberOfLines = 3
        dogRunAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        //configure dogNotesView 
        dogNotesView = UIView()
        
        //configure dogNotesLabel
        dogNotesLabel = UILabel()
        
        
        //configure dogReviewView 
        dogReviewView = UIView()
        
        
        // TODO: Add dogRun icons
        //if dogrun.isOffLeash = true
        // display dogRun.offLeash icon
        // else //
        // display dogRun.Run icon
    
        
        //configure reviews view
         dogReviewView = UIView()
        
        //configure reviews tableview
        dogReviewTableView = UITableView()
        dogReviewTableView .rowHeight = 40
        dogReviewTableView .backgroundColor = UIColor.themeLightBlue
        dogReviewTableView .layer.cornerRadius = 5
        
        //configure submitReviewButton
        submitReviewButton = UIButton(frame: CGRect(x: 0, y: 0, width:700 , height: 120))
        submitReviewButton.setTitle("Submit a Review", for: .normal)
        submitReviewButton.layer.cornerRadius = 2
        submitReviewButton.titleLabel?.font = UIFont.themeSmallThin
        submitReviewButton.backgroundColor = UIColor.themeRed
        submitReviewButton.setTitleColor(UIColor.themeWhite, for: .normal)
        
        
        
        
        //configure() function finished
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
            $0.height.equalTo(streetView.snp.width).multipliedBy(0.6)
        }
        
        dogStreetView.addSubview(dogPanoView)
        dogPanoView.snp.makeConstraints {
            $0.edges.equalToSuperview() 
            
        }
        
    
        
        
        
      
      
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // constrain() function finsihed
    }
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
