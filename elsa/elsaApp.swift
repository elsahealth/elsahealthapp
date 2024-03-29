//
//  elsaApp.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-20.
//

import SwiftUI
import Firebase
import Stripe

@main
struct elsaApp: App {
    @StateObject var userProfileWrapper = UserProfileWrapper()
    
    init() {
        FirebaseApp.configure()
        StripeAPI.defaultPublishableKey = "pk_test_51Iat6wHGUWpJ4L2d9NEqGACNfT3NxHj01nxVE1VDb9VVMNHLuOw3kq3SIJzLY6VQligz6QfsmXbeOF243H95s6Bb00aLqGC1RG"
        
    }
    
    var body: some Scene {
        WindowGroup {
            StartPageView()
                .environmentObject(userProfileWrapper)
        }
    }
}
