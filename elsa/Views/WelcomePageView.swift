//
//  WelcomePageView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-22.
//

import SwiftUI

struct WelcomePageView: View {
    @EnvironmentObject var userProfileWrapper : UserProfileWrapper
    
    var body: some View {
        ZStack{
            Color("welcomePageBackground")
                .ignoresSafeArea()
            // make the name change depending on the user
            VStack{
                Text("Hello \(self.userProfileWrapper.userProfile!.firstName)")
                Text("Welcome to elsa")
                Text("Learn more about elsa")
                Text("Start your birth control experience")
                ZStack {
                    GeometryReader { geo in
                        Image("Ellipse 13")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width)
                        // blue shape
                        Image("path18")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width)
                        //right lighter blue shape
                        Image("path20")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width)
                        // beige shape
                        Image("path22")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width + 50, height: geo.size.height)
                        // the girl
                        Image("welcome_egirl")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    }
                }
                NavigationLink(destination: HomeView()) {
                    Text("GET STARTED")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color("elsaBlue1"))
                        .clipShape(Capsule())
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomePageView()
        }
    }
}
