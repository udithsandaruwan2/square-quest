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
    let wrongMatchShake: Bool
    let onTap: () -> Void
    
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: 8)
                .fill(cell.color)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .overlay(
                    // Red flash overlay for wrong matches
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red.opacity(cell.isSelected && wrongMatchShake ? 0.4 : 0))
                )
                .opacity(cell.isMatched ? 0.3 : 1.0)
                .scaleEffect(cell.isSelected ? 0.9 : 1.0)
                .offset(x: cell.isSelected && wrongMatchShake ? shakeOffset : 0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: cell.isSelected)
                .animation(.easeOut(duration: 0.3), value: cell.isMatched)
                .onChange(of: wrongMatchShake) { _, newValue in
                    if newValue && cell.isSelected {
                        performShake()
                    }
                }
        }
        .disabled(cell.isMatched)
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func performShake() {
        withAnimation(.easeInOut(duration: 0.1)) {
            shakeOffset = -5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = 5
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = 0
            }
        }
    }
    
    private var borderColor: Color {
        if cell.isSelected {
            return wrongMatchShake ? .red : .white
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
        CellView(cell: Cell(color: .red, isSelected: false, isMatched: false), wrongMatchShake: false) {}
        CellView(cell: Cell(color: .blue, isSelected: true, isMatched: false), wrongMatchShake: false) {}
        CellView(cell: Cell(color: .green, isSelected: false, isMatched: true), wrongMatchShake: false) {}
    }
    .padding()
    .frame(height: 100)
}
