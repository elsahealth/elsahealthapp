//
//  LoginView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-22.
//

import SwiftUI
import Firebase

struct LoginView : View {
    @ObservedObject var model = ModelData()
    
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
                
                CustomTextField(placeHolder: "Email", txt: $model.email)
                
                HStack {
                    CustomTextField(placeHolder: "Password", txt: $model.password)
                    //Image(systemName: <#T##String#>)
                    // TODO: add the eye pic so that we can view the password
                    // on both this view and the sign up one
                }
                
            }
            .padding(.top)
            
            Button(action: model.login) {
                Text("LOG IN")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color("elsaBlue1"))
                    .clipShape(Capsule())
            }
            .padding(.top, 22)
            
            
            Button(action: model.resetPassword){
                Text("Forgot Password?")
                    .fontWeight(.bold)
                
            }
            
            Spacer()
            Spacer()
            
            HStack {
                Text("ALREADY HAVE AN ACCOUNT?")
                
                Button(action: {model.isSignedUp.toggle()}, label: {
                    Text("SIGN UP")
                        .fontWeight(.bold)
                })
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $model.isSignedUp) {
            SignUp()
        }
        .alert(isPresented: $model.isLinkEmailSent) {
            Alert(title: Text("Message"), message: Text("The password reset link has been sent"), dismissButton: .destructive(Text("Ok")))
            //TODO: add a check to see if this is a valid address
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
