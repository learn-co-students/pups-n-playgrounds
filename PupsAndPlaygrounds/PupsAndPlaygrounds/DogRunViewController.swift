//
//  DogRunViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Missy Allan on 12/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import GoogleMaps

class DogRunViewController: UIViewController, GMSMapViewDelegate {

    
    var dogrun: Dogrun
    var dogRunProfileView: DogRunViewController!
    var dogReviewTableView: UITableView!
    var currentUser: User?
    var dogReviewsArray: [Review?] = []
    
   var location: Dogrun!
    var dogRunProfileImage: UIImageView!
    var dogRunNameLabel: UILabel!
    var dogRunAddressLabel: UILabel!
    var submitReviewButton: UIButton!
    var reviewsView: UIView!
    var reviewsTableView: UIView!
    var dogStreetView: UIView!
    var dogPanoView: GMSPanoramaView!
    var starReviews: StarReview!
    var rating: String?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(dogrun: Dogrun) {
        self.init(frame: CGRect.zero)
        location = dogrun
        
        //call configure() to configure view here 
        // call constrain() to constrain view objects here
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        // call calculate average star for location here 
        
        backgroundColor = UIColor.themeLightBlue
        
        //configure dogRunProfileImage 
        
        dogRunProfileImage = UIImageView()
        
        
        //configure dogRunNameLabel 
        dogRunNameLabel = UILabel()
        dogRunNameLabel.font = UIFont.themeMediumThin
        dogRunNameLabel.textColor = UIColor.themeWhite
        dogRunNameLabel.adjustsFontSizeToFitWidth = true
        dogRunNameLabel.numberOfLines = 2
        dogRunNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        

    
        // configure dogRunAddressLabel 
        
        dogRunAddressLabel = UILabel()
        dogRunAddressLabel.font = UIFont.themeMediumLight
        dogRunAddressLabel.textColor = UIColor.themeWhite
        dogRunAddressLabel.adjustsFontSizeToFitWidth = true
        dogRunAddressLabel.numberOfLines = 3
        dogRunAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //
        
        
        //configure dogRunTypeIcon 
        
        //if dogrun.isOffLeash = true 
          // display dogRun.offLeash icon 
        // else // 
            // display dogRun.Run icon 
        
        
        // 
        
        
        
        
    
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    


   

}
