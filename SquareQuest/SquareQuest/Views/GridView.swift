//
//  GridView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-12.
//

import SwiftUI

/// The game grid containing all cells
struct GridView: View {
    let cells: [Cell]
    let gridSize: Int
    let wrongMatchShake: Bool
    let onCellTap: (Cell) -> Void
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(cells) { cell in
                CellView(cell: cell, wrongMatchShake: wrongMatchShake) {
                    onCellTap(cell)
                }
            }
        }
        .padding()
    }
    
    /// Dynamic columns based on grid size
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 8), count: gridSize)
    }
}

#Preview {
    let sampleCells = [
        Cell(color: .red, isFaceUp: true), Cell(color: .blue, isFaceUp: false), Cell(color: .green, isFaceUp: true),
        Cell(color: .yellow, isFaceUp: false), Cell(color: .orange, isFaceUp: true), Cell(color: .purple, isFaceUp: false),
        Cell(color: .pink, isFaceUp: true), Cell(color: .cyan, isFaceUp: false), Cell(color: .mint, isFaceUp: true)
    ]
    
    GridView(cells: sampleCells, gridSize: 3, wrongMatchShake: false) { _ in }
}
