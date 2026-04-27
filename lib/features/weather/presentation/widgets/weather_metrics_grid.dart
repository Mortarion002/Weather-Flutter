import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/storage/unit_provider.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/temp_formatter.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/weather_entity.dart';
import '../../../../core/utils/date_formatter.dart';

class WeatherMetricsGrid extends StatelessWidget {
  const WeatherMetricsGrid({super.key, required this.weather, required this.unit});

  final WeatherEntity weather;
  final TemperatureUnit unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _HumidityCard(weather: weather, unit: unit)),
            const SizedBox(width: 16),
            Expanded(child: _WindCard(weather: weather)),
          ],
        ),
        const SizedBox(height: 16),
        _FeelsLikeCard(weather: weather, unit: unit),
      ],
    );
  }
}

// ─── Humidity ────────────────────────────────────────────────────────────────

class _HumidityCard extends StatelessWidget {
  const _HumidityCard({required this.weather, required this.unit});
  final WeatherEntity weather;
  final TemperatureUnit unit;

  @override
  Widget build(BuildContext context) {
    final dewCelsius = weather.temperature - ((100 - weather.humidity) / 5);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('HUMIDITY', style: TemporaTextStyles.labelCaps()),
              const Icon(
                Symbols.humidity_percentage,
                size: 18,
                color: TemporaColors.amber,
                weight: 200,
                fill: 0,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${weather.humidity}%',
            style: TemporaTextStyles.headingLg(),
          ),
          const SizedBox(height: 4),
          Text(
            'Dew ~${TempFormatter.format(dewCelsius, unit)}',
            style: TemporaTextStyles.dataMono(),
          ),
        ],
      ),
    );
  }
}

// ─── Wind ─────────────────────────────────────────────────────────────────────

class _WindCard extends StatelessWidget {
  const _WindCard({required this.weather});
  final WeatherEntity weather;

  @override
  Widget build(BuildContext context) {
    final dir = DateFormatter.windDirection(weather.windDeg);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('WIND', style: TemporaTextStyles.labelCaps()),
              const Icon(
                Symbols.air,
                size: 18,
                color: TemporaColors.cyan,
                weight: 200,
                fill: 0,
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: weather.windSpeedKmh.toStringAsFixed(0),
                  style: TemporaTextStyles.headingLg(),
                ),
                TextSpan(
                  text: ' km/h',
                  style: TemporaTextStyles.dataMono(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Direction $dir',
            style: TemporaTextStyles.dataMono(),
          ),
        ],
      ),
    );
  }
}

// ─── Feels Like (full-width) ──────────────────────────────────────────────────

class _FeelsLikeCard extends StatelessWidget {
  const _FeelsLikeCard({required this.weather, required this.unit});
  final WeatherEntity weather;
  final TemperatureUnit unit;

  @override
  Widget build(BuildContext context) {
    // Clamp progress bar between 0–1 across the day's temp range
    final range = weather.tempMax - weather.tempMin;
    final progress = range > 0
        ? ((weather.feelsLike - weather.tempMin) / range).clamp(0.0, 1.0)
        : 0.5;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Symbols.device_thermostat,
                    size: 16,
                    color: TemporaColors.amber,
                    weight: 200,
                    fill: 0,
                  ),
                  const SizedBox(width: 6),
                  Text('FEELS LIKE', style: TemporaTextStyles.labelCaps()),
                ],
              ),
              Text(
                _feelsLikeLabel(weather.feelsLike),
                style: TemporaTextStyles.dataMono(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                TempFormatter.format(weather.feelsLike, unit),
                style: TemporaTextStyles.headingLg(),
              ),
              const Spacer(),
              Text(
                'Lo ${TempFormatter.format(weather.tempMin, unit)}',
                style: TemporaTextStyles.dataMono(),
              ),
              const SizedBox(width: 8),
              Text(
                'Hi ${TempFormatter.format(weather.tempMax, unit)}',
                style: TemporaTextStyles.dataMono(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Temperature range bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                Container(
                  height: 3,
                  color: Colors.white.withAlpha(25),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [TemporaColors.cyan, TemporaColors.amber],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _feelsLikeLabel(double temp) {
    if (temp >= 40) return 'Very Hot';
    if (temp >= 32) return 'Hot';
    if (temp >= 24) return 'Warm';
    if (temp >= 16) return 'Comfortable';
    if (temp >= 8) return 'Cool';
    return 'Cold';
  }
}
