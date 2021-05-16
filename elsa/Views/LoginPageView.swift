//
//  LoginPageView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-22.
//

import SwiftUI
import Firebase

struct LoginPageView : View {
    //@ObservedObject var model = ModelData()
    @ObservedObject var sessionStore = SessionStoreViewModel()
    
    @State var email: String = ""
    @State var password: String = ""
    @State var loading: Bool = false
    @State var error: Bool = false
    @State private var isLoggedIn: Bool = false
    

    // TODO: add error/warning when login isn't valid
    
    var body : some View {
        VStack {
            Text("Welcome Back")
                .font(.title)
                .fontWeight(.bold)
            VStack {
                Text("placeholder for alternate login in methods")
            }
            .padding(.top)
            
            VStack(spacing: 20) {
                
                CustomTextField(placeHolder: "Email", txt: $email)
                
                HStack {
                    CustomTextField(placeHolder: "Password", txt: $password)
                    //Image(systemName: <#T##String#>)
                    // TODO: add the eye pic so that we can view the password
                    // on both this view and the sign up one
                }
                
            }
            .padding(.top)
            
            //TODO: add loading screen
            NavigationLink(destination: WelcomePageView(), isActive: $isLoggedIn) {
                EmptyView() }
            Button {
                loading = true
                error = false
                sessionStore.login(email: email, password: password) { (result, error) in
                    self.loading = false
                    if error != nil {
                        self.error = true
                    } else {
                        self.isLoggedIn = true
                        self.password = ""
                    }
                }
            } label: {
                Text("LOG IN")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color("elsaBlue1"))
                    .clipShape(Capsule())
            }
//            .alert(isPresented: $model.alert) {
//                Alert(title: Text("Message"), message: Text("Please input the fields properly"), dismissButton: .destructive(Text("Ok")))
//            }
            .padding(.top, 22)
            
            
            Button(action: sessionStore.resetPassword){
                Text("Forgot Password?")
                    .fontWeight(.bold)
                
            }
            
            Spacer()
            Spacer()
            // should be placed in the sign up view
//            HStack {
//                Text("ALREADY HAVE AN ACCOUNT?")
//
//                Button(action: {model.isSignedUp.toggle()}, label: {
//                    Text("LOG IN")
//                        .fontWeight(.bold)
//                })
//            }
            Spacer()
        }
//        .fullScreenCover(isPresented: $model.isSignedUp) {
//            SignUpView()
//        }
        .alert(isPresented: $sessionStore.isLinkEmailSent) {
            Alert(title: Text("Message"), message: Text("The password reset link has been sent"), dismissButton: .destructive(Text("Ok")))
            //TODO: add a check to see if this is a valid address
        }
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}
