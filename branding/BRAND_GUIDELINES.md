# YHealth Brand Identity Guidelines & Asset Specification

## 1. Brand Concept: The VITA-Y Monogram

The new YHealth visual identity is built upon **The VITA-Y (Vitality Monogram)** — a bespoke, world-class emblem engineered specifically for intelligent health tracking, athletic performance, and proactive wellness.

### Conceptual Architecture:
- **Left Wing & Spine (Trust & Endurance)**: Rendered in **Crisp Pure White** (`#FFFFFF`), representing medical precision, clinical integrity, grounded endurance, and stability.
- **Right Wing (Vitality & Active Surge)**: Rendered in a vibrant vertical gradient from **Radiant Electric Mint** (`#34D399`) down to **Vital Emerald** (`#10B981`), symbolizing kinetic movement, aerobic energy, cardio acceleration, and life force.
- **Cardio-Diamond Nexus (Intelligent Pulse)**: A precision faceted diamond node nested at the junction of the wings, evoking heartbeat electrical signals (ECG complex), digital bio-telemetry, and cellular vitality.
- **Precision Negative-Space Seam**: A 14px surgical channel dividing the stem, creating architectural depth and ensuring instant recognizability at small mobile launcher sizes (down to 48x48 px).

---

## 2. Official Brand Color Palette

| Name | Hex Code | RGB | Usage |
| :--- | :--- | :--- | :--- |
| **Deep Forest Emerald** | `#0B2619` | `rgb(11, 38, 25)` | Primary brand background, dark launcher backdrop |
| **Obsidian Forest** | `#04100B` | `rgb(4, 16, 11)` | Gradient depth, surface shadow |
| **Vital Emerald** | `#10B981` | `rgb(16, 185, 129)` | Primary brand accent, right wing base, active metrics |
| **Electric Mint** | `#34D399` | `rgb(52, 211, 153)` | High-vitality highlight, right wing apex, pulse glow |
| **Pure Clinical White** | `#FFFFFF` | `rgb(255, 255, 255)` | Left wing, high-contrast dark-mode typography |
| **Pearl White (Light BG)**| `#F6FAF8` | `rgb(246, 250, 248)` | Light theme background, crisp card surfaces |
| **Muted Slate Green** | `#6B7280` / `#9CA3AF` | `rgb(156, 163, 175)` | Secondary typography, timestamps, metric labels |

---

## 3. Typography & Wordmark

- **Monogram Initial**: **"Y"** in Vital Emerald (`#10B981`), FontWeight 900 (Black).
- **Wordmark Body**: **"Health"** in Pure White (`#FFFFFF`) or Deep Forest (`#0B2619`), FontWeight 600 (SemiBold), tight tracking (`-0.5`).
- **Tagline**: **"INTELLIGENT VITALITY & WELLNESS"** in Electric Mint (`#34D399`), uppercase, letter-spacing `+1.2`.

---

## 4. Deliverables & Asset Directory Structure

```
assets/branding/
├── yhealth_symbol_dark_1024.png       # 1024x1024 Squircle App Icon (Dark Forest Theme)
├── yhealth_symbol_round_1024.png      # 1024x1024 Round App Icon (Dark Forest Theme)
├── yhealth_symbol_transparent.png    # 1024x1024 Vector Monogram on Transparent Background
├── yhealth_playstore_512.png          # 512x512 Google Play Store Production Icon
├── yhealth_logo_wordmark_dark.png     # 1600x500 Full Wordmark on Dark Forest
├── yhealth_logo_wordmark_light.png    # 1600x500 Full Wordmark on Pearl Light
└── BRAND_GUIDELINES.md                # Brand Identity Documentation (this file)

android/app/src/main/res/
├── values/colors.xml                  # Defines @color/ic_launcher_background as #0B2619
├── drawable/ic_launcher_background.xml# Vector background colored #0B2619
├── mipmap-anydpi-v26/
│   ├── ic_launcher.xml                # Adaptive icon linking foreground + background
│   └── ic_launcher_round.xml          # Adaptive round icon
├── mipmap-mdpi/                       # 48px squircle, 48px round, 108px adaptive FG
├── mipmap-hdpi/                       # 72px squircle, 72px round, 162px adaptive FG
├── mipmap-xhdpi/                      # 96px squircle, 96px round, 216px adaptive FG
├── mipmap-xxhdpi/                     # 144px squircle, 144px round, 324px adaptive FG
└── mipmap-xxxhdpi/                    # 192px squircle, 192px round, 432px adaptive FG

lib/core/widgets/
└── yhealth_logo.dart                  # Infinite-resolution Flutter CustomPainter & Widget
```

---

## 5. Mobile & Android Launcher Compliance

1. **Android Adaptive Icons (API 26+)**:
   - Background: Vector `#0B2619` Deep Forest Emerald.
   - Foreground: Transparent 108dp asset with VITA-Y monogram centered within the **66% safe zone** (inner 72dp circle) to prevent clipping on Samsung squircle, Google Pixel circle, or Xiaomi rounded masks.
2. **Legacy Android Icons (API <26)**:
   - `ic_launcher.png`: High-density pre-rendered squircle icons.
   - `ic_launcher_round.png`: High-density pre-rendered circular icons.
3. **In-App Integration**:
   - `YHealthLogo`: Implemented in Flutter via `CustomPainter` (`YHealthLogoPainter`) for infinite crispness on onboarding, authentication, and profile screens.
