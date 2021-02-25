//
//  ModelData.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-23.
//

// MVVM Model

import SwiftUI
import Firebase

class ModelData : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isSignedUp = false
    @Published var emailSignUp = ""
    @Published var passwordSignUp = ""
    @Published var passwordReEnter = ""
    @Published var emailReset = ""
    @Published var isLinkEmailSent = false
    
    // Errors
    @Published var alert = false
    @Published var alertMsg = ""
    
    // User Status
    @AppStorage("log_status") var status = false
    
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
    
    // Login and authenticate with Firebase
    func login() {
        if email == "" || password == "" {
                self.alertMsg = "Input fields not properly filled"
                self.alert.toggle()
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            let user = Auth.auth().currentUser
            if !user!.isEmailVerified {
                self.alertMsg = "Please verify email address"
                self.alert.toggle()
                //logging out
                try! Auth.auth().signOut()
                return
            }
            
            withAnimation {
                self.status = true
            }
        }
    }
    
    // Sign up and authenticate with Firebase
    func signUp() {
        if emailSignUp == "" || passwordSignUp == "" || passwordReEnter == "" {
            self.alertMsg = "Please fill in all the fields"
            self.alert.toggle ()
            return
        }
        if passwordSignUp != passwordReEnter {
            self.alertMsg = "Your passwords do not match"
            self.alert.toggle ()
            return
        }
        
        Auth.auth().createUser(withEmail: emailSignUp, password: passwordSignUp) {
            (result, err) in
            
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            //Sending verification email
            result?.user.sendEmailVerification(completion: { (err) in
                if err != nil {
                    self.alertMsg = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                // Alerting user to verify email
                self.alertMsg = "Please verify your email. Once you recieve and email from us, please click on the link to verify"
                self.alert.toggle()
            })
        }
    }
    //integrate this function with a logout option
    func logOut() {
        try! Auth.auth().signOut()
        //clear data
        email = ""
        password = ""
        emailSignUp = ""
        passwordSignUp = ""
        passwordReEnter = ""
    }
}
