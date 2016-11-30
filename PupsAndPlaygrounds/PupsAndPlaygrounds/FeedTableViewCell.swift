//
//  FeedTableViewCell.swift
//  PupsAndPlaygrounds
//
//  Created by Felicity Johnson on 11/30/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    let flagButton = UIButton()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func cellConfig() {
        
        
        //Flag Button 
        
        flagButton.setImage(#imageLiteral(resourceName: "Flag"), for: .normal)
        flagButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    
        contentView.addSubview(flagButton)
        flagButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            
        }
        
        // Title Label
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(flagButton.snp.leading)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        

        
    }
    
}
