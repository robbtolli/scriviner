# Authoring Compendiums

This guide walks you step-by-step through creating a custom homebrew compendium for Scrivener, from organizing your lore to writing balanced spells, equipment, and class archetypes.

---

## 1. Preparing Your Plugin Project

A Scrivener compendium plugin is a single `.json` file containing metadata and structured entities.

1. Create a workspace folder for your pack (e.g. `sunken-spire/`).
2. Create `plugin.json`.
3. Fill in the top-level manifest metadata:

```json
{
  "id": "sunken-spire-pack",
  "name": "Chronicles of the Sunken Spire",
  "version": "1.0.0",
  "author": "Archmage Varis",
  "targetSystem": "dnd5e",
  "type": "compendium",
  "description": "Aquatic spells, deep-tide weaponry, and abyssal traits discovered within the Sunken Spire.",
  "entities": {
    "spells": [],
    "items": [],
    "features": []
  }
}
```

---

## 2. Authoring Custom Spells

When adding spells to `entities.spells`, ensure you include standard spellcasting fields so Scrivener can auto-calculate DCs, attack bonuses, and roll triggers on character sheets:

```json
{
  "name": "Abyssal Geyser",
  "level": 3,
  "school": "Conjuration",
  "castingTime": "1 action",
  "range": "90 feet",
  "components": "V, S, M (a droplet of seawater)",
  "duration": "Instantaneous",
  "damage": "4d8 Bludgeoning",
  "description": "You conjure a violent spout of pressurized abyssal brine from the ground beneath a creature you can see. The target must make a Dexterity saving throw. On a failed save, the creature takes 4d8 bludgeoning damage and is knocked prone. On a successful save, it takes half damage and is not knocked prone.\n\n**At Higher Levels**: When you cast this spell using a spell slot of 4th level or higher, the damage increases by 1d8 for each slot level above 3rd."
}
```

### Tips for Balanced Spells
- **Action Economy**: Clearly define `1 action`, `1 bonus action`, or `1 reaction` (with the trigger condition).
- **Concentration**: If a spell provides persistent buffs or ongoing damage, specify `"duration": "Concentration, up to 1 minute"`.
- **Higher Level Scaling**: Document higher-slot benefits under a standard `**At Higher Levels**:` subheader.

---

## 3. Authoring Custom Equipment & Items

Items added to `entities.items` automatically populate the Compendium search dialog and can be added directly to any hero's inventory:

### A. Magical Weapons
```json
{
  "name": "Trident of the Tidal Lord",
  "category": "Martial Melee Weapon",
  "weight": 4.0,
  "cost": "3,200 gp",
  "damage": "1d6 Piercing (1d8 Versatile) + 1d6 Cold",
  "rarity": "Very Rare",
  "attunement": true,
  "description": "Forged from oceanite coral and tipped with enchanted glacial ice.\n\n- You gain a **+2 bonus** to attack and damage rolls made with this magic weapon.\n- When immersed in water, your swimming speed matches your walking speed, and you can breathe underwater freely.\n- **Tidal Wave (1/Day)**: You can cast the *Tidal Wave* spell (save DC 15) without expending a spell slot."
}
```

### B. Armor & Shields
```json
{
  "name": "Kelp-Woven Carapace",
  "category": "Medium Armor",
  "weight": 20.0,
  "cost": "750 gp",
  "ac": 14,
  "rarity": "Rare",
  "attunement": false,
  "description": "Hardened deep-sea carapace laced with enchanted kelp fibres. Provides an Armor Class of **14 + Dexterity modifier (max 2)**. Does not impose disadvantage on Stealth checks."
}
```

---

## 4. Authoring Class Features & Feats

Traits in `entities.features` provide lore, mechanics, and usage restrictions:

```json
{
  "name": "Aquatic Adaptability",
  "source": "Sunken Spire Archetype Level 3",
  "description": "You have adapted to the crushing depths of the abyssal seas:\n\n- You gain a swimming speed of 30 feet.\n- You suffer no penalties on weapon attacks made underwater.\n- You have resistance to cold damage."
}
```

---

## 5. Testing Your Compendium Pack

Before distributing your plugin:
1. Validate JSON syntax using `jq` or an online JSON validator:
   ```bash
   jq . plugin.json > /dev/null
   ```
2. Open Scrivener, tap the **Plugins** icon (`Icons.extension_outlined`) on the Home screen.
3. Tap **Import JSON** and paste your `plugin.json` content.
4. Verify your spells, items, and traits appear in the **Compendium Browser** (`Icons.search`).
5. Open a character sheet, add an item to the hero's inventory, and verify stats and roll buttons work smoothly.
