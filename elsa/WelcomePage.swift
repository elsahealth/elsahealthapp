//
//  WelcomePage.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-22.
//

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        ZStack{
            Color("welcomePageBackground")
                .ignoresSafeArea()
            // make the name change depending on the user
            VStack{
                Text("Hello Emy, ")
                Text("Welcome to elsa")
                Text("Learn more about elsa")
                Text("Start your birth control experience")
                Image("path22")
            }

            
        }
        
    }
}

struct WelcomePage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage()
    }
}
