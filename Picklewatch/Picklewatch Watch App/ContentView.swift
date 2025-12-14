//
//  ContentView.swift
//  Picklewatch Watch App
//
//  Created by Daniel Shemon on 12/13/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameModel: WatchGameModel
    @State private var showingWinAlert = false
    @State private var winner = ""
    
    var body: some View {
        ZStack {
            // Clean dark background
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.2), Color.blue.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if !gameModel.isConnected {
                // Not connected screen
                notConnectedScreen
            } else {
                if !gameModel.isGameStarted {
                    // Pre-game UI
                    preGameSection
                } else {
                    // Game active UI
                    gameActiveSection
                }
            }
        }
        .alert("Game Over!", isPresented: $showingWinAlert) {
            Button("New Game") {
                gameModel.sendActionToPhone("resetGame")
            }
            Button("OK") { }
        } message: {
            Text("\(winner) wins!")
        }
    }
    
    // MARK: - Not Connected Screen
    private var notConnectedScreen: some View {
        VStack(spacing: 10) {
            Image(systemName: "iphone.slash")
                .font(.system(size: 28))
                .foregroundColor(.white.opacity(0.6))
            
            Text("Not Connected")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Open app on iPhone")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Pre-Game Section
    private var preGameSection: some View {
        VStack(spacing: 15) {
            // Simple title
            Text("PICKLEBALL")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .tracking(2)
                .foregroundColor(.white)
            
            // Start button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    gameModel.sendActionToPhone("startGame")
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(Color.green, lineWidth: 2)
                        )
                    
                    VStack(spacing: 2) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("START")
                            .font(.system(size: 8, weight: .bold))
                            .tracking(1)
                    }
                    .foregroundColor(.green)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Game Active Section
    private var gameActiveSection: some View {
        VStack(spacing: 10) {
            // Team 1
            teamScoreCard(
                teamName: "TEAM 1",
                score: gameModel.team1Score,
                color: .cyan,
                onIncrement: { incrementTeam1() },
                onDecrement: { decrementTeam1() }
            )
            
            // VS Divider
            HStack {
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(height: 1)
                
                Text("VS")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.horizontal, 8)
                
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(height: 1)
            }
            
            // Team 2
            teamScoreCard(
                teamName: "TEAM 2",
                score: gameModel.team2Score,
                color: .orange,
                onIncrement: { incrementTeam2() },
                onDecrement: { decrementTeam2() }
            )
            
            // Reset button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    gameModel.sendActionToPhone("resetGame")
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 9, weight: .semibold))
                    
                    Text("RESET")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(0.5)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.red.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color.red, lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Team Score Card
    private func teamScoreCard(
        teamName: String,
        score: Int,
        color: Color,
        onIncrement: @escaping () -> Void,
        onDecrement: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 8) {
            // Team name
            Text(teamName)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .tracking(1)
                .foregroundColor(color)
            
            // Digital scoreboard display
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color, lineWidth: 2)
                            .shadow(color: color.opacity(0.3), radius: 4)
                    )
                    .frame(width: 90, height: 50)
                
                Text("\(score)")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
                    .shadow(color: color.opacity(0.5), radius: 3)
            }
            
            // Control buttons
            HStack(spacing: 15) {
                Button(action: {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        onDecrement()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.red, lineWidth: 2)
                            )
                        
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.red)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        onIncrement()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.green, lineWidth: 2)
                            )
                        
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Score Management
    private func incrementTeam1() {
        gameModel.sendActionToPhone("incrementTeam1")
    }
    
    private func decrementTeam1() {
        gameModel.sendActionToPhone("decrementTeam1")
    }
    
    private func incrementTeam2() {
        gameModel.sendActionToPhone("incrementTeam2")
    }
    
    private func decrementTeam2() {
        gameModel.sendActionToPhone("decrementTeam2")
    }
}

#Preview {
    ContentView()
}
