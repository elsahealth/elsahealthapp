//
//  OfferingsViewModel.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-04-18.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class OfferingsViewModel : ObservableObject {
    @Published var offerings = [Offerings]()
    private let db = Firestore.firestore()
    
    func fetchData() {
        db.collection("elsahealth_products").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents in the server found")
                return
            }
            
            // Make a query to Firebase and return response
            self.offerings = documents.compactMap{ (queryDocumentSnapshot) -> Offerings? in
                return try? queryDocumentSnapshot.data(as: Offerings.self)
            }
        }
    }
}
