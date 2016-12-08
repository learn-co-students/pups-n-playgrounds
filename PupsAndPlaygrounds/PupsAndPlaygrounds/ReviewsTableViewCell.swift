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
    let reviewLabel = UILabel()
    
    weak var review: Review! {
        didSet {
            reviewLabel.text = review.comment
            reviewLabel.textColor = UIColor.blue
            reviewLabel.font = UIFont.themeTinyRegular
            reviewLabel.numberOfLines = 3
            reviewLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
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
        contentView.addSubview(flagButton)
        flagButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.lessThanOrEqualTo(50)
        }

        deleteReviewButton.setTitle("❌", for: .normal)
        contentView.addSubview(deleteReviewButton)
        deleteReviewButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(flagButton.snp.leading)
            $0.width.lessThanOrEqualTo(50)
        }


        contentView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(deleteReviewButton.snp.leading)
        }
    }
    
}


extension ReviewsTableViewCell {
    

    
}
