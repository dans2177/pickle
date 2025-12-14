# Pickleball Score Tracker

## Overview
This project consists of two apps:
1. **Pickle** - iPhone app for scoring pickleball games
2. **Picklewatch** - Apple Watch companion app

## Features

### iPhone App (Pickle)
- Simple "Start Game" button to begin a new game
- Large, easy-to-read scores for Team 1 and Team 2
- Plus/minus buttons to increment/decrement scores for each team
- Reset game functionality
- Connects to Apple Watch for remote scoring

### Apple Watch App (Picklewatch)
- Shows "Start Game" button when no game is active
- Displays current scores with small +/- buttons for quick scoring
- Syncs with iPhone app in real-time
- Compact interface optimized for watch screen

## How to Use

1. **Starting a Game:**
   - Open the iPhone app and tap "Start Game"
   - Or use the watch app to start a game remotely

2. **Scoring:**
   - Use the large +/- buttons on iPhone for clear visibility
   - Use the compact +/- buttons on Apple Watch for quick updates
   - Scores sync automatically between devices

3. **Reset:**
   - Tap "Reset Game" button on either device to start over

## Setup Requirements

To build and run these apps:

1. Open the respective Xcode projects
2. Set up a development team in the Signing & Capabilities section
3. Build and install on your iPhone and Apple Watch
4. Make sure both devices are paired and connected

## Technical Details

- Uses WatchConnectivity framework for communication between devices
- SwiftUI interface for both iPhone and Watch apps
- Real-time score synchronization
- Handles connection states gracefully

The apps will automatically connect when both are running on paired devices.