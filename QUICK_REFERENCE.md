# Square Quest - Quick Reference

## 📁 Project Structure

```
SquareQuest/
├── Models/
│   ├── Cell.swift              # Game cell data model
│   └── Difficulty.swift        # Difficulty enum (Easy/Medium/Hard)
│
├── ViewModels/
│   └── GameViewModel.swift     # Game state & logic
│
├── Views/
│   ├── GameView.swift          # Main game screen
│   ├── GridView.swift          # Grid container (LazyVGrid)
│   └── CellView.swift          # Individual cell UI
│
├── ContentView.swift           # Root view (wraps GameView)
└── SquareQuestApp.swift        # App entry point
```

---

## 🎮 How to Play

1. **Start:** Game begins on Easy (3×3 grid)
2. **Select:** Tap two squares to match their colors
3. **Match:** If colors match → +10 points, cells disappear
4. **No Match:** If colors differ → selection resets
5. **Win:** Match all pairs to complete the game
6. **Difficulty:** Switch between Easy, Medium, Hard anytime
7. **Reset:** Tap Reset Game to start over

---

## 🔧 Key Components

### Models

**Cell.swift**
```swift
struct Cell: Identifiable, Equatable {
    let id: UUID        // Unique identifier
    var color: Color    // Visual color
    var isSelected: Bool // Currently selected
    var isMatched: Bool  // Already matched
}
```

**Difficulty.swift**
```swift
enum Difficulty {
    case easy    // 3×3 = 9 cells
    case medium  // 5×5 = 25 cells
    case hard    // 7×7 = 49 cells
}
```

---

### ViewModel

**GameViewModel.swift**
- `@Published var difficulty` → Current difficulty level
- `@Published var cells` → Array of all grid cells
- `@Published var score` → Current score
- `@Published var selectedCells` → IDs of selected cells

**Key Methods:**
- `setupGame()` → Initialize new game
- `selectCell(_ cell)` → Handle cell tap
- `checkForMatch()` → Compare selected cells
- `resetGame()` → Clear and restart

---

### Views

**GameView.swift** - Main screen
- Title
- Difficulty picker (segmented control)
- Score display
- Grid view
- Reset button

**GridView.swift** - Grid container
- Dynamic columns based on difficulty
- Uses LazyVGrid for performance
- Passes tap events to parent

**CellView.swift** - Individual cell
- Colored square with rounded corners
- Visual states: normal, selected, matched
- Spring animations on interaction

---

## 🎨 Customization Quick Tips

### Change Colors
```swift
// In GameViewModel.swift → generateCells()
let availableColors: [Color] = [
    .red, .blue, .green, .yellow, .orange,
    .purple, .pink, .cyan, .mint, .indigo
]
```

### Adjust Scoring
```swift
// In GameViewModel.swift → checkForMatch()
self.score += 10  // Change points per match
```

### Modify Grid Sizes
```swift
// In Difficulty.swift
case easy: return 4   // 4×4 instead of 3×3
case medium: return 6 // 6×6 instead of 5×5
```

### Animation Speed
```swift
// In GameViewModel.swift
DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) // Match delay
DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) // Reset delay
```

---

## 🔑 SwiftUI Concepts Used

| Concept | Where Used | Purpose |
|---------|------------|---------|
| `@State` | N/A in this project | Local view state |
| `@Published` | GameViewModel | Observable properties |
| `@StateObject` | GameView | Own ViewModel |
| `LazyVGrid` | GridView | Grid layout |
| `ForEach` | GridView | Iterate cells |
| `Button` | CellView, GameView | Tap handling |
| `Picker` | GameView | Difficulty selection |
| Animations | CellView | Visual feedback |
| Closures | All Views | Event callbacks |

---

## 🚀 Build & Run

```bash
# Navigate to project
cd /Users/neon/us/square-quest/SquareQuest

# Open in Xcode
open SquareQuest.xcodeproj

# Or build from command line
xcodebuild -scheme SquareQuest -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

**Keyboard Shortcut in Xcode:**
- `Cmd + R` → Build & Run
- `Cmd + .` → Stop
- `Cmd + B` → Build only

---

## 📊 File Sizes

| File | ~Lines | Complexity |
|------|--------|------------|
| Cell.swift | 25 | Simple |
| Difficulty.swift | 40 | Simple |
| GameViewModel.swift | 170 | Moderate |
| CellView.swift | 50 | Simple |
| GridView.swift | 35 | Simple |
| GameView.swift | 130 | Moderate |

**Total: ~450 lines of code**

---

## 🐛 Troubleshooting

### Issue: "Cannot find 'GameView' in scope"
**Solution:** Make sure all files are added to the target
1. Select file in Xcode
2. Check "Target Membership" in File Inspector
3. Ensure "SquareQuest" is checked

### Issue: Grid doesn't resize with difficulty
**Solution:** ViewModel automatically handles this via `@Published`
- Check that GameView has `@StateObject private var viewModel`
- Verify `GridView` receives `viewModel.difficulty.gridSize`

### Issue: Cells not animating
**Solution:** Ensure `.animation()` modifier has `value:` parameter
```swift
.animation(.spring(), value: cell.isSelected)
```

---

## 📚 Documentation Files

- `DOCUMENTATION.md` → Complete guide with code explanations
- `CODE_REVIEW.md` → Quality analysis and recommendations
- `README.md` → Project overview
- `QUICK_REFERENCE.md` → This file!

---

## ✅ Checklist for Development

**Before Coding:**
- [ ] Read DOCUMENTATION.md for concepts
- [ ] Understand MVVM pattern
- [ ] Review file structure

**While Coding:**
- [ ] Follow naming conventions
- [ ] Add comments for complex logic
- [ ] Test on simulator frequently

**After Coding:**
- [ ] Review CODE_REVIEW.md
- [ ] Test all difficulty levels
- [ ] Verify animations work
- [ ] Check on different screen sizes

---

## 🎯 Next Features to Add (Priority Order)

1. **Win Alert** (5 min)
   - Show alert when all matched
   - Offer "Play Again" button

2. **High Score** (10 min)
   - Save best score with UserDefaults
   - Display alongside current score

3. **Haptic Feedback** (10 min)
   - Vibrate on match/mismatch
   - Enhance tactile experience

4. **Move Counter** (15 min)
   - Track number of attempts
   - Show moves/score ratio

5. **Timer** (20 min)
   - Time-based challenge mode
   - Track completion speed

---

**Happy Coding! 🚀**

*For detailed explanations, see DOCUMENTATION.md*  
*For quality analysis, see CODE_REVIEW.md*
