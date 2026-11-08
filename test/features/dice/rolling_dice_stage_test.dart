import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/features/dice/presentation/dice3d/baked_die.dart';
import 'package:scrivener/features/dice/presentation/dice3d/dice_stage_layout.dart';
import 'package:scrivener/features/dice/presentation/dice_roller_drawer.dart';
import 'package:scrivener/features/dice/presentation/widgets/rolling_dice_stage.dart';
import 'package:scrivener/features/dice/providers/dice_drawer_provider.dart';

import 'dice_test_atlas.dart';

void main() {
  group('DiceStageLayout tiers', () {
    test('dice shrink, then lose numbers, then become total only', () {
      expect(DiceStageLayout.forCount(1).dieSize, 96);
      expect(DiceStageLayout.forCount(6).dieSize, 80);
      expect(DiceStageLayout.forCount(12).dieSize, 64);
      expect(DiceStageLayout.forCount(12).mode, DiceDisplayMode.numbered);
      expect(DiceStageLayout.forCount(13).mode, DiceDisplayMode.blank);
      expect(DiceStageLayout.forCount(13).dieSize, 48);
      expect(DiceStageLayout.forCount(40).mode, DiceDisplayMode.blank);
      expect(DiceStageLayout.forCount(40).dieSize, 32);
      expect(DiceStageLayout.forCount(41).mode, DiceDisplayMode.totalOnly);
    });
  });

  testWidgets('settles on the exact recorded values', (tester) async {
    final atlas = await buildTestAtlas(tester);
    await tester.pumpWidget(
      stageHost(
        RollingDiceStage(record: testRecord([3, 5]), serial: 1, atlas: atlas),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(find.text('3'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('8'), findsOneWidget); // total
  });

  testWidgets('disableAnimations shows final state immediately', (
    tester,
  ) async {
    final atlas = await buildTestAtlas(tester);
    await tester.pumpWidget(
      stageHost(
        RollingDiceStage(record: testRecord([4]), serial: 1, atlas: atlas),
        disableAnimations: true,
      ),
    );
    expect(find.text('4'), findsNWidgets(2)); // die face + total
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('new serial restarts the animation', (tester) async {
    final atlas = await buildTestAtlas(tester);
    Widget stage(int serial) => stageHost(
      RollingDiceStage(record: testRecord([3]), serial: serial, atlas: atlas),
    );
    await tester.pumpWidget(stage(1));
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
    await tester.pumpWidget(stage(2));
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpAndSettle();
  });

  testWidgets('13+ dice tumble without numbers', (tester) async {
    final atlas = await buildTestAtlas(tester);
    await tester.pumpWidget(
      stageHost(
        RollingDiceStage(
          record: testRecord(List.filled(13, 2)),
          serial: 1,
          atlas: atlas,
        ),
        disableAnimations: true,
      ),
    );
    expect(find.byType(BakedDie), findsNWidgets(13));
    final dies = tester.widgetList<BakedDie>(find.byType(BakedDie));
    expect(dies.every((d) => !d.showNumber && d.size == 48), isTrue);
    expect(find.text('26'), findsOneWidget); // total only
  });

  testWidgets('41+ dice show only the total', (tester) async {
    final atlas = await buildTestAtlas(tester);
    await tester.pumpWidget(
      stageHost(
        RollingDiceStage(
          record: testRecord(List.filled(41, 1)),
          serial: 1,
          atlas: atlas,
        ),
        disableAnimations: true,
      ),
    );
    expect(find.byType(BakedDie), findsNothing);
    expect(find.text('41'), findsOneWidget);
  });

  testWidgets('total-only count-up ends on the real total', (tester) async {
    final atlas = await buildTestAtlas(tester);
    await tester.pumpWidget(
      stageHost(
        RollingDiceStage(
          record: testRecord(List.filled(50, 2)),
          serial: 1,
          atlas: atlas,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('100'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('100'), findsOneWidget);
  });

  testWidgets('shows only the total while the atlas is still loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      stageHost(
        RollingDiceStage(record: testRecord([3, 4]), serial: 1),
        disableAnimations: true,
      ),
    );
    expect(find.byType(BakedDie), findsNothing);
    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('dropped dice are dimmed once settled', (tester) async {
    final atlas = await buildTestAtlas(tester);
    await tester.pumpWidget(
      stageHost(
        RollingDiceStage(
          record: testRecord([2, 6], sides: 10, dropIndex: 0),
          serial: 1,
          atlas: atlas,
        ),
        disableAnimations: true,
      ),
    );
    final opacities = tester
        .widgetList<Opacity>(
          find.ancestor(
            of: find.byType(BakedDie),
            matching: find.byType(Opacity),
          ),
        )
        .map((o) => o.opacity)
        .toList();
    expect(opacities, contains(0.35));
  });

  for (final size in const [Size(360, 640), Size(640, 360)]) {
    for (final count in const [10, 30, 60]) {
      testWidgets('$count dice do not overflow at $size', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        final atlas = await buildTestAtlas(tester);
        await tester.pumpWidget(
          stageHost(
            RollingDiceStage(
              record: testRecord(List.filled(count, 4)),
              serial: 1,
              atlas: atlas,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('roll button shows the stage and bumps rollSerial', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: DiceRollerDrawer(isBottomSheet: true)),
        ),
      ),
    );
    expect(find.byType(RollingDiceStage), findsNothing);
    await tester.tap(find.text('ROLL'));
    await tester.pump();
    expect(find.byType(RollingDiceStage), findsOneWidget);
    expect(container.read(diceDrawerProvider).rollSerial, 1);
    await tester.pumpAndSettle();
  });
}
