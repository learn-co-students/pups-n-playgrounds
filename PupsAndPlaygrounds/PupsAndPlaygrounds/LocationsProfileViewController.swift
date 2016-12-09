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
    var currentUser: User?
    var reviewsArray: [Review?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configure()
        
        guard let firebaseUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        FirebaseData.getUser(with: firebaseUserID) { (currentFirebaseUser) in
            self.currentUser = currentFirebaseUser
        }
        
        if FIRAuth.auth()?.currentUser?.isAnonymous == false {
            self.locationProfileView.submitReviewButton.addTarget(self, action: #selector(writeReview), for: .touchUpInside)
        }
        
        if let playgroundReviewsIDs = playground?.reviewsID {
            
            for reviewID in playgroundReviewsIDs {
                guard let unwrappedReviewID = reviewID else { return }
                
                FirebaseData.getReview(with: unwrappedReviewID, completion: { (firebaseReview) in
                    
                    self.reviewsArray.append(firebaseReview)
                    
                    print("REVIEWS ARRAY NOW HAS \(self.reviewsArray.count) REVIEWS")
                    self.locationProfileView.reviewsTableView.reloadData()
                    
                })
                
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: Setup ReviewVC Child
    func writeReview() {
        navigationController?.navigationBar.isUserInteractionEnabled = false
        tabBarController?.tabBar.isUserInteractionEnabled = false
        
        print("CLICKED REVIEW BUTTON")
        let childVC = ReviewViewController()
        childVC.location = playground
        
        addChildViewController(childVC)
        
        view.addSubview(childVC.view)
        childVC.view.snp.makeConstraints {
            childVC.edgesConstraint = $0.edges.equalToSuperview().constraint
        }
        childVC.didMove(toParentViewController: self)
        
        view.layoutIfNeeded()
    }
    
    func configure() {
        guard let unwrappedPlayground = playground else { return }
        self.locationProfileView = LocationProfileView(playground: unwrappedPlayground)
        
        let color1 = UIColor(red: 34/255.0, green: 91/255.0, blue: 102/255.0, alpha: 1.0)
        let color2 = UIColor(red: 141/255.0, green: 191/255.9, blue: 103/255.0, alpha: 1.0)
        
        let backgroundGradient = CALayer.makeGradient(firstColor: color1, secondColor: color2)
        
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, at: 0)
        
        
        reviewsTableView = locationProfileView.reviewsTableView
        locationProfileView.reviewsTableView.delegate = self
        locationProfileView.reviewsTableView.dataSource = self
        locationProfileView.reviewsTableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: "reviewCell")
        locationProfileView.reviewsView.alpha = 0.6
        
        self.view.addSubview(locationProfileView)
        locationProfileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    func flagButtonTouched(sender: UIButton) {
        let cellContent = sender.superview!
        let cell = cellContent.superview! as! UITableViewCell
        let indexPath = locationProfileView.reviewsTableView.indexPath(for: cell)
        
        if let flaggedReview = reviewsArray[(indexPath?.row)!] {
            
            FirebaseData.flagReviewWith(unique: flaggedReview.reviewID, locationID: flaggedReview.locationID, comment: flaggedReview.comment, userID: flaggedReview.userID) {
                let alert = UIAlertController(title: "Success!", message: "You have flagged this comment for review", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    FirebaseData.getVisibleReviewsForFeed { reviews in
                        self.reviewsArray = reviews
                        self.locationProfileView.reviewsTableView.reloadData()
                    }
                })
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension LocationProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewsTableViewCell
        
        if let currentReview = reviewsArray[indexPath.row] {
            cell.review = currentReview
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let userID = reviewsArray[indexPath.row]?.userID else { print("trouble casting userID");return [] }
        guard let reviewID = reviewsArray[indexPath.row]?.reviewID else { print("trouble casting reviewID");return [] }
        guard let locationID = reviewsArray[indexPath.row]?.locationID else { print("trouble casting locationID");return [] }
        guard let reviewComment = reviewsArray[indexPath.row]?.comment else { print("trouble casting reviewComment"); return [] }
        
        
        if userID == currentUser?.userID {
            
            
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in

                self.reviewsArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                FirebaseData.deleteUsersOwnReview(userID: userID, reviewID: reviewID, locationID: locationID) {
                    
                    let alert = UIAlertController(title: "Success!", message: "You have flagged this comment for review", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                        FirebaseData.getVisibleReviewsForFeed { reviews in
                            self.reviewsArray = reviews
                            self.locationProfileView.reviewsTableView.reloadData()
                        }
                    })
                }
            }
            return [delete]
            
        } else {
            
            let flag = UITableViewRowAction(style: .destructive, title: "Flag") { (action, indexPath) in
                
                self.reviewsArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                FirebaseData.flagReviewWith(unique: reviewID, locationID: locationID, comment: reviewComment, userID: userID) {
                    let alert = UIAlertController(title: "Success!", message: "You have flagged this comment for review", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                        FirebaseData.getVisibleReviewsForFeed { reviews in
                            self.reviewsArray = reviews
                            self.locationProfileView.reviewsTableView.reloadData()
                        }
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            flag.backgroundColor = UIColor.yellow
            return [flag]
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
}
