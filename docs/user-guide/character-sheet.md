# Character Sheet Mastery

The **Character Sheet** is the core gameplay interface in Scrivener. Built to replace physical paper character sheets without sacrificing clarity or tactile feedback, it organizes all character attributes across seven dedicated tabs.

<p align="center">
  <img src="../images/character_sheet_stats.png" alt="Stats Tab" width="800" />
</p>

---

## 1. Sheet Header & Global Actions

At the top of every character sheet:
- **Back Navigation** (`←`): Saves current character state to SQLite and returns to the Home screen.
- **Hero Name & Edit Icon** (`✏️`): Tap the pencil icon to rename your character in place.
- **Subtitle**: Displays your hero's class, level, and race (e.g. `LEVEL 3 FIGHTER (MOUNTAIN DWARF)`).
- **Theme Palette** (`Icons.palette_outlined`): Opens the in-sheet theme selector to customize this character's individual theme override and tab navigation style.
- **Print PDF** (`Icons.print_outlined`): Generates a 2-page printable PDF character sheet and opens the preview dialog.
- **Export Character** (`Icons.download_outlined`): Exports this character as clean JSON or displays a peer-to-peer QR code.
- **Dice Roller Drawer** (`Icons.casino_outlined`): Opens the dice roller configured with this character's attributes.
- **Rest Button** (`Icons.hotel_outlined` / `REST`): Opens the **Rest Management Dialog** to perform a Short Rest or Long Rest.

---

## 2. The Seven Character Sheet Tabs

### Tab 1: Stats
The **Stats Tab** provides your foundational ability scores and derived defenses:

1. **Hero Level Banner**:
   - Displays your current level with an **Advance to Next Level** indicator.
   - Tap the gold **Level Up** button to launch the **In-Sheet Leveling Wizard**.
2. **Passive Senses**:
   - **Proficiency Bonus**: Automatically calculated based on total character level (+2 at levels 1–4, +3 at levels 5–8, etc.).
   - **Passive Perception**: `10 + WIS modifier + (Proficiency bonus if proficient)`.
   - **Passive Investigation**: `10 + INT modifier + (Proficiency bonus if proficient)`.
   - **Passive Insight**: `10 + WIS modifier + (Proficiency bonus if proficient)`.
3. **Ability Score Cards** (Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma):
   - **Modifier Pill**: Displays the calculated modifier (e.g. `+3` for score 16, `-1` for score 8).
   - **Check Button**: Tap `CHECK (+X)` to automatically open the dice roller and roll a d20 with your ability modifier applied.
   - **Saving Throw Pill**: Indicates whether your character is proficient in the save (indicated by a filled gold star `★`). Tap `SAVE (+X)` to roll the save with situational modifiers.

---

### Tab 2: Skills
The **Skills Tab** lists all standard TTRPG skill proficiencies (Acrobatics, Animal Handling, Arcana, Athletics, Deception, History, Insight, Intimidation, Investigation, Medicine, Nature, Perception, Performance, Persuasion, Religion, Sleight of Hand, Stealth, Survival):

- **Proficiency Cycles**: Tap the circular indicator next to each skill to cycle between:
  - **Not Proficient**: Uses base ability modifier.
  - **Half Proficient** (Jack of all Trades): Base modifier + `floor(Proficiency / 2)`.
  - **Proficient** (`★`): Base modifier + full Proficiency bonus.
  - **Expertise** (`★★`): Base modifier + double Proficiency bonus.
- **Roll Button**: Tapping any skill immediately loads `1d20 + Total Skill Bonus` into the dice roller.

---

### Tab 3: Combat
The **Combat Dashboard** is engineered for rapid, error-free play during combat encounters:

<p align="center">
  <img src="../images/character_sheet_combat.png" alt="Combat Dashboard" width="800" />
</p>

1. **Hit Point Tracker**:
   - **Current / Maximum HP**: Displays current hit points against maximum.
   - **Temporary HP**: Displays active temporary hit points in a cyan badge.
   - **Dynamic Health Bar**: Visually transitions from radiant green to amber to deep crimson as health depletes.
   - **Quick Adjustment Buttons**: Tap `-10`, `-5`, `-1`, `+1`, `+5`, or `+10` for instant damage or healing adjustments.
   - **Custom Damage / Heal**: Opens a numerical keypad for arbitrary adjustments.
