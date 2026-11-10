import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/features/dice/presentation/dice_roller_screen.dart';
import 'package:scrivener/features/widgets/widget_launch_handler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WidgetLaunchEvent Parsing Tests', () {
    test('parses scrivener://dice scheme', () {
      final uri = Uri.parse('scrivener://dice');
      final event = WidgetLaunchEvent.parse(uri);

      expect(event, isNotNull);
      expect(event!.destination, WidgetLaunchDestination.dice);
      expect(event.characterId, isNull);
    });

    test('parses scrivener://character?id=hero-123 scheme', () {
      final uri = Uri.parse('scrivener://character?id=hero-123');
      final event = WidgetLaunchEvent.parse(uri);

      expect(event, isNotNull);
      expect(event!.destination, WidgetLaunchDestination.character);
      expect(event.characterId, 'hero-123');
    });

    test('parses scrivener://character/hero-456 path scheme', () {
      final uri = Uri.parse('scrivener://character/hero-456');
      final event = WidgetLaunchEvent.parse(uri);

      expect(event, isNotNull);
      expect(event!.destination, WidgetLaunchDestination.character);
      expect(event.characterId, 'hero-456');
    });

    test('parses universal query parameters ?openDice=true', () {
      final uri = Uri.parse('https://scrivener.app/?openDice=true');
      final event = WidgetLaunchEvent.parse(uri);

      expect(event, isNotNull);
      expect(event!.destination, WidgetLaunchDestination.dice);
    });

    test('parses universal query parameters ?char=hero-789', () {
      final uri = Uri.parse('https://scrivener.app/?char=hero-789');
      final event = WidgetLaunchEvent.parse(uri);

      expect(event, isNotNull);
      expect(event!.destination, WidgetLaunchDestination.character);
      expect(event.characterId, 'hero-789');
    });

    test('returns null on empty, unknown, or null uris', () {
      expect(WidgetLaunchEvent.parse(null), isNull);
      expect(WidgetLaunchEvent.parse(Uri.parse('scrivener://unknown')), isNull);
      expect(
        WidgetLaunchEvent.parse(Uri.parse('https://example.com/')),
        isNull,
      );
    });

    testWidgets(
      'WidgetLaunchController navigates to full-screen DiceRollerScreen on scrivener://dice launch',
      (tester) async {
        const channel = MethodChannel('com.tollitech.scrivener/widget_launch');
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
              if (call.method == 'getInitialLaunchUri') {
                return 'scrivener://dice';
              }
              return null;
            });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null);
        });

        final controller = WidgetLaunchController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, _) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.initialize(
                      context: context,
                      ref: ref,
                      onOpenCharacter: (_) {},
                    );
                  });
                  return const Scaffold(body: Text('Home'));
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(DiceRollerScreen), findsOneWidget);
        expect(find.text('DICE ROLLER'), findsOneWidget);
      },
    );

    test('isSupported and isLaunchChannelSupported on various platforms', () {
      try {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;
        expect(WidgetLaunchController.isSupported, isFalse);
        expect(WidgetLaunchController.isLaunchChannelSupported, isFalse);

        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        expect(WidgetLaunchController.isSupported, isFalse);
        expect(WidgetLaunchController.isLaunchChannelSupported, isFalse);

        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        expect(WidgetLaunchController.isSupported, isTrue);
        expect(WidgetLaunchController.isLaunchChannelSupported, isFalse);

        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        expect(WidgetLaunchController.isSupported, isTrue);
        expect(WidgetLaunchController.isLaunchChannelSupported, isTrue);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets(
      'WidgetLaunchController.initialize safely does nothing on Linux without error',
      (tester) async {
        try {
          debugDefaultTargetPlatformOverride = TargetPlatform.linux;

          final controller = WidgetLaunchController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                home: Consumer(
                  builder: (context, ref, _) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.initialize(
                        context: context,
                        ref: ref,
                        onOpenCharacter: (_) {},
                      );
                    });
                    return const Scaffold(body: Text('Home'));
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Home'), findsOneWidget);
          expect(tester.takeException(), isNull);
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );
  });
}
