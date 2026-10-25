# AGENTS.md — Scrivener Developer & Agent Guide

> **Project**: Scrivener — Modern TTRPG Character Manager & Rules Engine  
> **Author & Copyright**: Robert Tolliver (tollitech.com)  
> **Bundle Identifier**: `com.tollitech.scrivener`  
> **Tech Stack**: Flutter 3.x, Dart 3.x, Riverpod 2.x, Drift / SQLite, Google Fonts, PDF / Printing

---

## 1. Overview & System Purpose

Scrivener is a high-performance, cross-platform tabletop roleplaying game (TTRPG) companion app for mobile (Android, iOS) and desktop (macOS, Windows, Linux, Web). It provides:
- **Dynamic Rules & Modifier Engine**: Stacking bonuses, priority overrides, and formula evaluation for stats, skills, saves, and attacks.
- **TTRPG System Modularity**: Out-of-the-box D&D 5e / 2024 implementation with extensible contracts for Pathfinder 2e and homebrew systems.
- **Character Management**: 4-step guided creation wizard, direct freeform creation ("Smart Paper"), in-sheet leveling wizard, and 7-tab character sheet.
- **Interactive Dice Roller**: Full mathematical dice parser with drop-lowest/keep-highest, critical hit detection, roll history, and neutral title-bar quick-roller.
- **Rich Theme Engine**: 6 built-in themes (Ancient Tome, Scholar's Desk, Midnight Arcana, Dungeon OLED, Emerald Enclave, Infernal Brimstone) with per-character theme overrides and responsive tab styles.
- **Offline First**: Local Drift SQLite persistence with JSON backup/restore and 2-page printable character sheet PDF export.

---

## 2. Directory Architecture

```
lib/
├── app.dart                   # Root MaterialApp with theme listener
├── main.dart                  # Application entry point with ProviderScope
├── core/
│   ├── database/              # Drift SQLite database, tables, and migrations
│   │   ├── app_database.dart  # Database schema definition
│   │   ├── database_provider.dart # Riverpod database singleton provider
│   │   └── tables/            # Characters, Conditions, Inventory, Compendium
│   ├── dice/                  # Dice parsing and execution engine
│   │   ├── dice_ast.dart      # Abstract syntax tree for dice expressions
│   │   ├── dice_parser.dart   # String parser (e.g., 2d20kh1+5, 4d6dl1)
│   │   └── dice_roller.dart   # Deterministic & cryptographically secure roller
│   ├── engine/                # Core calculation & modifier pipeline
│   │   ├── formula_evaluator.dart # Math evaluator with @variable token support
│   │   ├── modifier.dart      # Modifier definitions (base, additive, override)
│   │   ├── property.dart      # Dynamic property models
│   │   └── property_pipeline.dart # Pipeline applying priority-ordered modifiers
│   └── theme/                 # Theme system & typography
│       ├── app_theme.dart     # ThemeData generation for 6 AppThemeMode options
│       ├── theme_provider.dart# Active theme Riverpod state notifier
│       └── models/            # ScrivenerThemeTokens, typography, iconography
├── systems/                   # Modular TTRPG rulesets
│   ├── system_contract.dart   # Abstract TTRPG ruleset interface
│   └── dnd5e/                 # D&D 5e / 2024 implementation
│       ├── dnd5e_system.dart
│       ├── dnd5e_conditions.dart
│       └── dnd5e_rest_manager.dart
└── features/                  # Feature-first domain modules
    ├── character_sheet/       # 7-tab sheet, leveling dialog, theme picker
    ├── character_wizard/      # 4-step wizard & freeform hero creation
    ├── combat/                # Combat dashboard, HP, death saves, conditions
    ├── compendium/            # Searchable SRD compendium & filters
    ├── dice/                  # Interactive dice tray, drawer, & neutral quick-roller
    ├── export_import/         # JSON character backup/restore & QR sharing
    ├── home/                  # Character roster, hero cards, responsive app bar
    ├── pdf_export/            # 2-page printable PDF generator & preview
    └── plugins/               # Sandboxed community plugin manager & manifests
```

---

## 3. Essential Commands & Development Workflows

Agents working in this repository must use these standard commands:

### Running Analysis & Tests
```bash
# Analyze Dart code for static warnings and lint violations (must have 0 issues)
flutter analyze

# Run all automated test suites (must 100% pass)
flutter test

# Run a specific test file
flutter test test/features/responsive/mobile_responsive_layout_test.dart
```

### Code Generation & Build Runner
When modifying Drift table schemas (`lib/core/database/tables/*.dart`):
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Formatting & Code Quality
```bash
# Format all source and test code
dart format lib test
```

### Running the Application
```bash
flutter run -d chrome
flutter run -d linux
```

---

## 4. Key Architectural Patterns & Rules

### A. State Management (Riverpod)
- All reactive state is managed via `flutter_riverpod` (Riverpod 2.x).
- Avoid storing business logic or calculation math inside UI `Widget` classes. Use `Notifier` / `StateNotifier` / `Provider`.
- Inject dependencies via providers (e.g., `databaseProvider`, `characterSheetProvider`, `diceRollerProvider`).
- In widget tests, override providers using `ProviderScope(overrides: [...])` and pass in-memory databases (`NativeDatabase.memory()`).

### B. Property Calculation Pipeline
- **Never perform ad-hoc arithmetic** for character stats, armor class, attack bonuses, or spell save DCs.
- Always use `PropertyPipeline` (`lib/core/engine/property_pipeline.dart`).
- Modifiers must use the appropriate `ModifierType`:
  1. `base`: Initial unaugmented score.
  2. `additive`: Flat numerical adjustments (+2 shield, +1 magic item).
  3. `override`: Absolute hard set (e.g., *Gauntlets of Ogre Power* setting Strength to 19).
- Modifiers are sorted and applied according to `priority` (lower numbers evaluate first).

### C. Responsive UI & Mobile First Design
Scrivener runs on phones, tablets, and desktops. Follow these strict UI safety rules:
1. **Narrow Screen Widths (320px–360px)**:
   - Never use fixed widths greater than 300px.
   - Use `Wrap`, `Flexible`, `Expanded`, or `SingleChildScrollView` for button bars and title bars.
   - Avoid redundant buttons on small screens (e.g., the Home screen AppBar omits the "+ New Hero" button on narrow widths because the FAB provides that action).
2. **Safe Areas**:
   - Always wrap bottom navigation, dialog actions, and wizard step buttons in `SafeArea` to prevent overlap with Android system navigation bars and iOS home indicators.
3. **Landscape Viewports**:
   - Modal bottom sheets and wizards must be scrollable (`SingleChildScrollView`) so keyboard or landscape height constraints do not cause `RenderFlex` overflow errors.

### D. Typography & Theming
- Typography utilizes `google_fonts` with system font fallbacks:
  - Headers / Titles: MedievalSharp, Cinzel, or Playfair Display with fallback to `serif`.
  - Body Text: Spectral, Roboto, or Merriweather with fallback to `sans-serif`.
  - Numerical / Stat values: Alegreya SC or Oswald with fallback to `sans-serif`.
- Color tokens must be read from `Theme.of(context).extension<ScrivenerThemeTokens>()` rather than hardcoding hex colors in widgets.
- Tabs support three configurable styles via `CharacterTabContentStyle`:
  - `iconsAndText` (default)
  - `iconsOnly` (compact)
  - `textOnly` (editorial)

### E. Dice Rolling Engine
- When adding roll actions, parse formulas with `DiceParser.parse(formula)`.
- The dice roller supports notation such as `1d20+5`, `2d20kh1+3` (advantage), `2d20kl1+3` (disadvantage), `4d6dl1` (drop lowest), and complex compound formulas.
- **Title-Bar Quick Roller**: The global dice drawer opened from the AppBar operates in a neutral roll mode (`setQuickRoll()`). It displays visual roll results but does **not** mutate any character sheet attributes or logs.

---

## 5. Testing Requirements & Conventions

1. **Test Coverage**:
   - All new features and bug fixes must have unit or widget tests added in `test/`.
   - Maintain 100% passing tests across all test suites.
2. **In-Memory Database for Tests**:
   - Always instantiate `AppDatabase(NativeDatabase.memory())` in test setups and tear down using `addTearDown(() => db.close())`.
3. **Screen Size Tests**:
   - For responsive widgets, explicitly test at 360×640 (standard phone) and 640×360 (landscape phone) using `tester.view.physicalSize`.

---

## 6. Codebase Hygiene & Documentation Integrity

- **Comments & Docstrings**: Preserve existing comments, explanatory notes, and copyright headers.
- **Copyright & Author**: Robert Tolliver (`com.tollitech.scrivener`).
- **Static Analysis**: Never commit code that causes `flutter analyze` warnings or errors.
