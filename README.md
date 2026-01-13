# Square Quest 🎮

A colorful memory-matching puzzle game built with SwiftUI, demonstrating modern iOS development patterns and best practices.

![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS%2017+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 🎯 About

Square Quest is an educational SwiftUI project that implements a color-matching game with three difficulty levels. Players tap pairs of colored squares to find matches, earning points for correct selections.

**Perfect for:**

- Learning SwiftUI fundamentals
- Understanding MVVM architecture
- Practicing state management
- Exploring animations and layouts

---

## ✨ Features

- 🎨 **Colorful Grid Gameplay** - Match pairs of colored squares
- 🎚️ **Three Difficulty Levels** - Easy (3×3), Medium (5×5), Hard (7×7)
- 📊 **Score Tracking** - Earn points for successful matches
- 🎭 **Smooth Animations** - Spring-based interactions and transitions
- 📱 **Responsive Design** - Adapts to different screen sizes
- 🔄 **Reset Functionality** - Start fresh anytime

---

## 🚀 Getting Started

### Prerequisites

- macOS 13.0+ (Ventura or later)
- Xcode 15.0+
- iOS 17.0+ device or simulator

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/square-quest.git
   cd square-quest
   ```

2. **Open in Xcode**

   ```bash
   cd SquareQuest
   open SquareQuest.xcodeproj
   ```

3. **Build and Run**
   - Select a simulator (iPhone 15 Pro recommended)
   - Press `Cmd + R` or click the Run button ▶️

---

## 🎮 How to Play

1. **Select Difficulty** - Choose Easy, Medium, or Hard from the picker
2. **Tap Squares** - Select two squares to reveal their colors
3. **Match Colors** - If colors match, you earn 10 points and the squares disappear
4. **Keep Matching** - Continue until all pairs are found
5. **Reset** - Tap "Reset Game" to start over with a new random layout

---

## 🏗️ Architecture

Built using the **MVVM (Model-View-ViewModel)** pattern:

```
┌─────────────────┐
│     Models      │  Cell, Difficulty
│  (Data Layer)   │
└────────┬────────┘
         │
┌────────▼────────┐
│   ViewModels    │  GameViewModel (business logic)
│ (Logic Layer)   │
└────────┬────────┘
         │
┌────────▼────────┐
│     Views       │  GameView, GridView, CellView
│   (UI Layer)    │
└─────────────────┘
```

### Project Structure

```
SquareQuest/
├── Models/
│   ├── Cell.swift              # Cell data model
│   └── Difficulty.swift        # Difficulty enum
├── ViewModels/
│   └── GameViewModel.swift     # Game state management
├── Views/
│   ├── GameView.swift          # Main game screen
│   ├── GridView.swift          # Grid layout
│   └── CellView.swift          # Individual cell UI
├── ContentView.swift           # Root view
└── SquareQuestApp.swift        # App entry point
```

---

## 📚 Documentation

Comprehensive documentation is available in the repository:

- **[DOCUMENTATION.md](DOCUMENTATION.md)** - Complete guide with code explanations and SwiftUI concepts
- **[CODE_REVIEW.md](CODE_REVIEW.md)** - Quality analysis and improvement recommendations
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick lookup for components and customization

---

## 🎓 Learning Highlights

This project demonstrates:

- ✅ **SwiftUI State Management** - `@State`, `@Published`, `@StateObject`
- ✅ **MVVM Architecture** - Clean separation of concerns
- ✅ **LazyVGrid Layouts** - Dynamic, responsive grids
- ✅ **Animations** - Spring animations and transitions
- ✅ **Property Wrappers** - Modern Swift patterns
- ✅ **Closures & Callbacks** - Event handling
- ✅ **Protocol-Oriented Programming** - `Identifiable`, `Equatable`

---

## 🎨 Customization

Easy to customize and extend:

**Change Colors:**

```swift
// In GameViewModel.swift
let availableColors: [Color] = [.red, .blue, .green, ...]
```

**Adjust Difficulty:**

```swift
// In Difficulty.swift
case easy: return 4  // 4×4 grid instead of 3×3
```

**Modify Scoring:**

```swift
// In GameViewModel.swift
self.score += 20  // 20 points per match
```

See [DOCUMENTATION.md](DOCUMENTATION.md) for more customization options.

---

## 🛠️ Technologies Used

- **SwiftUI** - Declarative UI framework
- **Combine** - Reactive programming (`@Published`)
- **Swift 5.9+** - Modern Swift features
- **iOS 17.0+** - Latest iOS capabilities

---

## 🔮 Future Enhancements

Potential features to add:

- [ ] Timer-based challenge mode
- [ ] High score persistence (UserDefaults)
- [ ] Haptic feedback
- [ ] Sound effects
- [ ] Win celebration animation
- [ ] Move counter
- [ ] Multiple themes
- [ ] Accessibility improvements (VoiceOver)

---

## 🤝 Contributing

Contributions are welcome! This is an educational project perfect for:

- Adding new features
- Improving documentation
- Enhancing UI/UX
- Writing unit tests
- Fixing bugs

Feel free to open issues or submit pull requests.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built with ❤️ using SwiftUI
- Inspired by classic memory matching games
- Created for educational purposes

---

## 📞 Contact

Questions or feedback? Open an issue or reach out!

---

**Happy Coding! 🚀**

_For detailed code explanations, check out [DOCUMENTATION.md](DOCUMENTATION.md)_
