//
//  ContentView.swift
//  Picklewatch
//
//  Created by Daniel Shemon on 12/13/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameModel: GameModel
    @State private var showingCelebration = false
    
    var body: some View {
        Group {
            if gameModel.isGameStarted {
                // LANDSCAPE GAME VIEW - HORIZONTAL SCOREBOARD
                landscapeGameView
                    .ignoresSafeArea()
            } else {
                // PORTRAIT MENU VIEW
                portraitMenuView
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            updateOrientation()
        }
        .onChange(of: gameModel.isGameStarted) { _, isStarted in
            updateOrientation()
        }
    }
    
    private func updateOrientation() {
        print("🔄 Updating orientation - Game started: \(gameModel.isGameStarted)")
        if gameModel.isGameStarted {
            AppDelegate.orientationLock = .landscape
        } else {
            AppDelegate.orientationLock = .portrait
        }
        
        // Force orientation change
        DispatchQueue.main.async {
            let orientation: UIInterfaceOrientation = gameModel.isGameStarted ? .landscapeLeft : .portrait
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            print("🔄 Forced orientation to: \(orientation)")
        }
    }
    
    // MARK: - Landscape Game View (LIGHT MODE COURTSIDE)
    private var landscapeGameView: some View {
        GeometryReader { geometry in
            ZStack {
                // Clean white background for outdoor visibility
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Simple header
                    VStack(spacing: 8) {
                        Text("PICKLEBALL")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.black)
                            .tracking(2)
                        
                        Text("LIVE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.green)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.15))
                            .cornerRadius(12)
                    }
                    .padding(.top, 15)
                    
                    Spacer()
                    
                    // Main scoreboard - side by side
                    HStack(spacing: 15) {
                        // Team 1 Section
                        VStack(spacing: 18) {
                            // Team name
                            Text("TEAM 1")
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(.blue)
                                .tracking(1)
                            
                            // Score display - ultra high contrast
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 170, height: 130)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.blue, lineWidth: 6)
                                    )
                                
                                Text("\(gameModel.team1Score)")
                                    .font(.system(size: 80, weight: .black, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            
                            // Control buttons
                            HStack(spacing: 20) {
                                Button(action: {
                                    gameModel.decrementTeam1Score()
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.gray.opacity(0.15))
                                            .frame(width: 65, height: 65)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(Color.gray, lineWidth: 3)
                                            )
                                        
                                        Text("−")
                                            .font(.system(size: 40, weight: .bold))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Button(action: {
                                    gameModel.incrementTeam1Score()
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.blue)
                                            .frame(width: 65, height: 65)
                                        
                                        Text("+")
                                            .font(.system(size: 40, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Center divider & reset
                        VStack(spacing: 25) {
                            // VS separator
                            VStack(spacing: 4) {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 8, height: 8)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 3, height: 100)
                                
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 8, height: 8)
                            }
                            
                            // Reset button
                            Button(action: {
                                gameModel.resetGame()
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 18, weight: .bold))
                                    Text("RESET")
                                        .font(.system(size: 10, weight: .bold))
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                            }
                        }
                        .frame(width: 60)
                        
                        // Team 2 Section
                        VStack(spacing: 18) {
                            // Team name
                            Text("TEAM 2")
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(.red)
                                .tracking(1)
                            
                            // Score display - ultra high contrast
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 170, height: 130)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 6)
                                    )
                                
                                Text("\(gameModel.team2Score)")
                                    .font(.system(size: 80, weight: .black, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            
                            // Control buttons
                            HStack(spacing: 20) {
                                Button(action: {
                                    gameModel.decrementTeam2Score()
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.gray.opacity(0.15))
                                            .frame(width: 65, height: 65)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(Color.gray, lineWidth: 3)
                                            )
                                        
                                        Text("−")
                                            .font(.system(size: 40, weight: .bold))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Button(action: {
                                    gameModel.incrementTeam2Score()
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.red)
                                            .frame(width: 65, height: 65)
                                        
                                        Text("+")
                                            .font(.system(size: 40, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Bottom info - minimal
                    Text("First to 11 • Win by 2")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.bottom, 15)
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Landscape Buttons
    private func landscapeButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(color, lineWidth: 3)
                    )
                
                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
        }
    }
    
    private func landscapeActionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(color.opacity(0.2))
                    .frame(width: 120, height: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(color, lineWidth: 3)
                    )
                
                VStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(title)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(color)
            }
        }
    }
    
    // MARK: - Portrait Menu View
    private var portraitMenuView: some View {
        GeometryReader { geometry in
            ZStack {
                // Dynamic gradient background
                LinearGradient(
                    colors: [Color.orange.opacity(0.2), Color.pink.opacity(0.3), Color.purple.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        headerSection
                            .padding(.top, 20)
                        
                        // Pre-Game UI
                        preGameSection(geometry: geometry)
                        
                        Spacer(minLength: 30)
                        
                        // Connection Status
                        connectionStatusSection
                    }
                }
                
                // Celebration overlay
                if showingCelebration {
                    celebrationOverlay
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "tennis.racket")
                    .font(.title2)
                    .foregroundStyle(.linearGradient(colors: [.orange, .pink], startPoint: .leading, endPoint: .trailing))
                
                Text("PICKLEBALL")
                    .font(.title)
                    .fontWeight(.heavy)
                    .tracking(2)
                    .foregroundStyle(.linearGradient(colors: [.orange, .pink], startPoint: .leading, endPoint: .trailing))
                
                Image(systemName: "tennis.racket")
                    .font(.title2)
                    .foregroundStyle(.linearGradient(colors: [.orange, .pink], startPoint: .leading, endPoint: .trailing))
                    .scaleEffect(x: -1, y: 1)
            }
            
            Text(gameModel.isGameStarted ? "GAME IN PROGRESS" : "READY TO PLAY")
                .font(.caption)
                .fontWeight(.semibold)
                .tracking(1.5)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    // MARK: - Pre-Game Section
    private func preGameSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 40) {
            // Welcome message
            VStack(spacing: 16) {
                Text("Let's Play!")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                
                Text("Tap to start your pickleball match")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            
            // Giant start button
            Button(action: {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    gameModel.startGame()
                    showingCelebration = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showingCelebration = false
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.green, .teal, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)
                        .shadow(color: .green.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    VStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 40, weight: .bold))
                        
                        Text("START")
                            .font(.title2)
                            .fontWeight(.black)
                            .tracking(1)
                    }
                    .foregroundColor(.white)
                }
            }
            .scaleEffect(1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: gameModel.isGameStarted)
            
            // Stats preview
            statsPreview
        }
        .padding(.horizontal, 30)
    }
    
    // MARK: - Game Active Section
    private func gameActiveSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 30) {
            // Score Display
            scoreDisplaySection
                .padding(.top, 20)
            
            // Control Buttons
            controlButtonsSection
            
            // Action Buttons
            actionButtonsSection
        }
        .padding(.horizontal, 25)
    }
    
    // MARK: - Score Display
    private var scoreDisplaySection: some View {
        VStack(spacing: 25) {
            // Team 1
            teamScoreCard(
                teamName: "TEAM 1",
                score: gameModel.team1Score,
                color: .blue,
                onIncrement: { gameModel.incrementTeam1Score() },
                onDecrement: { gameModel.decrementTeam1Score() }
            )
            
            // VS Divider
            HStack {
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(height: 1)
                
                Text("VS")
                    .font(.title3)
                    .fontWeight(.black)
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 20)
                
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal, 20)
            
            // Team 2
            teamScoreCard(
                teamName: "TEAM 2",
                score: gameModel.team2Score,
                color: .orange,
                onIncrement: { gameModel.incrementTeam2Score() },
                onDecrement: { gameModel.decrementTeam2Score() }
            )
        }
    }
    
    // MARK: - Team Score Card
    private func teamScoreCard(
        teamName: String,
        score: Int,
        color: Color,
        onIncrement: @escaping () -> Void,
        onDecrement: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 15) {
            // Team Name
            Text(teamName)
                .font(.headline)
                .fontWeight(.black)
                .tracking(1.5)
                .foregroundColor(color)
            
            // Score Display
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    colors: [color.opacity(0.8), color.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .frame(height: 120)
                
                VStack(spacing: 8) {
                    Text("\(score)")
                        .font(.system(size: 56, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [color, color.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: score)
                    
                    Text("POINTS")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .tracking(1)
                        .foregroundColor(.secondary)
                }
            }
            
            // Control Buttons
            HStack(spacing: 20) {
                controlButton(
                    icon: "minus.circle.fill",
                    color: .red,
                    action: onDecrement
                )
                
                controlButton(
                    icon: "plus.circle.fill",
                    color: .green,
                    action: onIncrement
                )
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Control Button
    private func controlButton(
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                action()
            }
        }) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(0.6), lineWidth: 2)
                    )
                
                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
        }
        .scaleEffect(1.0)
        .buttonStyle(SpringButtonStyle())
    }
    
    // MARK: - Control Buttons Section
    private var controlButtonsSection: some View {
        HStack(spacing: 30) {
            // Pause/Resume (placeholder)
            actionButton(
                title: "PAUSE",
                icon: "pause.circle.fill",
                color: .orange,
                action: { }
            )
            
            // Reset Game
            actionButton(
                title: "RESET",
                icon: "arrow.clockwise.circle.fill",
                color: .red,
                action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        gameModel.resetGame()
                    }
                }
            )
        }
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 20) {
            // Quick Actions
            VStack(spacing: 12) {
                Text("QUICK ACTIONS")
                    .font(.caption)
                    .fontWeight(.black)
                    .tracking(1.5)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 15) {
                    quickActionButton(title: "TIMEOUT", icon: "hand.raised.fill", color: .yellow)
                    quickActionButton(title: "REVIEW", icon: "eye.fill", color: .purple)
                    quickActionButton(title: "STATS", icon: "chart.bar.fill", color: .teal)
                }
            }
        }
    }
    
    // MARK: - Action Button
    private func actionButton(
        title: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.6), lineWidth: 2)
                        )
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .tracking(0.5)
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(SpringButtonStyle())
    }
    
    // MARK: - Quick Action Button
    private func quickActionButton(title: String, icon: String, color: Color) -> some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .tracking(0.5)
            }
            .foregroundColor(color)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(color.opacity(0.4), lineWidth: 1)
            )
        }
        .buttonStyle(SpringButtonStyle())
    }
    
    // MARK: - Stats Preview
    private var statsPreview: some View {
        VStack(spacing: 16) {
            Text("RECENT MATCHES")
                .font(.caption)
                .fontWeight(.black)
                .tracking(1.5)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                statCard(title: "WINS", value: "12", color: .green)
                statCard(title: "MATCHES", value: "18", color: .blue)
                statCard(title: "STREAK", value: "3", color: .orange)
            }
        }
    }
    
    // MARK: - Stat Card
    private func statCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .tracking(1)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Connection Status
    private var connectionStatusSection: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(gameModel.isWatchConnected ? .green : .red)
                .frame(width: 8, height: 8)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: gameModel.isWatchConnected)
            
            Text("Apple Watch")
                .font(.caption)
                .fontWeight(.medium)
            
            Text(gameModel.isWatchConnected ? "Connected" : "Disconnected")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(gameModel.isWatchConnected ? .green : .red)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Celebration Overlay
    private var celebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "party.popper.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.linearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .rotationEffect(.degrees(showingCelebration ? 360 : 0))
                    .animation(.easeInOut(duration: 1.0), value: showingCelebration)
                
                Text("GAME ON!")
                    .font(.title)
                    .fontWeight(.black)
                    .tracking(3)
                    .foregroundStyle(.linearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing))
                    .scaleEffect(showingCelebration ? 1.2 : 1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showingCelebration)
            }
        }
        .opacity(showingCelebration ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: showingCelebration)
    }
}

// MARK: - Spring Button Style
struct SpringButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
        .environmentObject(GameModel())
}
