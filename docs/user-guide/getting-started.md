# Getting Started with Scrivener

Welcome to **Scrivener**, a cross-platform companion application designed for tabletop roleplaying games (TTRPGs). Scrivener runs natively on Android, iOS, macOS, Windows, Linux, and modern Web browsers.

<p align="center">
  <img src="../images/hero_roster.png" alt="Scrivener Hero Roster" width="800" />
</p>

---

## 1. System Requirements & Installation

Scrivener is an offline-first application. It requires no persistent internet connection and does not demand account creation or subscriptions.

### Platform Availability
- **Desktop (Linux, macOS, Windows)**: Download and run the native desktop executable or build from source using the Flutter SDK.
- **Mobile (Android, iOS)**: Install the native package (`com.tollitech.scrivener`).
- **Web**: Access via any standards-compliant browser with WebGL and IndexedDB support (Chrome, Firefox, Safari, Edge).

---

## 2. The Home Screen & Hero Roster

Upon opening Scrivener, you are greeted by the **Home Screen**:

1. **Title Bar**:
   - **Tome Icon & Title**: Tap to return to the root roster at any time.
   - **Search Icon** (`Icons.search`): Search characters instantly across your roster by hero name, class, or ruleset.
   - **Quick Dice Roller** (`Icons.casino_outlined`): Opens the global dice roller in neutral mode. Rolls display immediately without altering any character stats or logs.
   - **App Theme Selector** (`Icons.palette_outlined`): Switch between the six global atmospheric themes.
   - **Plugins & Compendiums** (`Icons.extension_outlined`): Manage installed homebrew packages, custom spells, and items.
2. **Resume Session Hero Card**:
   - The hero you played most recently is pinned prominently at the top with quick-access vital statistics (Level, Class, HP, AC) and a direct **Continue** button.
3. **Recent Heroes Grid**:
   - Displays all other characters ordered by last-played timestamp.
   - Tap any card to open the character sheet.
   - Tap the three-dot overflow menu (`⋮`) on any card to export as JSON, print to PDF, or delete the character.
4. **Floating Action Button** (`+`):
   - Located at the bottom right. Tapping this opens the **Create New Character** modal.

---

## 3. Creating a New Character

When you tap the `+` Floating Action Button (or "+ Create New Character" on an empty roster), the **Create New Character** modal appears:

<p align="center">
  <img src="../images/character_wizard.png" alt="Create New Character Modal" width="650" />
</p>

Scrivener offers two distinct creation workflows:

### Option A: Guided Step-by-Step Wizard (Recommended for New & Leveling Players)
A structured 4-step wizard that calculates stats, provides educational hints, and applies SRD rules automatically:

1. **Step 1: Character Concept & Identity**:
   - Enter your hero's name and optional alignment.
   - Select your character's gender (Male or Female) or specify custom pronouns.
   - Choose your character's starting level (1–20).
2. **Step 2: Class & Background**:
   - Choose from standard SRD classes (Barbarian, Bard, Cleric, Druid, Fighter, Monk, Paladin, Ranger, Rogue, Sorcerer, Warlock, Wizard).
   - Select your character's race and background (e.g. Soldier, Sage, Criminal, Acolyte).
3. **Step 3: Equipment & Spells**:
   - Choose starting equipment packages or starting wealth.
   - If playing a spellcasting class, select starting cantrips and 1st-level spells.
4. **Step 4: Ability Scores**:
   - Choose your preferred stat generation method:
     - **Standard Array**: Fixed values [15, 14, 13, 12, 10, 8] assigned to attributes.
     - **Point Buy**: 27 points to distribute across attributes (costs scaling from 8 to 15).
     - **Rolling (4d6dl1)**: An interactive rolling tray that rolls 4d6, drops the lowest die, and records the score for each of the six attributes.
   - Review racial attribute bonuses applied live to your scores.
   - Tap **Finish & Create** to generate your character sheet.

### Option B: Freeform / "Smart Paper" Sheet
Designed for experienced players, game masters creating quick NPCs, or homebrew campaigns:
- Instantly creates a blank Level 1 character sheet with neutral baseline attributes (10 in all stats, 10 HP, 10 AC).
- Every stat, skill, weapon, and feature is editable in place directly on the sheet.
- Bypasses rule prerequisites, allowing arbitrary ability scores, custom classes, and homebrew mechanics.

---

## 4. Importing Characters

You can import characters created on another device:
1. Tap **Import JSON** on the character creation modal or select the menu action from the AppBar.
2. Paste the JSON backup string directly into the text field or scan a peer's character QR code.
3. Tap **Import Hero**. The character is validated, inserted into your local database, and opened immediately.

---

## Next Steps
- Learn how to master every tab of your sheet in the [**Character Sheet Mastery Guide**](character-sheet.md).
- Learn advanced dice rolling syntax in the [**Dice Roller Reference**](dice-roller.md).
- Learn about backups and printing in the [**Export & Backup Guide**](export-and-backup.md).
