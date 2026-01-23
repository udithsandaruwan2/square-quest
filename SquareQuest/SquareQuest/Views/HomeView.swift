//
//  HomeView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-22.
//

import SwiftUI

/// Main menu/home screen
struct HomeView: View {
    @EnvironmentObject var scoreManager: ScoreManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient - matches other screens
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Game title
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.15))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "square.grid.3x3.fill")
                                .font(.system(size: 56))
                                .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                        }
                        
                        VStack(spacing: 8) {
                            Text("Square Quest")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                            
                            Text("Match the Colors")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Menu buttons
                    VStack(spacing: 16) {
                        NavigationLink(destination: DifficultySelectionView()) {
                            MenuButton(icon: "play.fill", title: "Start Game", isPrimary: true)
                        }
                        
                        NavigationLink(destination: ScoreboardView()) {
                            MenuButton(icon: "trophy.fill", title: "Scoreboard", isPrimary: false)
                        }
                        
                        NavigationLink(destination: HowToPlayView()) {
                            MenuButton(icon: "book.fill", title: "How to Play", isPrimary: false)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    // Best score
                    if let bestScore = scoreManager.getBestScore() {
                        VStack(spacing: 8) {
                            Text("Your Best")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 16) {
                                Label("\(bestScore.score)", systemImage: "star.fill")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Label(bestScore.difficulty.rawValue.capitalized, systemImage: "square.grid.3x3")
                                    .font(.subheadline)
                                
                                Label(bestScore.formattedTime, systemImage: "clock.fill")
                                    .font(.subheadline)
                                    .monospacedDigit()
                            }
                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.1), radius: 5)
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    } else {
                        Spacer()
                            .frame(height: 20)
                    }
                }
            }
        }
    }
}

/// Reusable menu button component
struct MenuButton: View {
    let icon: String
    let title: String
    let isPrimary: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 28)
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .foregroundColor(isPrimary ? .white : .primary)
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isPrimary ? 
                    LinearGradient(
                        colors: [Color(red: 0.2, green: 0.4, blue: 0.8), Color(red: 0.3, green: 0.5, blue: 0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) : 
                    LinearGradient(
                        colors: [Color(.systemBackground), Color(.systemBackground)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: isPrimary ? Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.3) : .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(ScoreManager())
}
