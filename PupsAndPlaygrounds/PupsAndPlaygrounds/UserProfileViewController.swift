//
//  UserProfileViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class UserProfileViewController: UIViewController {
  
  // MARK: Properties
  lazy var userProfileView = UserProfileView()
  lazy var imagePicker = UIImagePickerController()
  
  let containerVC = (UIApplication.shared.delegate as? AppDelegate)?.containerViewController
  let store = WSRDataStore.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    constrain()
  }
  
  override func viewDidLayoutSubviews() {
    userProfileView.layer.sublayers?.first?.frame = userProfileView.bounds
    userProfileView.profileButton.layer.cornerRadius = userProfileView.profileButton.frame.width / 2
  }
  
  // MARK: Setup
  private func configure() {
    navigationItem.title = "Profile"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTouched))
    
    userProfileView.profileButton.addTarget(self, action: #selector(profileButtonTouched), for: .touchUpInside)
    
    userProfileView.reviewsTableView.delegate = self
    userProfileView.reviewsTableView.dataSource = self
    userProfileView.reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
    
    NotificationCenter.default.addObserver(self, selector: #selector(finishedSaving), name: Notification.Name("savedProfilePhoto"), object: nil)
  }
  
  private func constrain() {
    view.addSubview(userProfileView)
    userProfileView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    view.layoutIfNeeded()
  }
  
  // MARK: Display User Information
  func displayUserInfo() {
    DispatchQueue.main.async {
      if let profilePhoto = self.store.user?.profilePhoto {
        self.userProfileView.profileButton.setImage(profilePhoto, for: .normal)
      } else {
        self.userProfileView.profileButton.setImage(#imageLiteral(resourceName: "AddPhoto"), for: .normal)
      }
      
      if let firstName = self.store.user?.firstName, let lastName = self.store.user?.lastName {
        self.userProfileView.userNameLabel.text = "\(firstName) \(lastName)"
      }
      
      self.view.layoutIfNeeded()
    }
  }
  
  // MARK: Display User Reviews
  func displayUserReviews() {
    DispatchQueue.main.async {
      self.userProfileView.reviewsTableView.reloadData()
    }
  }
  
  // MARK: Photo Saved Successfully
  func finishedSaving() {
    DispatchQueue.main.async {
      self.userProfileView.savingView.isHidden = true
      self.userProfileView.savingActivityIndicator.stopAnimating()
    }
  }
  
  // MARK: Action Methods
  func profileButtonTouched() {
    let alert = UIAlertController(title: "Update Profile Photo", message: nil, preferredStyle: .alert)
    
    let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        self.imagePicker.cameraCaptureMode = .photo
        self.imagePicker.allowsEditing = true
        
        self.present(self.imagePicker, animated: true, completion: nil)
      }
    }
    
    let cameraRoll = UIAlertAction(title: "Camera roll", style: .default) { _ in
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        
        self.present(self.imagePicker, animated: true, completion: nil)
      }
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alert.addAction(takePhoto)
    alert.addAction(cameraRoll)
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
  }
  
  func logOutButtonTouched() {
    do {
      try FIRAuth.auth()?.signOut()
    } catch {
      print("error signing user out")
    }
    
    containerVC?.childVC = LoginViewController()
    containerVC?.childVC?.view.layoutIfNeeded()
    containerVC?.setup(forAnimation: .slideUp)
  }
}

// MARK: UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    store.user?.profilePhoto = info[UIImagePickerControllerEditedImage] as? UIImage
    
    if let profilePhoto = store.user?.profilePhoto {
      userProfileView.profileButton.setImage(profilePhoto, for: .normal)
    }
    
    userProfileView.savingActivityIndicator.startAnimating()
    userProfileView.savingView.isHidden = false
    
    self.dismiss(animated: true, completion: nil)
    
    FIRClient.saveProfilePhoto {
      NotificationCenter.default.post(name: Notification.Name("savedProfilePhoto"), object: nil)
    }
  }
}

// MARK: UITableViewDelegate and UITableViewDataSource
extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return store.userReviews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewsTableViewCell
    cell.review = store.userReviews[indexPath.row]
    
    return cell
  }
  
  //  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
  //
  //    guard let userID = reviewsArray[indexPath.row]?.userID else { print("trouble casting userID");return [] }
  //    guard let reviewID = reviewsArray[indexPath.row]?.reviewID else { print("trouble casting reviewID");return [] }
  //    guard let locationID = reviewsArray[indexPath.row]?.locationID else { print("trouble casting locationID");return [] }
  //    guard let reviewComment = reviewsArray[indexPath.row]?.comment else { print("trouble casting reviewComment"); return [] }
  //
  //
  //    if userID == currentUser?.userID {
  //
  //
  //      let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
  //
  //        self.reviewsArray.remove(at: indexPath.row)
  //        tableView.deleteRows(at: [indexPath], with: .fade)
  //
  //        FirebaseData.deleteUsersOwnReview(userID: userID, reviewID: reviewID, locationID: locationID) {
  //
  //          let alert = UIAlertController(title: "Success!", message: "You have flagged this comment for review", preferredStyle: .alert)
  //          alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
  //            FirebaseData.getVisibleReviewsForFeed { reviews in
  //              self.reviewsArray = reviews
  //              self.userProfileView.reviewsTableView.reloadData()
  //            }
  //          })
  //        }
  //      }
  //      delete.backgroundColor = UIColor.themeCoral
  //      return [delete]
  //
  //    } else {
  //
  //      let flag = UITableViewRowAction(style: .destructive, title: "Flag") { (action, indexPath) in
  //
  //        self.reviewsArray.remove(at: indexPath.row)
  //        tableView.deleteRows(at: [indexPath], with: .fade)
  //
  //        FirebaseData.flagReviewWith(unique: reviewID, locationID: locationID, comment: reviewComment, userID: userID) {
  //          let alert = UIAlertController(title: "Success!", message: "You have flagged this comment for review", preferredStyle: .alert)
  //          alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
  //            FirebaseData.getVisibleReviewsForFeed { reviews in
  //              self.reviewsArray = reviews
  //              self.userProfileView.reviewsTableView.reloadData()
  //            }
  //          })
  //
  //          self.present(alert, animated: true, completion: nil)
  //        }
  //      }
  //      flag.backgroundColor = UIColor.themeSunshine
  //      return [flag]
  //    }
  //  }
  
  
}





