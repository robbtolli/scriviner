import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/core/legal/license_registration.dart';
import 'package:scrivener/features/home/presentation/home_screen.dart';
import 'package:scrivener/features/home/presentation/widgets/about_scrivener_dialog.dart';

void main() {
  group('Legal & About Dialog Tests', () {
    test(
      'registerScrivenerLicenses registers MPL-2.0 and SRD 5.1 licenses',
      () async {
        registerScrivenerLicenses();
        final licenses = await LicenseRegistry.licenses.toList();

        final packages = licenses.expand((entry) => entry.packages).toSet();
        expect(packages.contains('scrivener'), isTrue);
        expect(packages.contains('dnd5e_srd_5.1'), isTrue);

        final scrivenerEntry = licenses.firstWhere(
          (entry) => entry.packages.contains('scrivener'),
        );
        final paragraphTexts = scrivenerEntry.paragraphs
            .map((p) => p.text)
            .join('\n');
        expect(
          paragraphTexts.contains('Mozilla Public License Version 2.0'),
          isTrue,
        );
        expect(
          paragraphTexts.contains('Robert Tolliver (tollitech.com)'),
          isTrue,
        );
      },
    );

    testWidgets(
      'AboutScrivenerDialog displays author, MPL 2.0, and SRD attribution',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: AboutScrivenerDialog())),
        );
        await tester.pumpAndSettle();

        expect(find.text('SCRIVENER'), findsOneWidget);
        expect(find.text('v1.0.0'), findsOneWidget);
        expect(find.text('Robert Tolliver (tollitech.com)'), findsOneWidget);
        expect(find.text('What is a Scrivener?'), findsOneWidget);
        expect(find.byIcon(Icons.history_edu), findsOneWidget);
        expect(find.text('MPL 2.0'), findsOneWidget);
        expect(find.text('Open Source License'), findsOneWidget);
        expect(find.text('SRD 5.1 Attribution (CC-BY-4.0)'), findsOneWidget);
        expect(find.text('FULL LICENSES'), findsOneWidget);
        expect(find.text('CLOSE'), findsOneWidget);
      },
    );

    testWidgets('HomeScreen info action opens AboutScrivenerDialog', (
      tester,
    ) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(() => db.close());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final infoBtn = find.byTooltip('About Scrivener');
      expect(infoBtn, findsOneWidget);

      await tester.tap(infoBtn);
      await tester.pumpAndSettle();

      expect(find.byType(AboutScrivenerDialog), findsOneWidget);

      // Tap CLOSE to dismiss
      await tester.tap(find.text('CLOSE'));
      await tester.pumpAndSettle();

      expect(find.byType(AboutScrivenerDialog), findsNothing);

      // Clean unmount
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets(
      'AboutScrivenerDialog renders in landscape (640x360) without overflow',
      (tester) async {
        tester.view.physicalSize = const Size(640, 360);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: AboutScrivenerDialog())),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AboutScrivenerDialog), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
