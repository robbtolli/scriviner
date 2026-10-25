# Plugin Manifest Specification

Every Scrivener plugin is declared via a JSON object conforming to the `PluginManifest` schema. This document specifies the required fields, data types, validation constraints, and entity structures.

---

## 1. Top-Level Manifest Fields

| Field | Type | Required | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `String` | **Yes** | — | Unique package identifier. Must use lowercase alphanumeric characters and hyphens (e.g., `eloria-homebrew-compendium`). |
| `name` | `String` | **Yes** | — | Human-readable display name of the plugin pack (e.g., `Relics of Eloria Pack`). |
| `version` | `String` | **Yes** | `1.0.0` | Semantic version string adhering to `MAJOR.MINOR.PATCH` format (e.g., `1.2.0`). |
| `author` | `String` | **Yes** | `Unknown Author` | Name, studio, or handle of the author or publisher. |
| `targetSystem` | `String` | **Yes** | `dnd5e` | Identifier of the target TTRPG system (e.g., `dnd5e`, `pf2e`). |
| `type` | `String` | No | `compendium` | Category of plugin: `compendium`, `theme`, or `system`. |
| `description` | `String` | No | `""` | Markdown-supported summary describing the contents of the pack. |
| `entities` | `Map<String, List<Object>>` | No | `{}` | Key-value mapping containing lists of packaged game entities. |

---

## 2. Validation Rules & ID Namespacing

### Validation Rules
When `PluginManifest.fromJson()` or `PluginLoaderService.installPlugin()` evaluates a manifest:
1. `id` must not be empty or whitespace only. Otherwise, throws `FormatException('Plugin manifest missing required field: id')`.
2. `name` must not be empty or whitespace only. Otherwise, throws `FormatException('Plugin manifest missing required field: name')`.
3. `version` must not be empty or whitespace only. Otherwise, throws `FormatException('Plugin manifest missing required field: version')`.
4. `targetSystem` must not be empty or whitespace only. Otherwise, throws `FormatException('Plugin manifest missing required field: targetSystem')`.

### Slugification & Namespacing Algorithm
To ensure entity IDs remain globally unique across multiple homebrew creators and official SRD content:
1. Entity names are slugified:
   - Converted to lowercase.
   - Non-alphanumeric characters replaced with underscores (`_`).
   - Leading and trailing underscores stripped.
2. The final database ID is assembled using the format:
   ```
   ${manifest.id}:${category}:${slug}
   ```
   *Example*: Manifest `shadow-realm` with spell name `Grave Chill` produces:
   ```
   shadow-realm:spell:grave_chill
   ```

---

## 3. Entity Schemas

### A. Spells (`entities.spells`)
A list of spell objects.

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `name` | `String` | **Yes** | Name of the spell. |
| `id` | `String` | No | Explicit entity ID. If omitted, slugified from `name`. |
| `level` | `int` | **Yes** | Spell tier (0 for Cantrips, 1–9 for leveled spells). |
| `school` | `String` | **Yes** | Magic school (e.g. `Abjuration`, `Evocation`, `Transmutation`). |
| `castingTime` | `String` | **Yes** | Action cost (e.g. `1 action`, `1 bonus action`, `1 reaction`). |
| `range` | `String` | **Yes** | Target range (e.g. `Self`, `Touch`, `60 feet`, `120 feet`). |
| `components` | `String` | No | Spell components (e.g. `V, S, M (a pinch of sulfur)`). |
| `duration` | `String` | No | Duration (e.g. `Instantaneous`, `Concentration, up to 1 minute`). |
| `damage` | `String` | No | Damage formula (e.g. `3d6 Radiant`). |
| `description` | `String` | **Yes** | Complete rules description and effects. |

---

### B. Equipment & Items (`entities.items` or `entities.equipment`)
A list of item objects.

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `name` | `String` | **Yes** | Name of the equipment or item. |
| `id` | `String` | No | Explicit entity ID. If omitted, slugified from `name`. |
| `category` | `String` | **Yes** | Item type (e.g. `Martial Melee Weapon`, `Heavy Armor`, `Wondrous Item`, `Ring`). |
| `weight` | `double` | No | Weight in pounds (e.g. `3.0`). |
| `cost` | `String` | No | Price or market value (e.g. `1,500 gp`). |
| `damage` | `String` | No | Damage dice formula (e.g. `1d8 Slashing + 1d4 Radiant`). |
| `ac` | `int` | No | Base AC value (for armor). |
| `acBonus` | `int` | No | AC bonus (e.g. `2` for a shield). |
| `rarity` | `String` | No | Rarity tier (`Common`, `Uncommon`, `Rare`, `Very Rare`, `Legendary`). |
| `attunement` | `bool` | No | Whether the item requires an attunement slot. |
| `description` | `String` | **Yes** | Item description and magical properties. |

---

### C. Class Features & Traits (`entities.features`)
A list of trait objects.

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `name` | `String` | **Yes** | Feature title. |
| `id` | `String` | No | Explicit entity ID. If omitted, slugified from `name`. |
| `source` | `String` | **Yes** | Origin (e.g. `Paladin Level 3`, `Wood Elf Trait`, `Feat`). |
| `description` | `String` | **Yes** | Complete ability rules and usage restrictions. |

---

## 4. Full Manifest Example

```json
{
  "id": "eloria-homebrew-compendium",
  "name": "Relics of Eloria Pack",
  "version": "1.0.0",
  "author": "Tabletop Guild",
  "targetSystem": "dnd5e",
  "type": "compendium",
  "description": "Adds 3 legendary relics, 3 mystic spells, and 1 unique feature from the Eloria campaign.",
  "entities": {
    "spells": [
      {
        "name": "Elorian Moonfire",
        "level": 2,
        "school": "Evocation",
        "castingTime": "1 action",
        "range": "60 feet",
        "damage": "3d6 Radiant",
        "description": "Bathes targets in silver moonlight dealing 3d6 radiant damage and revealing invisible creatures."
      }
    ],
    "items": [
      {
        "name": "Sunforged Blade",
        "category": "Martial Melee Weapon",
        "weight": 3.0,
        "cost": "1,500 gp",
        "damage": "1d8 Slashing + 1d4 Radiant",
        "rarity": "Very Rare",
        "attunement": true,
        "description": "A mastercrafted radiant scimitar forged inside the heart of an ancient solar forge."
      }
    ],
    "features": [
      {
        "name": "Moonlight Blessing",
        "source": "Eloria Cleric Domain",
        "description": "Once per long rest, call upon astral moonlight to grant yourself advantage on all saving throws for 1 round."
      }
    ]
  }
}
```
