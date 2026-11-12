# Scrivener Website & Documentation Hub

This directory contains the source code for the official **Scrivener** website, documentation hub, downloads portal, and interactive Flutter Web demos.

- **Framework**: [Astro](https://astro.build/) & [Starlight](https://starlight.astro.build/)
- **Hosting**: [Cloudflare Pages](https://pages.cloudflare.com/) ($0/month with unlimited bandwidth & free SSL)
- **Domain Targets**: `scrivener.tollitech.com` and `dice.tollitech.com`
- **Embedded Web Apps**:
  - `/app/` — Scrivener full character manager (Flutter Web + Drift SQLite WASM)
  - `/dice-app/` — Dice Caster standalone polyhedral roller (Flutter Web)

---

## Directory Layout

```
site/
├── astro.config.mjs          # Astro & Starlight configuration
├── package.json              # Scripts and npm dependencies
├── public/
│   ├── _headers              # Cloudflare Pages WASM & COOP/COEP isolation headers
│   ├── favicon.png           # Scrivener favicon
│   ├── screenshots/          # High-resolution screenshots
│   ├── images/               # Feature and architecture illustrations
│   ├── app/                  # Compiled Scrivener Flutter Web app (/app/)
│   └── dice-app/             # Compiled Dice Caster Flutter Web app (/dice-app/)
├── src/
│   ├── content/
│   │   └── docs/             # Starlight documentation collection
│   │       ├── user-guide/   # Player guides (Character sheet, dice, backups)
│   │       ├── themes/       # Theme architecture & 7 built-in themes
│   │       └── plugins/      # Homebrew developer docs & JSON manifests
│   ├── layouts/
│   │   └── BaseLayout.astro  # Shared layout for landing & custom pages
│   ├── pages/
│   │   ├── index.astro       # Modern product landing page
│   │   ├── download.astro    # Platform downloads & installation guide
│   │   ├── dice.astro        # Dedicated Dice Caster companion page
│   │   └── demo/
│   │       └── index.astro   # Interactive Flutter Web demo with device toggles
│   └── styles/
│       └── custom.css        # Scrivener dark fantasy typography & palette
└── dist/                     # Static production build output (deployed to Cloudflare)
```

---

## Local Development

### 1. Install dependencies
```bash
cd site
npm install
```

### 2. Run the Astro development server
```bash
npm run dev
```
Open `http://localhost:4321` in your browser.

### 3. Updating the Flutter Web builds
When modifying Flutter code in `lib/`:
```bash
# Rebuild Scrivener for Web
npm run build:flutter

# Rebuild Dice Caster for Web
npm run build:dice

# Or rebuild everything at once
npm run build:all
```

### 4. Build and preview static production site
```bash
npm run build
npm run preview
```

---

## Cloudflare Pages Setup

### 1. Zero-Cost Hosting Guarantees
Cloudflare Pages Free Tier covers:
- **Bandwidth**: **Unlimited** (no egress fees for Flutter WASM bundles)
- **Requests**: **Unlimited**
- **SSL / TLS**: Free managed certificates
- **Global CDN**: 300+ edge locations worldwide

### 2. Cloudflare Pages Git Integration
Deployments are triggered automatically by Cloudflare Pages on pushes to `master`:

- **Framework preset**: `None`
- **Build command**:
  ```bash
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 /tmp/flutter && export PATH="/tmp/flutter/bin:$PATH" && flutter pub get && cd site && npm ci && npm run build:all
  ```
- **Build output directory**: `site/dist`
- **Environment variable**: `NODE_VERSION=24`
- **Custom domains**:
  - `scrivener.tollitech.com` -> points to `scrivener.pages.dev`
  - `dice.tollitech.com` -> points to `scrivener.pages.dev/dice`
