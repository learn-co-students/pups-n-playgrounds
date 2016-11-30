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
  let feedView = FeedView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Live Feed"
    
    feedView.feedTableView.delegate = self
    feedView.feedTableView.dataSource = self
    feedView.feedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "feedCell")
    
    view.addSubview(feedView)
    feedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    
//   feedView.flagButton.addTarget(self, action: #selector(flagButtonTouched), for: .touchUpInside)
//    
  }
    
    
    func flagButtonTouched() {
        
        print("button touched")
    }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)
    
    let flagButton = UIButton()
    flagButton.setImage(#imageLiteral(resourceName: "Flag"), for: .normal)



    cell.addSubview(flagButton)
    flagButton.snp.makeConstraints {
        $0.top.equalTo(cell.snp.top)
        $0.right.equalTo(cell.snp.right)
    }
    
    cell.textLabel?.text = "Feed Post \(indexPath.row + 1)"
    
    
    
    return cell
  }
}
