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
    let onCellTap: (Cell) -> Void
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(cells) { cell in
                CellView(cell: cell) {
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
        Cell(color: .red), Cell(color: .blue), Cell(color: .green),
        Cell(color: .yellow), Cell(color: .orange), Cell(color: .purple),
        Cell(color: .pink), Cell(color: .cyan), Cell(color: .mint)
    ]
    
    GridView(cells: sampleCells, gridSize: 3) { _ in }
}
