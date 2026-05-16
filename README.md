# Zephyr

Tempora is a precision weather app built with Flutter. It delivers current weather, short-term hourly forecasts, multi-day outlooks, and location management in a focused, deep navy dark-themed mobile UI.

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
	- **Home**: current weather view with SVG illustration, full metrics grid, and sunrise/sunset arc
	- **Forecast**: hourly strip + 10-day style list with tomorrow's temperature delta banner
	- **Settings**: units, saved cities, app info
- Add city modal with debounced search
- Persistent city list and active city selection
- Temperature unit toggle (Celsius / Fahrenheit)
- Network error mapping with user-friendly retry messages and auto-retry countdown
- Shimmer loading states for weather and forecast screens
- **Expanded metrics grid**: Feels Like, UV Index, Humidity, Dew Point, Wind, Visibility, Pressure
- **Sunrise / Sunset arc card** with custom painter showing current sun position
- **Tomorrow's Temperature banner** with directional delta computed from daily forecast
- **SVG weather illustrations** mapped per condition (sunny, night, rain, cloudy, snow, fog)
- Navy card surfaces with subtle borders replacing glassmorphic blur

## Tech Stack

- Flutter (Dart SDK constraint: `^3.11.5`)
- State management: `flutter_riverpod`, `riverpod_annotation`
- HTTP client: `dio`
- Storage: `shared_preferences`
- Location package available: `geolocator`
- UI: `google_fonts`, `material_symbols_icons`, `shimmer`, `flutter_svg`
- Models/codegen: `freezed`, `json_serializable`, `build_runner`

## Design

The UI follows a deep midnight navy theme inspired by Google Weather:

| Token | Color | Usage |
| --- | --- | --- |
| `background` | `#1A2744` | Scaffold background |
| `surfaceContainer` | `#213560` | Card surfaces |
| `surfaceContainerHigh` | `#273D6E` | Elevated cards |
| `onSurface` | `#FFFFFF` | Primary text |
| `onSurfaceVariant` | `#8AAEC4` | Secondary text |
| `amber` | `#FFBF00` | Sun / warm accents |
| `cyan` | `#4DD0E1` | Rain / cold accents |
| `primaryBlue` | `#5BB5FF` | Active nav item |

Weather condition codes are mapped to SVG illustrations in `lib/core/utils/weather_illustration_mapper.dart`. Assets live in `assets/illustrations/`.

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
			weather_illustration_mapper.dart   ← SVG asset mapper
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
assets/
	Zephyr.png
	illustrations/              ← SVG weather illustrations
		sunny.svg
		night.svg
		rain.svg
		cloudy.svg
		snow.svg
		fog.svg
		stars.svg
		default.svg
		forecast.svg
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

1. User selects a city in the Add City modal.
2. City is saved in SharedPreferences and set as active.
3. Weather providers request current weather + forecast.
4. Repository maps API models into domain entities.
5. UI renders hero weather with SVG illustration, metrics grid, hourly strip, daily rows, and sunrise/sunset arc.

## Getting Started

### Prerequisites

- Flutter SDK installed and in PATH
- A valid OpenWeatherMap API key
- Android Studio / Xcode toolchains depending on your target platform

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
- AQI and UV Index currently show approximated/static values — wire up OpenWeatherMap Air Pollution and UV Index endpoints for real data.
- Moonrise/Moonset section not yet implemented — requires astronomical calculation or a separate API.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
