# 🌍 Country Info Sync

![Country Info Sync Logo](assets/images/logo-256.png)

A professional, offline-first Flutter application for exploring global country information.

## 📌 Project Overview

Country Info Sync is a Flutter-based application that allows users to:

- Explore up-to-date information about countries worldwide
- Search and filter countries instantly
- View rich country details with flags and statistics
- Access previously loaded data offline through local caching

## ✨ Key Features

- 🌐 **Real-time Sync**: Fetches global country data from the `countries.dev` API
- 💾 **Offline-First**: Automatic local storage using **Hive** for instant offline access
- 🔍 **Smart Search**: Fast, case-insensitive search with relevance sorting (exact matches first)
- 📱 **Modern UI**: Built with **Material 3** and **Inter/Vazirmatn** typography
- 🏳️ **Visual Identity**: Flag displays with Hero animations for smooth transitions
- 📊 **Rich Details**: Native Name, Population, Capital, Subregion, Continent, Languages, Currencies, Area, Timezones, Calling Code, and Border Countries
- 📏 **Adaptive Layout**: Responsive text scaling for long country names using `FittedBox`

## 🛠️ Tech Stack

- **Flutter & Dart** (3.13.2+)
- **Networking**: [`http`](https://pub.dev/packages/http) (REST API calls to `countries.dev`)
- **Local Persistence**: [`hive`](https://pub.dev/packages/hive) & [`hive_flutter`](https://pub.dev/packages/hive_flutter)
- **Typography**: [`google_fonts`](https://pub.dev/packages/google_fonts) (Inter for Latin, Vazirmatn for Persian)
- **Localization**: `flutter_localizations`
- **Architecture**: No external state management — local UI state handled directly with `StatefulWidget` + `setState`

## 🚀 How to Run

### Prerequisites

- Flutter SDK (3.13.2+)
- Dart 3.x
- Platform-specific requirements:
  - **Android**: Android SDK 21+
  - **iOS**: Xcode 14+
  - **macOS**: Xcode 14+
  - **Web**: Any modern browser
  - **Windows**: Windows 10+ (⚠️ Untested)
  - **Linux**: (⚠️ Untested)

### Installation

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Build for Platforms

```bash
# Android
flutter build apk

# iOS
flutter build ios

# macOS
flutter build macos

# Windows
flutter build windows

# Linux
flutter build linux

# Web
flutter build web
```

## 📂 Project Structure

```
lib/
├── main.dart                     # Entry point, Hive init & theme configuration
├── models/
│   └── country.dart              # Country data model + Hive adapter
├── services/
│   └── country_service.dart      # API sync and local caching
├── screens/
│   ├── home_screen.dart          # Searchable country list with modern card design
│   └── details_screen.dart       # Multi-section country details view
└── widgets/                      # Shared widgets (reserved)
assets/
├── images/                       # App logo (SVG + PNG variants)
└── icons/                        # Platform icons used in this README
```

## 📱 Supported Platforms

| Platform | Icon | Status | Notes |
|---|:---:|---|---|
| 🤖 Android | ![Android Icon](assets/icons/android-icon.png) | ✅ **Tested** | Working perfectly on all devices |
| 🍎 iOS | ![iOS Icon](assets/icons/ios-icon.png) | ✅ **Tested** | Working on iPhone & iPad |
| 🌐 Web | ![Web Icon](assets/icons/web-icon.png) | ✅ **Tested** | Chrome, Firefox, Safari compatible |
| 🖥️ macOS | ![macOS Icon](assets/icons/macos-icon.png) | ✅ **Tested** | Working on Apple Silicon (M-series) |
| 🪟 Windows | ![Windows Icon](assets/icons/windows-icon.png) | ❌ **Not tested** | Build available, awaiting testing |
| 🐧 Linux | ![Linux Icon](assets/icons/linux-icon.png) | ❌ **Not tested** | Build available, awaiting testing |

> **Note**: Android, iOS, Web, and macOS have been tested and work correctly. Windows and Linux builds are available but have not been tested yet.

## 📝 License

MIT License. See [LICENSE](LICENSE) for details.

**Copyright © 2026 moradzadeh67**

This project is open-source and free to use, modify, and distribute under the MIT License terms.

