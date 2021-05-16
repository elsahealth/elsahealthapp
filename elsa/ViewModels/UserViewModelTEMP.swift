//
//  UserViewModelTEMP.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-05-16.
//

import Foundation
import Firebase

class UserViewModelTEMP : ObservableObject {
    @Published var user = [User]()
    
    func signUp (firstName: String, lastName: String, email: String, password: String, reenterPassword: String, handler: @escaping AuthDataResultCallback) {
        var ref: DocumentReference? = nil
        
        //Ensure that passwords match
        if reenterPassword != password {
            print("Passwords do not match") // make this into a popup
            return
        }
        //Authenticate with Firebase
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        
        //Push the user's name and email to Firebase
        ref = db?.collection("users").addDocument(data: [
            "first_name" : firstName,
            "last_name"  : lastName,
            "email"      : email
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