2. **Combat Vitals**:
   - **Armor Class (AC)**: Evaluated dynamically through `PropertyPipeline` considering base armor, Dexterity caps, shields, and magic items.
   - **Initiative**: Dex modifier + initiative bonuses. Tapping rolls initiative directly into the dice log.
   - **Speed**: Tactical movement speed in feet (e.g. `25 FT`, `30 FT`).
   - **Hit Dice**: Remaining available hit dice (e.g. `2/3 1D10`).
3. **Death Saving Throws**:
   - Automatically activates whenever Current HP drops to 0.
   - Tracks 3 Successes and 3 Failures.
   - Supports natural 20 recovery (instantly heals 1 HP and regains consciousness) and natural 1 consequences (marks 2 failures).
4. **Active Conditions & Buffs**:
   - Lists active status effects (Blinded, Charmed, Deafened, Frightened, Grappled, Incapacitated, Invisible, Paralyzed, Petrified, Poisoned, Prone, Restrained, Stunned, Unconscious, Exhaustion levels).
   - Tap **Manage** to add new conditions with duration counters or remove expired debuffs.
5. **Attacks & Actions**:
   - Equipped weapons with calculated attack rolls (`+5 to Hit`) and damage formulas (`1d8 + 3 Slashing`).
   - Dedicated buttons to roll the attack check or damage expression in one click.

---

### Tab 4: Spells
For spellcasters (Wizards, Clerics, Sorcerers, Warlocks, Druids, Bards, Paladins, Rangers):

<p align="center">
  <img src="../images/character_sheet_spells.png" alt="Spells Tab" width="800" />
</p>

1. **Spell Statistics**:
   - **Spell Save DC**: Calculated as `8 + Proficiency Bonus + Spellcasting Ability Modifier`.
   - **Spell Attack Bonus**: Calculated as `Proficiency Bonus + Spellcasting Ability Modifier`.
2. **Spell Slot Counters**:
   - Dedicated slot trackers for spell levels 1st through 9th.
   - Tap circles to expend or recover slots individually during encounters.
3. **Known & Prepared Spells**:
   - Filterable list of spells grouped by tier: Cantrips (At-Will), Level 1, Level 2, etc.
   - Gold star indicates whether a spell is currently prepared.
   - Tapping **Cast** triggers the spell's damage formula or saving throw DC prompt.

---

### Tab 5: Features
- Displays all passive and active abilities granted by class, subclass, race, background, and feats.
- Features include descriptive summaries and usage recovery rules (e.g., *Second Wind*, *Action Surge*, *Sneak Attack*, *Darkvision*).
- Tap **Add Feature** to add custom homebrew traits.

---

### Tab 6: Gear & Inventory
- **Carried Equipment**: Tracks items, quantity, individual weight, container assignment (Backpack, Belt Pouch, Quiver), and equipped status.
- **Attunement Slots**: Track up to 3 attuned magic items simultaneously.
- **Currency Purse**: Manages Copper (cp), Silver (sp), Electrum (ep), Gold (gp), and Platinum (pp).
- **Total Weight & Capacity**: Automatically sums total carried weight and compares against maximum carrying capacity (`Strength × 15 lbs`).

---

### Tab 7: Bio & Notes
- Records character identity details: Personality Traits, Ideals, Bonds, Flaws.
- Backstory, physical appearance notes, age, height, weight, and deity.
- Freeform session chronicle notes persisted directly in SQLite.

---

## 3. Rest Management

Tap the **REST** button in the AppBar to open the Rest Dialog:

- **Short Rest**:
  - Spend available Hit Dice one at a time to recover HP.
  - The roller evaluates `1d[Die] + CON modifier` and increments your health automatically.
  - Recovers short-rest class features (e.g. *Action Surge*, *Second Wind*, Warlock spell slots).
- **Long Rest**:
  - Automatically restores HP to full maximum.
  - Clears all temporary hit points.
  - Recovers half of your total Hit Dice pool.
  - Restores all expended spell slots to full.
  - Removes conditions that reset on a long rest (such as 1 level of Exhaustion).

---

## 4. In-Sheet Leveling Wizard

Tap **Level Up** on the Stats Tab to advance your character:
1. Select your target level (e.g. Level 3 → Level 4).
2. Choose your hit point advancement:
   - Roll class hit die (e.g. `1d10 + CON`).
   - Take the safe fixed average (e.g. `6 + CON`).
3. Unlock newly available spell slots, class features, and ability score improvements.
4. Tap **Confirm Level Up** to apply all modifications through `PropertyPipeline` atomically.
