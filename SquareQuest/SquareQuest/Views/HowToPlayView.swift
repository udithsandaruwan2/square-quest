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
                    Text("Match pairs of colored squares to score points. Find all matching pairs before the countdown timer reaches zero!")
                }
                
                // How to play
                InstructionSection(
                    icon: "hand.tap.fill",
                    title: "How to Play",
                    color: .green
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        StepView(number: 1, text: "Tap on any square to reveal its color")
                        StepView(number: 2, text: "Tap another square to find its match")
                        StepView(number: 3, text: "If colors match, you score 10 points!")
                        StepView(number: 4, text: "If they don't match, squares flash red and shake")
                        StepView(number: 5, text: "Complete all pairs before time runs out!")
                    }
                }
                
                // Countdown Timer
                InstructionSection(
                    icon: "timer",
                    title: "Countdown Timer",
                    color: .red
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("You play against the clock! Each difficulty has a time limit:")
                            .font(.subheadline)
                        
                        DifficultyInfo(level: "Easy", grid: "3×3", pairs: "2 minutes", color: .green)
                        DifficultyInfo(level: "Medium", grid: "5×5", pairs: "3 minutes", color: .orange)
                        DifficultyInfo(level: "Hard", grid: "7×7", pairs: "5 minutes", color: .red)
                        
                        Text("The timer turns orange at 1 minute and red at 30 seconds!")
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
                        BulletPoint(text: "Faster completion = Better rank")
                        BulletPoint(text: "Fewer moves = Higher efficiency")
                        BulletPoint(text: "Wrong matches flash red but don't penalize score")
                    }
                }
                
                // Shuffle mode
                InstructionSection(
                    icon: "shuffle",
                    title: "Shuffle Mode",
                    color: .purple
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("In Shuffle Mode, you get 3 shuffles to rearrange unmatched squares.")
                            .font(.subheadline)
                        
                        BulletPoint(text: "Tap the shuffle button to rearrange")
                        BulletPoint(text: "Only unmatched squares shuffle")
                        BulletPoint(text: "Use wisely - you only get 3!")
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
                        BulletPoint(text: "Remember square positions after seeing them")
                        BulletPoint(text: "Start with corners and edges")
                        BulletPoint(text: "Work systematically across the grid")
                        BulletPoint(text: "The timer tracks your speed - be quick!")
                        BulletPoint(text: "There's always one unpaired square")
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
