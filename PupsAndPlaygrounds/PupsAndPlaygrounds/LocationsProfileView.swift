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
    
    var nameField: UILabel!
    var locationField: UILabel!
    var ratingField: UILabel!
    //  var reviewsTableView: UITableView!
    var addReviewButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(location: Location) {
        self.init(frame: CGRect.zero)
        configure(location: location)
        constrain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    func configure(location: Location) {
        backgroundColor = UIColor.themeLightBlue

        nameField = UILabel()
        nameField.text = location.name
        locationField.text = location.location

        
    }
    
    func constrain() {
        
    }
    
}
