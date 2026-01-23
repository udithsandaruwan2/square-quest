//
//  HowToPlayView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-22.
//

import SwiftUI

/// Game manual and instructions
struct HowToPlayView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Hero section
                VStack(spacing: 12) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                    
                    Text("How to Play")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Learn the basics and master Square Quest!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                
                // Game objective
                InstructionSection(
                    icon: "target",
                    title: "Game Objective",
                    color: .blue
                ) {
                    Text("Complete as many rounds as possible within the session time! Flip and match all colored card pairs. The more rounds you complete, the higher your score!")
                        .font(.subheadline)
                }
                
                // How to play
                InstructionSection(
                    icon: "hand.tap.fill",
                    title: "How to Play",
                    color: .green
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        StepView(number: 1, text: "Cards show briefly at the start, then flip face-down")
                        StepView(number: 2, text: "Tap a card to flip it and reveal its color")
                        StepView(number: 3, text: "Tap another card to find its match")
                        StepView(number: 4, text: "If they match, both stay face-up (+10 points)")
                        StepView(number: 5, text: "If not, both flip back face-down (try again!)")
                        StepView(number: 6, text: "Complete the round, then start the next!")
                    }
                }
                
                // Session Timer
                InstructionSection(
                    icon: "timer",
                    title: "Session Timer",
                    color: .red
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("You have 3 minutes per game session to complete as many rounds as you can!")
                            .font(.subheadline)
                        
                        BulletPoint(text: "Timer counts down continuously")
                        BulletPoint(text: "Complete rounds before time runs out")
                        BulletPoint(text: "Each round gives bonus points")
                        BulletPoint(text: "Timer turns red at 30 seconds!")
                    }
                }
                
                // Difficulty levels
                InstructionSection(
                    icon: "slider.horizontal.3",
                    title: "Difficulty Levels",
                    color: .orange
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        DifficultyInfo(level: "Easy", grid: "3×3 grid", pairs: "4 pairs", color: .green)
                        DifficultyInfo(level: "Medium", grid: "5×5 grid", pairs: "12 pairs", color: .orange)
                        DifficultyInfo(level: "Hard", grid: "7×7 grid", pairs: "24 pairs", color: .red)
                        
                        Text("Higher difficulty = More squares + Less time!")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Scoring system
                InstructionSection(
                    icon: "star.fill",
                    title: "Scoring",
                    color: .yellow
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        BulletPoint(text: "Each match: +10 points")
                        BulletPoint(text: "Round completion: +20 bonus × round number")
                        BulletPoint(text: "More rounds = Higher total score")
                        BulletPoint(text: "Wrong matches flash red (no penalty)")
                    }
                }
                
                // Shuffle mode
                InstructionSection(
                    icon: "shuffle",
                    title: "Shuffle Mode",
                    color: .purple
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("In Shuffle Mode, you get 3 shuffles to rearrange face-down cards.")
                            .font(.subheadline)
                        
                        BulletPoint(text: "Tap the shuffle button to rearrange cards")
                        BulletPoint(text: "Only unmatched cards shuffle")
                        BulletPoint(text: "Cards flip back face-down after shuffle")
                        BulletPoint(text: "Use wisely - you only get 3 per round!")
                        BulletPoint(text: "Perfect for when you're stuck!")
                    }
                }
                
                // Tips & tricks
                InstructionSection(
                    icon: "lightbulb.fill",
                    title: "Tips & Tricks",
                    color: .cyan
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        BulletPoint(text: "Watch carefully during the initial preview!")
                        BulletPoint(text: "Remember card positions as you reveal them")
                        BulletPoint(text: "Start with corners and edges for easier tracking")
                        BulletPoint(text: "Work systematically across the grid")
                        BulletPoint(text: "The timer tracks your speed - be quick but accurate!")
                        BulletPoint(text: "There's always one unpaired card")
                    }
                }
                
                // Game stats
                InstructionSection(
                    icon: "chart.bar.fill",
                    title: "Stats Tracked",
                    color: .indigo
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        StatInfo(icon: "star.fill", label: "Score", description: "Total points earned")
                        StatInfo(icon: "clock.fill", label: "Time", description: "How fast you completed")
                        StatInfo(icon: "hand.tap.fill", label: "Moves", description: "Number of attempts")
                        StatInfo(icon: "trophy.fill", label: "Rank", description: "Position on leaderboard")
                    }
                }
                
                // Ready to play
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                    
                    Text("Ready to Play!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Start a new game and put your skills to the test")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Player Manual")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Section container for instructions
struct InstructionSection<Content: View>: View {
    let icon: String
    let title: String
    let color: Color
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            content()
        }
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5)
        )
    }
}

/// Numbered step view
struct StepView: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.2))
                    .frame(width: 28, height: 28)
                
                Text("\(number)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
            }
            
            Text(text)
                .font(.subheadline)
        }
    }
}

/// Difficulty information row
struct DifficultyInfo: View {
    let level: String
    let grid: String
    let pairs: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(level)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
                .frame(width: 80, alignment: .leading)
            
            Text(grid)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            Text(pairs)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

/// Bullet point view
struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.subheadline)
                .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
            
            Text(text)
                .font(.subheadline)
        }
    }
}

/// Stat information row
struct StatInfo: View {
    let icon: String
    let label: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HowToPlayView()
    }
}
