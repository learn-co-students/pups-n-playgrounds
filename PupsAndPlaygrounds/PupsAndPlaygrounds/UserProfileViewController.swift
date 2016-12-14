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
    var userReviews = [Review?]()
    var settingsDropDownView: SettingsDropDownView!
    
    let containerVC = (UIApplication.shared.delegate as? AppDelegate)?.containerViewController
    let store = DataStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedUserReviewIDs = store.user?.reviewIDs {
            for reviewID in unwrappedUserReviewIDs {
                FIRClient.getReview(with: reviewID, completion: { (firebaseReview) in
                    self.userReviews.append(firebaseReview)
                    self.userProfileView.reviewsTableView.reloadData()
                })
            }
        }
        
        configure()
        constrain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userProfileView.reviewsTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        userProfileView.layer.sublayers?.first?.frame = userProfileView.bounds
        userProfileView.profileButton.layer.cornerRadius = userProfileView.profileButton.frame.width / 2
    }
    
    // MARK: Setup
    private func configure() {
        settingsDropDownView = SettingsDropDownView()

        settingsDropDownView.settingsDropDownStackView.isHidden = true
        settingsDropDownView.changePasswordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        settingsDropDownView.logoutButton.addTarget(self, action: #selector(logOutButtonTouched), for: .touchUpInside)
        settingsDropDownView.contactPPButton.addTarget(self, action: #selector(contactPP), for: .touchUpInside)
        
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(onSettingsButtonTap))
        
        
        userProfileView.profileButton.addTarget(self, action: #selector(profileButtonTouched), for: .touchUpInside)
        
        userProfileView.reviewsTableView.delegate = self
        userProfileView.reviewsTableView.dataSource = self
        userProfileView.reviewsTableView.register(UserReviewTableViewCell.self, forCellReuseIdentifier: "userReviewCell")
        userProfileView.reviewsTableView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishedSaving), name: Notification.Name("savedProfilePhoto"), object: nil)
    }
    
    private func constrain() {
        view.addSubview(userProfileView)
        userProfileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        view.addSubview(settingsDropDownView)
        settingsDropDownView.snp.makeConstraints {
            $0.height.width.equalToSuperview().multipliedBy(0.3)
        }
        view.layoutIfNeeded()
    }
    // MARK: Change Password
    
    func onSettingsButtonTap() {
        print("BUTTON TAPPED")
        UIView.animate(withDuration: 0.3) {
            self.settingsDropDownView.settingsDropDownStackView.isHidden = false
        }
    }
    
    func changePassword() {
        let alertController = UIAlertController(title: "Enter E-Mail", message: "We'll send you a password reset e-mail", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Send", style: .default) { (action) in
            let emailField = alertController.textFields![0]
            if let email = emailField.text {
                
                FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                    // Handle error
                    if let error = error {
                        
                        let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        // Success
                    } else {
                        let alertController = UIAlertController(title: "Success", message: "Password reset e-mail sent", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter E-mail"
        }
        
        self.present(alertController, animated: true, completion: nil)
        self.settingsDropDownView.settingsDropDownStackView.isHidden = true
    }
    
    // MARK: Contact App
    
    func contactPP() {
        
        guard (FIRAuth.auth()?.currentUser?.uid) != nil else { return }
        
        let alert = UIAlertController(title: "Feedback for P&P?", message: "Type your comments or questions here!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (reviewTextField) in
            reviewTextField.text = "" }
        
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            
            FIRClient.sendFeedbackToPP(with: reviewTextField.text!)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        self.settingsDropDownView.settingsDropDownStackView.isHidden = true
        
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
        let alert = UIAlertController(title: "Update Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraRoll = UIAlertAction(title: "Camera roll", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraRoll)
        alert.addAction(takePhoto)
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

        return userReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userReviewCell", for: indexPath) as? UserReviewTableViewCell else {
            print("error unwrapping cell in user review table view")
            return UITableViewCell()
        }
        
        cell.review = userReviews[indexPath.row]
        
        if let locationID = userReviews[indexPath.row]?.locationID {
            FIRClient.getLocation(with: locationID) {
                cell.locationNameLabel.text = $0?.name
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let userID = userReviews[indexPath.row]?.userID else { print("trouble casting userID");return [] }
        guard let reviewID = userReviews[indexPath.row]?.reviewID else { print("trouble casting reviewID");return [] }
        guard let locationID = userReviews[indexPath.row]?.locationID else { print("trouble casting locationID");return [] }
        guard let reviewComment = userReviews[indexPath.row]?.comment else { print("trouble casting reviewComment"); return [] }

        
        if userID == store.user?.uid {
            
            
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                
                self.userReviews.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                FIRClient.deleteReview(userID: userID, reviewID: reviewID, locationID: locationID) {
                    
                    let alert = UIAlertController(title: "Success!", message: "You have flagged this comment for review", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                        FIRClient.getVisibleReviews { reviews in
                            self.userReviews = reviews
                            self.userProfileView.reviewsTableView.reloadData()
                        }
                    })
                }
            }
            delete.backgroundColor = UIColor.themeCoral
            return [delete]
            
        } else {
            
            let flag = UITableViewRowAction(style: .destructive, title: "Flag") { (action, indexPath) in
                
                self.userReviews.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                FIRClient.flagReviewWith(unique: reviewID, locationID: locationID, comment: reviewComment, userID: userID) {
                    let alert = UIAlertController(title: "Success!", message: "You have flagged this comment for review", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                        FIRClient.getVisibleReviews { reviews in
                            self.userReviews = reviews
                            self.userProfileView.reviewsTableView.reloadData()
                        }
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            flag.backgroundColor = UIColor.themeSunshine
            return [flag]
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }}






