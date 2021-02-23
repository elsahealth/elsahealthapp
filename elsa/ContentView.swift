//
//  ContentView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Birth control made simple")
                    //.font(.custom("hirakakustd-w8"))
                    
                Text("Birth control for you, from the comfort of your home")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
                    //.font(Font.custom("hirakakustd-w8", size: 20))
                NavigationLink(destination: LoginView()) {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                        //.font(Font.custom("hirakakustd-w8", size: 8))
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color("elsaBlue2"))
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .padding(.horizontal, 20)
                }
            
                HStack {
                    Text("Already have an account?")
                        //.font(.custom("hirakakustd-w8"))
                    NavigationLink(destination: LoginView()) {
                        Text("Log in")
                            //.font(.custom("hirakakustd-w8"))
                    }
                }
                
                
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
