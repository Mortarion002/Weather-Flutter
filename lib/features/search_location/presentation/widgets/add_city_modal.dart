import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../data/city_record.dart';
import '../../data/geocoding_model.dart';
import '../providers/saved_cities_provider.dart';
import '../../../weather/presentation/providers/weather_provider.dart';

void showAddCityModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const AddCityModal(),
  );
}

class AddCityModal extends ConsumerStatefulWidget {
  const AddCityModal({super.key});

  @override
  ConsumerState<AddCityModal> createState() => _AddCityModalState();
}

class _AddCityModalState extends ConsumerState<AddCityModal> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  // Fix: build a CityRecord from the geocoding result so that lat/lon are
  // persisted alongside the display name.  Subsequent weather lookups will
  // use the coordinates, not the bare city name, ensuring the right city
  // is always shown even for ambiguous names like "Springfield".
  void _selectCity(GeocodingResultModel result) {
    final city = CityRecord(
      name: result.name,
      lat: result.lat,
      lon: result.lon,
    );
    ref.read(savedCitiesProvider.notifier).add(city);
    ref.read(selectedCityProvider.notifier).select(city);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    final hasQuery = _query.length >= 2;
    final searchAsync = hasQuery
        ? ref.watch(citySearchProvider(_query))
        : null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPad),
      child: GlassCard(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: TemporaColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('ADD CITY', style: TemporaTextStyles.labelCaps()),
            const SizedBox(height: 12),

            // Search field
            TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              style: TemporaTextStyles.bodyMd(color: TemporaColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search city…',
                hintStyle: TemporaTextStyles.bodyMd(),
                prefixIcon: const Icon(
                  Symbols.search,
                  color: TemporaColors.onSurfaceVariant,
                  size: 20,
                  weight: 200,
                ),
                filled: true,
                fillColor: TemporaColors.surfaceContainer,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Results area
            if (searchAsync != null)
              searchAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: TemporaColors.cyan,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    e.toString(),
                    style: TemporaTextStyles.dataMono(
                      color: TemporaColors.error,
                    ),
                  ),
                ),
                data: (results) => results.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No results found.',
                          style: TemporaTextStyles.dataMono(),
                        ),
                      )
                    : Column(
                        children: results
                            .map(
                              (r) => _ResultTile(
                                result: r,
                                onTap: () => _selectCity(r),
                              ),
                            )
                            .toList(),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Result row ───────────────────────────────────────────────────────────────

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.result, required this.onTap});
  final GeocodingResultModel result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (result.state.isNotEmpty) result.state,
      result.country,
    ].join(', ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            const Icon(
              Symbols.location_on,
              size: 18,
              color: TemporaColors.onSurfaceVariant,
              weight: 200,
              fill: 0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    style: TemporaTextStyles.bodyMd(
                      color: TemporaColors.onSurface,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: TemporaTextStyles.dataMono()),
                ],
              ),
            ),
            const Icon(
              Symbols.navigate_next,
              size: 20,
              color: TemporaColors.onSurfaceVariant,
              weight: 200,
            ),
          ],
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    final hasQuery = _query.length >= 2;
    final searchAsync = hasQuery
        ? ref.watch(citySearchProvider(_query))
        : null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPad),
      child: GlassCard(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: TemporaColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('ADD CITY', style: TemporaTextStyles.labelCaps()),
            const SizedBox(height: 12),

            // Search field
            TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              style: TemporaTextStyles.bodyMd(color: TemporaColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search city…',
                hintStyle: TemporaTextStyles.bodyMd(),
                prefixIcon: const Icon(
                  Symbols.search,
                  color: TemporaColors.onSurfaceVariant,
                  size: 20,
                  weight: 200,
                ),
                filled: true,
                fillColor: TemporaColors.surfaceContainer,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Results area
            if (searchAsync != null)
              searchAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: TemporaColors.cyan,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    e.toString(),
                    style: TemporaTextStyles.dataMono(
                      color: TemporaColors.error,
                    ),
                  ),
                ),
                data: (results) => results.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No results found.',
                          style: TemporaTextStyles.dataMono(),
                        ),
                      )
                    : Column(
                        children: results
                            .map(
                              (r) => _ResultTile(
                                result: r,
                                onTap: () => _selectCity(r),
                              ),
                            )
                            .toList(),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Result row ───────────────────────────────────────────────────────────────

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.result, required this.onTap});
  final GeocodingResultModel result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (result.state.isNotEmpty) result.state,
      result.country,
    ].join(', ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            const Icon(
              Symbols.location_on,
              size: 18,
              color: TemporaColors.onSurfaceVariant,
              weight: 200,
              fill: 0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    style: TemporaTextStyles.bodyMd(
                      color: TemporaColors.onSurface,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: TemporaTextStyles.dataMono()),
                ],
              ),
            ),
            const Icon(
              Symbols.navigate_next,
              size: 20,
              color: TemporaColors.onSurfaceVariant,
              weight: 200,
            ),
          ],
        ),
      ),
    );
  }
}
