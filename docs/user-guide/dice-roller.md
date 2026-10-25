# Dice Roller & Syntax Reference

Scrivener features an interactive mathematical dice engine and parser capable of evaluating complex tabletop formulas, tracking advantage/disadvantage, dropping dice, detecting critical successes, and maintaining an encounter roll history.

<p align="center">
  <img src="../images/dice_roller.png" alt="Scrivener Dice Roller Drawer" width="800" />
</p>

---

## 1. Dual Rolling Modes

### A. Title-Bar Quick Roller (Neutral Mode)
- Accessible from the AppBar on both the **Home Screen** and **Character Sheet Screen** via the die icon (`Icons.casino_outlined`).
- Operates in a **neutral roll mode** (`setQuickRoll()`):
  - Rolls evaluate in real time with animations and sound effects.
  - Results are displayed prominently in the drawer.
  - **Zero Character Mutation**: Neutral rolls do *not* deduct spell slots, alter character HP, or write to character-specific encounter logs.
  - Ideal for Dungeon Masters rolling monster attacks, secret perception checks, or quick random table lookups.

### B. Character Sheet Roller (Contextual Mode)
- Triggered whenever you tap a stat check, saving throw, skill check, weapon attack, or spell cast on a character sheet.
- Automatically pre-populates the formula bar with the character's exact derived modifiers (e.g. `1d20+5` for a Strength check or `1d8+3` for a Warhammer attack).
- Roll results can be logged to the character's history.

---

## 2. Supported Dice Notation & Syntax

The Scrivener parser (`DiceParser`) supports standard tabletop mathematical expressions:

| Notation Pattern | Example Expression | Description |
| :--- | :--- | :--- |
| **Standard Die** | `1d20`, `3d6`, `1d100` | Rolls $N$ dice with $X$ faces. |
| **Shorthand Die** | `d20`, `d6`, `d8` | Omitting $N$ defaults to 1 die (`1d20`). |
| **Flat Modifiers** | `1d20 + 5`, `2d6 - 1` | Adds or subtracts numerical bonuses. |
| **Keep Highest** | `2d20kh1`, `4d6kh3` | Rolls $N$ dice, keeps only the highest $K$ dice, and drops the rest. |
| **Keep Lowest** | `2d20kl1` | Rolls $N$ dice and keeps only the lowest $K$ dice. |
| **Drop Lowest** | `4d6dl1` | Rolls $N$ dice and drops the lowest $D$ dice (standard character stat generation). |
| **Drop Highest** | `2d20dh1` | Rolls $N$ dice and drops the highest $D$ dice. |
| **Advantage / Disadvantage** | `1d20adv`, `1d20dis` | Shorthand for `2d20kh1` (Advantage) and `2d20kl1` (Disadvantage). |
| **Compound Expressions** | `1d8 + 1d6 + 3` | Combines multiple die pools and modifiers in a single roll (e.g. Sneak Attack + weapon damage). |
| **Multi-Pool Dice** | `2d6 + 2d8 + 4` | Supports arbitrary mixtures of dice types and constants. |

---

## 3. Interactive Dice Tray Features

### 1. Preset Dice Buttons
Tap any die button in the tray (`d4`, `d6`, `d8`, `d10`, `d12`, `d20`, `d100`) to add dice to your current formula. Tapping `d6` three times automatically formats `3d6`.

### 2. Roll Type Toggles
Select your roll type before rolling:
- **Normal**: Standard roll (`1d20`).
- **Advantage**: Automatically rolls with advantage (`2d20kh1`).
- **Disadvantage**: Automatically rolls with disadvantage (`2d20kl1`).

### 3. Situational Modifiers
One-tap situational buff buttons:
- **+1d4 Bless**: Appends `+ 1d4` to attack rolls and saving throws.
- **+1d4 Guidance**: Appends `+ 1d4` to ability checks.
- **+1d6 Bardic Inspiration**: Appends `+ 1d6` to any roll.

### 4. Critical Detection
- **Natural 20**: When a 20 is rolled on a d20, the result card flashes radiant gold with a **CRITICAL HIT!** badge.
- **Natural 1**: When a 1 is rolled on a d20, the result card highlights in crimson with a **CRITICAL MISS!** badge.

### 5. Roll History Log
The bottom section of the drawer maintains a scrollable history of all rolls executed during the active session. Each log entry displays:
- The formula rolled (e.g. `2d20kh1 + 5`).
- Total final result.
- Granular breakdown of individual dice rolled (e.g. `[18, (dropped: 7)] + 5 = 23`).
- Timestamp.
- Quick **Re-roll** button to repeat previous formulas instantly.
