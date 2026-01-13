# Win Alert Implementation - Step by Step Guide

**Feature:** Congratulations alert when game is completed  
**Date Added:** January 13, 2026  
**Difficulty:** Intermediate

---

## 🎯 What We're Building

A win detection system that:

1. Detects when all possible pairs are matched
2. Shows a congratulations alert with final score
3. Offers options to play again or change difficulty

### The Challenge

Each grid has an **odd number** of cells:

- 3×3 = 9 cells
- 5×5 = 25 cells
- 7×7 = 49 cells

This means there's **always 1 cell left unpaired**. We need to detect when all matchable pairs are found!

---

## 📚 Step 1: Understanding the Problem

### Before the Fix

```swift
// ❌ Old logic - This would NEVER work!
let allMatched = cells.allSatisfy { $0.isMatched }
```

**Why this fails:**

- Checks if ALL cells are matched
- But 1 cell can never be matched (odd number)
- Win condition would never trigger

### The Solution

```swift
// ✅ New logic - Works perfectly!
let matchedCount = cells.filter { $0.isMatched }.count
let maxMatchable = totalCells - 1
if matchedCount == maxMatchable {
    // WIN!
}
```

**Why this works:**

- Counts how many cells are matched
- Compares to maximum possible (total - 1)
- Triggers when all pairs are found

---

## 🔧 Step 2: Adding State to ViewModel

### Location

`ViewModels/GameViewModel.swift`

### What We Added

```swift
@Published var showWinAlert: Bool = false
```

### Explanation

**@Published Property Wrapper**

```swift
@Published var showWinAlert: Bool = false
```

**What it does:**

- Creates an observable property
- When `showWinAlert` changes from `false` to `true`
- SwiftUI automatically re-renders any View watching this property

**Why we need it:**

- GameView needs to know when to show the alert
- SwiftUI's `.alert()` modifier binds to this property
- When we set `showWinAlert = true`, alert appears automatically

**Type:**

- `Bool` - Simple true/false flag
- `false` by default (no alert on start)

---

## 🎮 Step 3: Resetting the Alert Flag

### Location

`ViewModels/GameViewModel.swift` - `setupGame()` method

### Before

```swift
func setupGame() {
    score = 0
    selectedCells = []
    cells = generateCells()
}
```

### After

```swift
func setupGame() {
    score = 0
    selectedCells = []
    showWinAlert = false  // ← Added this line
    cells = generateCells()
}
```

### Why This Matters

**The Problem Without It:**

1. Player wins and sees alert
2. Clicks "Play Again"
3. Alert is STILL true
4. Alert shows again immediately!

**The Solution:**

- Reset `showWinAlert = false` when starting new game
- Ensures alert only shows when actually winning
- Clean state for each game session

**When setupGame() is Called:**

- On app launch (from `init()`)
- When "Reset Game" button is pressed
- When difficulty is changed
- When "Play Again" is clicked in win alert

---

## 🏆 Step 4: Implementing Win Detection Logic

### Location

`ViewModels/GameViewModel.swift` - `checkGameComplete()` method

### Complete Implementation

```swift
/// Checks if all cells are matched (game complete)
private func checkGameComplete() {
    // Count how many cells are matched
    let matchedCount = cells.filter { $0.isMatched }.count

    // Since we have odd number of cells (9, 25, 49), there's always 1 leftover
    // Win when all pairs are matched (total cells - 1)
    let totalCells = difficulty.totalCells
    let maxMatchable = totalCells - 1

    if matchedCount == maxMatchable {
        // Game complete! Show win alert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showWinAlert = true
        }
    }
}
```

### Breaking It Down

#### Part 1: Count Matched Cells

```swift
let matchedCount = cells.filter { $0.isMatched }.count
```

**What's happening:**

- `cells.filter { }` - Loops through all cells
- `$0.isMatched` - Checks if cell is matched
- `.count` - Counts how many passed the filter

**Example:**

```swift
// Grid: 9 cells
// Matched: [true, true, false, true, true, true, true, true, true]
// matchedCount = 8
```

#### Part 2: Calculate Maximum Matchable

```swift
let totalCells = difficulty.totalCells
let maxMatchable = totalCells - 1
```

**Why totalCells - 1?**

| Difficulty | Total Cells | Pairs | Leftover | Max Matchable |
| ---------- | ----------- | ----- | -------- | ------------- |
| Easy       | 9           | 4     | 1        | 8             |
| Medium     | 25          | 12    | 1        | 24            |
| Hard       | 49          | 24    | 1        | 48            |

**Math:**

- 9 cells = 4 pairs (8 cells) + 1 leftover
- 25 cells = 12 pairs (24 cells) + 1 leftover
- 49 cells = 24 pairs (48 cells) + 1 leftover

#### Part 3: Check Win Condition

```swift
if matchedCount == maxMatchable {
    // Player won!
}
```

**When this triggers:**

- Easy: When 8 out of 9 cells are matched
- Medium: When 24 out of 25 cells are matched
- Hard: When 48 out of 49 cells are matched

