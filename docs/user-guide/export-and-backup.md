# Character Export, Backup & Printable PDF Guide

Scrivener is built with an **offline-first, user-owned data model**. Your characters, compendium entries, and notes belong to you. This guide explains how to back up characters, share them with peers, and print publication-grade character sheets.

<p align="center">
  <img src="../images/pdf_export.png" alt="2-Page Printable Character Sheet PDF" width="850" />
</p>

---

## 1. Offline Persistence & Local Storage

- All characters, active conditions, inventory, and compendium data are stored in a local SQLite database powered by **Drift**.
- On Desktop (Linux, macOS, Windows), the database file is located in your operating system's standard application data directory (`scrivener_db.sqlite`).
- On Mobile (Android, iOS), the database is stored in secure, private app storage.
- On Web, data is stored in your browser's persistent IndexedDB via WebAssembly SQLite.
- **Zero Cloud Requirement**: Scrivener functions completely offline in air-gapped conventions, remote cabins, or basement gaming dens.

---

## 2. JSON Character Backup & Restore

### Exporting to JSON
1. From the **Character Sheet**, tap the **Export** icon (`Icons.download_outlined`) in the AppBar (or choose **Export Character** from the three-dot card menu on the Home screen).
2. The export dialog displays the complete, formatted JSON representation of your hero.
3. Tap **Copy to Clipboard** or **Save File** to store the `.json` file on your device, cloud drive, or flash drive.

### Sample JSON Character Format
```json
{
  "scrivener_version": "1.0.0",
  "id": "sample-thorin",
  "name": "Thorin Ironforge",
  "systemId": "dnd5e",
  "createdAt": "2026-10-24T18:00:00.000Z",
  "lastPlayedAt": "2026-10-24T20:45:00.000Z",
  "rawProperties": {
    "level": 3,
    "class": "Fighter",
    "subclass": "Champion",
    "race": "Mountain Dwarf",
    "background": "Soldier",
    "hp": { "current": 28, "max": 31, "temp": 5 },
    "armorClass": 18,
    "speed": 25,
    "proficiencyBonus": 2,
    "abilities": {
      "str": { "score": 16, "mod": 3 },
      "dex": { "score": 12, "mod": 1 },
      "con": { "score": 16, "mod": 3 },
      "int": { "score": 10, "mod": 0 },
      "wis": { "score": 13, "mod": 1 },
      "cha": { "score": 8, "mod": -1 }
    },
    "savingThrows": ["strength", "constitution"],
    "skills": ["Athletics", "Intimidation", "Survival", "Perception"],
    "currency": { "gp": 120, "sp": 24, "cp": 15, "pp": 2 }
  },
  "inventory": [
    {
      "name": "Dwarven Warhammer",
      "quantity": 1,
      "weight": 2.0,
      "isEquipped": true
    }
  ],
  "conditions": [
    {
      "conditionId": "blessed",
      "durationRounds": 10
    }
  ]
}
```

### Importing from JSON
1. Tap the **+** button on the Home screen to open the **Create New Character** modal.
2. Tap **Import JSON**.
3. Paste the JSON backup text or select a saved `.json` file.
4. Tap **Import Hero**. The character is parsed, validated, assigned a unique ID, and added to your roster.

---

## 3. Peer-to-Peer QR Code Sharing

For rapid transfer at the game table without Wi-Fi, cables, or file transfers:
1. Open the **Export Character** dialog on your device.
2. Select the **QR Code** tab. Scrivener generates a compressed high-density QR code encoding your character's properties.
3. Your friend taps **Import JSON** on their device and taps **Scan QR Code** using their phone camera.
4. The character imports instantly onto their device.

---

## 4. 2-Page Printable Character Sheet PDF Export

Scrivener generates publication-grade 2-page PDF character sheets adhering to the standard D&D 5e / 2024 tabletop layout:

### Page 1: Core Attributes & Combat Vitals
- **Header**: Character Name, Class & Level, Race, Background, System (`D&D 5e / 2024`).
- **Ability Score Boxes**: Large score display, modifier pills (`STR +3`, `DEX +1`, `CON +3`, `INT +0`, `WIS +1`, `CHA -1`).
- **Proficiency & Inspiration**: Dynamic proficiency bonus pill and inspiration checkbox.
- **Saving Throws**: All 6 saves with filled circles indicating proficiencies.
- **Skill List**: All 18 standard skills with calculated bonuses and proficiency indicators.
- **Defenses & Health**:
  - Armor Class (AC) with armor notes.
  - Initiative modifier.
  - Tactical speed in feet.
  - Maximum and Current Hit Points with temporary HP.
  - Hit Dice total and die type (`3d10`).
  - Death Saving Throw trackers (3 success circles, 3 failure circles).
- **Attacks & Spellcasting**: Table listing equipped weapons, attack bonuses, and damage formulas.
- **Active Conditions & Buffs**: Visual warning box listing active status effects.
- **Passive Senses & Languages**: Passive Perception, Insight, Investigation, and known languages.

### Page 2: Features, Spells & Equipment
- **Features & Traits**: Bulleted list of all class features, subclass traits, and racial perks with full descriptions.
- **Equipment & Carried Gear**: Inventory table listing item names, quantities, individual weights, equipped flags (`[E]`), and carried coin purse (CP, SP, EP, GP, PP) with total capacity.
- **Spellcasting Section**: Spell Save DC, Spell Attack modifier, and list of known and prepared spells.
- **Character Backstory & Traits**: Personality Traits, Ideals, Bonds, Flaws, and campaign chronicle notes.
- **Footer**: Includes copyright attribution and page indexing (`PAGE 1 OF 2`, `PAGE 2 OF 2`).

### Printing from Scrivener
1. Tap the **Print** icon (`Icons.print_outlined`) in the character sheet AppBar.
2. The **PDF Preview Screen** opens with an interactive document viewer.
3. Use the page format dropdown to select between **US Letter** and **A4**.
4. Tap **Print** to send directly to your operating system's printer dialog or tap **Share** to email or save the PDF file.
