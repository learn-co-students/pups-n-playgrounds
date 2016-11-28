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
  
    let store = LocationsDataStore.sharedInstance
    
  // MARK: Properties
  var profileView: ProfileView!
  var profileImage: UIImage!
//  var imagePicker: UIImagePickerController!
//  var imagePickerView: ImagePickerView!
  var user: FIRUser!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Profile"
    navigationController?.isNavigationBarHidden = false
    
    profileView = ProfileView()
//    profileView.profileButton.addTarget(self, action: #selector(profileButtonTouched), for: .touchUpInside)
    
    view = profileView
    profileView.locationButton.addTarget(self, action: #selector(locationButtonTouched), for: .touchUpInside)
//    imagePicker = UIImagePickerController()
//    imagePicker.delegate = self
//    imagePicker.sourceType = .camera
//    imagePicker.cameraCaptureMode = .photo
//    imagePicker.showsCameraControls = false
//    imagePicker.allowsEditing = false
//    
//    imagePickerView = ImagePickerView()
//    imagePickerView.captureButton.addTarget(self, action: #selector(captureButtonTouched), for: .touchUpInside)
//    
//    imagePicker.view.addSubview(imagePickerView)
//    imagePickerView.snp.makeConstraints {
//      
//      $0.edges.equalToSuperview()
//    }
    
    guard let user = FIRAuth.auth()?.currentUser else { print("error retrieving current user"); return }
    profileView.userNameLabel.text = user.displayName
    
//    guard let photoURL = user.photoURL else { profileView.profileButton.setTitle("Add\nphoto", for: .normal); return }
    //    profileView.profileButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
  }
  
    func locationButtonTouched() {
        let locationsTableViewController = TestFirebaseTableViewController()
        self.navigationController?.pushViewController(locationsTableViewController, animated: true)
    }
    
  // MARK: Action Methods
//  func profileButtonTouched() {
//    present(imagePicker, animated: true, completion: nil)
//  }
//  
//  func captureButtonTouched() {
//    imagePicker.takePicture()
//  }
}

//extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//    profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//    profileView.profileButton.setImage(profileImage, for: .normal)
//    
//    dismiss(animated: true, completion: nil)
//  }
//  
//  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//    dismiss(animated: true, completion: nil)
//  }
//}
