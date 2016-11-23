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
  
  // MARK: Properties
  var storageRef: FIRStorageReference!
  var profileView: ProfileView!
  var profileImage: UIImage!
  var imagePicker: UIImagePickerController!
  var imagePickerView: ImagePickerView!
  var currentUser: FIRUser!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    storageRef = FIRStorage.storage().reference()
    
    navigationItem.title = "Profile"
    navigationController?.isNavigationBarHidden = false
    
    profileView = ProfileView()
    profileView.profileButton.addTarget(self, action: #selector(profileButtonTouched), for: .touchUpInside)
    
    view = profileView
    
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
    
    if let currentUser = FIRAuth.auth()?.currentUser {
      
      self.currentUser = currentUser
      
    } else {
      
      print("error retrieving current user"); return
      
    }
    
    profileView.userNameLabel.text = currentUser.displayName
    
    guard let photoURL = currentUser.photoURL else { profileView.profileButton.setTitle("Add\nphoto", for: .normal); return }
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
    let profileImagePNG = UIImagePNGRepresentation(profileImage)
    
    let profileImageRef = storageRef.child("images").child("userImages").child("\(currentUser.uid)").setValuesForKeys(["profileImage" : profileImagePNG])
  
    profileView.profileButton.setImage(profileImage, for: .normal)
    
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    
    dismiss(animated: true, completion: nil)
  }
}

