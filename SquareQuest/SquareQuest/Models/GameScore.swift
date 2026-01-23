//
//  GameScore.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-22.
//

import Foundation

/// Represents a completed game score entry
struct GameScore: Identifiable, Codable {
    let id: UUID
    let playerName: String
    let score: Int
    let difficulty: Difficulty
    let timeInSeconds: Int
    let matchedPairs: Int
    let totalMoves: Int
    let date: Date
    let isShuffleMode: Bool
    
    init(
        id: UUID = UUID(),
        playerName: String = "Player",
        score: Int,
        difficulty: Difficulty,
        timeInSeconds: Int,
        matchedPairs: Int,
        totalMoves: Int,
        date: Date = Date(),
        isShuffleMode: Bool = false
    ) {
        self.id = id
        self.playerName = playerName
        self.score = score
        self.difficulty = difficulty
        self.timeInSeconds = timeInSeconds
        self.matchedPairs = matchedPairs
        self.totalMoves = totalMoves
        self.date = date
        self.isShuffleMode = isShuffleMode
    }
    
    /// Formatted time string (e.g., "1:23")
    var formattedTime: String {
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    /// Formatted date string
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
