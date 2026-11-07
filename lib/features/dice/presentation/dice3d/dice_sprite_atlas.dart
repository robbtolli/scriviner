import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One pre-rendered, blank-faced tumble animation for a die type.
///
/// Frames live in a sprite atlas laid out row-major in a grid of [columns].
/// Frame index = `variant * frames + frame`. The last frame of every variant
/// shows the same face looking straight at the camera; [faceCenter] (0..1,
/// top-left origin) and [faceRadius] (fraction of the frame) locate it so the
/// rolled number can be overlaid.
class DiceAtlasClip {
  final int sides;
  final ui.Image image;
  final int columns;
  final int frameSize;
  final int frames;
  final int variants;
  final ui.Offset faceCenter;
  final double faceRadius;

  const DiceAtlasClip({
    required this.sides,
    required this.image,
    required this.columns,
    required this.frameSize,
    required this.frames,
    required this.variants,
    required this.faceCenter,
    required this.faceRadius,
  });

  /// Source rectangle in the atlas for [frame] (0-based) of [variant].
  ui.Rect frameRect(int variant, int frame) {
    final clampedFrame = frame.clamp(0, frames - 1);
    final index = (variant % variants) * frames + clampedFrame;
    final row = index ~/ columns;
    final col = index % columns;
    return ui.Rect.fromLTWH(
      (col * frameSize).toDouble(),
      (row * frameSize).toDouble(),
      frameSize.toDouble(),
      frameSize.toDouble(),
    );
  }

  /// Frame index to show for animation [progress] in 0..1.
  int frameForProgress(double progress) =>
      (progress.clamp(0.0, 1.0) * (frames - 1)).round();
}

/// All pre-rendered die clips, keyed by die sides.
class DiceSpriteAtlas {
  final Map<int, DiceAtlasClip> _clips;

  const DiceSpriteAtlas(this._clips);

  bool get isEmpty => _clips.isEmpty;

  /// Returns the clip for a die with [sides]. A d100 reuses the d10 tumble and
  /// any other size (e.g. d2, d3) uses the closest baked die. Null only when
  /// the atlas is empty.
  DiceAtlasClip? clipFor(int sides) {
    final exact = _clips[sides == 100 ? 10 : sides];
    if (exact != null || _clips.isEmpty) return exact;
    final nearest = _clips.keys.reduce(
      (a, b) => (a - sides).abs() <= (b - sides).abs() ? a : b,
    );
    return _clips[nearest];
  }

  /// Parses the manifest JSON, resolving each atlas image through [loadImage].
  static Future<DiceSpriteAtlas> fromManifest(
    String manifestJson,
    Future<ui.Image> Function(String atlasFile) loadImage,
  ) async {
    final manifest = jsonDecode(manifestJson) as Map<String, dynamic>;
    final clips = <int, DiceAtlasClip>{};
    for (final entry in manifest.values) {
      final m = entry as Map<String, dynamic>;
      final center = (m['faceCenter'] as List).cast<num>();
      final sides = m['sides'] as int;
      clips[sides] = DiceAtlasClip(
        sides: sides,
        image: await loadImage(m['atlas'] as String),
        columns: m['columns'] as int,
        frameSize: m['frameSize'] as int,
        frames: m['frames'] as int,
        variants: m['variants'] as int,
        faceCenter: ui.Offset(center[0].toDouble(), center[1].toDouble()),
        faceRadius: (m['faceRadius'] as num).toDouble(),
      );
    }
    return DiceSpriteAtlas(clips);
  }

  static Future<DiceSpriteAtlas> loadFromAssets([AssetBundle? bundle]) async {
    final b = bundle ?? rootBundle;
    final json = await b.loadString('assets/dice/dice_manifest.json');
    return fromManifest(json, (file) async {
      final data = await b.load('assets/dice/$file');
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      return (await codec.getNextFrame()).image;
    });
  }
}

/// Loads the baked dice atlas once. While loading (or if the assets are
/// missing) the UI falls back to the flat 2D dice.
final diceSpriteAtlasProvider = FutureProvider<DiceSpriteAtlas>(
  (ref) => DiceSpriteAtlas.loadFromAssets(),
);
