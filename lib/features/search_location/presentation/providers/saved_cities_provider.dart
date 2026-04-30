import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/prefs_provider.dart';
import '../../data/city_record.dart';
import '../../data/geocoding_model.dart';
import '../../data/location_repository.dart';
import '../../../weather/presentation/providers/weather_provider.dart';

part 'saved_cities_provider.g.dart';

const _savedCitiesKey = 'saved_cities';

// ─── Location repository provider ─────────────────────────────────────────────

@Riverpod(keepAlive: true)
LocationRepository locationRepository(LocationRepositoryRef ref) {
  return LocationRepository(ref.watch(dioClientProvider));
}

// ─── Saved cities (persisted via SharedPreferences) ───────────────────────────
// Each city is stored as a JSON string so that its lat/lon coordinates are
// preserved.  This ensures weather lookups always resolve to the exact city
// the user selected from the geocoding results.

@Riverpod(keepAlive: true)
class SavedCities extends _$SavedCities {
  @override
  List<CityRecord> build() {
    final raw = ref.watch(sharedPreferencesProvider).getStringList(_savedCitiesKey) ?? [];
    return raw.map(CityRecord.fromJsonString).toList();
  }

  void add(CityRecord city) {
    if (state.any((c) => c.lat == city.lat && c.lon == city.lon)) return;
    final next = [city, ...state];
    ref.read(sharedPreferencesProvider).setStringList(
          _savedCitiesKey,
          next.map((c) => c.toJsonString()).toList(),
        );
    state = next;
  }

  // Removes the city and, if it was the active selection, clears that too.
  void remove(CityRecord city) {
    final next = state.where((c) => c != city).toList();
    ref.read(sharedPreferencesProvider).setStringList(
          _savedCitiesKey,
          next.map((c) => c.toJsonString()).toList(),
        );
    state = next;

    // Fix: clear selectedCity when the active city is deleted so the app
    // doesn't continue displaying weather for a city that no longer exists
    // in the saved list.
    final selected = ref.read(selectedCityProvider);
    if (selected != null && selected.lat == city.lat && selected.lon == city.lon) {
      ref.read(selectedCityProvider.notifier).clear();
    }
  }
}

// ─── City search (geocoding API) ──────────────────────────────────────────────

@riverpod
Future<List<GeocodingResultModel>> citySearch(
  CitySearchRef ref,
  String query,
) async {
  if (query.trim().length < 2) return [];
  final repo = ref.watch(locationRepositoryProvider);
  return repo.searchCity(query.trim());
}
