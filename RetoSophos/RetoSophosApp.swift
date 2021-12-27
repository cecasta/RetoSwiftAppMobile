//
//  RetoSophosApp.swift
//  RetoSophos
//
//  Created by ccastano on 21/12/21.
//

import SwiftUI
import Firebase
@main
struct RetoSophosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()       }
    }
}


// initiall firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}
