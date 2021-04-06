//
//  elsaApp.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-02-20.
//

import SwiftUI
import Firebase
import UIKit
import Stripe

@main
struct elsaApp: App {
    
    @UIApplicationDelegateAdaptor(Delegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Connecting Firebase

class Delegate : NSObject, UIApplicationDelegate {
    
    func application (_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}
