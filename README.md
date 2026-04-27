# Zephyr

Tempora is a precision weather app built with Flutter. It delivers current weather, short-term hourly forecasts, multi-day outlooks, and location management in a focused, dark-themed mobile UI.

The app title shown in UI is **Zephyr**.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Architecture and Data Flow](#architecture-and-data-flow)
- [Getting Started](#getting-started)
- [API Key Setup](#api-key-setup)
- [Code Generation](#code-generation)
- [Testing and Quality](#testing-and-quality)
- [Build and Run](#build-and-run)
- [Known Issues and Improvements](#known-issues-and-improvements)

## Overview

Tempora uses OpenWeatherMap APIs to fetch:

- Current weather by city or coordinates
- 5-day forecast (3-hour intervals), then derives:
	- Next 24-hour hourly timeline
	- 5-day daily high/low summary
- City search suggestions via geocoding

The app uses Riverpod for state management, Dio for networking, and SharedPreferences for persistence of selected city, saved cities, and temperature unit preferences.

## Features

- Splash experience with custom animation and transition to main shell
- Bottom tab shell with 3 sections:
	- Home: current weather view
	- Forecast: hourly + 10-day style list (derived from 5-day/3h feed)
	- Settings: units, saved cities, app info
- Add city modal with debounced search
- Persistent city list and active city selection
- Temperature unit toggle (Celsius/Fahrenheit)
- Network error mapping with user-friendly retry messages
- Shimmer loading states for weather and forecast screens
- Styled weather visuals (icon mapping, accent glow, glass cards)

## Tech Stack

- Flutter (Dart SDK constraint: `^3.11.5`)
- State management: `flutter_riverpod`, `riverpod_annotation`
- HTTP client: `dio`
- Storage: `shared_preferences`
- Location package available: `geolocator`
- UI: `google_fonts`, `material_symbols_icons`, `shimmer`
- Models/codegen: `freezed`, `json_serializable`, `build_runner`

## Project Structure

```text
lib/
	app_shell.dart
	main.dart
	splash_screen.dart
	core/
		network/
			api_endpoints.dart
			dio_client.dart
			network_exceptions.dart
		storage/
			prefs_provider.dart
			unit_provider.dart
		theme/
			app_theme.dart
			colors.dart
			text_styles.dart
		utils/
			date_formatter.dart
			temp_formatter.dart
			weather_icon_mapper.dart
		widgets/
			bottom_nav_bar.dart
			glass_card.dart
			retry_error_card.dart
			top_app_bar.dart
			weather_background.dart
	features/
		weather/
			data/
			domain/
			presentation/
		search_location/
			data/
			presentation/
		settings/
			presentation/
test/
	widget_test.dart
```

## Architecture and Data Flow

The app follows a feature-first structure with a lightweight clean separation:

- **Data layer**
	- Repositories call OpenWeatherMap through a shared Dio client.
	- API DTOs are generated with Freezed/JSON Serializable.
- **Domain layer**
	- `WeatherEntity`, `HourlyForecastEntity`, and `DailyForecastEntity` represent UI-facing business data.
- **Presentation layer**
	- Riverpod providers expose repositories, persisted settings, and async weather data.
	- Screens react to provider state (`loading`, `error`, `data`).

High-level flow:

1. User selects a city in Add City modal.
2. City is saved in SharedPreferences and set as active.
3. Weather providers request current weather + forecast.
4. Repository maps API models into domain entities.
5. UI renders hero weather, metrics, hourly strip, and daily rows.

## Getting Started

### Prerequisites

- Flutter SDK installed and in PATH
- A valid OpenWeatherMap API key
- Android Studio/Xcode toolchains depending on your target platform

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

## API Key Setup

API configuration is currently defined in:

- `lib/core/network/api_endpoints.dart`

Set the values for:

- `baseUrl`
- `apiKey`
- `units`

Current implementation injects the API key globally through Dio query parameters in `dio_client.dart`.

### Security note

The API key is currently hardcoded in source. For production or public repositories, move secrets out of source control (for example: build-time defines, secure config files, or CI-injected environment values).

## Code Generation

This project uses Riverpod code generation and Freezed/JSON serialization.

Generate code once:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Watch mode during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Testing and Quality

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

### Current test status

The default `test/widget_test.dart` is still scaffold-generated and references `MyApp`, while this project boots `TemporaApp`. Update this test before using CI test gates.

## Build and Run

Common commands:

```bash
# Android debug
flutter run

# Build Android APK
flutter build apk

# Build Android appbundle
flutter build appbundle

# Build iOS (macOS required)
flutter build ios
```

## Known Issues and Improvements

- Move API key to secure runtime/build configuration.
- Replace scaffold default widget test with real app tests.
- Add repository/provider unit tests and golden/widget tests for key screens.
- Add CI workflow for analyze + build_runner check + tests.
- Consider offline caching strategy for latest successful weather response.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.