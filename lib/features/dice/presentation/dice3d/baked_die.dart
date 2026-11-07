import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'dice_sprite_atlas.dart';

/// Plays a pre-rendered blank-faced die tumble and, as it comes to rest,
/// overlays the rolled [value] on the face that is looking at the user.
///
/// [progress] runs 0..1. The sprite is neutral grey and tinted at runtime.
class BakedDie extends StatelessWidget {
  final DiceAtlasClip clip;
  final int value;
  final int index;
  final double progress;
  final double size;
  final Color tint;
  final Color numberColor;

  /// When false (many small dice) the die tumbles with blank faces throughout.
  final bool showNumber;

  const BakedDie({
    super.key,
    required this.clip,
    required this.value,
    required this.index,
    required this.progress,
    required this.size,
    required this.tint,
    required this.numberColor,
    this.showNumber = true,
  });

  /// Progress after which the number starts to fade in.
  static const double numberStart = 0.85;

  @override
  Widget build(BuildContext context) {
    final variant = index % clip.variants;
    final mirrored = (index ~/ clip.variants).isOdd;
    // Small deterministic in-plane tilt so identical dice do not look cloned.
    final tilt = ((index * 37) % 21 - 10) / 10 * 0.35;

    final numberOpacity = ((progress - numberStart) / (1 - numberStart)).clamp(
      0.0,
      1.0,
    );
    final cx = mirrored ? 1 - clip.faceCenter.dx : clip.faceCenter.dx;
    final digits = '$value'.length;
    final fontSize = math.max(
      10.0,
      clip.faceRadius *
          size *
          1.6 *
          (digits >= 3
              ? 0.6
              : digits == 2
              ? 0.85
              : 1),
    );

    return Transform.rotate(
      angle: tilt,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _BakedDiePainter(
                  clip: clip,
                  variant: variant,
                  frame: clip.frameForProgress(progress),
                  mirrored: mirrored,
                  tint: tint,
                ),
              ),
            ),
            if (showNumber)
              Positioned(
                left: cx * size - size / 2,
                top: clip.faceCenter.dy * size - size / 2,
                width: size,
                height: size,
                child: Center(
                  child: Opacity(
                    opacity: numberOpacity,
                    child: Transform.scale(
                      scale: 0.7 + 0.3 * numberOpacity,
                      child: Text(
                        '$value',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w800,
                          color: numberColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BakedDiePainter extends CustomPainter {
  final DiceAtlasClip clip;
  final int variant;
  final int frame;
  final bool mirrored;
  final Color tint;

  _BakedDiePainter({
    required this.clip,
    required this.variant,
    required this.frame,
    required this.mirrored,
    required this.tint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..filterQuality = FilterQuality.medium
      ..colorFilter = ColorFilter.mode(tint, BlendMode.modulate);
    if (mirrored) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }
    canvas.drawImageRect(
      clip.image,
      clip.frameRect(variant, frame),
      Offset.zero & size,
      paint,
    );
  }

  @override
  bool shouldRepaint(_BakedDiePainter old) =>
      old.frame != frame ||
      old.variant != variant ||
      old.mirrored != mirrored ||
      old.tint != tint ||
      old.clip != clip;
}

/// A single still frame of a baked die, cropped in to fill [size]. Used for
/// buttons that show a resting die. Defaults to the last frame of the tumble
/// (the die lying face-up, ready for a number or label).
class DieSprite extends StatelessWidget {
  final DiceAtlasClip clip;
  final double size;
  final Color tint;
  final int variant;

  /// Frame to show; null means the last frame.
  final int? frame;

  /// Fraction of each frame edge cropped away (the baked frames have empty
  /// margin around the die).
  final double cropMargin;

  const DieSprite({
    super.key,
    required this.clip,
    required this.size,
    this.tint = Colors.white,
    this.variant = 0,
    this.frame,
    this.cropMargin = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DieSpritePainter(
          clip: clip,
          variant: variant,
          frame: frame ?? clip.frames - 1,
          tint: tint,
          cropMargin: cropMargin,
        ),
      ),
    );
  }
}

class _DieSpritePainter extends CustomPainter {
  final DiceAtlasClip clip;
  final int variant;
  final int frame;
  final Color tint;
  final double cropMargin;

  _DieSpritePainter({
    required this.clip,
    required this.variant,
    required this.frame,
    required this.tint,
    required this.cropMargin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final src = clip.frameRect(variant, frame);
    final inset = src.width * cropMargin;
    canvas.drawImageRect(
      clip.image,
      src.deflate(inset),
      Offset.zero & size,
      Paint()
        ..filterQuality = FilterQuality.medium
        ..colorFilter = ColorFilter.mode(tint, BlendMode.modulate),
    );
  }

  @override
  bool shouldRepaint(_DieSpritePainter old) =>
      old.clip != clip ||
      old.variant != variant ||
      old.frame != frame ||
      old.tint != tint ||
      old.cropMargin != cropMargin;
}
