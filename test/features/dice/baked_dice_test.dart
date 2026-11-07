import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/features/dice/presentation/dice3d/baked_die.dart';
import 'package:scrivener/features/dice/presentation/dice3d/dice_sprite_atlas.dart';
import 'package:scrivener/features/dice/presentation/widgets/polyhedral_dice_tray.dart';

import 'dice_test_atlas.dart';

void main() {
  testWidgets('manifest parsing and frame rect math', (tester) async {
    final atlas = await buildTestAtlas(tester);
    final d6 = atlas.clipFor(6)!;
    expect(d6.frames, 6);
    expect(d6.faceCenter, const Offset(0.5, 0.4));
    // variant 0 frame 0 -> top-left; variant 1 frame 0 -> index 6 -> row 1 col 2
    expect(d6.frameRect(0, 0), const Rect.fromLTWH(0, 0, 10, 10));
    expect(d6.frameRect(1, 0), const Rect.fromLTWH(20, 10, 10, 10));
    expect(d6.frameForProgress(0), 0);
    expect(d6.frameForProgress(1), 5);
  });

  testWidgets('d100 reuses d10; other sizes use the nearest baked die', (
    tester,
  ) async {
    final atlas = await buildTestAtlas(tester);
    expect(atlas.clipFor(100)!.sides, 10);
    expect(atlas.clipFor(3)!.sides, 6);
    expect(atlas.clipFor(20)!.sides, 10);
    expect(const DiceSpriteAtlas({}).clipFor(6), isNull);
  });

  testWidgets('number is hidden while tumbling and shown when landed', (
    tester,
  ) async {
    final atlas = await buildTestAtlas(tester);
    Widget host(double progress, {bool showNumber = true}) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: BakedDie(
            clip: atlas.clipFor(6)!,
            value: 4,
            index: 0,
            progress: progress,
            size: 80,
            tint: Colors.blue,
            numberColor: Colors.white,
            showNumber: showNumber,
          ),
        ),
      ),
    );

    await tester.pumpWidget(host(0.3));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0);

    await tester.pumpWidget(host(1));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
    expect(find.text('4'), findsOneWidget);

    await tester.pumpWidget(host(1, showNumber: false));
    expect(find.text('4'), findsNothing);
  });

  testWidgets('PolyhedralDiceTray renders DieSprite when atlas is provided', (
    tester,
  ) async {
    final atlas = await buildTestAtlas(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PolyhedralDiceTray(
            diceCounts: const {6: 1},
            flatModifier: 0,
            onAddDie: (_) {},
            onRemoveDie: (_) {},
            onAdjustModifier: (_) {},
            atlas: atlas,
          ),
        ),
      ),
    );

    // DieSprite should be used for the polyhedral dice buttons
    expect(find.byType(DieSprite), findsWidgets);
    // Labels should be present on top of the buttons
    expect(find.text('d4'), findsOneWidget);
    expect(find.text('d6'), findsOneWidget);
    expect(find.text('d8'), findsOneWidget);
    expect(find.text('d10'), findsOneWidget);
    expect(find.text('d12'), findsOneWidget);
    expect(find.text('d20'), findsOneWidget);
    expect(find.text('d100'), findsOneWidget);
  });

  testWidgets('PolyhedralDiceTray falls back to icons when atlas is null', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PolyhedralDiceTray(
            diceCounts: const {6: 1},
            flatModifier: 0,
            onAddDie: (_) {},
            onRemoveDie: (_) {},
            onAdjustModifier: (_) {},
            atlas: null,
          ),
        ),
      ),
    );

    expect(find.byType(DieSprite), findsNothing);
    expect(find.byIcon(Icons.casino), findsOneWidget); // d20 icon
    expect(find.text('d6'), findsOneWidget);
  });

  test('baked assets declared in manifest exist on disk', () {
    final manifest = File('assets/dice/dice_manifest.json').readAsStringSync();
    for (final sides in [4, 6, 8, 10, 12, 20]) {
      expect(manifest.contains('"d$sides"'), isTrue, reason: 'd$sides');
      expect(File('assets/dice/d$sides.png').existsSync(), isTrue);
    }
  });
}
