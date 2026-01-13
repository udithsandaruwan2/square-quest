//
//  GameView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-12.
//

import SwiftUI

/// Main game screen with all UI components
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Square Quest")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(
                    Color.black
                )
            
            // Difficulty Picker
            difficultyPicker
            
            // Score View
            scoreView
            
            // Grid View
            GridView(
                cells: viewModel.cells,
                gridSize: viewModel.difficulty.gridSize
            ) { cell in
                viewModel.selectCell(cell)
            }
            .frame(maxWidth: 500, maxHeight: 500)
            
            // Reset Button
            resetButton
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
        .alert("🎉 Congratulations!", isPresented: $viewModel.showWinAlert) {
            Button("Play Again") {
                withAnimation {
                    viewModel.resetGame()
                }
            }
            Button("Change Difficulty", role: .cancel) {
                // Alert dismisses automatically
            }
        } message: {
            Text("You won with a score of \(viewModel.score)!\n\nAll pairs matched successfully. 🏆")
        }
    }
    
    private var difficultyPicker: some View {
        VStack(spacing: 8) {
            Text("Difficulty")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Picker("Difficulty", selection: $viewModel.difficulty) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Text(difficulty.rawValue).tag(difficulty)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.difficulty) { _, newValue in
                viewModel.changeDifficulty(to: newValue)
            }
        }
        .padding(.horizontal)
    }
    
    private var scoreView: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("Score")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(viewModel.score)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Divider()
                .frame(height: 40)
            
            VStack(spacing: 4) {
                Text("Grid Size")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(viewModel.difficulty.gridSize)×\(viewModel.difficulty.gridSize)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private var resetButton: some View {
        Button(action: {
            withAnimation {
                viewModel.resetGame()
            }
        }) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Reset Game")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Color.black
            )
            .cornerRadius(12)
            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal)
    }
}

#Preview {
    GameView()
}
