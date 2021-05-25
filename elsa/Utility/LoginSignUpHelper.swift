//
//  LoginSignUpHelper.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-23.
//

import SwiftUI

struct CustomTextField : View {
    var placeHolder : String
    @Binding var txt : String
    
    var body : some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            ZStack {
                if placeHolder == "Password" || placeHolder == "Re-Enter Password" {
                    SecureField(placeHolder, text: $txt)
                } else if placeHolder == "Email" {
                    TextField(placeHolder, text: $txt)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    TextField(placeHolder, text: $txt)
                        .disableAutocorrection(true)
                }
            }
            .padding(.horizontal)
            .frame(height: 60)
            .background(Color.black.opacity(0.2))
            .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}