#### Part 4: Delayed Alert Trigger

```swift
DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    self.showWinAlert = true
}
```

**Breaking it down:**

**DispatchQueue.main**

- The main thread (where UI updates happen)
- All SwiftUI updates must be on main thread

**asyncAfter**

- Schedules code to run AFTER a delay
- "async" = doesn't block current code

**deadline: .now() + 0.5**

- `.now()` = current time
- `+ 0.5` = plus 0.5 seconds
- Waits half a second before running

**Why the delay?**

1. Last match animation completes (fade out)
2. Player sees the final match
3. Then alert appears smoothly
4. Better user experience!

**self.showWinAlert = true**

- Sets the flag to true
- Triggers SwiftUI to show alert
- GameView is watching this property

---

## 🎨 Step 5: Adding Alert to GameView

### Location

`Views/GameView.swift` - After the main VStack

### The Code

```swift
.alert("🎉 Congratulations!", isPresented: $viewModel.showWinAlert) {
    Button("Play Again") {
        withAnimation {
            viewModel.resetGame()
        }
    }
    Button("Change Difficulty", role: .cancel) {
        // Alert dismisses automatically
    }
} message: {
    Text("You won with a score of \(viewModel.score)!\n\nAll pairs matched successfully. 🏆")
}
```

### Understanding Each Part

#### Alert Title

```swift
.alert("🎉 Congratulations!", isPresented: $viewModel.showWinAlert)
```

**Parameters:**

- `"🎉 Congratulations!"` - Title text with emoji
- `isPresented:` - Binding to control visibility
- `$viewModel.showWinAlert` - Two-way binding

**The $ Symbol:**

- Creates a Binding (not just a value)
- SwiftUI can READ and WRITE to it
- When alert closes, SwiftUI sets it back to `false`

**How it works:**

1. `showWinAlert` becomes `true` → Alert shows
2. User taps a button → Alert closes
3. SwiftUI sets `showWinAlert = false` automatically

#### Primary Button

```swift
Button("Play Again") {
    withAnimation {
        viewModel.resetGame()
    }
}
```

**Button("Play Again")**

- Creates a button with label
- Primary action (blue, prominent)

**withAnimation { }**

- Wraps the action in animation context
- All state changes inside animate smoothly
- Grid cells fade in nicely

**viewModel.resetGame()**

- Calls the ViewModel method
- Resets score, cells, selections
- Generates new random grid

**Flow:**

1. User taps "Play Again"
2. Alert closes (automatic)
3. Animation starts
4. Game resets with smooth transition
5. New game ready to play

#### Secondary Button

```swift
Button("Change Difficulty", role: .cancel) {
    // Alert dismisses automatically
}
```

**role: .cancel**

- Marks as cancel button
- Appears differently (less prominent)
- Usually at bottom or left

**Empty closure { }**

- No action needed
- Alert dismisses by default
- User can now pick new difficulty from picker

#### Message Body

```swift
message: {
    Text("You won with a score of \(viewModel.score)!\n\nAll pairs matched successfully. 🏆")
}
```

**String Interpolation:**

```swift
\(viewModel.score)
```

- Injects the actual score value
- Example: "You won with a score of 80!"

**\n\n**

- Two newline characters
- Creates blank line for spacing
- Makes message easier to read

**Emoji: 🏆**

- Trophy emoji for celebration
- Makes alert feel rewarding
- Visual feedback for winning

---

## 🔄 Step 6: How It All Works Together

### The Complete Flow

```
1. Game Starts
   └─→ setupGame() called
       └─→ showWinAlert = false
       └─→ cells generated
       └─→ Grid displays

2. Player Taps Cell
   └─→ selectCell() called
       └─→ Cell marked as selected
       └─→ If 2 cells selected...
           └─→ checkForMatch()

3. Match Found!
   └─→ Colors are equal
       └─→ Wait 0.5 seconds
       └─→ Mark both cells as matched
       └─→ score += 10
       └─→ checkGameComplete() ← Called here!

4. Check Game Complete
   └─→ Count matched cells
       └─→ Compare to maxMatchable
       └─→ If equal...
           └─→ Wait 0.5 seconds
           └─→ showWinAlert = true

5. Alert Shows
   └─→ SwiftUI detects showWinAlert = true
       └─→ .alert() modifier activates
       └─→ Alert appears on screen
       └─→ Displays title, message, buttons

6. User Taps "Play Again"
   └─→ withAnimation starts
       └─→ viewModel.resetGame()
           └─→ setupGame() called
           └─→ showWinAlert = false
           └─→ New game generated
       └─→ Alert closes
       └─→ Grid animates in
```

### Timing Diagram

```
Match Found (t=0s)
    ↓
Wait 0.5s for animation
    ↓
Mark as matched (t=0.5s)
Update score
    ↓
checkGameComplete() runs
    ↓
Is it a win? Check count
    ↓
Yes! Wait 0.5s
    ↓
showWinAlert = true (t=1.0s)
    ↓
Alert appears
```

---

