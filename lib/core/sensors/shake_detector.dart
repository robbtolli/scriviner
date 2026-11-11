import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Detects deliberate physical shaking of the device using accelerometer events.
class ShakeDetector {
  static const double defaultShakeThresholdGravity = 2.7;
  static const int defaultShakeSlopTimeMs = 500;
  static const int defaultShakeCountResetTimeMs = 1500;
  static const int defaultMinShakeCount = 1;

  final VoidCallback onShake;
  final double shakeThresholdGravity;
  final int shakeSlopTimeMs;
  final int shakeCountResetTimeMs;
  final int minShakeCount;
  final Stream<AccelerometerEvent>? eventStreamOverride;
  final int Function()? clock;

  StreamSubscription<AccelerometerEvent>? _streamSubscription;
  int _shakeTimestamp = 0;
  int _shakeCount = 0;

  ShakeDetector({
    required this.onShake,
    this.shakeThresholdGravity = defaultShakeThresholdGravity,
    this.shakeSlopTimeMs = defaultShakeSlopTimeMs,
    this.shakeCountResetTimeMs = defaultShakeCountResetTimeMs,
    this.minShakeCount = defaultMinShakeCount,
    this.eventStreamOverride,
    this.clock,
  });

  bool get isListening => _streamSubscription != null;

  /// Starts listening to accelerometer sensor events.
  void startListening() {
    if (_streamSubscription != null) return;

    final stream = eventStreamOverride ?? accelerometerEventStream();
    _streamSubscription = stream.listen(
      _handleAccelerometerEvent,
      onError: (dynamic error) {
        // Gracefully ignore sensors error on devices without accelerometer support
        debugPrint('ShakeDetector accelerometer error: $error');
      },
      cancelOnError: false,
    );
  }

  /// Stops listening and cancels active stream subscriptions.
  void stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _shakeCount = 0;
    _shakeTimestamp = 0;
  }

  void _handleAccelerometerEvent(AccelerometerEvent event) {
    final gX = event.x / 9.80665;
    final gY = event.y / 9.80665;
    final gZ = event.z / 9.80665;

    // gForce will be close to 1.0 when stationary (1G gravity)
    final gForce = math.sqrt(gX * gX + gY * gY + gZ * gZ);

    if (gForce > shakeThresholdGravity) {
      final now = clock != null ? clock!() : DateTime.now().millisecondsSinceEpoch;

      // Ignore shakes that occur too close together (slop debounce)
      if (_shakeTimestamp + shakeSlopTimeMs > now) {
        return;
      }

      // Reset the shake count if user hasn't shaken again within the reset window
      if (_shakeTimestamp + shakeCountResetTimeMs < now) {
        _shakeCount = 0;
      }

      _shakeTimestamp = now;
      _shakeCount++;

      if (_shakeCount >= minShakeCount) {
        _shakeCount = 0;
        onShake();
      }
    }
  }
}
