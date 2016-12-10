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

class ProfileViewController: UIViewController {
    lazy var profileView = ProfileView()
    lazy var imagePicker = UIImagePickerController()
    var currentUser: User?
    var profileImage: UIImage?
    var reviewsArray: [Review?] = []
    
    
    let containerVC = (UIApplication.shared.delegate as? AppDelegate)?.containerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let firebaseUserID = FIRAuth.auth()?.currentUser?.uid else { print("trouble unwrapping user id"); return }
        
        FirebaseData.getUser(with: firebaseUserID) { (currentFirebaseUser) in
            self.currentUser = currentFirebaseUser
            print("user first name is \(self.currentUser?.firstName)")
            self.configure()
            
            if let userReviewsIDs = self.currentUser?.reviewsID {
                for reviewID in userReviewsIDs {
                    guard let unwrappedReviewID = reviewID else { print("trouble unwrapping IDS"); return }
                    
                    FirebaseData.getReview(with: unwrappedReviewID, completion: { (firebaseReview) in
                        
                        self.reviewsArray.append(firebaseReview)
                        print("REVIEWS ARRAY NOW HAS \(self.reviewsArray.count) REVIEWS")
                        self.profileView.reviewsTableView.reloadData()
                    })
                    
                }
            }
            
//            self.retrieveUserPhoto {
//                DispatchQueue.main.async {
//                    
//                    self.view.addSubview(self.profileView)
//                    self.profileView.snp.makeConstraints {
//                        $0.edges.equalToSuperview()
//                    }
//                    
//                }
//            }
        }
        
    }
    
    // MARK: configure app
    
    func configure() {
        guard let firstName = currentUser?.firstName else { print("trouble unwrapping user first name"); return }

        guard let lastName = currentUser?.lastName else { print("trouble unwrapping user last name"); return }
        profileView.userNameLabel.text = "\(firstName) \(lastName)"
        
        let color1 = UIColor(red: 34/255.0, green: 91/255.0, blue: 102/255.0, alpha: 1.0)
        let color2 = UIColor(red: 141/255.0, green: 191/255.9, blue: 103/255.0, alpha: 1.0)
        
        let backgroundGradient = CALayer.makeGradient(firstColor: color1, secondColor: color2)
        
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, at: 0)
        
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTouched))
        
        profileView.profileButton.addTarget(self, action: #selector(profileButtonTouched), for: .touchUpInside)
        
        profileView.reviewsTableView.delegate = self
        profileView.reviewsTableView.dataSource = self
        profileView.reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
    }
    
    // MARK: Retrieve User Information from Firebase
    // TODO: Factor Into FirebaseData File
    private func retrieveUserPhoto(completion: @escaping () -> Void) {
        guard let firebaseUserID = FIRAuth.auth()?.currentUser?.uid else { print("could not fetch firebase userID");return }
        
        let userRef = FIRDatabase.database().reference().child("users").child(firebaseUserID)
        
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let userInfo = snapshot.value as? [String : Any] else { print("could not return snapshot \(snapshot.value)");return }
            
            if let profilePhotoURL = URL(string: userInfo["profilePicURL"] as? String ?? "") {
                URLSession.shared.dataTask(with: profilePhotoURL) { data, response, error in
                    guard let data = data else { print("error unwrapping data"); return }
                    self.profileImage = UIImage(data: data)
                    self.profileView.profileButton.setImage(self.profileImage, for: .normal)
                    }.resume()
            } else {
                self.profileImage = #imageLiteral(resourceName: "AddPhoto")
                self.profileView.profileButton.setImage(self.profileImage, for: .normal)
            }
        })
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
        containerVC?.setup(forAnimation: .slideUp)
    }
}

// MARK: UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profileImage = info[UIImagePickerControllerEditedImage] as? UIImage
        profileView.profileButton.setImage(profileImage, for: .normal)
        
        handleSavingPic()
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate and UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
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
                            self.profileView.reviewsTableView.reloadData()
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
                            self.profileView.reviewsTableView.reloadData()
                        }
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            flag.backgroundColor = UIColor.themeSunshine
            return [flag]
        }
    }
    
    
}

// MARK: Save User Photos to Firebase
extension ProfileViewController {
    func handleSavingPic() {
        guard let user = currentUser else { print("error unrwapping current user"); return }
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profilePics").child("\(imageName).png")
        guard let imageToUpload = profileImage else { print("no image"); return }
        
        if let uploadData = UIImagePNGRepresentation(imageToUpload) {
            storageRef.put(uploadData, metadata: nil) { (metadata, error) in
                if let error = error { print(error); return }
                
                guard let metaDataURL = metadata?.downloadURL()?.absoluteString else { print("no profile image URL"); return }
                
                FIRDatabase.database().reference().child("users").child(user.userID).updateChildValues(["profilePicURL" : metaDataURL])
            }
        }
    }
}






