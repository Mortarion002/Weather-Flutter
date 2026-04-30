import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import 'glass_card.dart';

class RetryErrorCard extends StatefulWidget {
  const RetryErrorCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  State<RetryErrorCard> createState() => _RetryErrorCardState();
}

class _RetryErrorCardState extends State<RetryErrorCard> {
  static const _maxAutoRetries = 3;
  static const _countdownSeconds = 5;

  int _seconds = _countdownSeconds;
  int _autoRetryCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer t) {
    if (!mounted) return;
    if (_seconds <= 1) {
      t.cancel();
      _autoRetryCount++;
      widget.onRetry();
      if (_autoRetryCount < _maxAutoRetries) {
        // Resume countdown for next auto-retry
        setState(() => _seconds = _countdownSeconds);
        _startCountdown();
      } else {
        // Max auto-retries reached — stop the countdown loop
        setState(() => _seconds = 0);
      }
    } else {
      setState(() => _seconds--);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _retryNow() {
    _timer?.cancel();
    widget.onRetry();
  }

  bool get _autoRetryActive => _autoRetryCount < _maxAutoRetries;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Symbols.wifi_off,
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
                      'NETWORK ERROR',
                      style: TemporaTextStyles.dataMono(
                        color: TemporaColors.error,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.message,
                      style: TemporaTextStyles.bodyMd(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                _autoRetryActive
                    ? 'Retrying in ${_seconds}s (${_autoRetryCount + 1}/$_maxAutoRetries)'
                    : 'Auto-retry stopped',
                style: TemporaTextStyles.dataMono(),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _retryNow,
                child: Text(
                  'RETRY NOW',
                  style: TemporaTextStyles.labelCaps(color: TemporaColors.cyan),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
