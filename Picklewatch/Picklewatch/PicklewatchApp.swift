//
//  PicklewatchApp.swift
//  Picklewatch
//
//  Created by Daniel Shemon on 12/13/25.
//

import SwiftUI

// AppDelegate for orientation control
class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

@main
struct PicklewatchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var gameModel = GameModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameModel)
        }
    }
}
