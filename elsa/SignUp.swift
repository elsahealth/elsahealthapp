//
//  SignUp.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-20.
//

import SwiftUI
//import Firebase

/*
 TODO: fix the navigation when going to the sign up page from the login page vs the home page
 not the same look. coming from the home page i have a "Back" buttom, while coming from the log in page
 is more like a pop-up. UNIFY
 
 */

struct SignUp: View {
    @ObservedObject var model = ModelData() //check if I am fucking anything up here with loginpage
    //@State var testing : Bool = false
    
    var body : some View {
        NavigationView {
            ZStack {
                VStack {
                    //Spacer()
                    
                    Text("Create your account")
                        .font(.title)
                        .fontWeight(.bold)
                    VStack {
                        Text("placeholder for alternate login in methods")
                    }
                    //.padding(.top)
                    
                    Text("OR LOG IN WITH EMAIL")
                    
                    VStack(spacing: 20) {
                        CustomTextField(placeHolder: "Email", txt: $model.emailSignUp)
                        
                        CustomTextField(placeHolder: "Password", txt: $model.passwordSignUp)
                        
                        CustomTextField(placeHolder: "Re-Enter Password", txt: $model.passwordReEnter)
                    }
                    .padding(.top)
                    
                    HStack {
                        Text("I have read the pp placeholder")
                        // TODO: add checkbox and link to the Privacy policy
                    }
                    NavigationLink(destination: WelcomePage(), isActive: $model.isSignedUp) {
                        EmptyView()
                    }
                    Text("GET STARTED")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color("elsaBlue1"))
                        .clipShape(Capsule())
                        .onTapGesture {
                            model.signUp()
                        }
                    Spacer() // TODO: why minLength
                }
//                Button(action: model.signUp) {
//                    Text("GET STARTED")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.vertical)
//                        .frame(width: UIScreen.main.bounds.width - 30)
//                        .background(Color("elsaBlue1"))
//                        .clipShape(Capsule())
//                }
//                .padding(.top, 10)
                
                
            
            
//            Button(action: {
//                    model.isSignedUp.toggle()
//            }) {
//                Image(systemName: "xmark")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.black.opacity(0.6))
//                    .clipShape(Circle())
//            }
//            .padding(.trailing)
//            .padding(.top, 10)
            }
            .alert(isPresented: $model.alert, content: {
                Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                    
                    if model.alertMsg == "Please verify your email. Once you recieve and email from us, please click on the link to verify" {
                        model.isSignedUp.toggle()
                        model.emailSignUp = ""
                        model.passwordSignUp = ""
                        model.passwordReEnter = ""
                    }
                }))
            })
        }
    }
}



struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp() //check this later
    }
}
