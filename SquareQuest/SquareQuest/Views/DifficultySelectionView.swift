//
//  DifficultySelectionView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-22.
//

import SwiftUI

/// Screen to select difficulty and game mode
struct DifficultySelectionView: View {
    @EnvironmentObject var scoreManager: ScoreManager
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var isShuffleMode: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title
                VStack(spacing: 6) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 44))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                    
                    Text("Select Difficulty")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                
                // Difficulty cards
                VStack(spacing: 12) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        DifficultyCard(
                            difficulty: difficulty,
                            isSelected: selectedDifficulty == difficulty,
                            bestScore: scoreManager.getBestScore(for: difficulty)
                        ) {
                            selectedDifficulty = difficulty
                        }
                    }
                }
                .padding(.horizontal)
                
                // Shuffle mode toggle
                Toggle(isOn: $isShuffleMode) {
                    HStack {
                        Image(systemName: "shuffle")
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Shuffle Mode")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Get 3 shuffles per round")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .tint(Color(red: 0.3, green: 0.4, blue: 0.9))
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 5)
                )
                .padding(.horizontal)
                
                // Game info
                VStack(spacing: 2) {
                    Text("3 minute session • Complete multiple rounds")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Earn bonus points for each round!")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                
                // Start button
                NavigationLink(destination: {
                    let viewModel = GameViewModel(scoreManager: scoreManager)
                    viewModel.difficulty = selectedDifficulty
                    viewModel.isShuffleMode = isShuffleMode
                    return GameView(
                        viewModel: viewModel,
                        difficulty: selectedDifficulty,
                        isShuffleMode: isShuffleMode
                    )
                }()) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Game")
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.2, green: 0.4, blue: 0.8), Color(red: 0.3, green: 0.5, blue: 0.9)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("New Game")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Card showing difficulty information
struct DifficultyCard: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let bestScore: GameScore?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(difficulty.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                        }
                    }
                    
                    Text("\(difficulty.gridSize)×\(difficulty.gridSize) Grid")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let best = bestScore {
                        HStack(spacing: 12) {
                            Label("\(best.score)", systemImage: "star.fill")
                            Label(best.formattedTime, systemImage: "clock.fill")
                        }
                        .font(.caption)
                        .foregroundColor(.orange)
                    } else {
                        Text("No score yet")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Grid preview
                GridPreview(size: difficulty.gridSize)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.1) : Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color(red: 0.2, green: 0.4, blue: 0.8) : Color.clear, lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 5)
            )
        }
        .buttonStyle(.plain)
    }
}

/// Small grid preview
struct GridPreview: View {
    let size: Int
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<min(size, 3), id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<min(size, 3), id: \.self) { col in
                        Rectangle()
                            .fill(Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DifficultySelectionView()
            .environmentObject(ScoreManager())
    }
}
