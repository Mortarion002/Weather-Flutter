import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/storage/unit_provider.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/top_app_bar.dart';
import '../../../../core/widgets/weather_background.dart';
import '../../../search_location/presentation/providers/saved_cities_provider.dart';
import '../../../search_location/presentation/widgets/add_city_modal.dart';
import '../../../weather/presentation/providers/weather_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPad = MediaQuery.of(context).padding.top + 56 + 24;
    final unit = ref.watch(temperatureUnitProvider);
    final savedCities = ref.watch(savedCitiesProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return Scaffold(
      backgroundColor: TemporaColors.black,
      extendBodyBehindAppBar: true,
      appBar: TemporaTopAppBar(
        onSearchTap: () => showAddCityModal(context),
        onAddTap: () => showAddCityModal(context),
      ),
      body: WeatherBackground(
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: topPad,
          left: 20,
          right: 20,
          bottom: 140,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Units ──────────────────────────────────────────────────────
            Text('UNITS', style: TemporaTextStyles.labelCaps()),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Symbols.device_thermostat,
                    size: 18,
                    color: TemporaColors.amber,
                    weight: 200,
                    fill: 0,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Temperature',
                    style: TemporaTextStyles.bodyMd(
                      color: TemporaColors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  _UnitToggle(unit: unit),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── My Cities ──────────────────────────────────────────────────
            Text('MY CITIES', style: TemporaTextStyles.labelCaps()),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: savedCities.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No cities saved yet. Tap + to add one.',
                        style: TemporaTextStyles.dataMono(),
                      ),
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < savedCities.length; i++) ...[
                          _CityRow(
                            cityName: savedCities[i],
                            isSelected: savedCities[i] == selectedCity,
                            onTap: () => ref
                                .read(selectedCityProvider.notifier)
                                .select(savedCities[i]),
                            onDelete: () => ref
                                .read(savedCitiesProvider.notifier)
                                .remove(savedCities[i]),
                          ),
                          if (i < savedCities.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.white.withAlpha(15),
                              indent: 16,
                              endIndent: 16,
                            ),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 28),

            // ── About ──────────────────────────────────────────────────────
            Text('ABOUT', style: TemporaTextStyles.labelCaps()),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  _InfoRow(label: 'App', value: 'Zephyr 1.0.0'),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withAlpha(15),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _InfoRow(label: 'Weather data', value: 'OpenWeatherMap'),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withAlpha(15),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _InfoRow(label: 'Built with', value: 'Flutter + Riverpod'),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

// ─── Unit toggle ──────────────────────────────────────────────────────────────

class _UnitToggle extends ConsumerWidget {
  const _UnitToggle({required this.unit});
  final TemperatureUnit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _UnitChip(
          label: '°C',
          selected: unit == TemperatureUnit.celsius,
          onTap: () {
            if (unit != TemperatureUnit.celsius) {
              ref.read(temperatureUnitProvider.notifier).toggle();
            }
          },
        ),
        const SizedBox(width: 6),
        _UnitChip(
          label: '°F',
          selected: unit == TemperatureUnit.fahrenheit,
          onTap: () {
            if (unit != TemperatureUnit.fahrenheit) {
              ref.read(temperatureUnitProvider.notifier).toggle();
            }
          },
        ),
      ],
    );
  }
}

class _UnitChip extends StatelessWidget {
  const _UnitChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? TemporaColors.amber.withAlpha(30)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                selected ? TemporaColors.amber : TemporaColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TemporaTextStyles.dataMono(
            color: selected
                ? TemporaColors.amber
                : TemporaColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ─── City row ─────────────────────────────────────────────────────────────────

class _CityRow extends StatelessWidget {
  const _CityRow({
    required this.cityName,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });
  final String cityName;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              Symbols.location_on,
              size: 16,
              color: isSelected ? TemporaColors.cyan : TemporaColors.onSurfaceVariant,
              weight: 200,
              fill: isSelected ? 1 : 0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                cityName,
                style: TemporaTextStyles.bodyMd(
                  color: isSelected
                      ? TemporaColors.onSurface
                      : TemporaColors.onSurfaceVariant,
                ),
              ),
            ),
            if (isSelected)
              Text(
                'ACTIVE',
                style: TemporaTextStyles.labelCaps(
                  color: TemporaColors.cyan,
                ),
              ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(
                Symbols.delete,
                size: 18,
                color: TemporaColors.onSurfaceVariant,
                weight: 200,
                fill: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Info row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: TemporaTextStyles.bodyMd(color: TemporaColors.onSurface),
          ),
          const Spacer(),
          Text(value, style: TemporaTextStyles.dataMono()),
        ],
      ),
    );
  }
}
