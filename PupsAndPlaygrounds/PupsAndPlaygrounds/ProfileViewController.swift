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
  lazy var imagePickerView = ImagePickerView()
  lazy var user = FIRAuth.auth()?.currentUser
  var profileImage: UIImage?
  
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Profile"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTouched))
  
    profileView.profileButton.addTarget(self, action: #selector(profileButtonTouched), for: .touchUpInside)
    profileView.locationsTableView.delegate = self
    profileView.locationsTableView.dataSource = self
    profileView.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
    
    view.addSubview(profileView)
    profileView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    guard let user = user else {
      print("error unrwapping current user")
      return
    }
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
  }
  
  // MARK: Action Methods
  func profileButtonTouched() {
    let alert = UIAlertController(title: "Update Profile Photo", message: nil, preferredStyle: .alert)
    let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        self.imagePicker.cameraCaptureMode = .photo
        self.imagePicker.showsCameraControls = false
        self.imagePicker.allowsEditing = false
        
        self.imagePickerView.captureButton.addTarget(self, action: #selector(self.captureButtonTouched), for: .touchUpInside)
        
        self.imagePicker.view.addSubview(self.imagePickerView)
        self.imagePickerView.snp.makeConstraints {
          $0.edges.equalToSuperview()
        }
        
        self.present(self.imagePicker, animated: true, completion: nil)
      }
    }
    let cameraRoll = UIAlertAction(title: "Camera roll", style: .default) { _ in
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
      }
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alert.addAction(takePhoto)
    alert.addAction(cameraRoll)
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
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
    profileView.profileButton.setImage(profileImage, for: .normal)
    
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: UITableViewDelegate and UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
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






