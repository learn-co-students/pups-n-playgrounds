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
  lazy var user = FIRAuth.auth()?.currentUser
  var profileImage: UIImage?
  
  let containerVC = (UIApplication.shared.delegate as? AppDelegate)?.containerViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Profile"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTouched))
    
    profileView.profileButton.addTarget(self, action: #selector(profileButtonTouched), for: .touchUpInside)
    
    profileView.locationsTableView.delegate = self
    profileView.locationsTableView.dataSource = self
    profileView.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
    
    retrieveUserInfo {
      DispatchQueue.main.async {
        self.view.addSubview(self.profileView)
        self.profileView.snp.makeConstraints { $0.edges.equalToSuperview() }
      }
    }
  }
  
  // MARK: Retrieve User Information from Firebase
  // TODO: Factor Into FirebaseData File
  private func retrieveUserInfo(completion: @escaping () -> Void) {
    guard let user = user else { print("error unrwapping current user"); completion(); return }
    let userRef = FIRDatabase.database().reference().child("users").child(user.uid)
    
    userRef.observeSingleEvent(of: .value, with: { snapshot in
      guard let userInfo = snapshot.value as? [String : String] else { completion(); return }
      let firstName = userInfo["firstName"] ?? ""
      let lastName = userInfo["lastName"] ?? ""
      
      self.profileView.userNameLabel.text = "\(firstName) \(lastName)"
      
      if let profilePhotoURL = URL(string: userInfo["profilePicURL"] ?? "") {
        URLSession.shared.dataTask(with: profilePhotoURL) { data, response, error in
          guard let data = data else { print("error unwrapping data"); completion(); return }
          self.profileImage = UIImage(data: data)
          self.profileView.profileButton.setImage(self.profileImage, for: .normal)
          completion()
          }.resume()
      } else {
        self.profileImage = #imageLiteral(resourceName: "AddPhoto")
        self.profileView.profileButton.setImage(self.profileImage, for: .normal)
        completion()
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
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    profileImage = info[UIImagePickerControllerEditedImage] as? UIImage
    profileView.profileButton.setImage(profileImage, for: .normal)
    
    handleSavingPic()
    
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

// MARK: Save User Photos to Firebase
extension ProfileViewController {
  func handleSavingPic() {
    guard let user = user else { print("error unrwapping current user"); return }
    let userRef = FIRDatabase.database().reference().child("users").child(user.uid)
    
    let imageName = NSUUID().uuidString
    let storageRef = FIRStorage.storage().reference().child("profilePics").child("\(imageName).png")
    guard let imageToUpload = profileImage else { print("no image"); return }
    
    if let uploadData = UIImagePNGRepresentation(imageToUpload) {
      storageRef.put(uploadData, metadata: nil) { (metadata, error) in
        if let error = error { print(error); return }
        
        guard let metaDataURL = metadata?.downloadURL()?.absoluteString else { print("no profile image URL"); return }
        userRef.setValue(["profilePicURL": metaDataURL])
      }
    }
  }
}






