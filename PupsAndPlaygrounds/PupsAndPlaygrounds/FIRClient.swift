//
//  FIRClient.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 12/11/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Firebase

final class FIRClient {
    
    // Firebase Root Reference
    static let ref = FIRDatabase.database().reference()
    static let store = DataStore.shared
    
    // MARK: Create new user account
    static func createAccount(firstName: String, lastName: String, email: String, password: String, completion: @escaping () -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            guard error == nil else {
                print("error creating firebase user")
                return
            }
            
            guard let user = user else {
                print("error unwrapping new user data")
                return
            }
            
            ref.child("users").updateChildValues([user.uid : ["firstName" : firstName, "lastName": lastName]])
            
            completion()
        }
    }
    
    // MARK: Existing User Login
    static func login(email: String, password: String, completion: @escaping () -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
            guard error == nil else {
                print("error signing user in")
                return
            }
            
            completion()
        }
    }
    
    // MARK: Retrieve existing user
    static func getUser(user: FIRUser?, completion: @escaping(User) -> Void) {
        guard let uid = user?.uid else {
            print("error unwrapping uid from user in FIRClient")
            return
        }
        
        ref.child("users").child(uid).observe(.value, with: { snapshot in
            guard let userInfo = snapshot.value as? [String : Any] else {
                print("error unwrapping user information")
                return
            }
            
            guard let firstName = userInfo["firstName"] as? String else {
                print("error unwrapping first name")
                return
            }
            
            guard let lastName = userInfo["lastName"] as? String else {
                print("error unwrapping last name")
                return
            }
            
            let user = User(uid: uid, firstName: firstName, lastName: lastName)
            
            if let reviewIDs = userInfo["reviews"] as? [String : Any] {
                for reviewID in reviewIDs.keys {
                    user.reviewIDs.append(reviewID)
                }
            }
            
            if let profilePhotoURL = URL(string: userInfo["profilePhotoURLString"] as? String ?? "") {
                URLSession.shared.dataTask(with: profilePhotoURL) { data, response, error in
                    guard let data = data else {
                        print("error unwrapping data")
                        return
                    }
                    
                    user.profilePhoto = UIImage(data: data)
                    completion(user)
                    }.resume()
            } else {
                completion(user)
            }
        })
    }
    
    static func getReviews(forUser user: User?, completion: @escaping ([Review]) -> Void) {
        guard let user = user else {
            print("error unwrapping user while retrieving reviews")
            return
        }
        
        ref.child("reviews").child("visible").observe(.value, with: { snapshot in
            guard let reviewsDict = snapshot.value as? [String : [String : Any]] else {
                print("error unwrapping user reviews dict")
                return
            }
            
            var reviews = [Review]()
            
            for (reviewID, reviewInfo) in reviewsDict {
                guard user.reviewIDs.contains(reviewID) else { continue }
                guard let locationID = reviewInfo["locationID"] as? String else {
                    print("error unwrapping location id from user review")
                    return
                }
                
                guard let rating = reviewInfo["rating"] as? Int else {
                    print("error unwrapping rating from user review")
                    return
                }
                
                guard let comment = reviewInfo["comment"] as? String else {
                    print("error unwrapping comment from user review")
                    return
                }
                
                reviews.append(Review(reviewID: reviewID, userID: user.uid, locationID: locationID, rating: rating, comment: comment))
            }
            
            completion(reviews)
        })
    }
    
    static func getReview(with reviewID: String, completion: @escaping (Review) -> ()) {
        let ref = FIRDatabase.database().reference().root
        
        let userKey = ref.child("reviews").child("visible").child(reviewID)
        
        userKey.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let reviewDict = snapshot.value as? [String : Any] else { print("REVIEWDICTIONARY = \(snapshot.value as? [String : Any]): review was flagged"); return }
            guard let comment = reviewDict["comment"] as? String else { print("ERROR #2 \(reviewDict["comment"])"); return }
            guard let userID = reviewDict["userID"] as? String else { print("ERROR #3"); return }
            guard let locationID = reviewDict["locationID"] as? String else { print("ERROR #4"); return }
            
            let newReview = Review(reviewID: reviewID, userID: userID, locationID: locationID, rating: 0, comment: comment)
            
            completion(newReview)
        })
    }
    
    static func saveProfilePhoto(completion: @escaping () -> Void) {
        guard let user = DataStore.shared.user else {
            print("error unwrapping user on profile photo save")
            return
        }
        
        guard let profilePhoto = user.profilePhoto else {
            print("error unwrapping user profile photo on save")
            return
        }
        
        let profilePhotoID = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profilePhotos").child("\(profilePhotoID).png")
        
        if let profilePhotoPNG = UIImagePNGRepresentation(profilePhoto) {
            storageRef.put(profilePhotoPNG, metadata: nil) { metadata, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let metadataURLString = metadata?.downloadURL()?.absoluteString else {
                    print("no profile image URL")
                    return
                }
                
                ref.child("users").child(user.uid).updateChildValues(["profilePhotoURLString" : metadataURLString])
                
                completion()
            }
        }
    }
    
    static func getLocation(with locationID: String, completion: @escaping (Location?) -> ()) {
        
        let ref = FIRDatabase.database().reference().root
        
        let locationKey = ref.child("locations").child("playgrounds").child(locationID)
        
        locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let locationDict = snapshot.value as? [String : Any] else { print("ERROR #1"); return }
            guard let name = locationDict["name"] as? String else { print("ERROR #2"); return }
            guard let address = locationDict["address"] as? String else { print("ERROR #3"); return }
            guard let latitudeString = locationDict["latitude"] as? String else { print("ERROR #4"); return }
            guard let longitudeString = locationDict["longitude"] as? String else { print("ERROR #5"); return }
            guard let isHandicap = locationDict["isHandicap"] as? String else { print("ERROR #6"); return }
            guard let isFlagged = locationDict["isFlagged"] as? String else { print("ERROR #7"); return }
            
            var rating: Int
            if let averageRating = locationDict["rating"] as? Int {
                rating = averageRating
            } else {
                rating = 0
            }
            
            //            guard let photos = locationDict["photos"] as? [UIImage] else { return }
            
            var reviewsIDArray = [String]()
            
            guard let latitude = Double(latitudeString) else { return }
            guard let longitude = Double(longitudeString) else { return }
            
            
            if let reviewsDictionary = locationDict["reviews"] as? [String : Any] {
                for iterReview in reviewsDictionary {
                    let reviewID = iterReview.key
                    reviewsIDArray.append(reviewID)
                }
            }
            
            let newestPlayground = Playground(id: locationID, name: name, address: address, isHandicap: isHandicap, latitude: latitude, longitude: longitude, reviewIDs: reviewsIDArray, rating: rating, photos: [], isFlagged: isFlagged)
            
            completion(newestPlayground)
        })
        
    }
    
    static func addReview(comment: String, locationID: String, rating: Int) -> Review? {
        let ref = FIRDatabase.database().reference().root
        
        let uniqueReviewKey = FIRDatabase.database().reference().childByAutoId().key
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else { return nil }
        
        if locationID.hasPrefix("PG") {
            
            ref.child("locations").child("playgrounds").child("\(locationID)").child("reviews").updateChildValues([uniqueReviewKey: ["flagged": "false", "rating": rating]])
            
        } else if locationID.hasPrefix("DR") {
            
            ref.child("locations").child("dogruns").child("\(locationID)").child("reviews").updateChildValues([uniqueReviewKey: ["flagged": "false", "rating": rating]])
        }
        
        ref.child("users").child("\(userUniqueID)").child("reviews").updateChildValues([uniqueReviewKey: ["flagged": "false"]])
        
        ref.child("reviews").child("visible").updateChildValues([uniqueReviewKey : ["comment" : comment,
                                                                                    "userID" : userUniqueID,
                                                                                    "locationID" : locationID,
                                                                                    "rating" : rating,
                                                                                    "flagged" : "false",
                                                                                    "reviewID" : uniqueReviewKey]])
        
        let newReview = Review(reviewID: uniqueReviewKey, userID: userUniqueID, locationID: locationID, rating: rating, comment: comment)
        
        return newReview
    }
    
    static func deleteReview(userID: String, reviewID: String, locationID: String, completion: () -> Void) {
        guard let uid = store.user?.uid else {
            print("error unwrapping uid for user review deletion")
            return
        }
        
        if userID == uid {
            if locationID.hasPrefix("PG") {
                ref.child("locations").child("playgrounds").child("\(locationID)").child("reviews").child(reviewID).removeValue()
            } else if locationID.hasPrefix("DR") {
                ref.child("locations").child("dogruns").child("\(locationID)").child("reviews").child(reviewID).removeValue()
            }
            
            ref.child("users").child("\(uid)").child("reviews").child(reviewID).removeValue()
            ref.child("reviews").child("visible").child(reviewID).removeValue()
        }
        
        completion()
    }
    
    static func flagReviewWith(unique reviewID: String, locationID: String, comment: String, userID: String, completion: () -> Void) {
        let rootRef = FIRDatabase.database().reference().root
        
        let reviewRef = rootRef.child("reviews")
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        if locationID.hasPrefix("PG") {
            
            rootRef.child("locations").child("playgrounds").child("\(locationID)").child("reviews").updateChildValues([reviewID: ["flagged": true]])
            
        } else if locationID.hasPrefix("DR") {
            
            rootRef.child("locations").child("dogruns").child("\(locationID)").child("reviews").updateChildValues([reviewID: ["flagged": true]])
        }
        
        rootRef.child("users").child("\(userUniqueID)").child("reviews").updateChildValues([reviewID: ["flagged": true]])
        
        
        reviewRef.child("flagged").updateChildValues([reviewID: ["comment": comment, "userID": userID, "locationID": locationID, "flagged": true]])
        
        reviewRef.child("visible").child(reviewID).removeValue()
        completion()
    }
    
    static func getVisibleReviews(completion: @escaping ([Review]) -> Void) {
        let reviewsRef = ref.child("reviews").child("visible")
        reviewsRef.observe(.value, with: { snapshot in
            guard let reviewsDict = snapshot.value as? [String : [String : Any]] else {
                print("no user reviews")
                return
            }
            
            guard let uid = store.user?.uid else {
                print("error unwrapping user while retrieving reviews")
                return
            }
            
            guard let reviewIDs = store.user?.reviewIDs else {
                print("error unwrapping review idea while retrieving reviews")
                return
            }
            
            var reviews = [Review]()
            
            for (reviewID, review) in reviewsDict {
                if reviewIDs.contains(reviewID) {
                    guard let locationID = review["locationID"] as? String,
                        let comment = review["comment"] as? String else {
                            print("error unwrapping user review data")
                            continue
                    }
                    let rating = review["rating"] as? Int ?? 4
                    
                    reviews.append(Review(reviewID: reviewID,
                                          userID: uid,
                                          locationID: locationID,
                                          rating: rating,
                                          comment: comment))
                }
            }
            
            completion(reviews)
        })
    }
    
    static func calcAverageStarFor(location uniqueID: String) -> Float {
        
        let ref = FIRDatabase.database().reference().child("locations")
        
        var playgroundRatings = [Double]()
        var playgroundRatingsSum = Double()
        var dogrunRatingsSum = Double()
        var dogrunRatings = [Double]()
        var averageStarValueToReturn = Float()
        
        if uniqueID.hasPrefix("PG") {
            
            ref.child("playgrounds").child("\(uniqueID)").child("reviews").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotValue = snapshot.value as? [String: Any] else { print("error returning playground reviews"); return}
                
                for snap in snapshotValue {
                    guard let playgroundInfo = snap.value as? [String: Any] else {print("error returning playground info"); return}
                    
                    if let rating = playgroundInfo["rating"] as? Int {
                        playgroundRatings.append(Double(rating))
                    } else {
                        playgroundRatings.append(0)
                    }
                }
                
                for value in playgroundRatings {
                    playgroundRatingsSum += value
                }
                
                print("PLAYGROUND RATING SUM =\(playgroundRatingsSum)")
                print("PLAYGROUND RATING count =\(playgroundRatings.count)")
                
                averageStarValueToReturn = Float(playgroundRatingsSum / Double(playgroundRatings.count))
                print("AVERAGE STARS: \(averageStarValueToReturn)")
                
                ref.child("playgrounds").child(uniqueID).updateChildValues(["rating" : averageStarValueToReturn])
            })
            return averageStarValueToReturn
        } else if uniqueID.hasPrefix("DR") {
            
            ref.child("dogruns").child("\(uniqueID)").child("reviews").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotValue = snapshot.value as? [String: Any] else { print("error returning playground reviews"); return}
                
                for snap in snapshotValue {
                    guard let dogRunInfo = snap.value as? [String : Any] else {
                        print("error returning playground info")
                        return
                    }
                    
                    if let rating = dogRunInfo["rating"] as? Int {
                        dogrunRatings.append(Double(rating))
                    } else {
                        dogrunRatings.append(0)
                    }
                    
                    if dogrunRatings.count == snapshotValue.count {
                        for value in dogrunRatings {
                            dogrunRatingsSum += value
                        }
                        print("DOGRUN RATING SUM =\(dogrunRatingsSum)")
                        print("DOGRUN RATING count =\(dogrunRatings.count)")
                        
                        averageStarValueToReturn = Float(dogrunRatingsSum / Double(dogrunRatings.count))
                    }
                }
                
                ref.child("dogruns").child(uniqueID).updateChildValues(["rating" : averageStarValueToReturn])
            })
            return averageStarValueToReturn
        }
        return averageStarValueToReturn
    }
}




