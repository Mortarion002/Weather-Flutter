import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/geocoding_model.dart';
import '../../data/location_repository.dart';

part 'saved_cities_provider.g.dart';

// ─── Location repository provider ─────────────────────────────────────────────

@Riverpod(keepAlive: true)
LocationRepository locationRepository(LocationRepositoryRef ref) {
  return LocationRepository(ref.watch(dioClientProvider));
}

// ─── Saved cities (in-memory list; persisted in Phase 5B) ────────────────────

@Riverpod(keepAlive: true)
class SavedCities extends _$SavedCities {
  @override
  List<String> build() => [];

  void add(String cityName) {
    if (!state.contains(cityName)) {
      state = [...state, cityName];
    }
  }

  void remove(String cityName) {
    state = state.where((c) => c != cityName).toList();
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
