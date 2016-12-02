//
//  LocationProfileViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit


class LocationProfileViewController: UIViewController {
    var playground: Playground?
    var locationProfileView: LocationProfileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Location"
        
        locationProfileView = LocationProfileView(playground: playground!)
        locationProfileView.reviewsTableView.delegate = self
        locationProfileView.reviewsTableView.dataSource = self
        locationProfileView.reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "reviewsCell")
        
        view.addSubview(locationProfileView)
        locationProfileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        locationProfileView.submitReviewButton.addTarget(self, action: #selector(submitReviewAlert), for: .touchUpInside)
        
        FirebaseData.deleteCommentAdmin(userID: "myibiCF6axgoobzMBwCsvo7iyWv1", reviewID: "-KXxU7NYhFLuybiv42ug", locationID: "PG--KXwqRAMLn49jy5zJC-c", completion: {
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitReviewAlert() {
        
        guard let location = locationProfileView.location else { return }
        let name = location.name
        
        let alert = UIAlertController(title: "\(name)", message: "Type your review here!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (reviewTextField) in
            reviewTextField.text = "" }
        
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            
            FirebaseData.addReview(comment: reviewTextField.text!, locationID: location.playgroundID, tableView: self.locationProfileView.reviewsTableView)
            
        }))
        self.present(alert, animated: true, completion: nil)
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
