# jippin

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Directory Structure

lib/
│── l10n/ 👈 📌 Stores ARB localization files
│ ├── app_en.arb
│ ├── app_ko.arb
│── generated/ 👈 📌 Stores auto-generated localization files
│ ├── l10n/
│ ├── app_localizations.dart
│── models/ 👈 Models (Country, Language, etc.)
│ ├── country.dart
│ ├── language.dart
│── providers/ 👈 Stores state management (e.g., LocaleProvider)
│ ├── locale_provider.dart
│── theme/ 👈 Stores app-wide theme settings
│── components/ 👈 Stores reusable UI widgets
│── pages/ 👈 UI Screens
│── utilities/ 👈 helper functions and constants
│── main.dart
