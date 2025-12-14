//
//  ContentView.swift
//  Pickle
//
//  Created by Daniel Shemon on 12/12/25.
//

import SwiftUI

// Extension to handle orientation constraints
struct OrientationViewModifier: ViewModifier {
    let orientation: UIInterfaceOrientationMask
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                // This will help with orientation handling
            }
    }
}

extension View {
    func supportedOrientations(_ orientation: UIInterfaceOrientationMask) -> some View {
        self.modifier(OrientationViewModifier(orientation: orientation))
    }
}

struct ContentView: View {
    @StateObject private var gameModel = GameModel()
    @State private var isLandscape = false
    
    var body: some View {
        ZStack {
            if !gameModel.isGameStarted {
                // Start screen - portrait orientation
                VStack(spacing: 30) {
                    Text("Pickleball Score")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        gameModel.startGame()
                        isLandscape = true
                        // Force landscape orientation when game starts
                        DispatchQueue.main.async {
                            let value = UIInterfaceOrientation.landscapeLeft.rawValue
                            UIDevice.current.setValue(value, forKey: "orientation")
                        }
                    }) {
                        Text("Start Game")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Game screen - Light Mode Courtside Design
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
                                    isLandscape = false
                                    DispatchQueue.main.async {
                                        let value = UIInterfaceOrientation.portrait.rawValue
                                        UIDevice.current.setValue(value, forKey: "orientation")
                                    }
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            // Set initial orientation based on game state
            if gameModel.isGameStarted {
                isLandscape = true
                DispatchQueue.main.async {
                    let value = UIInterfaceOrientation.landscapeLeft.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
