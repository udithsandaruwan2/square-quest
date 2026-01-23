//
//  GameViewModel.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-12.
//

import SwiftUI
import Combine

/// Manages the game state and logic
class GameViewModel: ObservableObject {
    @Published var difficulty: Difficulty = .easy
    @Published var cells: [Cell] = []
    @Published var score: Int = 0
    @Published var selectedCells: [UUID] = []
    @Published var showWinAlert: Bool = false
    @Published var showLossAlert: Bool = false
    @Published var showRoundCompleteAlert: Bool = false
    @Published var timeRemaining: Int = 0
    @Published var totalMoves: Int = 0
    @Published var roundNumber: Int = 1
    @Published var roundsCompleted: Int = 0
    @Published var isShuffleMode: Bool = false
    @Published var shufflesRemaining: Int = 3
    @Published var wrongMatchShake: Bool = false
    
    private var timer: Timer?
    private var scoreManager: ScoreManager?
    private let sessionTimeLimit: Int = 180  // 3 minutes for entire session
    
    var roundBonus: Int {
        roundNumber * 20  // Bonus points for each round completed
    }
    
    init(scoreManager: ScoreManager? = nil) {
        self.scoreManager = scoreManager
        setupGame()
    }
    
    /// Sets up a new game session with the current difficulty
    func setupGame() {
        score = 0
        selectedCells = []
        showWinAlert = false
        showLossAlert = false
        showRoundCompleteAlert = false
        timeRemaining = sessionTimeLimit
        totalMoves = 0
        roundNumber = 1
        roundsCompleted = 0
        shufflesRemaining = isShuffleMode ? 3 : 0
        wrongMatchShake = false
        cells = generateCells()
        startTimer()
    }
    
    /// Starts a new round (keeps timer and total score)
    func startNewRound() {
        selectedCells = []
        showRoundCompleteAlert = false
        roundNumber += 1
        shufflesRemaining = isShuffleMode ? 3 : 0
        wrongMatchShake = false
        cells = generateCells()
    }
    
    /// Generates cells with matching pairs of colors
    private func generateCells() -> [Cell] {
        let totalCells = difficulty.totalCells
        let colorCount = difficulty.colorCount
        
        // Define available colors
        let availableColors: [Color] = [
            .red, .blue, .green, .yellow, .orange,
            .purple, .pink, .cyan, .mint, .indigo,
            .teal, .brown
        ]
        
        var cellColors: [Color] = []
        
        // Create pairs of colors
        for i in 0..<colorCount {
            let color = availableColors[i % availableColors.count]
            cellColors.append(color)
            // Add a second one for the pair (except for odd total cells - last one is single)
            if cellColors.count < totalCells {
                cellColors.append(color)
            }
        }
        
        // Shuffle the colors
        cellColors.shuffle()
        
        // Create cells with shuffled colors
        return cellColors.map { color in
            Cell(color: color)
        }
    }
    
    /// Handles cell selection logic
    func selectCell(_ cell: Cell) {
        // Don't select if already matched
        guard !cell.isMatched else { return }
        
        // Find the cell index
        guard let index = cells.firstIndex(where: { $0.id == cell.id }) else { return }
        
        // If this cell is already selected, deselect it
        if selectedCells.contains(cell.id) {
            cells[index].isSelected = false
            selectedCells.removeAll { $0 == cell.id }
            return
        }
        
        // If we already have 2 cells selected, reset them first
        if selectedCells.count >= 2 {
            resetSelection()
        }
        
        // Select the current cell
        cells[index].isSelected = true
        selectedCells.append(cell.id)
        
        // Increment move counter when selecting second cell
        if selectedCells.count == 2 {
            totalMoves += 1
        }
        
        // If we now have 2 cells selected, check for a match
        if selectedCells.count == 2 {
            checkForMatch()
        }
    }
    
