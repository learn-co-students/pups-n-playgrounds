//
//  LocationProfileViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase


class LocationProfileViewController: UIViewController {
    
    var playground: Playground?
    var locationProfileView: LocationProfileView!
    var reviewsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrappedPlayground = playground else { return }
        
        
        
        self.locationProfileView = LocationProfileView(playground: unwrappedPlayground)
        self.view = self.locationProfileView
        
        self.locationProfileView.submitReviewButton.addTarget(self, action: #selector(writeReview), for: .touchUpInside)
        
        print("THIS PLAYGROUND HAS \(unwrappedPlayground.reviews.count) REVIEWS")
        navigationItem.title = "Location"
        navigationController?.isNavigationBarHidden = false
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func writeReview() {
        setup()
    }
    
    // MARK: Setup ReviewVC Child
    func setup() {
        print("CLICKED REVIEW BUTTON")
        let childVC = ReviewViewController()
        childVC.location = playground

        addChildViewController(childVC)
        
        view.addSubview(childVC.view)
        childVC.view.snp.makeConstraints {
            childVC.centerConstraint = $0.center.equalToSuperview().constraint
            childVC.widthHeightConstraint = $0.width.height.equalToSuperview().dividedBy(1.5).constraint
        }
        childVC.didMove(toParentViewController: self)
        
        view.layoutIfNeeded()

    }
}

extension LocationProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let reviews = playground?.reviews {
            return reviews.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewsCell")!
        
        if let review = playground?.reviews[indexPath.row] {
            cell.textLabel?.text = review.comment
            cell.textLabel?.textColor = UIColor.blue
            cell.textLabel?.font = UIFont.themeTinyRegular
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            
        }
        return cell
    }
}
