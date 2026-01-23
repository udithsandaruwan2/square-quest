//
//  CellView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-12.
//

import SwiftUI

/// A single cell in the game grid with flip animation
struct CellView: View {
    let cell: Cell
    let wrongMatchShake: Bool
    let onTap: () -> Void
    
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Card back (when face down)
                CardBackView()
                    .opacity(cell.isFaceUp ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(cell.isFaceUp ? 90 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                
                // Card front (when face up)
                CardFrontView(color: cell.color, borderColor: borderColor, borderWidth: borderWidth)
                    .opacity(cell.isFaceUp ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(cell.isFaceUp ? 0 : -90),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .overlay(
                        // Red flash overlay for wrong matches
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red.opacity(cell.isSelected && wrongMatchShake ? 0.4 : 0))
                    )
            }
            .opacity(cell.isMatched ? 0.4 : 1.0)
            .scaleEffect(cell.isSelected && !cell.isMatched ? 0.95 : 1.0)
            .offset(x: cell.isSelected && wrongMatchShake ? shakeOffset : 0)
            .animation(.easeInOut(duration: 0.3), value: cell.isFaceUp)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: cell.isSelected)
            .animation(.easeOut(duration: 0.4), value: cell.isMatched)
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

/// Card back design (face-down state)
struct CardBackView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    colors: [Color(red: 0.2, green: 0.4, blue: 0.8), Color(red: 0.3, green: 0.5, blue: 0.9)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                ZStack {
                    // Pattern design
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 2)
                        .padding(4)
                    
                    // Question mark or pattern
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.title)
                        .foregroundColor(.white.opacity(0.4))
                }
            )
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

/// Card front design (face-up state showing color)
struct CardFrontView: View {
    let color: Color
    let borderColor: Color
    let borderWidth: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    HStack(spacing: 20) {
        CellView(cell: Cell(color: .red, isFaceUp: false), wrongMatchShake: false) {}
        CellView(cell: Cell(color: .blue, isSelected: true, isFaceUp: true), wrongMatchShake: false) {}
        CellView(cell: Cell(color: .green, isMatched: true, isFaceUp: true), wrongMatchShake: false) {}
    }
    .padding()
    .frame(height: 100)
}
