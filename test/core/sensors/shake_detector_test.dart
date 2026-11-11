import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/sensors/shake_detector.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  group('ShakeDetector', () {
    late StreamController<AccelerometerEvent> eventController;

    setUp(() {
      eventController = StreamController<AccelerometerEvent>.broadcast();
    });

    tearDown(() async {
      await eventController.close();
    });

    test('ignores normal stationary gravity (approx 9.8 m/s^2 on Z axis)', () {
      var shakeDetected = false;
      final detector = ShakeDetector(
        onShake: () => shakeDetected = true,
        eventStreamOverride: eventController.stream,
      );

      detector.startListening();
      expect(detector.isListening, isTrue);

      // Normal gravity resting on table
      eventController.add(AccelerometerEvent(0.0, 0.0, 9.80665, DateTime.now()));
      expect(shakeDetected, isFalse);

      detector.stopListening();
      expect(detector.isListening, isFalse);
    });

    test('triggers onShake when acceleration exceeds gravity threshold', () async {
      var shakeDetected = false;
      final detector = ShakeDetector(
        onShake: () => shakeDetected = true,
        eventStreamOverride: eventController.stream,
        shakeThresholdGravity: 2.5,
      );

      detector.startListening();

      // Send strong acceleration spike (approx 3.0 Gs: 3 * 9.8 = 29.4)
      eventController.add(AccelerometerEvent(25.0, 15.0, 10.0, DateTime.now()));
      await Future<void>.delayed(Duration.zero);

      expect(shakeDetected, isTrue);
      detector.stopListening();
    });

    test('respects debounce slop time window between shakes', () async {
      var shakeCount = 0;
      final detector = ShakeDetector(
        onShake: () => shakeCount++,
        eventStreamOverride: eventController.stream,
        shakeThresholdGravity: 2.0,
        shakeSlopTimeMs: 200,
      );

      detector.startListening();

      // First shake event
      eventController.add(AccelerometerEvent(25.0, 0.0, 0.0, DateTime.now()));
      await Future<void>.delayed(Duration.zero);
      expect(shakeCount, equals(1));

      // Immediate second shake within 200ms slop window -> should be ignored
      eventController.add(AccelerometerEvent(25.0, 0.0, 0.0, DateTime.now()));
      await Future<void>.delayed(Duration.zero);
      expect(shakeCount, equals(1));

      // Wait past slop window and shake again -> should trigger
      await Future<void>.delayed(const Duration(milliseconds: 250));
      eventController.add(AccelerometerEvent(25.0, 0.0, 0.0, DateTime.now()));
      await Future<void>.delayed(Duration.zero);
      expect(shakeCount, equals(2));

      detector.stopListening();
    });
  });
}
