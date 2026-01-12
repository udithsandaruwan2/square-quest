//
//  CellView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-12.
//

import SwiftUI

/// A single cell in the game grid
struct CellView: View {
    let cell: Cell
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: 8)
                .fill(cell.color)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .opacity(cell.isMatched ? 0.3 : 1.0)
                .scaleEffect(cell.isSelected ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: cell.isSelected)
                .animation(.easeOut(duration: 0.3), value: cell.isMatched)
        }
        .disabled(cell.isMatched)
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var borderColor: Color {
        if cell.isSelected {
            return .white
        } else if cell.isMatched {
            return .gray.opacity(0.3)
        } else {
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        cell.isSelected ? 4 : 0
    }
}

#Preview {
    HStack(spacing: 20) {
        CellView(cell: Cell(color: .red, isSelected: false, isMatched: false)) {}
        CellView(cell: Cell(color: .blue, isSelected: true, isMatched: false)) {}
        CellView(cell: Cell(color: .green, isSelected: false, isMatched: true)) {}
    }
    .padding()
    .frame(height: 100)
}
