//
//  LocationsProfileView.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class LocationsProfileView: UIView {
    
    var nameLabel: UILabel!
    var locationLabel: UILabel!
    var handicapLabel: UILabel!
    //  var ratingLabel: UILabel!
    //  var reviewsTableView: UITableView!
    var reviewTextField: UITextField!
    var ratingTextField: UITextField!
    var addReviewButton: UIButton!
    
    // inevitably the argument will be from Firebase and not the local LocationsDataStore
    convenience init(location: Location) {
        self.init(frame: CGRect.zero)
        configure(location: location)
        constrain()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(location: Location) {
        backgroundColor = UIColor.themeLightBlue
        
        nameLabel = UILabel()
        locationLabel = UILabel()
        handicapLabel = UILabel()
        
        nameLabel.text = location.name
        locationLabel.text = location.location
        if location.isHandicap == true {
            handicapLabel.text = "Is accessible"
        }else {
            self.handicapLabel.text = "Is not accessible"
        }
        
        
        
    }
    
    
    func constrain() {
        
    }
    
}
