//
//  PicklewatchApp.swift
//  Picklewatch Watch App
//
//  Created by Daniel Shemon on 12/13/25.
//

import SwiftUI

@main
struct Picklewatch_Watch_AppApp: App {
    @StateObject private var watchGameModel = WatchGameModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(watchGameModel)
        }
    }
}
