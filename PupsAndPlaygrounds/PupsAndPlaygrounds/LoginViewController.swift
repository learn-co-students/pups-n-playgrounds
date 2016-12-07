//
//  LoginViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

final class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    let store = DataStore.sharedInstance
    // MARK: Properties
    let loginView = LoginView()
    let containerVC = (UIApplication.shared.delegate as? AppDelegate)?.containerViewController
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IS USER ANONYMOUS = \(store.user?.isAnonymous)")
        loginView.emailField.delegate = self
        loginView.passwordField.delegate = self
        
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        
        loginView.facebookButton.delegate = self
        loginView.facebookButton.readPermissions = ["email"]
        
        loginView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTouched), for: .touchUpInside)
        loginView.skipButton.addTarget(self, action: #selector(skipButtonTouched), for: .touchUpInside)
        
        view.addSubview(loginView)
        loginView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = view.endEditing(true)
    }
    
    // MARK: Action Methods
    func loginButtonTouched() {
        guard let email = loginView.emailField.text else { print("error unwrapping user email"); return }
        guard let password = loginView.passwordField.text else { print("error unwrapping user password"); return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
            guard error == nil else { print("error signing user in via email"); return }
            
            let mainTBC = MainTabBarController()
            self.containerVC?.childVC = mainTBC
            self.containerVC?.setup(forAnimation: .slideDown)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential) { user, error in
            guard error == nil else { print("error logging using in via facebook"); return }
            
            let mainTBC = MainTabBarController()
            self.containerVC?.childVC = mainTBC
            self.containerVC?.setup(forAnimation: .slideDown)    }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out of facebook")
    }
    
    func createAccountButtonTouched() {
        let createAccountVC = CreateAccountViewController()
        self.containerVC?.childVC = createAccountVC
        self.containerVC?.setup(forAnimation: .slideLeft)
    }
    
    func skipButtonTouched() {
        FIRAuth.auth()?.signInAnonymously { user, error in
            guard error == nil else  { print("error signing user in anonymously"); return }
            
            let mainTBC = MainTabBarController()
            self.containerVC?.childVC = mainTBC
            self.containerVC?.setup(forAnimation: .slideDown)
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
