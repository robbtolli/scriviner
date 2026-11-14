import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/app.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/core/widgets/app_splash_screen.dart';
import 'package:scrivener/dice_app.dart';

void main() {
  group('AppSplashScreen', () {
    testWidgets(
      'ScrivenerApp displays Scrivener under logo then transitions to HomeScreen',
      (tester) async {
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() => db.close());

        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: const ScrivenerApp(),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(AppSplashScreen), findsOneWidget);
        final titleText = tester.widget<Text>(find.text('Scrivener'));
        expect(titleText.style?.fontFamily, contains('Cinzel'));
        expect(
          find.image(const AssetImage('assets/icons/app_icon_transparent.png')),
          findsOneWidget,
        );

        await tester.pumpAndSettle();
        expect(find.text('SCRIVENER'), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 50));
      },
    );

    testWidgets(
      'DiceCasterApp displays Dice Caster under logo then transitions to DiceStandaloneScreen',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: DiceCasterApp()));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(AppSplashScreen), findsOneWidget);
        final titleText = tester.widget<Text>(find.text('Dice Caster'));
        expect(titleText.style?.fontFamily, contains('Cinzel'));
        expect(
          find.image(
            const AssetImage('assets/icons/dice_caster_icon_transparent.png'),
          ),
          findsOneWidget,
        );

        await tester.pumpAndSettle();
        expect(find.text('DICE CASTER'), findsOneWidget);
      },
    );

    testWidgets('renders without overflow on 360x640 and 640x360 viewports', (
      tester,
    ) async {
      for (final size in [const Size(360, 640), const Size(640, 360)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: AppSplashScreen(
              key: UniqueKey(),
              title: 'Dice Caster',
              logoAsset: 'assets/icons/dice_caster_icon_transparent.png',
              child: const SizedBox.shrink(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Dice Caster'), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.pumpAndSettle();
      }
    });
  });
}
