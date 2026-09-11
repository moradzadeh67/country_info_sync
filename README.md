# 🌍 Country Info Sync

A professional, offline-first Flutter application for exploring global country information, built using the **SSD (Specification-Driven Development)** methodology and **SPARC** workflow.

## 📌 Project Overview
Country Info Sync provides comprehensive and up-to-date information about countries worldwide. Designed with reliability in mind, it features a robust local caching system that ensures access to country data even when offline.

## 🏗️ Methodology: SSD & SPARC
This project follows the **SSD (Specification-Driven Development)** approach, ensuring all features are clearly specified before implementation. The **SPARC** workflow ensures a logical, maintainable, and simple codebase:

1.  **S**etup: Project initialization and minimalist dependency management.
2.  **P**ersistence: Designing simple data models and local storage with **Hive**.
3.  **A**PI: Implementing stateless network services for data retrieval from `countries.dev`.
4.  **R**eactivity: Managing state directly within the UI components for maximum simplicity.
5.  **C**omponents: Building a beautiful, responsive, and intuitive interface with **Material 3** and **Poppins** typography.

## ✨ Key Features
- 🌐 **Real-time Sync**: Fetches global country data from the **countries.dev API**.
- 💾 **Offline-First**: Automatic local storage using **Hive** for instant offline access.
- 🔍 **Smart Search**: Fast, case-insensitive search with relevance sorting (exact matches first).
- 📱 **Modern UI**: A stylish, grid-based details view and card-based home screen using the **Poppins** font.
- 🏳️ **Visual Identity**: High-quality flag displays with Hero animations for smooth transitions.
- 📊 **Rich Details**: Includes Native Name, Population, Capital, Subregion, Languages, Currencies, Area, and Border Countries.
- 📏 **Adaptive Layout**: Responsive text scaling for long country names using `FittedBox`.

## 🛠️ Tech Stack
- **Flutter & Dart**
- **Networking**: **http** package.
- **Local Persistence**: **Hive** & **Hive Flutter**.
- **Typography**: **Google Fonts (Poppins)**.
- **Architecture**: Minimalist structure following the simplest correct solution principles.

## 🚀 How to Run
1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/moradzadeh67/country_info_sync.git
    ```
2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the App**:
    ```bash
    flutter run
    ```

## 📂 Project Structure
- `lib/country.dart`: Unified data model with Native Name, Borders, and Hive adapter.
- `lib/country_service.dart`: Simplified service for API sync and local caching.
- `lib/home_screen.dart`: Searchable country list with modern card design and adaptive text.
- `lib/details_screen.dart`: Beautifully organized multi-section country details with subregion and border info.
- `lib/main.dart`: Clean entry point and theme configuration.
