# Built-in Themes Profile

Scrivener ships with six hand-crafted visual themes. Each theme provides an authentic tabletop atmosphere optimized for distinct gaming environments, lighting conditions, and character archetypes.

<p align="center">
  <img src="../images/theme_gallery.png" alt="Scrivener Theme Selector Dialog" width="700" />
</p>

---

## 1. Comparative Theme Matrix

| Theme Name | Primary Aesthetic | Best For | Background | Primary Accent | Border Style | Typography Pairing | Iconography Bundle |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Ancient Tome** | Dark Parchment Fantasy | Default table play | `#1C1815` | Antique Gold (`#C89B3C`) | Gold `#C89B3C` (1.5px) | Cinzel + serif | `fantasy` |
| **Scholar's Desk** | Daylight Light Parchment | Daytime sessions, outdoor play | `#F7F3E8` | Warm Bronze (`#996515`) | Sepia `#DDD2C0` (1.0px) | EB Garamond + serif | `classic` |
| **Midnight Arcana** | Cosmic Indigo & Glowing Cyan | Low-light evening sessions | `#0C101D` | Arcane Cyan (`#00E5FF`) | Cyan `#00E5FF` (1.5px) | Rajdhani + sans-serif | `arcana` |
| **High-Contrast Dungeon** | True OLED Black & Gold | Maximum battery life & legibility | `#000000` | Dungeon Gold (`#FFD700`) | Solid Gold (2.0px) | Chivo + sans-serif | `dungeon` |
| **Emerald Enclave** | Moss Green & Radiant Jade | Nature campaigns & Druids | `#0C1A13` | Jade Glow (`#00E676`) | Jade `#00E676` (1.5px) | Cormorant Garamond | `nature` |
| **Infernal Brimstone** | Obsidian Ash & Hellfire Orange | Fiendish, dark fantasy campaigns | `#120C0E` | Hellfire Orange (`#FF4500`) | Hellfire (1.5px) | Pirata One + serif | `infernal` |

---

## 2. In-Depth Theme Breakdown

### Preset 1: Ancient Tome (Default)
- **Aesthetic**: Aged grimoire parchment, antique brass clasps, and royal crimson ribbons.
- **Palette**:
  - Scaffold Background: `#1C1815` (Parchment Dark)
  - Surface: `#26211C`
  - Card Gradient: `[#382D20, #261F17]`
  - Primary Accent: `#C89B3C` (Primary Gold)
  - Secondary Accent: `#8B261E` (Dark Crimson)
  - Body Text: `#F2EBD9`
- **Typography**: Header font **Cinzel** with fallback to `serif`.
- **Navigation Style**: `CharacterNavigationStyle.horizontalTabs`
- **Tab Content Style**: `CharacterTabContentStyle.iconsAndText`
- **Iconography**: `ScrivenerIconography.fantasy` (Rune, shield, and spell book icons).

---

### Preset 2: Scholar's Desk
- **Aesthetic**: Crisp daylight parchment paper, fountain pen ink, and leather-bound library bindings.
- **Palette**:
  - Scaffold Background: `#F7F3E8` (Light Paper)
  - Surface: `#FFFFFF`
  - Card Gradient: `[#FFFFFF, #F4EFE6]`
  - Primary Accent: `#996515` (Warm Bronze)
  - Secondary Accent: `#8B261E` (Wax Seal Red)
  - Body Text: `#2A2118` (Dark Ink)
  - Card Border: `#DDD2C0`
- **Typography**: Header font **EB Garamond** with fallback to `serif`.
- **Navigation Style**: `CharacterNavigationStyle.horizontalTabs`
- **Tab Content Style**: `CharacterTabContentStyle.textOnly` (Clean editorial layout).
- **Iconography**: `ScrivenerIconography.classic`.

---

### Preset 3: Midnight Arcana
- **Aesthetic**: Deep astral void, glowing spellcasting circles, celestial constellations, and luminous cyan runes.
- **Palette**:
  - Scaffold Background: `#0C101D` (Space Navy)
  - Surface: `#141D38`
  - Card Gradient: `[#1E2850, #11172E]`
  - Primary Accent: `#00E5FF` (Arcane Cyan)
  - Secondary Accent: `#B388FF` (Mystic Violet)
  - Body Text: `#E2E8F8`
- **Typography**: Header font **Rajdhani** with fallback to `sans-serif`.
- **Navigation Style**: `CharacterNavigationStyle.horizontalTabs`
- **Tab Content Style**: `CharacterTabContentStyle.iconsAndText`
- **Iconography**: `ScrivenerIconography.arcana` (Cosmic stars, flares, diamonds).

---

### Preset 4: High-Contrast Dungeon (OLED)
- **Aesthetic**: Tactical, high-readability subterranean crawler aesthetic designed to maximize battery efficiency on OLED displays and eliminate eye strain in pitch-black rooms.
- **Palette**:
  - Scaffold Background: `#000000` (True OLED Black)
  - Surface: `#121212`
  - Card Gradient: `[#1E1E1E, #0A0A0A]`
  - Primary Accent: `#FFD700` (Dungeon Gold)
  - Secondary Accent: `#FF4444` (Danger Red)
  - Card Border: `#FFD700` (2.0px crisp border)
  - Body Text: `#FFFFFF`
- **Typography**: Header font **Chivo** with fallback to `sans-serif`.
- **Navigation Style**: `CharacterNavigationStyle.headerDropdown` (Maximizes vertical viewable height).
- **Tab Content Style**: `CharacterTabContentStyle.iconsAndText`
- **Iconography**: `ScrivenerIconography.dungeon` (Geometric, square, high-contrast glyphs).

---

### Preset 5: Emerald Enclave
- **Aesthetic**: Verdant moss, dense canopy foliage, ancient oak bark, and radiant healing jade.
- **Palette**:
  - Scaffold Background: `#0C1A13` (Forest Deep)
  - Surface: `#13281E` (Surface Moss)
  - Card Gradient: `[#1D3B2C, #0F2218]`
  - Primary Accent: `#00E676` (Jade Glow)
  - Secondary Accent: `#8D6E63` (Bark Brown)
  - Card Border: `#00E676` (1.5px)
  - Body Text: `#E8F5E9`
- **Typography**: Header font **Cormorant Garamond** with fallback to `serif`.
- **Navigation Style**: `CharacterNavigationStyle.horizontalTabs`
- **Tab Content Style**: `CharacterTabContentStyle.iconsAndText`
- **Iconography**: `ScrivenerIconography.nature` (Trees, leaves, flowers).

---

### Preset 6: Infernal Brimstone
- **Aesthetic**: Obsidian volcanic ash, smoky charcoal, and glowing molten hellfire orange.
- **Palette**:
  - Scaffold Background: `#120C0E` (Volcanic Ash)
  - Surface: `#1C1316`
  - Card Gradient: `[#331E24, #160B0E]`
  - Primary Accent: `#FF4500` (Hellfire Orange)
  - Secondary Accent: `#FFD600` (Lava Gold)
  - Card Border: `#FF4500` (1.5px)
  - Body Text: `#FFEBE8`
- **Typography**: Header font **Pirata One** with fallback to `serif`.
- **Navigation Style**: `CharacterNavigationStyle.headerDropdown`
- **Tab Content Style**: `CharacterTabContentStyle.iconsOnly` (Compact glyph-only navigation).
- **Iconography**: `ScrivenerIconography.infernal` (Fire, embers, flames).
