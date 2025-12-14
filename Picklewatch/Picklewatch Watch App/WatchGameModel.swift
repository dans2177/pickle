//
//  WatchGameModel.swift
//  Picklewatch Watch App
//
//  Created by Daniel Shemon on 12/13/25.
//

import Foundation
import WatchConnectivity

class WatchGameModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var isGameStarted = false
    @Published var team1Score = 0
    @Published var team2Score = 0
    @Published var isConnected = false
    
    private var session: WCSession?
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sendActionToPhone(_ action: String) {
        guard let session = session else {
            print("⌚ No WCSession available")
            return
        }
        
        print("⌚ Session state - Activated: \(session.activationState == .activated), Reachable: \(session.isReachable)")
        
        let message = ["action": action]
        print("⌚ Sending action to phone: \(message)")
        
        if session.isReachable {
            session.sendMessage(message, replyHandler: { reply in
                print("⌚ ✅ iPhone replied: \(reply)")
                // Update local state from the reply
                DispatchQueue.main.async {
                    if let isGameStarted = reply["isGameStarted"] as? Bool {
                        print("⌚ Updating isGameStarted from reply: \(isGameStarted)")
                        self.isGameStarted = isGameStarted
                    }
                    if let team1Score = reply["team1Score"] as? Int {
                        print("⌚ Updating team1Score from reply: \(team1Score)")
                        self.team1Score = team1Score
                    }
                    if let team2Score = reply["team2Score"] as? Int {
                        print("⌚ Updating team2Score from reply: \(team2Score)")
                        self.team2Score = team2Score
                    }
                }
            }) { error in
                print("⌚ ❌ Error sending message to phone: \(error.localizedDescription)")
            }
        } else {
            print("⌚ ❌ iPhone not reachable, cannot send action")
        }
    }
    
    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("⌚ WC Session activation completed with state: \(activationState.rawValue)")
        print("⌚ iPhone reachable: \(session.isReachable)")
        DispatchQueue.main.async {
            self.isConnected = session.isReachable
        }
        if let error = error {
            print("⌚ WC Session activation failed with error: \(error.localizedDescription)")
        } else if session.isReachable {
            sendActionToPhone("requestState")
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("⌚ Connection status changed: \(session.isReachable ? "Connected" : "Disconnected")")
        DispatchQueue.main.async {
            self.isConnected = session.isReachable
        }
        if session.isReachable {
            sendActionToPhone("requestState")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        NSLog("⌚ Watch received application context from iPhone: \(applicationContext)")
        DispatchQueue.main.async {
            if let isGameStarted = applicationContext["isGameStarted"] as? Bool {
                NSLog("⌚ Updating isGameStarted to \(isGameStarted)")
                self.isGameStarted = isGameStarted
            }
            if let team1Score = applicationContext["team1Score"] as? Int {
                NSLog("⌚ Updating team1Score to \(team1Score)")
                self.team1Score = team1Score
            }
            if let team2Score = applicationContext["team2Score"] as? Int {
                NSLog("⌚ Updating team2Score to \(team2Score)")
                self.team2Score = team2Score
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        NSLog("⌚ Watch received message from iPhone: \(message)")
        DispatchQueue.main.async {
            if let isGameStarted = message["isGameStarted"] as? Bool {
                NSLog("⌚ Updating isGameStarted to \(isGameStarted)")
                self.isGameStarted = isGameStarted
            }
            if let team1Score = message["team1Score"] as? Int {
                NSLog("⌚ Updating team1Score to \(team1Score)")
                self.team1Score = team1Score
            }
            if let team2Score = message["team2Score"] as? Int {
                NSLog("⌚ Updating team2Score to \(team2Score)")
                self.team2Score = team2Score
            }
        }
    }
}
