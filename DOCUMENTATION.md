# Square Quest - SwiftUI Game Documentation

A color-matching puzzle game built with SwiftUI demonstrating modern iOS development patterns.

---

## 📚 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Game Mechanics](#game-mechanics)
4. [Code Walkthrough](#code-walkthrough)
5. [SwiftUI Concepts Used](#swiftui-concepts-used)
6. [How to Build & Run](#how-to-build--run)

---

## 🎮 Project Overview

**Square Quest** is a memory-matching game where players:

- Select pairs of colored squares on a grid
- Match colors to score points
- Choose from three difficulty levels (3×3, 5×5, 7×7)

### Learning Goals

- SwiftUI Views and State Management
- MVVM Architecture Pattern
- Property Wrappers (@State, @Published, @StateObject)
- Grid Layouts and Animations
- Game Logic Implementation

---

## 🏗️ Architecture

### MVVM Pattern

```
┌─────────────┐      ┌──────────────┐      ┌─────────────┐
│    View     │─────▶│  ViewModel   │─────▶│    Model    │
│  (SwiftUI)  │◀─────│ (Observable) │      │   (Data)    │
└─────────────┘      └──────────────┘      └─────────────┘
```

### File Structure

```
SquareQuest/
├── Models/
│   ├── Cell.swift           # Data model for grid cells
│   └── Difficulty.swift     # Enum for difficulty levels
├── ViewModels/
│   └── GameViewModel.swift  # Game state & logic
├── Views/
│   ├── GameView.swift       # Main game screen
│   ├── GridView.swift       # Grid container
│   └── CellView.swift       # Individual cell UI
├── ContentView.swift        # Root view
└── SquareQuestApp.swift     # App entry point
```

---

## 🎲 Game Mechanics

### Game Flow

```
1. Game Setup
   ├─ Generate pairs of colored cells
   ├─ Shuffle randomly
   └─ Display on grid

2. Player Interaction
   ├─ Tap first cell → Mark as selected
   ├─ Tap second cell → Compare colors
   └─ Match?
       ├─ Yes → Mark matched, +10 score
       └─ No → Reset selection

3. Win Condition
   └─ All cells matched
```

### Difficulty Mapping

| Level  | Grid Size | Total Cells | Pairs |
| ------ | --------- | ----------- | ----- |
| Easy   | 3×3       | 9           | 4-5   |
| Medium | 5×5       | 25          | 12-13 |
| Hard   | 7×7       | 49          | 24-25 |

---

## 💻 Code Walkthrough

### 1. Models

#### Cell.swift

```swift
struct Cell: Identifiable, Equatable {
    let id: UUID           // Unique identifier for SwiftUI
    var color: Color       // Visual color of the cell
    var isSelected: Bool   // Currently selected by player
    var isMatched: Bool    // Already matched (disabled)
}
```

**Key Concepts:**

- `Identifiable`: Required for ForEach loops in SwiftUI
- `Equatable`: Allows comparison between cells
- `UUID`: Ensures each cell is uniquely identifiable

#### Difficulty.swift

```swift
enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var gridSize: Int {
        switch self {
        case .easy: return 3
        case .medium: return 5
        case .hard: return 7
        }
    }
}
```

**Key Concepts:**

- `CaseIterable`: Enables iteration over all cases
- Computed Properties: `gridSize` calculates based on difficulty
- Type-safe: Can't accidentally use invalid difficulty values

---

### 2. ViewModel

#### GameViewModel.swift

```swift
class GameViewModel: ObservableObject {
    @Published var difficulty: Difficulty = .easy
    @Published var cells: [Cell] = []
    @Published var score: Int = 0
    @Published var selectedCells: [UUID] = []

    // ... methods
}
```

**Key Concepts:**

##### @Published Property Wrapper

```swift
@Published var score: Int = 0
```

- Automatically triggers View updates when value changes
- SwiftUI re-renders any View observing this property
- Essential for reactive UI

##### ObservableObject Protocol

```swift
class GameViewModel: ObservableObject
```

- Marks class as observable by SwiftUI
- Works with @StateObject and @ObservedObject in Views
- Publishes changes to subscribers

##### Game Setup Method

```swift
func setupGame() {
    score = 0
    selectedCells = []
    cells = generateCells()
}

private func generateCells() -> [Cell] {
    let totalCells = difficulty.totalCells
    let colorCount = difficulty.colorCount

    var cellColors: [Color] = []

    // Create pairs
    for i in 0..<colorCount {
        let color = availableColors[i % availableColors.count]
        cellColors.append(color)
        if cellColors.count < totalCells {
            cellColors.append(color)  // Add matching pair
        }
    }

    cellColors.shuffle()  // Randomize positions

    return cellColors.map { color in
        Cell(color: color)
    }
}
```

**What's Happening:**

1. Calculate how many unique colors needed
2. Create pairs of each color
3. Shuffle to randomize positions
4. Map colors to Cell objects

##### Selection Logic

```swift
func selectCell(_ cell: Cell) {
    guard !cell.isMatched else { return }  // Ignore matched cells

    guard let index = cells.firstIndex(where: { $0.id == cell.id }) else { return }

    // Deselect if already selected
    if selectedCells.contains(cell.id) {
        cells[index].isSelected = false
        selectedCells.removeAll { $0 == cell.id }
        return
    }

    // Reset if 2 already selected
    if selectedCells.count >= 2 {
        resetSelection()
    }

    // Select current cell
    cells[index].isSelected = true
    selectedCells.append(cell.id)

    // Check for match if 2 selected
    if selectedCells.count == 2 {
        checkForMatch()
    }
}
```

**Flow:**

1. Prevent interaction with matched cells
2. Toggle selection on tap
3. Limit to 2 selections max
4. Trigger match check

##### Match Checking

```swift
private func checkForMatch() {
    guard selectedCells.count == 2 else { return }

    guard let firstIndex = cells.firstIndex(where: { $0.id == selectedCells[0] }),
          let secondIndex = cells.firstIndex(where: { $0.id == selectedCells[1] }) else {
        return
    }

    let firstCell = cells[firstIndex]
    let secondCell = cells[secondIndex]

    if firstCell.color == secondCell.color {
        // Match! Mark as matched after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cells[firstIndex].isMatched = true
            self.cells[secondIndex].isMatched = true
            self.cells[firstIndex].isSelected = false
            self.cells[secondIndex].isSelected = false
            self.selectedCells.removeAll()
            self.score += 10
            self.checkGameComplete()
        }
    } else {
        // No match - reset after longer delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.resetSelection()
        }
    }
}
```

**Why Delays?**

- Players need time to see their selection
- Visual feedback improves game experience
- `DispatchQueue.main.asyncAfter`: Schedule code to run later on main thread

---

### 3. Views

#### CellView.swift

```swift
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
```

**Key Concepts:**

##### Computed Properties in Views

```swift
private var borderColor: Color {
    if cell.isSelected { return .white }
    else if cell.isMatched { return .gray.opacity(0.3) }
    else { return .clear }
}
```

- Keeps View code clean
- Logic separated from layout
- Automatically updates when state changes

##### Animations

```swift
.scaleEffect(cell.isSelected ? 0.9 : 1.0)
.animation(.spring(response: 0.3, dampingFraction: 0.6), value: cell.isSelected)
```

- `scaleEffect`: Shrinks cell when selected (feedback)
- `.spring`: Bouncy animation effect
- `value:`: Only animate when this value changes

##### Closure Parameters

```swift
let onTap: () -> Void
```

- Passes behavior from parent View
- Keeps CellView reusable
- Parent decides what happens on tap

---

#### GridView.swift

```swift
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

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 8), count: gridSize)
    }
}
```

**Key Concepts:**

##### LazyVGrid

```swift
LazyVGrid(columns: columns, spacing: 8)
```

- Vertical grid layout
- "Lazy" = Creates cells only when visible (performance)
- `columns`: Array defining column behavior

##### Dynamic Columns

```swift
Array(repeating: GridItem(.flexible(), spacing: 8), count: gridSize)
```

- Creates flexible columns based on grid size
- `.flexible()`: Columns share available space equally
- Example: 3×3 = 3 columns, 5×5 = 5 columns

##### ForEach

```swift
ForEach(cells) { cell in
    CellView(cell: cell) { onCellTap(cell) }
}
```

- Requires `Identifiable` protocol (Cell has `id: UUID`)
- Creates a CellView for each cell
- Automatically tracks changes

---

#### GameView.swift

```swift
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack(spacing: 20) {
            // Title, Picker, Score, Grid, Reset Button
        }
    }
}
```

**Key Concepts:**

##### @StateObject

```swift
@StateObject private var viewModel = GameViewModel()
```

- Creates and owns the ViewModel
- Survives View updates
- Use for ViewModels you create
- Alternative: `@ObservedObject` for passed-in objects

##### Picker with Binding

```swift
Picker("Difficulty", selection: $viewModel.difficulty) {
    ForEach(Difficulty.allCases, id: \.self) { difficulty in
        Text(difficulty.rawValue).tag(difficulty)
    }
}
.onChange(of: viewModel.difficulty) { _, newValue in
    viewModel.changeDifficulty(to: newValue)
}
```

- `$viewModel.difficulty`: Two-way binding
- `onChange`: Reacts to selection changes
- Triggers game reset with new difficulty

##### Gradient Backgrounds

```swift
.foregroundStyle(
    LinearGradient(
        colors: [.blue, .purple],
        startPoint: .leading,
        endPoint: .trailing
    )
)
```

- Creates smooth color transitions
- `leading` → `trailing`: Left to right
- Also: `top`, `bottom`, custom angles

---

## 🎯 SwiftUI Concepts Used

### Property Wrappers

| Wrapper           | Purpose               | Use Case                                  |
| ----------------- | --------------------- | ----------------------------------------- |
| `@State`          | Local view state      | Simple values in a single View            |
| `@Published`      | Observable property   | ViewModel properties that trigger updates |
| `@StateObject`    | Own observable object | Create & manage ViewModel lifecycle       |
| `@ObservedObject` | Reference observable  | Receive ViewModel from parent             |

### Layout Components

```swift
VStack       // Vertical stack
HStack       // Horizontal stack
LazyVGrid    // Vertical grid (lazy loading)
Spacer()     // Flexible space
Divider()    // Separator line
```

### Modifiers

```swift
.padding()                    // Add spacing
.background(Color.blue)       // Background color/view
.cornerRadius(12)             // Round corners
.shadow(radius: 5)            // Drop shadow
.opacity(0.5)                 // Transparency
.scaleEffect(1.2)            // Scale transform
.animation(.spring())         // Animate changes
.disabled(true)               // Disable interaction
.onChange(of:) { }           // React to changes
```

---

## 🚀 How to Build & Run

### Prerequisites

- macOS 13.0+ (Ventura or later)
- Xcode 15.0+
- iOS 17.0+ Simulator or Device

### Steps

1. **Open Project**

   ```bash
   cd /Users/neon/us/square-quest/SquareQuest
   open SquareQuest.xcodeproj
   ```

2. **Select Target**

   - Choose "SquareQuest" scheme
   - Select iPhone simulator (e.g., iPhone 15 Pro)

3. **Build & Run**

   - Press `Cmd + R` or click ▶️ button
   - Wait for build to complete

4. **Play!**
   - Tap pairs of squares to match colors
   - Score points for correct matches
   - Change difficulty to challenge yourself

---

## 🎨 Customization Ideas

### Easy Modifications

**Change Colors:**

```swift
// In GameViewModel.swift - generateCells()
let availableColors: [Color] = [
    .red, .blue, .green,    // Current colors
    .black, .white, .gray   // Add your own!
]
```

**Adjust Scoring:**

```swift
// In GameViewModel.swift - checkForMatch()
self.score += 10  // Change to 5, 20, 100, etc.
```

**Grid Sizes:**

```swift
// In Difficulty.swift
case easy: return 4   // 4×4 instead of 3×3
```

**Animation Timing:**

```swift
// In GameViewModel.swift - checkForMatch()
DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)  // Faster/slower
```

### Advanced Features

- Timer: Track how fast players complete the game
- High Score: Persist best scores with UserDefaults
- Sound Effects: Add audio feedback on matches
- Haptic Feedback: Vibrate on tap/match
- Leaderboard: Save top 10 scores

---

## 🐛 Common Issues & Solutions

### Issue: Cells not appearing

**Solution:** Check that ViewModel `setupGame()` is called in `init()`

### Issue: Selection not working

**Solution:** Verify `onCellTap` closure is passed correctly through View hierarchy

### Issue: Colors repeating

**Solution:** Ensure `shuffle()` is called after generating color pairs

### Issue: Animations not smooth

**Solution:** Check that `.animation()` has a `value:` parameter specifying what to animate

---

## 📖 Learning Resources

### SwiftUI Fundamentals

- [Apple's SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Hacking with Swift](https://www.hackingwithswift.com/quick-start/swiftui)

### MVVM Pattern

- [MVVM in SwiftUI](https://www.swiftbysundell.com/articles/swiftui-state-management-guide/)

### Advanced Topics

- Property Wrappers Deep Dive
- Combine Framework (for reactive programming)
- SwiftUI Animations & Transitions

---

## 🏆 What You've Learned

✅ MVVM architecture pattern  
✅ SwiftUI state management (@State, @Published, @StateObject)  
✅ Grid layouts with LazyVGrid  
✅ Animations and transitions  
✅ Game loop and logic implementation  
✅ Closures and callbacks  
✅ Enums with computed properties  
✅ Protocol-oriented programming (Identifiable, Equatable)

---

**Happy Coding! 🎮✨**

Built with ❤️ in SwiftUI
