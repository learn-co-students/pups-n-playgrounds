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
  var profileView: ProfileView!
  var profileImage: UIImage!
  var imagePicker: UIImagePickerController!
  var imagePickerView: ImagePickerView!
  var user: FIRUser!
  
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTouched))
    
    profileView = ProfileView()
    profileView.profileButton.addTarget(self, action: #selector(profileButtonTouched), for: .touchUpInside)
    profileView.locationsTableView.delegate = self
    profileView.locationsTableView.dataSource = self
    profileView.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
    
    view.addSubview(profileView)
    profileView.snp.makeConstraints {
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
      self.profileView.userNameLabel.text = "\(firstName) \(lastName)"
    })
    
    guard let photoURL = user.photoURL else { profileView.profileButton.setTitle("Add\nphoto", for: .normal); return }
    guard let photoData = try? Data(contentsOf: photoURL) else { print("error retrieving image data"); return }
    
    profileView.profileButton.setImage(UIImage(data: photoData), for: .normal)
  }
  
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






