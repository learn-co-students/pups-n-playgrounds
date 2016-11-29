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

class UserProfileViewController: UIViewController {
    
    // MARK: Properties
    var userProfileView: UserProfileView!
    var userProfileImage: UIImage!
    var imagePicker: UIImagePickerController!
    var imagePickerView: ImagePickerView!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userProfileView = UserProfileView()
        userProfileView.profileButton.addTarget(self, action: #selector(profileButtonTouched), for: .touchUpInside)
        userProfileView.reviewsTableView.delegate = self
        userProfileView.reviewsTableView.dataSource = self
        userProfileView.reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        view.addSubview(userProfileView)
        userProfileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        
        guard let user = FIRAuth.auth()?.currentUser else { return }
        let userRef = FIRDatabase.database().reference().child("users").child(user.uid)
        
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String : String] else { return }
            guard let firstName = value["firstName"],
                let lastName = value["lastName"] else { return }
            self.userProfileView.userNameLabel.text = "\(firstName) \(lastName)"
        })
        
        guard let photoURL = user.photoURL else { userProfileView.profileButton.setTitle("Add\nphoto", for: .normal); return }
        //    profileView.profileButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
    }
    
    // MARK: Action Methods
    func profileButtonTouched() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func captureButtonTouched() {
        imagePicker.takePicture()
    }
}

// MARK: UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userProfileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        userProfileView.profileButton.setImage(userProfileImage, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate and UITableViewDataSource
extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
        
        cell.textLabel?.text = "Test Location \(indexPath.row + 1)"
        cell.textLabel?.textColor = UIColor.themeWhite
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
}






