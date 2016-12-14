//
//  SettingsDropDownView.swift
//  PupsAndPlaygrounds
//
//  Created by Felicity Johnson on 12/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//
import Foundation
import UIKit

class SettingsDropDownView: UIView {
    
    // MARK: Properties
    
    lazy var logoutButton = UIButton()
    lazy var changePasswordButton = UIButton()
    lazy var contactPPButton = UIButton()
    lazy var settingsButton = UIButton()
    lazy var settingsDropDownStackView = UIStackView()
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        configure()
        constrain()
    }
    
    // MARK: View Configuration
    private func configure() {
        
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont.themeTinyBold
        logoutButton.setTitleColor(UIColor.themeDarkBlue, for: .normal)
        
        changePasswordButton.setTitle("Change password", for: .normal)
        changePasswordButton.titleLabel?.font = UIFont.themeTinyBold
        changePasswordButton.setTitleColor(UIColor.themeDarkBlue, for: .normal)
        
        contactPPButton.setTitle("Contact P&P", for: .normal)
        contactPPButton.titleLabel?.font = UIFont.themeTinyBold
        contactPPButton.setTitleColor(UIColor.themeDarkBlue, for: .normal)
        
        settingsDropDownStackView.addArrangedSubview(logoutButton)
        settingsDropDownStackView.addArrangedSubview(changePasswordButton)
        settingsDropDownStackView.addArrangedSubview(contactPPButton)
        settingsDropDownStackView.axis = .vertical
        settingsDropDownStackView.alignment = .leading
        settingsDropDownStackView.distribution = .fillEqually
        
    }
    
    // MARK: View Constraints
    private func constrain() {
        
        
        addSubview(settingsDropDownStackView)
        settingsDropDownStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
}
