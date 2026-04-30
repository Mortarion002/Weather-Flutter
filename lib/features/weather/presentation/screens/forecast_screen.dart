import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/storage/unit_provider.dart';
import '../../../../core/utils/temp_formatter.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/retry_error_card.dart';
import '../../../../core/widgets/top_app_bar.dart';
import '../../../../core/widgets/weather_background.dart';
import '../../domain/weather_entity.dart';
import '../providers/weather_provider.dart';
import '../../../search_location/presentation/widgets/add_city_modal.dart';

class ForecastScreen extends ConsumerWidget {
  const ForecastScreen({super.key});

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
          : _CityForecast(lat: city.lat, lon: city.lon),
    );
  }
}

// ─── City forecast — resolves async state ─────────────────────────────────────

class _CityForecast extends ConsumerWidget {
  const _CityForecast({required this.lat, required this.lon});
  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsync = ref.watch(forecastByCoordsProvider(lat, lon));

    return forecastAsync.when(
      loading: () => const _LoadingBody(),
      error: (e, _) {
        final topPad = MediaQuery.of(context).padding.top + 56 + 8;
        return Padding(
          padding: EdgeInsets.only(top: topPad, left: 20, right: 20),
          child: RetryErrorCard(
            message: e.toString(),
            onRetry: () => ref.invalidate(forecastByCoordsProvider(lat, lon)),
          ),
        );
      },
      data: (data) => _ForecastBody(
        hourly: data.hourly,
        daily: data.daily,
        // Use the first hourly entry to drive the accent glow, matching the
        // dynamic colour behaviour already in MainWeatherScreen.
        accentConditionId: data.hourly.isNotEmpty ? data.hourly.first.conditionId : null,
      ),
    );
  }
}

// ─── Data state ───────────────────────────────────────────────────────────────

class _ForecastBody extends ConsumerWidget {
  const _ForecastBody({
    required this.hourly,
    required this.daily,
    this.accentConditionId,
  });
  final List<HourlyForecastEntity> hourly;
  final List<DailyForecastEntity> daily;
  final int? accentConditionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPad = MediaQuery.of(context).padding.top + 56 + 8;
    final unit = ref.watch(temperatureUnitProvider);

    return WeatherBackground(
      accentColor: accentConditionId != null
          ? WeatherIconMapper.glowFor(accentConditionId!)
          : null,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: topPad,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom + 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HOURLY', style: TemporaTextStyles.labelCaps()),
            const SizedBox(height: 12),
            _HourlySection(hourly: hourly, unit: unit),
            const SizedBox(height: 28),
            // Fix: OWM free tier provides up to 5 days; label updated accordingly.
            Text('5-DAY', style: TemporaTextStyles.labelCaps()),
            const SizedBox(height: 12),
            _DailySection(daily: daily, unit: unit),
          ],
        ),
      ),
    );
  }
}

// ─── Hourly section ───────────────────────────────────────────────────────────

class _HourlySection extends StatelessWidget {
  const _HourlySection({required this.hourly, required this.unit});
  final List<HourlyForecastEntity> hourly;
  final TemperatureUnit unit;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (int i = 0; i < hourly.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              _HourlyTile(item: hourly[i], unit: unit),
            ],
          ],
        ),
      ),
    );
  }
}

class _HourlyTile extends StatelessWidget {
  const _HourlyTile({required this.item, required this.unit});
  final HourlyForecastEntity item;
  final TemperatureUnit unit;

  bool get _isDay {
    final h = item.time.hour;
    return h >= 6 && h < 20;
  }

  @override
  Widget build(BuildContext context) {
    final icon = WeatherIconMapper.iconFor(item.conditionId, isDay: _isDay);
    final iconColor = WeatherIconMapper.colorFor(item.conditionId);
    final pop = (item.precipitationProbability * 100).round();

    return SizedBox(
      width: 64,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormatter.hourLabel(item.time),
            style: TemporaTextStyles.dataMono(),
          ),
          const SizedBox(height: 10),
          Icon(icon, size: 26, color: iconColor, weight: 200, fill: 0),
          const SizedBox(height: 10),
          Text(
            TempFormatter.format(item.temperature, unit),
            style: TemporaTextStyles.headingLg(),
          ),
          const SizedBox(height: 4),
          Text(
            pop > 0 ? '$pop%' : '',
            style: TemporaTextStyles.dataMono(color: TemporaColors.cyan),
          ),
        ],
      ),
    );
  }
}

// ─── Daily section ────────────────────────────────────────────────────────────

class _DailySection extends StatelessWidget {
  const _DailySection({required this.daily, required this.unit});
  final List<DailyForecastEntity> daily;
  final TemperatureUnit unit;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          for (int i = 0; i < daily.length; i++) ...[
            _DailyTile(item: daily[i], unit: unit),
            if (i < daily.length - 1)
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
    );
  }
}

class _DailyTile extends StatelessWidget {
  const _DailyTile({required this.item, required this.unit});
  final DailyForecastEntity item;
  final TemperatureUnit unit;

  @override
  Widget build(BuildContext context) {
    final icon = WeatherIconMapper.iconFor(item.conditionId);
    final iconColor = WeatherIconMapper.colorFor(item.conditionId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormatter.shortDayCaps(item.date),
                  style: TemporaTextStyles.labelCaps(
                    color: TemporaColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.shortMonthDay(item.date),
                  style: TemporaTextStyles.dataMono(),
                ),
              ],
            ),
          ),
          Icon(icon, size: 22, color: iconColor, weight: 200, fill: 0),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.condition,
              style: TemporaTextStyles.dataMono(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            TempFormatter.format(item.tempHigh, unit),
            style: TemporaTextStyles.headingLg(),
          ),
          const SizedBox(width: 8),
          Text(
            TempFormatter.format(item.tempLow, unit),
            style: TemporaTextStyles.dataMono(),
          ),
        ],
      ),
    );
  }
}

// ─── Loading state (shimmer) ─────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top + 56 + 8;

    return Shimmer.fromColors(
      baseColor: TemporaColors.surfaceContainer,
      highlightColor: TemporaColors.surfaceContainerHigh,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: topPad,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom + 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimBox(width: 60, height: 12),
            const SizedBox(height: 12),
            _ShimBox(height: 110),
            const SizedBox(height: 28),
            _ShimBox(width: 50, height: 12),
            const SizedBox(height: 12),
            _ShimBox(height: 380),
          ],
        ),
      ),
    );
  }
}

class _ShimBox extends StatelessWidget {
  const _ShimBox({this.width, required this.height});
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            Symbols.calendar_today,
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
