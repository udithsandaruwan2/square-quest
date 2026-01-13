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
    
    init() {
        setupGame()
    }
    
    /// Sets up a new game with the current difficulty
    func setupGame() {
        score = 0
        selectedCells = []
        showWinAlert = false
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
            // No match - reset after a delay
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
    
    /// Checks if all cells are matched (game complete)
    private func checkGameComplete() {
        // Count how many cells are matched
        let matchedCount = cells.filter { $0.isMatched }.count
        
        // Since we have odd number of cells (9, 25, 49), there's always 1 leftover
        // Win when all pairs are matched (total cells - 1)
        let totalCells = difficulty.totalCells
        let maxMatchable = totalCells - 1
        
        if matchedCount == maxMatchable {
            // Game complete! Show win alert
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showWinAlert = true
            }
        }
    }
    
    /// Changes the difficulty and restarts the game
    func changeDifficulty(to newDifficulty: Difficulty) {
        difficulty = newDifficulty
        setupGame()
    }
    
    /// Resets the game with current difficulty
    func resetGame() {
        setupGame()
    }
}
