//
//  GameModel.swift
//  Pickle
//
//  Created by Daniel Shemon on 12/13/25.
//

import Foundation
import WatchConnectivity

class GameModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var isGameStarted = false
    @Published var team1Score = 0
    @Published var team2Score = 0
    
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
        sendGameStateToWatch()
    }
    
    func resetGame() {
        isGameStarted = false
        team1Score = 0
        team2Score = 0
        sendGameStateToWatch()
    }
    
    func incrementTeam1Score() {
        team1Score += 1
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
        sendGameStateToWatch()
    }
    
    func decrementTeam2Score() {
        if team2Score > 0 {
            team2Score -= 1
        }
        sendGameStateToWatch()
    }
    
    private func sendGameStateToWatch() {
        guard let session = session, session.isReachable else { return }
        
        let gameState: [String: Any] = [
            "isGameStarted": isGameStarted,
            "team1Score": team1Score,
            "team2Score": team2Score
        ]
        
        session.sendMessage(gameState, replyHandler: nil) { error in
            print("Error sending message to watch: \(error.localizedDescription)")
        }
    }
    
    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WC Session activation failed with error: \(error.localizedDescription)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let action = message["action"] as? String {
                print("📱 Received action from watch: \(action)")
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
                    // Watch is requesting current state, send it
                    self.sendGameStateToWatch()
                default:
                    break
                }
            }
        }
    }
}
