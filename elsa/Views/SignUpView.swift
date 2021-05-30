//
//  SignUpView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-20.
//

import SwiftUI

/*
 TODO: fix the navigation when going to the sign up page from the login page vs the home page
 not the same look. coming from the home page i have a "Back" buttom, while coming from the log in page
 is more like a pop-up. UNIFY

 */

struct SignUpView: View {
    @ObservedObject var userVM = UserProfileViewModel()
    @EnvironmentObject var userProfileWrapper : UserProfileWrapper
    
    @State var email: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @State var passwordReEnter: String = ""
    @State var isSignedUp: Bool = false
    //@State var error: Bool = false
    
    var body : some View {
        ZStack {
            VStack {
                //Spacer()
                Text("Create your account")
                    .font(.title)
                    .fontWeight(.bold)

                Text("placeholder for alternate login in methods")

                //.padding(.top)
                
                Text("OR LOG IN WITH EMAIL")
                
                VStack() {
                    CustomTextField(placeHolder: "First Name", txt: $firstName)
                    
                    CustomTextField(placeHolder: "Last Name", txt: $lastName)
                    
                    CustomTextField(placeHolder: "Email", txt: $email)
                    
                    CustomTextField(placeHolder: "Password", txt: $password)
                    
                    CustomTextField(placeHolder: "Re-Enter Password", txt: $passwordReEnter)
                }
                //.padding(.top)
                
                HStack {
                    Text("I have read the pp placeholder")
                    // TODO: add checkbox and link to the Privacy policy
                }
                /* figure out what to do here. once we select "SIGN UP" we go right to
                the next view. maybe when signing up, we have the log in view pop up instead?
                */
                NavigationLink(destination: LoginPageView(), isActive: $isSignedUp) {
                    EmptyView() }
                Button {
                    //self.error = false
                    self.signUp()
                } label: {
                    Text("GET STARTED")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color("elsaBlue1"))
                        .clipShape(Capsule())
                }
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            //.navigationBarHidden(true)
        }
//        .alert(isPresented: $model.alert, content: {
//            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
//
//                //this is also displayed
//                if model.alertMsg == "Please verify your email. Once verified, log into your account" {
//                    model.isSignedUp.toggle()
//                    model.emailSignUp = ""
//                    model.passwordSignUp = ""
//                    model.passwordReEnter = ""
//                }
//            }))
//        })
        
    }
    func signUp() {
        userVM.signUp(firstName: firstName, lastName: lastName, email: email, password: password, reenterPassword: passwordReEnter) { (profile, error) in
            if let error = error {
                print("Error signing up: \(error)")
                return
            }
            // TODO: test the signing up now using the @EnvironmentObject
            self.isSignedUp.toggle()
            self.userProfileWrapper.userProfile = profile
        }
    }
}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
