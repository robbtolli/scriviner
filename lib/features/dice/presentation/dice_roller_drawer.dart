import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dice_roll_record.dart';
import '../providers/dice_drawer_provider.dart';
import 'dice3d/baked_die.dart';
import 'dice3d/dice_sprite_atlas.dart';
import 'widgets/polyhedral_dice_tray.dart';
import 'widgets/roll_history_list.dart';
import 'widgets/rolling_dice_stage.dart';
import 'widgets/situational_chips_row.dart';

class DiceRollerDrawer extends ConsumerStatefulWidget {
  final bool isBottomSheet;
  final bool isFullScreen;

  const DiceRollerDrawer({
    super.key,
    this.isBottomSheet = false,
    this.isFullScreen = false,
  });

  @override
  ConsumerState<DiceRollerDrawer> createState() => _DiceRollerDrawerState();
}

class _DiceRollerDrawerState extends ConsumerState<DiceRollerDrawer> {
  late final TextEditingController _formulaController;
  late final FocusNode _formulaFocusNode;

  @override
  void initState() {
    super.initState();
    final initialFormula = ref.read(diceDrawerProvider).formula;
    _formulaController = TextEditingController(text: initialFormula);
    _formulaFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _formulaController.dispose();
    _formulaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(diceDrawerProvider);
    final notifier = ref.read(diceDrawerProvider.notifier);

    // Keep controller text in sync with provider state when updated externally (e.g., via dice buttons)
    if (_formulaController.text != state.formula) {
      _formulaController.value = TextEditingValue(
        text: state.formula,
        selection: TextSelection.collapsed(offset: state.formula.length),
      );
    }

    final scrollableContent = SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          if (!widget.isFullScreen)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.casino,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'DICE ROLLER',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                if (widget.isBottomSheet || Navigator.of(context).canPop())
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
              ],
            ),

          // Context Badge
          if (state.contextTitle != 'Quick Roll')
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(80),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_outline,
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      state.contextTitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),

          // Formula Display Box (full width, tappable to edit)
          GestureDetector(
            onTap: () => _formulaFocusNode.requestFocus(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.hasInvalidFormula
                      ? theme.colorScheme.error
                      : state.isFormulaValid
                      ? theme.colorScheme.primary
                      : theme.dividerColor,
                  width: 1.5,
                ),
                boxShadow: state.isFormulaValid
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withAlpha(25),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              'FORMULA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: state.hasInvalidFormula
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurface.withAlpha(
                                        140,
                                      ),
                              ),
                            ),
                            if (state.hasInvalidFormula) ...[
                              const SizedBox(width: 8),
                              Text(
                                'Invalid formula',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        TextField(
                          key: const ValueKey('formula_text_field'),
                          controller: _formulaController,
                          focusNode: _formulaFocusNode,
                          onChanged: (value) =>
                              notifier.setCustomFormula(value),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: state.hasInvalidFormula
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: 'Select dice',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal,
                              color: theme.colorScheme.onSurface.withAlpha(120),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.rollType != RollType.normal) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: state.rollType == RollType.advantage
                            ? Colors.green.withAlpha(40)
                            : Colors.red.withAlpha(40),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: state.rollType == RollType.advantage
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                      ),
                      child: Text(
                        state.rollType == RollType.advantage ? 'ADV' : 'DIS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: state.rollType == RollType.advantage
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  IconButton(
                    key: const ValueKey('clear_formula_button'),
                    tooltip: 'Clear formula',
                    icon: const Icon(Icons.close, size: 20),
                    visualDensity: VisualDensity.compact,
                    color: theme.colorScheme.onSurface.withAlpha(180),
                    onPressed: () {
                      _formulaController.clear();
                      notifier.clearDice();
                    },
                  ),
                ],
              ),
            ),
          ),
          if (state.lastRoll != null || state.previewDiceTerms.isNotEmpty) ...[
            const SizedBox(height: 12),
            RollingDiceStage(
              record: state.lastRoll,
              previewTerms: state.previewDiceTerms,
              serial: state.rollSerial,
              atlas: ref.watch(diceSpriteAtlasProvider).value,
            ),
          ],
          const SizedBox(height: 12),

          // Polyhedral Tray
          PolyhedralDiceTray(
            atlas: ref.watch(diceSpriteAtlasProvider).value,
            diceCounts: state.diceCounts,
            flatModifier: state.flatModifier,
            onAddDie: (sides) => notifier.addDie(sides),
            onRemoveDie: (sides) => notifier.removeDie(sides),
            onClearDieType: (sides) => notifier.clearDieType(sides),
            onAdjustModifier: (delta) => notifier.adjustFlatModifier(delta),
          ),
          const SizedBox(height: 12),

          // Advantage / Disadvantage Segments
          const Text(
            'ROLL TYPE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          SegmentedButton<RollType>(
            segments: const [
              ButtonSegment(
                value: RollType.normal,
                label: Text('Normal', style: TextStyle(fontSize: 12)),
              ),
              ButtonSegment(
                value: RollType.advantage,
                label: Text('Advantage', style: TextStyle(fontSize: 12)),
              ),
              ButtonSegment(
                value: RollType.disadvantage,
                label: Text('Disadvantage', style: TextStyle(fontSize: 12)),
              ),
            ],
            selected: {state.rollType},
            onSelectionChanged: (set) => notifier.setRollType(set.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.colorScheme.primary.withAlpha(60);
                }
                return theme.colorScheme.surface;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.colorScheme.primary;
                }
                return theme.colorScheme.onSurface.withAlpha(180);
              }),
            ),
          ),
          const SizedBox(height: 12),

          // Situational Modifiers
          const Text(
            'SITUATIONAL MODIFIERS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          SituationalChipsRow(
            activeBonusIds: state.activeBonusIds,
            onToggleBonus: (id) => notifier.toggleSituationalBonus(id),
          ),
          const SizedBox(height: 14),
          Divider(color: theme.dividerColor),
          const SizedBox(height: 8),

          // Roll History Log
          RollHistoryList(
            history: state.history,
            onReroll: (record) {
              notifier.loadFromRecord(record);
              notifier.roll();
            },
            onClearHistory: () => notifier.clearHistory(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );

    final rollFab = Positioned(
      right: 16,
      bottom: 16,
      child: SafeArea(
        child: _RollButton(
          onPressed: state.isFormulaValid
              ? () {
                  _formulaFocusNode.unfocus();
                  notifier.roll();
                }
              : null,
          clip: ref.watch(diceSpriteAtlasProvider).value?.clipFor(12),
        ),
      ),
    );

    final content = Stack(
      fit: StackFit.expand,
      children: [scrollableContent, rollFab],
    );

    if (widget.isFullScreen) {
      return content;
    }

    if (widget.isBottomSheet) {
      return Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: content,
      );
    }

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      width: 380,
      child: SafeArea(child: content),
    );
  }
}

