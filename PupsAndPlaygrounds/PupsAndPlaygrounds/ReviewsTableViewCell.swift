//
//  ReviewsTableViewCell.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 12/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {
    
    let deleteReviewButton = UIButton()
    let flagButton = UIButton()

    
    weak var review: Review! {
        didSet {
            textLabel?.text = review.comment
            textLabel?.textColor = UIColor.blue
            textLabel?.font = UIFont.themeTinyBold
            textLabel?.numberOfLines = 3
            textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        }
    }
    
    
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
        print("CONFIGURING CELL")
        
        flagButton.setTitle("⚠️", for: .normal)
//        flagButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        contentView.addSubview(flagButton)
        flagButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(10)
            $0.width.lessThanOrEqualTo(30)
        }

        deleteReviewButton.setTitle("❌", for: .normal)
//        deleteReviewButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        contentView.addSubview(deleteReviewButton)
        deleteReviewButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(flagButton.snp.leading).offset(5)
            $0.width.lessThanOrEqualTo(30)
        }
//        contentView.bringSubview(toFront: deleteReviewButton)


    }
    
}


extension ReviewsTableViewCell {
    

    
}
