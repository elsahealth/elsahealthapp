//
//  UserRepository.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-05-18.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class UserRepository : ObservableObject {
    private let db = Firestore.firestore()
    
    func createProfile(profile: UserProfile, completion: @escaping (_ profile: UserProfile?, _ error: Error?) -> Void) {
        do {
            let _ = try db.collection("users").document(profile.uid).setData(from: profile)
            completion(profile, nil)
        } catch let error {
            print("Error writing profile to Firestore \(error)")
            completion(nil, error)
        }
    }
    
    func fetchProfile(userId: String, completion: @escaping (_ profile : UserProfile?, _ error: Error?) -> Void) {
        db.collection("users").document(userId).getDocument { (snapshot, error) in
            let profile = try? snapshot?.data(as: UserProfile.self)
            completion(profile, error)
        }
    }
    // TODO: Complete implemtnation of this function - to replace the one in OfferingsViewModel
//    func fetchElsaProductsData(completion: @escaping (_ offerings : Offerings?, _ error: Error?) -> Void) {
//        db.collection("elsahealth_products").getDocuments { (query, error) in
//            do {
//                let _ = try query?.documents
//            } catch let error {
//                print("Error fetching elsa Health products: \(error)")
//                completion(nil, error)
//            }
//        }
//    }
}
