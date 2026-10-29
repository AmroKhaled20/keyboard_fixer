# ⌨️ Keyboard Fixer

A robust, fully offline Windows desktop application built with Flutter to fix and toggle Arabic/English keyboard language layouts seamlessly using custom global shortcuts. Designed following production-ready software engineering standards and Clean Architecture principles.

---

## ✨ Key Features

- **Global Hotkeys:** Switch between Arabic (`Ctrl + Alt + A`) and English (`Ctrl + Alt + E`) layouts instantly from anywhere on the system using `hotkey_service`.
- **System Tray Integration:** Runs quietly in the background with a fully managed system tray menu (`tray_manager`) supporting status indicators and quick toggles.
- **Run on Startup:** Optional background auto-start configuration with Windows startup registry integration (`startup_service`).
- **Interactive UI/UX:** Polished modern interface featuring custom hover animations, interactive shortcut cards, and custom window controls (`window_manager`).
- **100% Offline & Lightweight:** Operates entirely locally with zero internet dependency and minimal resource consumption.

---

## 🏗️ Architecture & Tech Stack

This project is structured using modular components and clean code principles to ensure high maintainability, separation of concerns, and smooth Windows API integration.

- **Framework:** Flutter (Dart) - Windows Desktop
- **Window Management:** `window_manager` (Borderless window, hide/close logic)
- **System Tray:** `tray_manager` (Background tray icon & context menu)
- **Global Shortcuts:** `hotkey_service`
- **Auto Startup:** `startup_service`
- **State Management & UI:** Stateful widgets, animated containers, and custom UI components.

---

## 🚀 Getting Started

To run this project locally, make sure you have Flutter installed with Windows desktop support enabled.

### 1. Clone the repository

```bash
git clone https://github.com/AmroKhaled20/keyboard_fixer.git
```

### 2. Navigate to the project directory

```bash
cd keyboard_fixer
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the app

```bash
flutter run
```
