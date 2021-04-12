//
//  SessionStore.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-04-07.
//

import Foundation
import Firebase

class SessionStore : ObservableObject {
    @Published var user: User?
    @Published var isLoggedin = false
    @Published private var emailReset: String = ""
    @Published var isLinkEmailSent: Bool = false
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen () {
        // monitor authentication changes using Firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                //if we have a user, create a new user model
                print("Got user: \(user.uid)")
                self.user = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
            } else {
                // when we don't have a user, set the session to nil
                self.user = nil
            }
        }
    }
    
    func signUp (email: String, password: String, reenterPassword: String, handler: @escaping AuthDataResultCallback) {
        if reenterPassword != password {
            print("Passwords do not match") // make this into a popup
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func login (email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func logout () {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Logout failed for: \(self.user!.uid)") // make this into an pop-up
            self.user = nil
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
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
