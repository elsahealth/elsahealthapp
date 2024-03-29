 //
//  StartPageView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-19.
//

import SwiftUI
import Firebase

struct StartPageView: View {
//    @AppStorage("log_status") var status = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Birth control made simple")
                    
                Text("Birth control for you, from the comfort of your home")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
                NavigationLink(destination: SignUpView()) {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color("elsaBlue2"))
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .padding(.horizontal, 20)
                
                }
                
            
                HStack {
                    Text("Already have an account?")
                    ZStack {
//                        if status {
//                            VStack(spacing: 25) {
//                                Text("Logged in as \(Auth.auth().currentUser?.email ?? "")")
//                                
//                            }
//                        }
                        NavigationLink(destination: LoginPageView()) {
                            Text("Log in")
                        }

                    }
                }
            }
        }
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
    }
}
