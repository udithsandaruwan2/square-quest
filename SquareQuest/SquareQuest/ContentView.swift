//
//  ContentView.swift
//  SquareQuest
//
//  Created by NEON on 2026-01-10.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var scoreManager = ScoreManager()
    
    var body: some View {
        HomeView()
            .environmentObject(scoreManager)
    }
}

#Preview {
    ContentView()
}
