# Per-Character Theming & Responsive Layouts

In tabletop roleplaying games, individual characters often possess radically different aesthetics. A fiery Tiefling Warlock radiating demonic brimstone feels unnatural framed in verdant green nature parchment, just as an ancient Elven Arch-Druid feels discordant wrapped in infernal magma.

Scrivener solves this with **Per-Character Theme Overrides** combined with **Configurable Tab Layout Styles**.

---

## 1. How Per-Character Theming Works

### Theme Resolution Cascade
Whenever a character sheet opens, Scrivener evaluates the active theme through `characterThemeModeProvider(characterId)` (`lib/core/theme/theme_provider.dart`):

```dart
final characterThemeModeProvider = Provider.family<AppThemeMode, String>((ref, characterId) {
  final charSheet = ref.watch(characterSheetProvider(characterId));
  final globalMode = ref.watch(themeProvider);
  return charSheet?.customTheme ?? globalMode;
});
```

1. **Character Custom Theme**: If the character has an explicit theme override selected, that theme is applied across all seven tabs, combat dashboards, and sheet modals.
2. **Global Fallback**: If no override is set (`customTheme == null`), the sheet automatically inherits the global application theme set in `themeProvider`.

---

## 2. Setting a Character's Theme

Inside any character sheet:
1. Tap the **Theme Palette** icon (`Icons.palette_outlined`) in the sheet's AppBar.
2. Select any of the six built-in theme presets (or custom themes).
3. The character sheet re-renders instantly with the new color scheme, typography, card gradients, and iconography.
4. The preference is automatically persisted to the character's record in the local SQLite database.

---

## 3. Configurable Tab & Navigation Styles

Every theme token bundle (`ScrivenerThemeTokens`) specifies how character navigation is rendered:

### A. Navigation Layouts (`CharacterNavigationStyle`)
1. **Horizontal Tabs (`CharacterNavigationStyle.horizontalTabs`)**:
   - The classic scrollable tab strip at the top of the sheet.
   - Ideal for tablets, desktop monitors, and landscape mobile viewports.
2. **Header Dropdown (`CharacterNavigationStyle.headerDropdown`)**:
   - Replaces the tab bar with a compact dropdown selector directly below the hero header.
   - Saves significant vertical screen real estate on phones and small displays.
   - Used by default in **High-Contrast Dungeon OLED** and **Infernal Brimstone**.

### B. Tab Content Styles (`CharacterTabContentStyle`)
1. **Icons and Text (`CharacterTabContentStyle.iconsAndText`)**:
   - Displays both the theme-styled glyph and the text title (Default).
2. **Icons Only (`CharacterTabContentStyle.iconsOnly`)**:
   - Ultra-compact presentation showing only the icon glyph.
3. **Text Only (`CharacterTabContentStyle.textOnly`)**:
   - Clean, bookish editorial typography without icon glyphs (Default in **Scholar's Desk**).

---

## 4. Responsive Design Guidelines

When developing custom widgets or responsive views in Scrivener, adhere to the mobile-first rules defined in `AGENTS.md`:
- **Narrow Viewports (320px–360px)**: Never use fixed widths greater than 300px. Use `Wrap`, `Flexible`, `Expanded`, or `SingleChildScrollView`.
- **System Safe Areas**: Bottom navigation and sticky action buttons must always be wrapped in `SafeArea` to prevent overlap with Android system navigation gestures and iOS home indicators.
- **Landscape Viewports**: Dialogs and bottom sheets must remain scrollable (`SingleChildScrollView`) so keyboard or height constraints do not cause `RenderFlex` overflow errors.
