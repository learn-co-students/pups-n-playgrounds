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

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    var blueGradient: CAGradientLayer!

    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTouched))
        
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
                
                if currentUserID != currentReview.userID {
                    cell.deleteReviewButton.isHidden = true
                    
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




