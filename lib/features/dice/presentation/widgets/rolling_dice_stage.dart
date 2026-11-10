import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/dice/dice_ast.dart';
import '../../models/dice_roll_record.dart';
import '../dice3d/baked_die.dart';
import '../dice3d/dice_sprite_atlas.dart';
import '../dice3d/dice_stage_layout.dart';

/// Plays the pre-rendered 3D tumble for every die in [record] and settles on
/// the real rolled values. Purely cosmetic: values come from the
/// already-resolved record. Changing [serial] restarts the animation.
///
/// When [record] is null and [previewTerms] is provided, displays the resting
/// dice for the current formula with blank faces (no numbers) and no total.
///
/// Large rolls degrade gracefully (see [DiceStageLayout]): dice shrink, then
/// lose their numbers, then are replaced by just the animated total.
class RollingDiceStage extends StatefulWidget {
  final DiceRollRecord? record;
  final List<DiceTerm> previewTerms;
  final int serial;

  /// Pre-rendered 3D dice. While null (still loading) only the total is shown.
  final DiceSpriteAtlas? atlas;

  const RollingDiceStage({
    super.key,
    this.record,
    this.previewTerms = const [],
    this.serial = 0,
    this.atlas,
  });

  @override
  State<RollingDiceStage> createState() => _RollingDiceStageState();
}

