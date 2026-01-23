//
//  Difficulty.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-12.
//

import Foundation

/// Difficulty levels that determine grid size
enum Difficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    /// Returns the grid size for each difficulty
    var gridSize: Int {
        switch self {
        case .easy:
            return 3  // 3×3 grid
        case .medium:
            return 5  // 5×5 grid
        case .hard:
            return 7  // 7×7 grid
        }
    }
    
    /// Total number of cells in the grid
    var totalCells: Int {
        return gridSize * gridSize
    }
    
    /// Number of unique colors needed (half the total cells, rounded up)
    var colorCount: Int {
        return (totalCells + 1) / 2
    }
}