/// Floating action button placed near the bottom of the drawer / screen.
/// Displays a resting d12 themed sprite with "ROLL" overlaid on top, with a
/// completely transparent background and no border. When tapped, the d12
/// executes the authentic 3D tumble simulation from the atlas (matching
/// [RollingDiceStage]), while the word "ROLL" disappears during the tumble
/// and smoothly reappears once the die settles face-up.
class _RollButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final DiceAtlasClip? clip;

  const _RollButton({required this.onPressed, this.clip});

  @override
  State<_RollButton> createState() => _RollButtonState();
}

class _RollButtonState extends State<_RollButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handlePress() {
    if (widget.onPressed == null || _animController.isAnimating) return;
    if (MediaQuery.of(context).disableAnimations) {
      _animController.value = 1.0;
    } else {
      _animController.forward(from: 0.0);
    }
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = widget.onPressed != null;
    final baseTint = Color.lerp(theme.colorScheme.primary, Colors.white, 0.25)!;
    final tint = isEnabled
        ? baseTint
        : Color.lerp(theme.disabledColor, Colors.white, 0.2)!;
    final labelColor = isEnabled
        ? (tint.computeLuminance() > 0.45 ? Colors.black87 : Colors.white)
        : theme.disabledColor;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final isRolling = _animController.isAnimating;
        final canPress = isEnabled && !isRolling;

        return Semantics(
          button: true,
          enabled: canPress,
          label: 'Roll',
          child: Tooltip(
            message: isRolling
                ? 'Rolling...'
                : (isEnabled ? 'Roll dice' : 'Formula is empty'),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isEnabled ? 1.0 : 0.4,
              child: SizedBox(
                width: 84,
                height: 84,
                child: FloatingActionButton(
                  heroTag: null,
                  elevation: 0,
                  focusElevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  disabledElevation: 0,
                  backgroundColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  shape: const CircleBorder(side: BorderSide.none),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: canPress ? _handlePress : null,
                  child: Builder(
                    builder: (context) {
                      final progress = isRolling ? _animation.value : 1.0;

                      // In authentic 3D simulation, the text disappears during tumble
                      // and fades/scales in when settling on the final face (progress >= 0.85)
                      final textOpacity = isRolling
                          ? ((progress - 0.85) / 0.15).clamp(0.0, 1.0)
                          : 1.0;
                      final textScale = isRolling
                          ? 0.7 + 0.3 * textOpacity
                          : 1.0;

                      final clip = widget.clip;
                      final frame = clip != null
                          ? (isRolling
                                ? clip.frameForProgress(progress)
                                : clip.frames - 1)
                          : null;

                      return clip != null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                DieSprite(
                                  clip: clip,
                                  frame: frame,
                                  size: 81,
                                  tint: tint,
                                ),
                                Opacity(
                                  opacity: textOpacity,
                                  child: Transform.scale(
                                    scale: textScale,
                                    child: Text(
                                      'ROLL',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.1,
                                        color: labelColor,
                                        shadows: isEnabled
                                            ? [
                                                Shadow(
                                                  color:
                                                      labelColor == Colors.white
                                                      ? Colors.black54
                                                      : Colors.white70,
                                                  blurRadius: 4,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.casino,
                                  size: 36,
                                  color: isEnabled
                                      ? theme.colorScheme.primary
                                      : theme.disabledColor,
                                ),
                                const SizedBox(height: 2),
                                Opacity(
                                  opacity: textOpacity,
                                  child: Transform.scale(
                                    scale: textScale,
                                    child: Text(
                                      'ROLL',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.1,
                                        color: isEnabled
                                            ? theme.colorScheme.primary
                                            : theme.disabledColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
