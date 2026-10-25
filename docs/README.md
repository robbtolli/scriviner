# Scrivener Documentation Hub

Welcome to the comprehensive documentation suite for **Scrivener** — a high-performance, modular TTRPG character manager and rules engine built with Flutter and Dart by Robert Tolliver ([tollitech.com](https://tollitech.com)).

---

## Documentation Directory

```
docs/
├── README.md                      # Documentation Hub & Sitemap (this file)
├── images/                        # High-resolution screenshots
├── user-guide/                    # Player & Game Master Manuals
│   ├── getting-started.md         # First launch, roster, and character creation
│   ├── character-sheet.md         # 7-tab sheet mastery, combat, rests, and leveling
│   ├── dice-roller.md             # Mathematical dice engine and formula syntax
│   └── export-and-backup.md       # JSON backup, QR transfer, and 2-page printable PDF
├── plugins/                       # Homebrew & Compendium Developer Guide
│   ├── plugin-architecture.md     # Sandboxed design and SQLite lifecycle
│   ├── manifest-spec.md           # Schema reference for PluginManifest JSON
│   ├── authoring-compendiums.md   # Writing custom spells, items, and features
│   ├── authoring-systems.md       # Implementing modular TTRPG rulesets
│   └── packaging-and-distribution.md # Bundling and sharing homebrew packs
└── themes/                        # Theme Customization & Visual Tokens
    ├── theme-architecture.md      # ScrivenerThemeTokens, iconography, and Riverpod
    ├── builtin-themes.md          # Visual profile of all 6 built-in themes
    ├── authoring-custom-themes.md # Guide to creating new themes and palettes
    └── per-character-theming.md   # Per-hero theme overrides and navigation styles
```

---

## 1. User Guides

For players, Dungeon Masters, and tabletop enthusiasts using Scrivener during play sessions:

- [**Getting Started**](user-guide/getting-started.md): System requirements, multi-platform setup, creating characters via the 4-step guided wizard or Smart Paper freeform mode, and managing the character roster.
- [**Character Sheet Mastery**](user-guide/character-sheet.md): Comprehensive breakdown of all seven character sheet tabs (Stats, Skills, Combat, Spells, Features, Gear, Bio), HP adjustments, death saving throw mechanics, short/long rest execution, and in-sheet leveling up.
- [**Dice Roller Reference**](user-guide/dice-roller.md): Global neutral title-bar quick-roller, character sheet roll actions, mathematical dice notation (`2d20kh1+5`, `4d6dl1`, advantage/disadvantage), situational modifiers (Bless, Guidance), and roll history log.
- [**Export, Backup & PDF Export**](user-guide/export-and-backup.md): Offline persistence guarantees, JSON character backup and restore, peer-to-peer QR code transfer, and 2-page printable character sheet PDF generation with system print integration.

---

## 2. Plugin Developer Guides

For creators authoring custom homebrew content, campaign compendiums, or new rulesets:

- [**Plugin Architecture**](plugins/plugin-architecture.md): Overview of Scrivener's sandboxed, declarative plugin design. Learn why data-driven JSON injection into SQLite ensures total security without executing untrusted bytecode.
- [**Manifest Specification**](plugins/manifest-spec.md): Complete JSON schema reference for `PluginManifest` (`id`, `name`, `version`, `author`, `targetSystem`, `type`, `description`, `entities`).
- [**Authoring Compendiums**](plugins/authoring-compendiums.md): Step-by-step tutorial on formatting custom spells, weapons, armor, wondrous items, class features, and feats with complete JSON examples.
- [**Authoring TTRPG Systems**](plugins/authoring-systems.md): Guide to the `SystemContract` architecture for extending Scrivener to support Pathfinder 2e, Shadowdark, or custom homebrew game engines.
- [**Packaging & Distribution**](plugins/packaging-and-distribution.md): Best practices for packaging `.json` manifests, testing locally with `PluginLoaderService`, importing via the in-app UI, and sharing with players.

---

## 3. Theme Developer Guides

For UI designers and developers creating atmospheric visual aesthetics:

- [**Theme Architecture**](themes/theme-architecture.md): The multi-layered visual engine combining Flutter's `ThemeData`, `ScrivenerThemeTokens`, `ScrivenerIconography`, typography pairings, and reactive Riverpod providers.
- [**Built-in Themes**](themes/builtin-themes.md): Deep-dive into the color palettes, typography pairings, and token values of the 6 built-in themes: Ancient Tome, Scholar's Desk, Midnight Arcana, High-Contrast Dungeon OLED, Emerald Enclave, and Infernal Brimstone.
- [**Authoring Custom Themes**](themes/authoring-custom-themes.md): Practical tutorial on writing a new theme, defining custom gradients and card borders, assigning iconography sets, and registering the theme in the theme selector.
- [**Per-Character Theming**](themes/per-character-theming.md): How character-level theme overrides work, database persistence, and configuring responsive navigation styles (tabs vs header dropdowns; icons, text, or both).

---

## 4. Architectural Rules & Coding Standards

For developers contributing code directly to the Scrivener codebase:
- See [**AGENTS.md**](../AGENTS.md) at the repository root for strict coding rules, responsive mobile layout rules (320px–360px support, SafeAreas), `PropertyPipeline` conventions, and automated testing requirements.
