//
//  ScoreManager.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-22.
//

import Foundation
import Combine

/// Manages local storage and retrieval of game scores
class ScoreManager: ObservableObject {
    @Published var scores: [GameScore] = []
    
    private let storageKey = "SquareQuest_Scores"
    private let maxScores = 100 // Keep only top 100 scores
    
    init() {
        loadScores()
    }
    
    /// Save a new game score
    func saveScore(_ score: GameScore) {
        scores.append(score)
        
        // Sort by score descending, then by time ascending (faster is better)
        scores.sort { first, second in
            if first.score != second.score {
                return first.score > second.score
            }
            return first.timeInSeconds < second.timeInSeconds
        }
        
        // Keep only top scores
        if scores.count > maxScores {
            scores = Array(scores.prefix(maxScores))
        }
        
        persistScores()
    }
    
    /// Get top scores for a specific difficulty
    func getTopScores(for difficulty: Difficulty, limit: Int = 10) -> [GameScore] {
        return scores
            .filter { $0.difficulty == difficulty }
            .prefix(limit)
            .map { $0 }
    }
    
    /// Get all-time best score
    func getBestScore() -> GameScore? {
        return scores.first
    }
    
    /// Get best score for specific difficulty
    func getBestScore(for difficulty: Difficulty) -> GameScore? {
        return scores.first { $0.difficulty == difficulty }
    }
    
    /// Clear all scores
    func clearAllScores() {
        scores.removeAll()
        persistScores()
    }
    
    /// Load scores from UserDefaults
    private func loadScores() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            scores = try decoder.decode([GameScore].self, from: data)
        } catch {
            print("Error loading scores: \(error)")
            scores = []
        }
    }
    
    /// Save scores to UserDefaults
    private func persistScores() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(scores)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Error saving scores: \(error)")
        }
    }
}
