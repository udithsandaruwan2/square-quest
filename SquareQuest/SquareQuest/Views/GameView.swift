//
//  GameView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-12.
//

import SwiftUI

/// Main game screen with all UI components
struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    let difficulty: Difficulty
    let isShuffleMode: Bool
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: GameViewModel, difficulty: Difficulty, isShuffleMode: Bool) {
        self.viewModel = viewModel
        self.difficulty = difficulty
        self.isShuffleMode = isShuffleMode
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Stats bar
            statsBar
            
            // Grid View
            GridView(
                cells: viewModel.cells,
                gridSize: viewModel.difficulty.gridSize,
                wrongMatchShake: viewModel.wrongMatchShake
            ) { cell in
                viewModel.selectCell(cell)
            }
            .frame(maxWidth: 500, maxHeight: 500)
            
            // Action buttons
            actionButtons
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle(viewModel.difficulty.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    // Timer (countdown with color warning)
                    Label(viewModel.formattedTime, systemImage: "timer")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.timerColor)
                    
                    // Moves
                    Label("\(viewModel.totalMoves)", systemImage: "hand.tap.fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .alert("✨ Round Complete!", isPresented: $viewModel.showRoundCompleteAlert) {
            Button("Next Round") {
                withAnimation {
                    viewModel.startNewRound()
                }
            }
            Button("End Session", role: .cancel) {
                viewModel.endSession()
                dismiss()
            }
        } message: {
            Text("Round \(viewModel.roundNumber) complete!\n\n+\(viewModel.roundBonus) Bonus Points\nTotal Score: \(viewModel.score)\n\nKeep going while time remains!")
        }
        .alert("⏰ Session Complete!", isPresented: $viewModel.showLossAlert) {
            Button("Play Again") {
                withAnimation {
                    viewModel.difficulty = difficulty
                    viewModel.isShuffleMode = isShuffleMode
                    viewModel.resetGame()
                }
            }
            Button("Back to Menu", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Time's up!\n\nFinal Score: \(viewModel.score)\nRounds Completed: \(viewModel.roundsCompleted)\nMoves: \(viewModel.totalMoves)\n\nGreat job!")
        }
        .onAppear {
            viewModel.difficulty = difficulty
            viewModel.isShuffleMode = isShuffleMode
            viewModel.setupGame()
        }
    }
    
    private var statsBar: some View {
        HStack(spacing: 12) {
            // Score
            StatCard(
                icon: "star.fill",
                value: "\(viewModel.score)",
                label: "Score",
                color: .yellow
            )
            
            // Round
            StatCard(
                icon: "arrow.triangle.2.circlepath",
                value: "R\(viewModel.roundNumber)",
                label: "Round",
                color: .purple
            )
            
            // Time
            StatCard(
                icon: "clock.fill",
                value: viewModel.formattedTime,
                label: "Time",
                color: viewModel.timeRemaining <= 30 ? .red : .blue
            )
            
            // Moves
            StatCard(
                icon: "hand.tap.fill",
                value: "\(viewModel.totalMoves)",
                label: "Moves",
                color: .orange
            )
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            // Shuffle button (if shuffle mode)
            if viewModel.isShuffleMode {
                Button(action: {
                    withAnimation {
                        viewModel.shuffleGrid()
                    }
                }) {
                    HStack {
                        Image(systemName: "shuffle")
                        Text("Shuffle")
                        Text("(\(viewModel.shufflesRemaining))")
                            .font(.caption)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        viewModel.shufflesRemaining > 0 ?
                        Color(red: 0.3, green: 0.4, blue: 0.9).gradient : Color.gray.gradient
                    )
                    .cornerRadius(12)
                }
                .disabled(viewModel.shufflesRemaining == 0)
            }
            
            // Reset button
            Button(action: {
                withAnimation {
                    viewModel.resetGame()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Reset")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.2, green: 0.4, blue: 0.8).gradient)
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}

/// Small stat card component
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3)
        )
    }
}

#Preview {
    NavigationStack {
        GameView(
            viewModel: GameViewModel(scoreManager: ScoreManager()),
            difficulty: .medium,
            isShuffleMode: true
        )
        .environmentObject(ScoreManager())
    }
}
