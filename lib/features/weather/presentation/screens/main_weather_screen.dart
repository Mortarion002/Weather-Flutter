import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/storage/unit_provider.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/temp_formatter.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/top_app_bar.dart';
import '../../domain/weather_entity.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_metrics_grid.dart';
import '../../../search_location/presentation/widgets/add_city_modal.dart';

class MainWeatherScreen extends ConsumerWidget {
  const MainWeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(selectedCityProvider);

    return Scaffold(
      backgroundColor: TemporaColors.black,
      extendBodyBehindAppBar: true,
      appBar: TemporaTopAppBar(
        onSearchTap: () => showAddCityModal(context),
        onAddTap: () => showAddCityModal(context),
      ),
      body: city == null
          ? const _EmptyState()
          : _CityWeather(cityName: city),
    );
  }
}

// ─── City weather — resolves async state ─────────────────────────────────────

class _CityWeather extends ConsumerWidget {
  const _CityWeather({required this.cityName});
  final String cityName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider(cityName));

    return weatherAsync.when(
      loading: () => const _LoadingBody(),
      error: (e, _) => _ErrorBody(message: e.toString()),
      data: (weather) => _WeatherBody(weather: weather),
    );
  }
}

// ─── Data state ───────────────────────────────────────────────────────────────

class _WeatherBody extends ConsumerWidget {
  const _WeatherBody({required this.weather});
  final WeatherEntity weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPad = MediaQuery.of(context).padding.top + 56 + 24;
    final unit = ref.watch(temperatureUnitProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: topPad,
        left: 20,
        right: 20,
        bottom: 140,
      ),
      child: Column(
        children: [
          _HeroSection(weather: weather, unit: unit),
          const SizedBox(height: 32),
          WeatherMetricsGrid(weather: weather, unit: unit),
        ],
      ),
    );
  }
}

// ─── Hero ─────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.weather, required this.unit});
  final WeatherEntity weather;
  final TemperatureUnit unit;

  bool get _isDay {
    final now = weather.observedAt;
    return now.isAfter(weather.sunrise) && now.isBefore(weather.sunset);
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = WeatherIconMapper.colorFor(weather.conditionId);
    final glowColor = WeatherIconMapper.glowFor(weather.conditionId);
    final icon = WeatherIconMapper.iconFor(weather.conditionId, isDay: _isDay);

    return Column(
      children: [
        // Weather icon with radial glow backdrop
        Container(
          width: 160,
          height: 160,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: 80,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 100,
            color: iconColor,
            weight: 200,
            fill: 0,
          ),
        ),
        const SizedBox(height: 24),

        // City name
        Text(
          weather.cityName.toUpperCase(),
          style: TemporaTextStyles.headingLg(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),

        // Coordinates / date
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.location_on,
              size: 13,
              color: TemporaColors.onSurfaceVariant,
              weight: 200,
            ),
            const SizedBox(width: 4),
            Text(
              DateFormatter.dayAndDate(weather.observedAt),
              style: TemporaTextStyles.dataMono(),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Temperature
        Text(
          TempFormatter.format(weather.temperature, unit),
          style: TemporaTextStyles.dataHuge(),
        ),
        const SizedBox(height: 12),

        // Condition label
        Text(
          weather.condition.toUpperCase(),
          style: TemporaTextStyles.dataMono().copyWith(
            letterSpacing: 4,
            color: TemporaColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ─── Loading state (shimmer) ─────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top + 56 + 24;

    return Shimmer.fromColors(
      baseColor: TemporaColors.surfaceContainer,
      highlightColor: TemporaColors.surfaceContainerHigh,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: topPad,
          left: 20,
          right: 20,
          bottom: 140,
        ),
        child: Column(
          children: [
            // Icon placeholder
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 24),
            // City name
            _ShimmerBox(width: 160, height: 24),
            const SizedBox(height: 10),
            _ShimmerBox(width: 120, height: 14),
            const SizedBox(height: 28),
            // Temperature
            _ShimmerBox(width: 120, height: 64),
            const SizedBox(height: 12),
            _ShimmerBox(width: 80, height: 14),
            const SizedBox(height: 32),
            // Metric cards
            Row(
              children: [
                Expanded(child: _ShimmerBox(height: 110)),
                const SizedBox(width: 16),
                Expanded(child: _ShimmerBox(height: 110)),
              ],
            ),
            const SizedBox(height: 16),
            _ShimmerBox(height: 96),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({this.width, required this.height});
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// ─── Error state ──────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top + 56 + 24;

    return Padding(
      padding: EdgeInsets.only(top: topPad, left: 20, right: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Symbols.warning,
              color: TemporaColors.error,
              size: 20,
              weight: 200,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SYSTEM EXCEPTION',
                    style: TemporaTextStyles.dataMono(
                      color: TemporaColors.error,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(message, style: TemporaTextStyles.bodyMd()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.add_location_alt,
            size: 56,
            color: TemporaColors.onSurfaceVariant,
            weight: 200,
            fill: 0,
          ),
          const SizedBox(height: 20),
          Text(
            'NO LOCATION SET',
            style: TemporaTextStyles.labelCaps(),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first city',
            style: TemporaTextStyles.bodyMd(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
