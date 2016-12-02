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
    
<<<<<<< HEAD
    feedView.feedTableView.delegate = self
    feedView.feedTableView.dataSource = self
    feedView.feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
    
    view.addSubview(feedView)
    feedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    
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
  
=======
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseData.getAllPlaygrounds { playgrounds in
            self.locations = playgrounds
            self.listView.locationsTableView.reloadData()
        }
        
        title = "Temporary Work Window!"
        
        listView.locationsTableView.delegate = self
        listView.locationsTableView.dataSource = self
        listView.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        view.addSubview(listView)
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
>>>>>>> reviews-rdfj
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
<<<<<<< HEAD
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
    
    cell.titleLabel.text = "Feed Post \(indexPath.row + 1)"
    
    cell.flagButton.addTarget(self, action: #selector(flagButtonTouched), for: .touchUpInside)


    return cell
  }
=======
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationProfileVC = LocationProfileViewController()
        guard let playground = locations[indexPath.row] as? Playground else { print("error downcasting to playground"); return }
        
        locationProfileVC.playground = playground
        navigationController?.pushViewController(locationProfileVC, animated: true)
    }
>>>>>>> reviews-rdfj
}
