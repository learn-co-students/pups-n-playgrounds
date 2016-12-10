//
//  ProfileViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    
    // MARK: Properties
    var currentUser: User?
    var userReviews: [Review?] = []
    var userProfileView: ProfileView!
    var profileImage: UIImage!
    var imagePicker: UIImagePickerController!
    var imagePickerView: ImagePickerView!
    var settingsDropDownView: SettingsDropDownView!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let firebaseUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FirebaseData.getUser(with: firebaseUserID) { (currentFBUser) in
            
            self.currentUser = currentFBUser
            self.configure()
            
        }
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.showsCameraControls = false
            imagePicker.allowsEditing = false
            
            imagePickerView = ImagePickerView()
            imagePickerView.captureButton.addTarget(self, action: #selector(captureButtonTouched), for: .touchUpInside)
            
            imagePicker.view.addSubview(imagePickerView)
            imagePickerView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    func configure() {
        guard let unwrappedCurrentUser = currentUser else { return }
        userProfileView = ProfileView(user: unwrappedCurrentUser)
        
        self.userProfileView.reviewsTableView.delegate = self
        self.userProfileView.reviewsTableView.dataSource = self
        self.userProfileView.reviewsTableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: "reviewCell")
        
        self.view.addSubview(userProfileView)
        userProfileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.userProfileView.profileButton.addTarget(self, action: #selector(self.profileButtonTouched), for: .touchUpInside)
        
        
        if let userReviewIDs = currentUser?.reviewsID {
            
            for reviewID in userReviewIDs {
                guard let reviewIDUnwrapped = reviewID else { return }
                FirebaseData.getReview(with: reviewIDUnwrapped, completion: { (FirebaseReview) in
                    self.userReviews.append(FirebaseReview)
                    
                    self.userProfileView.reviewsTableView.reloadData()
                    
                })
            }
        }
        
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings"), style: .plain, target: self, action: #selector(onSettingsButtonTap))
        
        settingsDropDownView = SettingsDropDownView()
        self.view.addSubview(settingsDropDownView)
        settingsDropDownView.snp.makeConstraints {
            $0.height.width.equalToSuperview().multipliedBy(0.3)
        }
        
        settingsDropDownView.settingsDropDownStackView.isHidden = true
        settingsDropDownView.changePasswordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        settingsDropDownView.logoutButton.addTarget(self, action: #selector(logOutButtonTouched), for: .touchUpInside)
        settingsDropDownView.contactPPButton.addTarget(self, action: #selector(contactPP), for: .touchUpInside)
        
    }
    
    
    func onSettingsButtonTap() {
        
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
    
    
    
    func contactPP() {
        
        guard (FIRAuth.auth()?.currentUser?.uid) != nil else { return }
        
        let alert = UIAlertController(title: "Feedback for P&P?", message: "Type your comments or questions here!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (reviewTextField) in
            reviewTextField.text = "" }
        
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            
            FirebaseData.sendFeedbackToPP(with: reviewTextField.text!)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        self.settingsDropDownView.settingsDropDownStackView.isHidden = true
        
    }
    
    /*
     guard let user = FIRAuth.auth()?.currentUser else { return }
     let userRef = FIRDatabase.database().reference().child("users").child(user.uid)
     
     userRef.observeSingleEvent(of: .value, with: { snapshot in
     guard let value = snapshot.value as? [String : String] else { return }
     guard let firstName = value["firstName"],
     let lastName = value["lastName"] else { return }
     self.profileView.userNameLabel.text = "\(firstName) \(lastName)"
     })
     
     guard let photoURL = user.photoURL else { profileView.profileButton.setTitle("Add\nphoto", for: .normal); return }
     guard let photoData = try? Data(contentsOf: photoURL) else { print("error retrieving image data"); return }
     
     profileView.profileButton.setImage(UIImage(data: photoData), for: .normal)
     */
    
    
    
    // MARK: Action Methods
    func profileButtonTouched() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func captureButtonTouched() {
        imagePicker.takePicture()
    }
    
    func logOutButtonTouched() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            print("error signing user out")
        }
        
        appDelegate?.window?.rootViewController = LoginViewController()
    }
}

// MARK: UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        userProfileView.profileButton.setImage(profileImage, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate and UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userReviews.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewsTableViewCell
        
        if let currentReview = userReviews[indexPath.row] {
            cell.review = currentReview
            
            if let currentUserID = currentUser?.userID {
                if currentReview.userID == currentUserID {
                    cell.deleteReviewButton.isHidden = false
                }
            }
            
            
        }
        return cell
    }
}

// MARK: Firebase Storage Methods

extension ProfileViewController {
    
    func handleSavingPic() {
        
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        let userRef = FIRDatabase.database().reference().child("users").child(currentUser)
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profilePics").child("\(imageName).png")
        guard let imageToUpload = profileImage else { print("no image"); return }
        
        if let uploadData = UIImagePNGRepresentation(imageToUpload) {
            
            storageRef.put(uploadData, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    print(error ?? String())
                    return
                }
                
                guard let metaDataURL = metadata?.downloadURL()?.absoluteString else { print("no profile image URL"); return }
                
                userRef.updateChildValues(["profilePicURL": metaDataURL])
                
            }
            
        }
        
    }
    
    
}




