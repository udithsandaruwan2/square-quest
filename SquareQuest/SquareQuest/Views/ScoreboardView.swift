//
//  ScoreboardView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-22.
//

import SwiftUI

/// Displays saved game scores
struct ScoreboardView: View {
    @EnvironmentObject var scoreManager: ScoreManager
    @State private var selectedFilter: Difficulty? = nil
    
    var filteredScores: [GameScore] {
        if let filter = selectedFilter {
            return scoreManager.scores.filter { $0.difficulty == filter }
        }
        return scoreManager.scores
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Filter buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterButton(title: "All", isSelected: selectedFilter == nil) {
                            selectedFilter = nil
                        }
                        
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            FilterButton(
                                title: difficulty.rawValue,
                                isSelected: selectedFilter == difficulty
                            ) {
                                selectedFilter = difficulty
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                
                if filteredScores.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Scores Yet")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Play some games to see scores here!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    // Score list
                    List {
                        ForEach(Array(filteredScores.enumerated()), id: \.element.id) { index, score in
                            ScoreRow(score: score, rank: index + 1)
                                .listRowBackground(Color(.systemBackground))
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle("Scoreboard")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if !scoreManager.scores.isEmpty {
                Button(role: .destructive) {
                    scoreManager.clearAllScores()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}

/// Filter button for difficulty selection
struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(red: 0.2, green: 0.4, blue: 0.8) : Color(.systemGray5))
                )
        }
    }
}

/// Individual score row
struct ScoreRow: View {
    let score: GameScore
    let rank: Int
    
    var medalColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .clear
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            ZStack {
                Circle()
                    .fill(rank <= 3 ? medalColor.opacity(0.2) : Color.clear)
                    .frame(width: 40, height: 40)
                
                if rank <= 3 {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(medalColor)
                } else {
                    Text("\(rank)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Score details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(score.score) pts")
                        .font(.headline)
                    
                    if score.isShuffleMode {
                        Image(systemName: "shuffle")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                }
                
                HStack(spacing: 12) {
                    Label(score.difficulty.rawValue, systemImage: "square.grid.3x3")
                    Label(score.formattedTime, systemImage: "clock")
                    Label("\(score.totalMoves)", systemImage: "hand.tap")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                Text(score.formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        ScoreboardView()
            .environmentObject(ScoreManager())
    }
}
