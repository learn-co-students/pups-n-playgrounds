//
//  FeedViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class FeedViewController: UIViewController {
    
    // MARK: Properties
    let listView = ListView()
    var locations = [Location]()
    var feedView = FeedView()
    
    
    func flagButtonTouched() {
        
        print("button touched")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedView.feedTableView.delegate = self
        feedView.feedTableView.dataSource = self
        feedView.feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
        
        view.addSubview(feedView)
        feedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        
        cell.titleLabel.text = "Feed Post \(indexPath.row + 1)"
        
        cell.flagButton.addTarget(self, action: #selector(flagButtonTouched), for: .touchUpInside)
        
        
        return cell
    }
    
}
