import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/dice/dice_ast.dart';
import 'package:scrivener/core/dice/dice_parser.dart';
import 'package:scrivener/features/dice/models/dice_roll_record.dart';
import 'package:scrivener/features/dice/presentation/dice3d/dice_sprite_atlas.dart';

/// Small in-memory atlas (d6, d10 only) for widget tests.
const testManifest = '''
{
  "d6": {"sides": 6, "atlas": "d6.png", "columns": 4, "rows": 3, "frameSize": 10,
         "frames": 6, "variants": 2, "faceCenter": [0.5, 0.4], "faceRadius": 0.2},
  "d10": {"sides": 10, "atlas": "d10.png", "columns": 4, "rows": 3, "frameSize": 10,
          "frames": 6, "variants": 2, "faceCenter": [0.5, 0.5], "faceRadius": 0.1}
}
''';

Future<ui.Image> _blankImage() async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawRect(
    const ui.Rect.fromLTWH(0, 0, 8, 8),
    ui.Paint()..color = const Color(0xFFCCCCCC),
  );
  return recorder.endRecording().toImage(8, 8);
}

Future<DiceSpriteAtlas> buildTestAtlas(WidgetTester tester) async {
  return (await tester.runAsync(
    () async =>
        DiceSpriteAtlas.fromManifest(testManifest, (_) => _blankImage()),
  ))!;
}

DiceRollRecord testRecord(
  List<int> values, {
  int sides = 6,
  int dropIndex = -1,
}) {
  final dice = [
    for (var i = 0; i < values.length; i++)
      SingleDieResult(
        value: values[i],
        sides: sides,
        isDropped: i == dropIndex,
      ),
  ];
  final kept = dice.where((d) => !d.isDropped).fold(0, (s, d) => s + d.value);
  return DiceRollRecord(
    id: 'x',
    context: 'Test',
    formula: '${values.length}d$sides',
    total: kept,
    modifier: 0,
    groups: [
      DiceGroupResult(
        term: DiceParser.parse('${values.length}d$sides').diceTerms.first,
        dice: dice,
        subtotal: kept,
      ),
    ],
    timestamp: DateTime(2026),
  );
}

Widget stageHost(Widget child, {bool disableAnimations = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);
