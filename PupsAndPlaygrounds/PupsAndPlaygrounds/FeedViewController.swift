//
//  FeedViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class FeedViewController: UIViewController {
  
  // MARK: Properties
  let listView = ListView()
  var locations = [Location]()
  var feedView = FeedView()
  var reviews = [Review]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Live Feed"
    
    print("reviews count: \(reviews.count)")
    feedView.feedTableView.delegate = self
    feedView.feedTableView.dataSource = self
    feedView.feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
    
    view.addSubview(feedView)
    feedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    FirebaseData.getVisibleReviewsForFeed { (reviews) in
      self.reviews = reviews
      self.feedView.feedTableView.reloadData()
      print("reviews count: \(reviews.count)")
    }
    
    print("reviews count: \(reviews.count)")
  }
  
  func flagButtonTouched(sender: UIButton) {
    let cellContent = sender.superview!
    let cell = cellContent.superview! as! UITableViewCell
    let indexPath = feedView.feedTableView.indexPath(for: cell)
    
    let flaggedReview = reviews[(indexPath?.row)!]
    
    FirebaseData.flagReviewWith(unique: flaggedReview.reviewID, locationID: flaggedReview.locationID, comment: flaggedReview.comment, userID: flaggedReview.userID) {
      let alert = UIAlertController(title: "Success!", message: "You have flagged this comment for review", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
        FirebaseData.getVisibleReviewsForFeed { reviews in
          self.reviews = reviews
          self.feedView.feedTableView.reloadData()
        }
      })
      
      self.present(alert, animated: true, completion: nil)
    }
  }
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
    cell.titleLabel.text = reviews[indexPath.row].comment
    cell.flagButton.addTarget(self, action: #selector(flagButtonTouched), for: .touchUpInside)
    
    return cell
  }
}
