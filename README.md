# <img src="assets/images/logo-128.png" width="36" height="36" align="absmiddle" alt="Country Info Sync Logo"> Country Info Sync

A professional, offline-first Flutter application for exploring global country information — with live API data, Wikipedia summaries, and a curated list of UNESCO heritage sites.

[![Latest Release](https://img.shields.io/github/v/release/moradzadeh67/country_info_sync?style=flat-square&color=green)](https://github.com/moradzadeh67/country_info_sync/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Web-blue?style=flat-square)]()

### 📥 [Download Latest APK](https://github.com/moradzadeh67/country_info_sync/releases/latest)

## 💡 Why I Built This

I wanted to explore a real-world Flutter project that combines **live API data**, **offline-first caching**, and **rich country information** in a single app. Most country explorer apps I found were either too basic (just a list of names) or too complex (over-engineered state management). Country Info Sync is my attempt at a **balanced middle ground**: a clean, adaptive UI with smart caching, persistent favorites, and a side-by-side comparison mode — all without adding unnecessary dependencies.

## 📸 Screenshots

### macOS
| Home | Dark Mode | Details | Compare |
|:---:|:---:|:---:|:---:|
| ![Home](assets/screenshots/macos/home_light.png) | ![Dark](assets/screenshots/macos/home_dark.png) | ![Details](assets/screenshots/macos/details.png) | ![Compare](assets/screenshots/macos/compare.png) |

### Android
| Home | Dark Mode | Details | Compare |
|:---:|:---:|:---:|:---:|
| ![Home](assets/screenshots/android/home_light.png) | ![Dark](assets/screenshots/android/home_dark.png) | ![Details](assets/screenshots/android/details.png) | ![Compare](assets/screenshots/android/compare.png) |

### iOS
| Home | Dark Mode | Details | Compare |
|:---:|:---:|:---:|:---:|
| ![Home](assets/screenshots/ios/home_light.png) | ![Dark](assets/screenshots/ios/home_dark.png) | ![Details](assets/screenshots/ios/details.png) | ![Compare](assets/screenshots/ios/compare.png) |

### Web
| Home | Dark Mode | Details | Compare |
|:---:|:---:|:---:|:---:|
| ![Home](assets/screenshots/web/home_light.png) | ![Dark](assets/screenshots/web/home_dark.png) | ![Details](assets/screenshots/web/details.png) | ![Compare](assets/screenshots/web/compare.png) |

> 💡 **Note:** Screenshots are stored in `assets/screenshots/` and organized by platform.

## ✨ Features

Here is what the app can do, in plain terms:

- 🌍 **Country Explorer** — A scrollable list of every country with its flag, name, and capital city.
- 🔍 **Smart Search** — Search by country name **or** capital, case-insensitive, with exact matches sorted first (e.g. typing "ira" puts *Iran* and *Iraq* above *Nigeria*).
- ❤️ **Favorites** — Tap the heart on any country to save it. Favorites are stored persistently and survive a full app restart.
- ⭐ **Favorites-only Filter** — A single toggle in the app bar narrows the list down to only your favorited countries (composes with the search box).
- ⚖️ **Compare Countries** — Long-press up to **2** countries to select them, then tap the floating **Compare** button to see their stats side by side (capital, population, area, continent, subregion, calling code, languages, currencies, timezones).
- 📄 **Country Details** — A rich detail screen with the flag (animated with a Hero transition), native name, and clearly grouped sections:
  - **General Information** — capital, population, subregion, area.
  - **Communication** — calling code, languages, timezones, currencies.
  - **Detailed Records** — full lists of languages, currencies, and border countries.
- 🏛️ **UNESCO Heritage Sites** — Countries with curated data show a heritage section with each site's name and description. Uses an offline-bundled JSON file, so no network is required.
- 📖 **Wikipedia Insight** — An "About <country>" card with a short summary pulled from the Wikipedia REST API, including a link to the full article. Summaries are cached for offline reuse.
- 🌗 **Dark & Light Theme** — Toggle between themes from the app bar. The choice is remembered across restarts.
- 💾 **Offline-First** — Country data is cached in Hive; if the network is unavailable a bundled `countries.json` is used as a final fallback.
- 📱 **Polished, Adaptive UI** — Responsive spacing that scales across screen sizes, shimmer loading placeholders, graceful empty/error states, and auto-shrinking text for very long country names.
- 🌐 **Localization-ready** — Latin text uses **Inter**; Persian/Arabic glyphs automatically fall back to **Vazirmatn**, so mixed strings render correctly.

## 🗺️ Roadmap

- [x] Country explorer with flags & capital
- [x] Smart search (name + capital)
- [x] Favorites with persistence
- [x] Favorites-only filter
- [x] Compare two countries side by side
- [x] Country details with Hero animation
- [x] UNESCO heritage sites (offline)
- [x] Wikipedia insight with caching
- [x] Dark / Light theme with persistence
- [x] Offline-first data layer (3-tier fallback)
- [x] Responsive design system (screen-relative spacing)
- [ ] Localization (Persian as primary language)
- [ ] Historical data / charts
- [ ] Search by continent / region
- [ ] Export favorites to JSON

## 🛠️ Technical Decisions

Every technical choice in Country Info Sync was made with **simplicity, maintainability, and offline-first behavior** in mind:

- **No external state management** — The app uses plain `StatefulWidget` + `setState` for UI state, and a single `ValueNotifier<ThemeMode>` for the theme. For a project of this size, this keeps the codebase readable and avoids unnecessary boilerplate (no Provider, BLoC, or Riverpod).
- **`hive` over `shared_preferences`** — Hive supports typed boxes (`Box<Country>`) and stores entire objects without needing manual JSON serialization. It's fast, has zero native dependencies on some platforms, and works seamlessly offline.
- **`http` over `dio`** — The app only calls two simple REST endpoints (`countries.dev` and the Wikipedia REST API). Using `http` keeps the dependency footprint minimal.
- **Hand-written `CountryAdapter`** — Instead of adding `hive_generator` + `build_runner` as dev dependencies, the adapter is written by hand. This keeps the build fast and the project free of code-generation tooling.
- **Screen-relative design system** — All spacing and sizing derive from `MediaQuery` (via `AppSpacing`). No absolute pixel constants. This makes the UI scale proportionally from small phones to large tablets without breakpoints or media queries scattered across widgets.
- **Glyph-level font fallback** — Latin text uses **Inter**, but Persian/Arabic glyphs automatically fall back to **Vazirmatn** at the glyph level. This means mixed strings like `"Iran (جمهوری اسلامی)"` render correctly without any per-widget direction logic.
- **3-tier data fallback** — Country data is fetched in this order: **live API → Hive cache → bundled `countries.json`**. The app remains useful even with zero connectivity.

## 🏗️ Architecture

Country Info Sync follows a clean layered architecture without external state management:

### Project Structure

![Project Structure](assets/diagrams/project-structure.png)

### Architecture Layers

![Architecture Layers](assets/diagrams/architecture-layers.png)

### Data Flow

![Data Flow](assets/diagrams/data-flow.png)

### Layer Breakdown

```text
lib/
├── main.dart                     → Entry point: Hive init, theme setup
├── models/
│   ├── country.dart              → Country model + hand-written Hive adapter
│   ├── country_insight.dart      → Wikipedia summary model
│   └── heritage_site.dart        → UNESCO heritage site model
├── services/
│   ├── country_service.dart      → API sync + Hive cache + asset fallback
│   ├── favorites_service.dart    → Read/write favorite country names
│   ├── heritage_service.dart     → Loads the bundled heritage JSON
│   └── wikipedia_service.dart    → Wikipedia summaries + caching
├── screens/
│   ├── home_screen.dart          → Country list, search, favorites & selection
│   ├── details_screen.dart       → Multi-section country details view
│   └── compare_screen.dart       → Side-by-side country comparison
├── theme/
│   ├── app_spacing.dart          → Responsive spacing/size tokens
│   └── app_typography.dart       → Inter + Vazirmatn typography
└── widgets/
    ├── country_card.dart         → Country list card
    ├── details_widgets.dart      → InfoTile, InsightCard, HeritageCard
    ├── shimmer_loading.dart      → Loading skeleton
    └── empty_state_view.dart     → Empty / error state placeholder
```

## 📱 Platform Support

| Platform | Status | Notes |
|---|:---:|---|
| 🤖 Android | ✅ Tested | Working on phones & tablets |
| 🍎 iOS | ✅ Tested | Working on iPhone & iPad |
| 🌐 Web | ✅ Tested | Chrome, Firefox, Safari compatible |
| 🖥️ macOS | ✅ Tested | Apple Silicon |
| 🪟 Windows | ⚠️ Untested | Build available |
| 🐧 Linux | ⚠️ Untested | Build available |

## 🚀 Installation & Running

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.13.2+)
- Dart SDK (v3.x)
- Platform-specific:
  - **Android**: Android SDK 21+
  - **iOS**: Xcode 14+
  - **macOS**: Xcode 14+
  - **Web**: Any modern browser

### Getting Started

1. **Clone the repository**:
   git clone https://github.com/moradzadeh67/country_info_sync.git
   cd country_info_sync

2. **Install dependencies**:
   flutter pub get

3. **Run the application**:
   flutter run

### Building

# Build Android APK
flutter build apk --release

# Build macOS Desktop app
flutter build macos --release

# Build iOS app
flutter build ios --release

# Build Web distribution
flutter build web --release

## 💻 Development Environment

This project is actively developed and tested using:
- **OS**: macOS (Apple Silicon)
- **IDE**: VS Code / Android Studio
- **iOS/macOS Build Toolchain**: Xcode 14+
- **Flutter Framework**: Flutter 3.13+

## 🙏 Credits & Attribution

Country Info Sync uses the following free and open APIs:

- **[countries.dev](https://countries.dev)** — Country data (flags, population, capital, languages, currencies, timezones, borders, area, region, subregion, calling codes)
- **[Wikipedia REST API](https://www.mediawiki.org/wiki/API:REST_API)** — Country insight summaries (`extract` field)
- **[UNESCO World Heritage Centre](https://whc.unesco.org)** — Heritage sites reference

**Data flow:** The app fetches country data from `countries.dev` on first launch, caches it locally with **Hive**, and falls back to a bundled `countries.json` if the network is unavailable. Wikipedia summaries are cached separately and reused offline.

**No API keys are required** — all three services are open and free to use.

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to get started.

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

Copyright © 2026 moradzadeh67
