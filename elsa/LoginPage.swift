//
//  LoginView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-22.
//

import SwiftUI

struct LoginView : View {
    @State var colour = Color.black.opacity(0.7)
    @State var email = ""
    @State var password = ""
    @State var visible = false
    var body : some View {
        VStack {
            Text("Log in to your account")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            TextField("Email", text: self.$email)
            .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.blue : self.colour, lineWidth: 2))
                .disableAutocorrection(true)
            
            HStack(spacing: 15) {
                VStack { //TODO: why is this vstack needed
                    if self.visible {
                        TextField("Password", text: self.$password)
                    } else {
                        SecureField("Password", text: self.$password)
                    }
                    
                }
                Button(action: {
                    self.visible = true //TODO: make this alternate
                }) {
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.colour)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color.blue : self.colour, lineWidth: 2))
            
            NavigationLink(destination: WelcomePage()) {
                Text("LOG IN")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color("elsaBlue2"))
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
            }
            
            HStack {
                Button(action: {
                    
                }) {
                    Text("Forgot Password?")
                }
                .padding(.top, 20)
            }
            
        }
        .padding(.horizontal, 25)
        
        
        
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