## 🧪 Step 7: Testing the Feature

### Test Case 1: Easy Mode (3×3)

```
Setup: 9 cells total
Expected: Win when 8 cells matched

Steps:
1. Select difficulty: Easy
2. Match pairs until 8 cells matched
3. Alert should appear
4. Message shows correct score
5. "Play Again" resets game
6. "Change Difficulty" dismisses alert
```

### Test Case 2: Medium Mode (5×5)

```
Setup: 25 cells total
Expected: Win when 24 cells matched

Steps:
1. Select difficulty: Medium
2. Match pairs until 24 cells matched
3. Alert appears after last match
4. Verify 1 cell remains unmatched
```

### Test Case 3: Hard Mode (7×7)

```
Setup: 49 cells total
Expected: Win when 48 cells matched

Steps:
1. Select difficulty: Hard
2. Match pairs until 48 cells matched
3. Alert appears
4. Verify all pairs found, 1 leftover
```

### Test Case 4: Reset Behavior

```
Steps:
1. Win a game → See alert
2. Click "Play Again"
3. Win again → Alert should show again
4. Alert should not appear prematurely
```

---

## 🎓 Key SwiftUI Concepts Used

### 1. Property Wrappers

```swift
@Published var showWinAlert: Bool = false
```

- Makes property observable
- Triggers UI updates when changed
- Part of Combine framework

### 2. Bindings

```swift
isPresented: $viewModel.showWinAlert
```

- Two-way connection
- SwiftUI reads value to show/hide
- SwiftUI writes value when dismissing

### 3. Alerts

```swift
.alert("Title", isPresented: $binding) { } message: { }
```

- Modal popup
- Blocks interaction
- Auto-dismisses on button tap

### 4. withAnimation

```swift
withAnimation {
    viewModel.resetGame()
}
```

- Animates state changes
- Makes transitions smooth
- Improves UX

### 5. String Interpolation

```swift
"Score: \(viewModel.score)"
```

- Embeds values in strings
- Dynamic text
- Updates automatically

---

## 💡 Common Mistakes & Solutions

### Mistake 1: Checking if ALL cells matched

```swift
❌ let allMatched = cells.allSatisfy { $0.isMatched }
✅ let matchedCount = cells.filter { $0.isMatched }.count
```

**Why:** With odd cells, all will never be matched

### Mistake 2: Forgetting to reset alert

```swift
❌ func setupGame() {
    score = 0
    cells = generateCells()
}

✅ func setupGame() {
    score = 0
    showWinAlert = false  // Don't forget!
    cells = generateCells()
}
```

**Why:** Alert would show again on reset

### Mistake 3: No delay before alert

```swift
❌ self.showWinAlert = true  // Immediate

✅ DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    self.showWinAlert = true  // Delayed
}
```

**Why:** Player needs to see the last match animation

### Mistake 4: Using one-way binding

```swift
❌ .alert("Title", isPresented: viewModel.showWinAlert)
✅ .alert("Title", isPresented: $viewModel.showWinAlert)
```

**Why:** SwiftUI can't set it back to false without $

---

## 🚀 Enhancements You Could Add

### 1. Sound Effects

```swift
import AVFoundation

// In checkGameComplete()
if matchedCount == maxMatchable {
    AudioServicesPlaySystemSound(1057) // Win sound
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.showWinAlert = true
    }
}
```

### 2. Confetti Animation

```swift
// Add confetti view when winning
@State private var showConfetti = false

// Trigger confetti before alert
.overlay {
    if showConfetti {
        ConfettiView()
    }
}
```

### 3. Time Tracking

```swift
@Published var gameTime: TimeInterval = 0

// Show time in alert
message: {
    Text("Time: \(Int(viewModel.gameTime))s\nScore: \(viewModel.score)")
}
```

### 4. Move Counter

```swift
@Published var moveCount: Int = 0

// Increment on each selection
func selectCell(_ cell: Cell) {
    moveCount += 1
    // ... rest of logic
}

// Show in alert
message: {
    Text("Score: \(score)\nMoves: \(moveCount)")
}
```

---

## 📝 Summary

### What We Built

✅ Win detection for odd-numbered grids  
✅ Congratulations alert with score  
✅ Play Again functionality  
✅ Change Difficulty option  
✅ Smooth animations and timing

### Files Modified

1. `GameViewModel.swift` - Added alert state and win logic
2. `GameView.swift` - Added alert UI

### Lines Changed

- ViewModel: ~15 lines added/modified
- View: ~10 lines added

### Concepts Learned

- @Published property wrapper
- Two-way bindings with $
- SwiftUI alerts
- DispatchQueue delays
- Win condition logic
- State management

---

**Congratulations!** You now understand how to implement win detection and alerts in SwiftUI! 🎉

This pattern can be used for:

- Game over screens
- Achievement unlocks
- Level completion
- Any success/failure feedback

---

**Next Steps:**

1. Try adding a high score tracker
2. Implement a timer
3. Add sound effects
4. Create different celebration messages

**Happy Learning! 🚀**
