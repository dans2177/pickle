//
//  GameModel.swift
//  Picklewatch
//
//  Created by Daniel Shemon on 12/13/25.
//

import Foundation
import WatchConnectivity

class GameModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var isGameStarted = false
    @Published var team1Score = 0
    @Published var team2Score = 0
    @Published var isWatchConnected = false
    @Published var gameWinner: String?
    @Published var showingWinAlert = false
    
    private var session: WCSession?
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func startGame() {
        isGameStarted = true
        team1Score = 0
        team2Score = 0
        gameWinner = nil
        showingWinAlert = false
        sendGameStateToWatch()
    }
    
    func resetGame() {
        isGameStarted = false
        team1Score = 0
        team2Score = 0
        gameWinner = nil
        showingWinAlert = false
        sendGameStateToWatch()
    }
    
    func incrementTeam1Score() {
        team1Score += 1
        checkForWin()
        sendGameStateToWatch()
    }
    
    func decrementTeam1Score() {
        if team1Score > 0 {
            team1Score -= 1
        }
        sendGameStateToWatch()
    }
    
    func incrementTeam2Score() {
        team2Score += 1
        checkForWin()
        sendGameStateToWatch()
    }
    
    func decrementTeam2Score() {
        if team2Score > 0 {
            team2Score -= 1
        }
        sendGameStateToWatch()
    }
    
    // MARK: - Win Detection Logic
    private func checkForWin() {
        // Win at 11 points with 2-point lead
        if team1Score >= 11 && team1Score - team2Score >= 2 {
            gameWinner = "Team 1"
            showingWinAlert = true
        } else if team2Score >= 11 && team2Score - team1Score >= 2 {
            gameWinner = "Team 2"
            showingWinAlert = true
        }
    }
    
    private func sendGameStateToWatch() {
        guard let session = session, session.isReachable else {
            print("Watch session not reachable - activation state: \(session?.activationState.rawValue ?? -1)")
            return
        }
        
        let gameState: [String: Any] = [
            "isGameStarted": isGameStarted,
            "team1Score": team1Score,
            "team2Score": team2Score
        ]
        
        print("Sending game state to watch: \(gameState)")
        
        session.sendMessage(gameState, replyHandler: nil) { error in
            print("Error sending message to watch: \(error.localizedDescription)")
        }
    }
    
    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("iPhone WC Session activation completed with state: \(activationState.rawValue)")
        DispatchQueue.main.async {
            self.isWatchConnected = session.isReachable
        }
        if let error = error {
            print("WC Session activation failed with error: \(error.localizedDescription)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("📱 iPhone WC Session became inactive")
        DispatchQueue.main.async {
            self.isWatchConnected = false
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("📱 iPhone WC Session deactivated")
        DispatchQueue.main.async {
            self.isWatchConnected = false
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        NSLog("📱 iPhone WC Session reachability changed: \(session.isReachable)")
        DispatchQueue.main.async {
            self.isWatchConnected = session.isReachable
        }
        // Send current state when watch becomes reachable
        if session.isReachable {
            sendGameStateToWatch()
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("📱 iPhone received application context from watch: \(applicationContext)")
        DispatchQueue.main.async {
            if let isGameStarted = applicationContext["isGameStarted"] as? Bool {
                self.isGameStarted = isGameStarted
            }
            if let team1Score = applicationContext["team1Score"] as? Int {
                self.team1Score = team1Score
            }
            if let team2Score = applicationContext["team2Score"] as? Int {
                self.team2Score = team2Score
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("📱 iPhone received message from watch: \(message)")
        DispatchQueue.main.async {
            if let action = message["action"] as? String {
                print("📱 Processing action: \(action)")
                switch action {
                case "incrementTeam1":
                    self.incrementTeam1Score()
                case "decrementTeam1":
                    self.decrementTeam1Score()
                case "incrementTeam2":
                    self.incrementTeam2Score()
                case "decrementTeam2":
                    self.decrementTeam2Score()
                case "startGame":
                    self.startGame()
                case "resetGame":
                    self.resetGame()
                case "requestState":
                    self.sendGameStateToWatch()
                default:
                    print("📱 Unknown action: \(action)")
                    break
                }
                
                // Send updated state back to watch as reply
                let gameState: [String: Any] = [
                    "isGameStarted": self.isGameStarted,
                    "team1Score": self.team1Score,
                    "team2Score": self.team2Score
                ]
                print("📱 Replying to watch with updated state: \(gameState)")
                replyHandler(gameState)
            }
        }
    }
}
