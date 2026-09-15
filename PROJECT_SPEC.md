# Project Specification: Country Info Sync

## 1. Overview
Country Info Sync is a mobile application built with Flutter that provides users with up-to-date information about countries worldwide. The app features offline support by caching data locally.

## 2. Core Features
- **Fetch Country List**: Retrieve country data from a public API (`https://countries.dev/countries`).
- **Country Details**: Display detailed information for each country (Flag, Population, Capital, Continent, Languages, Currencies, Area, Timezones, Calling Code).
- **Offline Caching**: Store fetched data locally using Hive to ensure availability without an internet connection.
- **Search & Filter**: (Future task) Search for specific countries.
- **Localization**: Support for Persian (Farsi) as the primary language.

## 3. Technology Stack
- **Framework**: Flutter
- **Language**: Dart
- **Networking**: `http` package
- **Local Storage**: `hive` and `hive_flutter`
- **Fonts**: Google Fonts (Vazirmatn)
- **Architecture**: Minimalist structure following `AGENTS.md` (Simplest correct solution).

## 4. User Interface (UI)
- **Home Screen**: List of countries with flags and names.
- **Details Screen**: Detailed view of a selected country.
- **Error States**: Handle networking and data loading errors gracefully.

## 5. Non-Functional Requirements
- **Simplicity**: Avoid over-engineering. No unnecessary abstractions.
- **Maintainability**: Clean and readable code.
- **Performance**: Fast loading and smooth scrolling.