    /// Checks if the two selected cells match
    private func checkForMatch() {
        guard selectedCells.count == 2 else { return }
        
        // Get the two selected cells
        guard let firstIndex = cells.firstIndex(where: { $0.id == selectedCells[0] }),
              let secondIndex = cells.firstIndex(where: { $0.id == selectedCells[1] }) else {
            return
        }
        
        let firstCell = cells[firstIndex]
        let secondCell = cells[secondIndex]
        
        // Check if colors match
        if firstCell.color == secondCell.color {
            // Match found!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.cells[firstIndex].isMatched = true
                self.cells[secondIndex].isMatched = true
                self.cells[firstIndex].isSelected = false
                self.cells[secondIndex].isSelected = false
                self.selectedCells.removeAll()
                self.score += 10
                
                // Check if game is complete
                self.checkGameComplete()
            }
        } else {
            // No match - show error feedback with shake animation
            withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                wrongMatchShake = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.wrongMatchShake = false
            }
            
            // Reset after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.resetSelection()
            }
        }
    }
    
    /// Resets the current selection
    private func resetSelection() {
        for cellId in selectedCells {
            if let index = cells.firstIndex(where: { $0.id == cellId }) {
                cells[index].isSelected = false
            }
        }
        selectedCells.removeAll()
    }
    
    /// Checks if round is complete (all pairs matched)
    private func checkGameComplete() {
        // Count how many cells are matched
        let matchedCount = cells.filter { $0.isMatched }.count
        
        // Since we have odd number of cells (9, 25, 49), there's always 1 leftover
        // Round complete when all pairs are matched (total cells - 1)
        let totalCells = difficulty.totalCells
        let maxMatchable = totalCells - 1
        
        if matchedCount == maxMatchable {
            // Round complete! Add bonus and start next round
            score += roundBonus
            roundsCompleted += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showRoundCompleteAlert = true
            }
        }
    }
    
    /// Called when session ends (time runs out or user chooses to end)
    func endSession() {
        stopTimer()
        
        // Save final score if score manager exists
        if let scoreManager = scoreManager {
            let gameScore = GameScore(
                score: score,
                difficulty: difficulty,
                timeInSeconds: sessionTimeLimit - timeRemaining,
                matchedPairs: roundsCompleted,
                totalMoves: totalMoves,
                isShuffleMode: isShuffleMode
            )
            scoreManager.saveScore(gameScore)
        }
        
        showLossAlert = true
    }
    
    /// Changes the difficulty and restarts the game
    func changeDifficulty(to newDifficulty: Difficulty) {
        stopTimer()
        difficulty = newDifficulty
        setupGame()
    }
    
    /// Resets the game with current difficulty
    func resetGame() {
        stopTimer()
        setupGame()
    }
    
    /// Shuffles the grid (only in shuffle mode)
    func shuffleGrid() {
        guard isShuffleMode && shufflesRemaining > 0 else { return }
        
        // Get all unmatched cells
        let unmatchedCells = cells.filter { !$0.isMatched }
        
        // Shuffle their colors
        var colors = unmatchedCells.map { $0.color }
        colors.shuffle()
        
        // Apply shuffled colors back
        var colorIndex = 0
        for i in 0..<cells.count {
            if !cells[i].isMatched {
                cells[i].color = colors[colorIndex]
                colorIndex += 1
            }
        }
        
        shufflesRemaining -= 1
        resetSelection()
    }
    
    /// Start the session timer (countdown)
    private func startTimer() {
        stopTimer() // Stop any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                // Time's up - session over!
                self.endSession()
            }
        }
    }
    
    /// Stop the game timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Formatted time string (countdown)
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    /// Color for timer display (red when running out of time)
    var timerColor: Color {
        if timeRemaining <= 30 {
            return .red
        } else if timeRemaining <= 60 {
            return .orange
        } else {
            return .primary
        }
    }
    
    deinit {
        stopTimer()
    }
}
