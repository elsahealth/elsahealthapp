//
//  UserProfileViewModel.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-05-16.
//

import Foundation
import Firebase
import SwiftUI

class UserProfileViewModel : ObservableObject {
    private var userRepo = UserRepository()
    @Published var isLinkEmailSent: Bool = false
    @Published private var emailReset: String = ""
    var handle: AuthStateDidChangeListenerHandle?
    
    func signUp (firstName: String, lastName: String, email: String, password: String, reenterPassword: String, completion: @escaping (_ profile: UserProfile?, _ error: Error?) -> Void) {
        //Ensure that passwords match
        if reenterPassword != password {
            print("Passwords do not match") // make this into a popup
            return
        }
        //Create authentication user in Firebase
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error creating user - \(error)")
                completion(nil, error)
                return
            }
            
            guard let user = result?.user else { return }
            print("User \(user.uid) signed up")
            // Create variable so that we can pass the UserProfile struct to Firestore
            let userProfile = UserProfile(uid: user.uid, firstName: firstName, lastName: lastName, email: email)
            
            // Save profile information to Firestore
            self.userRepo.createProfile(profile: userProfile) { (profile, error) in
                if let error = error {
                    print("Error creating profile - \(error)")
                    completion(nil, error)
                    return
                }
                //self.userProfile = profile
                print("sign up \(userProfile)")
                completion(profile, nil)
            }
        }
    }
    
    
    func login (email: String, password: String, completion: @escaping (_ profile: UserProfile?, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error logging in - \(error)")
                completion(nil, error)
                return
            }
            guard let user = result?.user else { return }
            print("User \(user.uid) signed in")
            
            self.userRepo.fetchProfile(userId: user.uid) { (profile, error) in
                if let error = error {
                    print("Error signing in - \(error)")
                    completion(nil, error)
                    return
                }
                completion(profile, nil)
            }
        }
    }
    
    func logout () {
        do {
            try Auth.auth().signOut()
            // Needs to be implemented when logging out (in the logout view? idk)
//            self.userProfileWrapper.userProfile?.uid = ""
//            self.userProfileWrapper.userProfile?.firstName = ""
//            self.userProfileWrapper.userProfile?.lastName = ""
//            self.userProfileWrapper.userProfile?.email = ""
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func resetPassword() {
        let alert = UIAlertController(title: "Reset Password", message: "Enter your email address to reset your password", preferredStyle: .alert)
        
        alert.addTextField { (password) in
            password.placeholder = "Email"
        }
        
        let proceed = UIAlertAction(title: "Reset", style: .default) {
            (_) in self.emailReset = alert.textFields![0].text!
            // showing the pop-up when the email link has been sent
            self.isLinkEmailSent.toggle()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(proceed)
        
        // the actual pop-up
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}
