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
/// Large rolls degrade gracefully (see [DiceStageLayout]): dice shrink, then
/// lose their numbers, then are replaced by just the animated total.
class RollingDiceStage extends StatefulWidget {
  final DiceRollRecord record;
  final int serial;

  /// Pre-rendered 3D dice. While null (still loading) only the total is shown.
  final DiceSpriteAtlas? atlas;

  const RollingDiceStage({
    super.key,
    required this.record,
    required this.serial,
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

  List<SingleDieResult> get _dice => [
    for (final g in widget.record.groups) ...g.dice,
  ];

  DiceStageLayout get _layout => (widget.atlas == null || widget.atlas!.isEmpty)
      ? const DiceStageLayout(DiceDisplayMode.totalOnly, 0)
      : DiceStageLayout.forCount(_dice.length);

  double get _staggerMs => math.min(80, 900 / math.max(1, _dice.length));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _play();
    }
  }

  @override
  void didUpdateWidget(RollingDiceStage old) {
    super.didUpdateWidget(old);
    if (old.serial != widget.serial) _play();
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
    final layout = _layout;
    final totalOnly = layout.mode == DiceDisplayMode.totalOnly;

    final totalColor = r.isCriticalHit
        ? Colors.greenAccent
        : r.isCriticalMiss
        ? Colors.redAccent
        : theme.colorScheme.primary;
    final modifierText = r.modifier == 0
        ? ''
        : '  (${r.modifier > 0 ? '+' : '−'}${r.modifier.abs()})';

    return Semantics(
      liveRegion: true,
      label: 'Rolled ${r.total}',
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final elapsed =
                  _controller.value * (_controller.duration!.inMilliseconds);
              final settled = _controller.isCompleted;
              final totalStyle = TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: totalColor,
              );

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  children: [
                    if (!totalOnly)
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: layout.dieSize >= 64 ? 8 : 4,
                        runSpacing: layout.dieSize >= 64 ? 8 : 4,
                        children: [
                          for (var i = 0; i < dice.length; i++)
                            _AnimatedDie(
                              clip: widget.atlas!.clipFor(dice[i].sides)!,
                              dieSize: layout.dieSize,
                              showNumber:
                                  layout.mode == DiceDisplayMode.numbered,
                              die: dice[i],
                              index: i,
                              progress: ((elapsed - i * _staggerMs) / _dieMs)
                                  .clamp(0.0, 1.0),
                            ),
                        ],
                      ),
                    if (!totalOnly) const SizedBox(height: 8),
                    if (totalOnly)
                      Text(
                        '${(r.total * _controller.value).round()}$modifierText',
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
                            '${r.total}$modifierText',
                            style: totalStyle,
                          ),
                        ),
                      ),
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

class _AnimatedDie extends StatelessWidget {
  final DiceAtlasClip clip;
  final double dieSize;
  final bool showNumber;
  final SingleDieResult die;
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
