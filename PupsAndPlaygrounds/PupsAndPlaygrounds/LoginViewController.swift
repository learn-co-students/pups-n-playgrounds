//
//  LoginViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

final class LoginViewController: UIViewController {
    
    // MARK: Properties
    var loginView: LoginView!
    var facebookLoginManager: FBSDKLoginManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    // MARK: Instance Methods
    func configure() {
        loginView = LoginView()
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        loginView.facebookButton.addTarget(self, action: #selector(facebookButtonTouched), for: .touchUpInside)
        loginView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTouched), for: .touchUpInside)
        
        facebookLoginManager = FBSDKLoginManager()
        
        view = loginView
    }
    
    // MARK: Action Methods
    func loginButtonTouched() {
        
        guard let email = loginView.emailField.text else { print("error unwrapping user email"); return }
        guard let password = loginView.passwordField.text else { print("error unwrapping user password"); return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            
            guard error == nil else { print("error signing user in: \(error)"); return }

            let testFB = FirebaseTestViewController()
            self.navigationController?.pushViewController(testFB, animated: true)
        }
    }
    
    func facebookButtonTouched() {
        
        facebookLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { result, error in
            
            guard error == nil else { print("error signing user in with facebook"); return }
            
            guard let result = result else { print("error retrieving facebook login result"); return }
            result.isCancelled ? print("facebook sign in cancelled") : print("facebook login successful")
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { self.handleSignIn(user: $0, error: $1) }
        }
        
    }
    
    func handleSignIn(user: FIRUser?, error: Error?) {
        
        guard error == nil else { print("error signing user in: \(error)"); return }
        
        let testFB = FirebaseTestViewController()
        self.navigationController?.pushViewController(testFB, animated: true)
        
        /*
         let profileVC = ProfileViewController()
         self.navigationController?.pushViewController(profileVC, animated: true)
         */
    }
    
    func createAccountButtonTouched() {
        
        let createAccountVC = CreateAccountViewController()
        navigationController?.pushViewController(createAccountVC, animated: true)
    }
}