class _RollingDiceStageState extends State<RollingDiceStage>
    with SingleTickerProviderStateMixin {
  static const _dieMs = 900;
  static const _totalOnlyMs = 700;

  late final AnimationController _controller = AnimationController(vsync: this);
  bool _started = false;

  bool get _isPreview => widget.record == null;

  List<_VisualDie> get _dice {
    final list = <_VisualDie>[];
    if (_isPreview) {
      for (final term in widget.previewTerms) {
        for (var i = 0; i < term.count; i++) {
          if (term.sides == 100) {
            list.add(
              const _VisualDie(
                sides: 10,
                value: 0,
                displayText: '',
                isDropped: false,
                isPercentileTens: true,
              ),
            );
            list.add(
              const _VisualDie(
                sides: 10,
                value: 0,
                displayText: '',
                isDropped: false,
              ),
            );
          } else {
            list.add(
              _VisualDie(
                sides: term.sides,
                value: 0,
                displayText: '',
                isDropped: false,
              ),
            );
          }
        }
      }
      return list;
    }

    for (final group in widget.record!.groups) {
      for (final die in group.dice) {
        if (die.sides == 100) {
          // Physical percentile pair: tens die (00-90) and ones die (0-9).
          // In standard D&D 5e percentile rules, 100 is represented by 00 and 0.
          final tensVal = (die.value == 100 ? 0 : (die.value ~/ 10) * 10);
          final onesVal = (die.value == 100 ? 0 : die.value % 10);
          final tensText = tensVal == 0 ? '00' : '$tensVal';
          final onesText = '$onesVal';

          list.add(
            _VisualDie(
              sides: 10,
              value: tensVal,
              displayText: tensText,
              isDropped: die.isDropped,
              isPercentileTens: true,
            ),
          );
          list.add(
            _VisualDie(
              sides: 10,
              value: onesVal,
              displayText: onesText,
              isDropped: die.isDropped,
            ),
          );
        } else {
          list.add(
            _VisualDie(
              sides: die.sides,
              value: die.value,
              displayText: '${die.value}',
              isDropped: die.isDropped,
            ),
          );
        }
      }
    }
    return list;
  }

  DiceStageLayout get _layout => (widget.atlas == null || widget.atlas!.isEmpty)
      ? (_isPreview
            ? DiceStageLayout.forCount(_dice.length)
            : const DiceStageLayout(DiceDisplayMode.totalOnly, 0))
      : DiceStageLayout.forCount(_dice.length);

  double get _staggerMs => math.min(80, 900 / math.max(1, _dice.length));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      if (!_isPreview) _play();
    }
  }

  @override
  void didUpdateWidget(RollingDiceStage old) {
    super.didUpdateWidget(old);
    if (!_isPreview && (old.serial != widget.serial || old.record == null)) {
      _play();
    }
  }

  void _play() {
    final totalMs = _layout.mode == DiceDisplayMode.totalOnly
        ? _totalOnlyMs
        : _dieMs + _staggerMs * (_dice.length - 1);
    _controller.duration = Duration(milliseconds: totalMs.round());
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dice = _dice;
    final r = widget.record;
    final isPreview = _isPreview;
    final layout = _layout;
    final hasAtlas = widget.atlas != null && !widget.atlas!.isEmpty;
    final totalOnly = layout.mode == DiceDisplayMode.totalOnly;

    final totalColor = r != null
        ? (r.isCriticalHit
              ? Colors.greenAccent
              : r.isCriticalMiss
              ? Colors.redAccent
              : theme.colorScheme.primary)
        : theme.colorScheme.primary;
    final modifierText = (r == null || r.modifier == 0)
        ? ''
        : '  (${r.modifier > 0 ? '+' : '−'}${r.modifier.abs()})';

    return Semantics(
      liveRegion: !isPreview,
      label: isPreview ? 'Selected dice preview' : 'Rolled ${r!.total}',
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final durationMs = _controller.duration?.inMilliseconds ?? 0;
              final elapsed = _controller.value * durationMs;
              final settled = isPreview || _controller.isCompleted;
              final totalStyle = TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: totalColor,
              );

              final baseSpacing = layout.dieSize >= 64 ? 12.0 : 6.0;
              // Pre-rendered 3D frames include ~23% transparent tumble padding on each side
              // (~44% between two frames). To ensure the visible distance between the physical
              // tens and ones dice is genuinely half of the normal distance between dice, the
              // frames overlap their transparent margins by ~19% of dieSize.
              final percentileOverlap = (layout.dieSize * 0.19).roundToDouble();
              final percentilePairWidth =
                  layout.dieSize * 2 - percentileOverlap;

              final stageChildren = <Widget>[];
              if (!totalOnly && hasAtlas) {
                Widget animatedDie(int i) => _AnimatedDie(
                  clip: widget.atlas!.clipFor(dice[i].sides)!,
                  dieSize: layout.dieSize,
                  showNumber:
                      !isPreview && layout.mode == DiceDisplayMode.numbered,
                  die: dice[i],
                  index: i,
                  progress: isPreview
                      ? 1.0
                      : ((elapsed - i * _staggerMs) / _dieMs).clamp(0.0, 1.0),
                );

                for (var i = 0; i < dice.length; i++) {
                  if (dice[i].isPercentileTens && i + 1 < dice.length) {
                    final tensIndex = i;
                    final onesIndex = i + 1;
                    stageChildren.add(
                      SizedBox(
                        width: percentilePairWidth,
                        height: layout.dieSize,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              width: layout.dieSize,
                              height: layout.dieSize,
                              child: animatedDie(tensIndex),
                            ),
                            Positioned(
                              left: layout.dieSize - percentileOverlap,
                              top: 0,
                              width: layout.dieSize,
                              height: layout.dieSize,
                              child: animatedDie(onesIndex),
                            ),
                          ],
                        ),
                      ),
                    );
                    i++; // Pair with ones die
                  } else {
                    stageChildren.add(animatedDie(i));
                  }
                }
              } else if (!totalOnly && isPreview && !hasAtlas) {
                // Fallback icon dice in preview mode when atlas is not loaded
                for (var i = 0; i < dice.length; i++) {
                  stageChildren.add(
                    SizedBox(
                      width: layout.dieSize,
                      height: layout.dieSize,
                      child: Center(
                        child: Icon(
                          dice[i].sides == 20
                              ? Icons.casino
                              : Icons.change_history,
                          size: layout.dieSize * 0.5,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                }
              }

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  children: [
                    if (stageChildren.isNotEmpty)
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: baseSpacing,
                        runSpacing: baseSpacing,
                        children: stageChildren,
                      ),
                    if (!isPreview) ...[
                      if (stageChildren.isNotEmpty) const SizedBox(height: 8),
                      if (totalOnly)
                        Text(
                          '${(r!.total * _controller.value).round()}$modifierText',
                          style: totalStyle,
                        )
                      else
                        AnimatedOpacity(
                          opacity: settled ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: AnimatedScale(
                            scale: settled ? 1 : 0.6,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            child: Text(
                              '${r!.total}$modifierText',
                              style: totalStyle,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VisualDie {
  final int sides;
  final int value;
  final String displayText;
  final bool isDropped;
  final bool isPercentileTens;

  const _VisualDie({
    required this.sides,
    required this.value,
    required this.displayText,
    required this.isDropped,
    this.isPercentileTens = false,
  });
}

class _AnimatedDie extends StatelessWidget {
  final DiceAtlasClip clip;
  final double dieSize;
  final bool showNumber;
  final _VisualDie die;
  final int index;

  /// 0 = not yet thrown, 1 = settled.
  final double progress;

  const _AnimatedDie({
    required this.clip,
    required this.dieSize,
    required this.showNumber,
    required this.die,
    required this.index,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settled = progress >= 1;

    final isNat20 = die.sides == 20 && die.value == 20 && !die.isDropped;
    final isNat1 = die.sides == 20 && die.value == 1 && !die.isDropped;
    final accent = isNat20
        ? Colors.greenAccent
        : isNat1
        ? Colors.redAccent
        : theme.colorScheme.primary;

    // Crit shake right after landing.
    final sinceLand = ((progress - 0.9) / 0.1).clamp(0.0, 1.0);
    final shake = isNat1 && progress >= 0.9
        ? math.sin(sinceLand * math.pi * 6) * 4 * (1 - sinceLand)
        : 0.0;

    final tint = Color.lerp(accent, Colors.white, 0.3)!;

    return Opacity(
      opacity: settled && die.isDropped ? 0.35 : 1,
      child: Container(
        width: dieSize,
        height: dieSize,
        decoration: settled && (isNat20 || isNat1)
            ? BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: accent.withAlpha(140), blurRadius: 18),
                ],
              )
            : null,
        child: Transform.translate(
          offset: Offset(shake, 0),
          child: BakedDie(
            clip: clip,
            value: die.value,
            displayText: die.displayText,
            index: index,
            progress: progress,
            size: dieSize,
            tint: tint,
            showNumber: showNumber,
            numberColor: tint.computeLuminance() > 0.45
                ? Colors.black87
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
