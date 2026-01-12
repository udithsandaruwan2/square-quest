//
//  Cell.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-12.
//

import SwiftUI

/// Represents a single cell in the game grid
struct Cell: Identifiable, Equatable {
    let id: UUID
    var color: Color
    var isSelected: Bool
    var isMatched: Bool
    
    init(id: UUID = UUID(), color: Color, isSelected: Bool = false, isMatched: Bool = false) {
        self.id = id
        self.color = color
        self.isSelected = isSelected
        self.isMatched = isMatched
    }
}
