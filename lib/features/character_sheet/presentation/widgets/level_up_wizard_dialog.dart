import 'dart:math';
import 'package:flutter/material.dart';

import '../../providers/character_sheet_provider.dart';

class LevelUpWizardDialog extends StatefulWidget {
  final CharacterSheetState state;
  final CharacterSheetNotifier notifier;

  const LevelUpWizardDialog({
    super.key,
    required this.state,
    required this.notifier,
  });

  @override
  State<LevelUpWizardDialog> createState() => _LevelUpWizardDialogState();
}

class _LevelUpWizardDialogState extends State<LevelUpWizardDialog> {
  ThemeData get _theme => Theme.of(context);
  ColorScheme get _colors => _theme.colorScheme;

  int _currentStep = 0; // 0: HP Gain, 1: Improvements, 2: Review

  // Hit Die & HP Gain State
  late final int _hitDie;
  late final int _hitDieAvg;
  late final int _conMod;
  bool _useRoll = false;
  int? _rolledValue;

  // ASI State
  int _asiMode = 0; // 0: +2 single, 1: +1 two, 2: none
  String _singleAbility = 'str';
  String _twoAbilityA = 'str';
  String _twoAbilityB = 'con';

  @override
  void initState() {
    super.initState();
    _hitDie = _resolveClassHitDie(widget.state.className);
    _hitDieAvg = (_hitDie / 2).floor() + 1;
    _conMod = widget.state.getAbilityModifier('con');
  }

  int _resolveClassHitDie(String className) {
    final cls = className.toLowerCase();
    if (cls.contains('barbarian')) return 12;
    if (cls.contains('fighter') ||
        cls.contains('paladin') ||
        cls.contains('ranger')) {
      return 10;
    }
    if (cls.contains('sorcerer') || cls.contains('wizard')) return 6;
    return 8; // Bard, Cleric, Druid, Monk, Rogue, Warlock, Adventurer
  }

  int get _targetLevel => (widget.state.level + 1).clamp(1, 20);

  bool get _isAsiLevel {
    final lvl = _targetLevel;
    final isFighter = widget.state.className.toLowerCase().contains('fighter');
    if (isFighter && (lvl == 6 || lvl == 14)) return true;
    return lvl == 4 || lvl == 8 || lvl == 12 || lvl == 16 || lvl == 19;
  }

  int get _calculatedHpGain {
    final base = _useRoll ? (_rolledValue ?? _hitDieAvg) : _hitDieAvg;
    final total = base + _conMod;
    return total < 1 ? 1 : total;
  }

  int get _newProficiencyBonus => 2 + ((_targetLevel - 1) / 4).floor();

  void _rollHitDie() {
    final roll = 1 + Random().nextInt(_hitDie);
    setState(() {
      _rolledValue = roll;
      _useRoll = true;
    });
  }

  Map<String, int> _buildAbilityIncreases() {
    if (!_isAsiLevel || _asiMode == 2) return {};

    final increases = <String, int>{};
    if (_asiMode == 0) {
      increases[_singleAbility] = 2;
    } else if (_asiMode == 1) {
      increases[_twoAbilityA] = (increases[_twoAbilityA] ?? 0) + 1;
      increases[_twoAbilityB] = (increases[_twoAbilityB] ?? 0) + 1;
    }
    return increases;
  }

  void _confirmLevelUp() async {
    final hpGain = _calculatedHpGain;
    final increases = _buildAbilityIncreases();

    await widget.notifier.applyLevelUp(
      hpIncrease: hpGain,
      abilityScoreIncreases: increases.isNotEmpty ? increases : null,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🎉 Level Up Complete! Welcome to Level $_targetLevel ${widget.state.className}!',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _theme.cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _theme.dividerColor),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: min(580, MediaQuery.sizeOf(context).height * 0.9),
        ),
        child: Column(
          children: [
            // Header
            _buildDialogHeader(),
            Divider(height: 1, color: _theme.dividerColor),

            // Step Progress Indicator
            _buildStepIndicator(),
            Divider(height: 1, color: _theme.dividerColor),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStepContent(),
              ),
            ),

            Divider(height: 1, color: _theme.dividerColor),
            // Bottom Action Bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _colors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _colors.primary),
            ),
            child: Icon(Icons.auto_awesome, color: _colors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LEVEL UP WIZARD',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: _colors.primary,
                  ),
                ),
                Text(
                  'Advance ${widget.state.name} from Level ${widget.state.level} to $_targetLevel',
                  style: TextStyle(
                    fontSize: 12,
                    color: _colors.onSurface.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['1. Hit Points', '2. Improvements', '3. Confirm'];
    return Container(
      color: _colors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (idx) {
          final isCurrent = _currentStep == idx;
          final isPast = _currentStep > idx;
          return Row(
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent
                      ? _colors.primary
                      : isPast
                      ? Colors.green
                      : _theme.cardColor,
                  border: Border.all(
                    color: isCurrent || isPast
                        ? Colors.transparent
                        : Colors.grey.shade600,
                  ),
                ),
                child: isPast
                    ? const Icon(Icons.check, size: 12, color: Colors.black)
                    : Text(
                        '${idx + 1}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? _colors.onPrimary : Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(width: 6),
              Text(
                steps[idx].substring(3),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent
                      ? _colors.primary
                      : isPast
                      ? _colors.onSurface
                      : Colors.grey,
                ),
              ),
              if (idx < steps.length - 1) ...[
                const SizedBox(width: 8),
                Container(width: 14, height: 1, color: Colors.grey.shade700),
                const SizedBox(width: 8),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildHpStep();
      case 1:
        return _buildImprovementsStep();
      case 2:
      default:
        return _buildReviewStep();
    }
  }

  // STEP 1: HIT POINTS
  Widget _buildHpStep() {
    final hpGain = _calculatedHpGain;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Class Hit Die Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF4A4037)),
          ),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.redAccent, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.state.className} Hit Die: 1d$_hitDie',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Constitution Modifier: ${_conMod >= 0 ? '+$_conMod' : '$_conMod'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _theme.cardColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _colors.primary),
                ),
                child: Text(
                  '+$hpGain HP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'CHOOSE HP INCREASE METHOD',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: _colors.primary,
          ),
        ),
        const SizedBox(height: 10),

        // Option A: Fixed Average
        InkWell(
          onTap: () => setState(() => _useRoll = false),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: !_useRoll
                  ? _colors.primary.withAlpha(25)
                  : _colors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: !_useRoll ? _colors.primary : const Color(0xFF4A4037),
                width: !_useRoll ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  !_useRoll
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: !_useRoll ? _colors.primary : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Take Fixed Average (Recommended)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '$_hitDieAvg (half die + 1) + CON (${_conMod >= 0 ? '+$_conMod' : '$_conMod'}) = ${_hitDieAvg + _conMod} HP',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '+${_hitDieAvg + _conMod}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: !_useRoll ? _colors.primary : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Option B: Roll Hit Die
        InkWell(
          onTap: () {
            setState(() => _useRoll = true);
            if (_rolledValue == null) _rollHitDie();
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _useRoll ? _colors.primary.withAlpha(25) : _colors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _useRoll ? _colors.primary : const Color(0xFF4A4037),
                width: _useRoll ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      _useRoll
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: _useRoll ? _colors.primary : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Roll 1d Hit Die',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Risk & reward: roll 1d$_hitDie + CON modifier',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_useRoll && _rolledValue != null)
                      Text(
                        '+$hpGain',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _colors.primary,
                        ),
                      ),
                  ],
                ),
                if (_useRoll) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _rollHitDie,
                        icon: const Icon(Icons.casino_outlined, size: 16),
                        label: Text(
                          _rolledValue == null
                              ? 'ROLL 1d$_hitDie'
                              : 'RE-ROLL (Rolled $_rolledValue)',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _colors.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_rolledValue != null) ...[
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        'Die: $_rolledValue + CON (${_conMod >= 0 ? '+$_conMod' : '$_conMod'}) = $hpGain HP',
                        style: TextStyle(
                          fontSize: 12,
                          color: _colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // STEP 2: IMPROVEMENTS (ASI OR FEATURES)
  Widget _buildImprovementsStep() {
    final isAsi = _isAsiLevel;
    const abilities = ['str', 'dex', 'con', 'int', 'wis', 'cha'];
    const abilityLabels = {
      'str': 'Strength',
      'dex': 'Dexterity',
      'con': 'Constitution',
      'int': 'Intelligence',
      'wis': 'Wisdom',
      'cha': 'Charisma',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isAsi) ...[
          // ASI Header Badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade900.withAlpha(40),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber),
            ),
            child: const Row(
              children: [
                Icon(Icons.workspace_premium, color: Colors.amber, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ABILITY SCORE IMPROVEMENT (ASI)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        'At Level 4, 8, 12, 16, & 19, increase your abilities or select a feat.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Segmented ASI choices
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('+2 Single')),
              ButtonSegment(value: 1, label: Text('+1 Two Stats')),
              ButtonSegment(value: 2, label: Text('Feat / Skip')),
            ],
            selected: {_asiMode},
            onSelectionChanged: (val) => setState(() => _asiMode = val.first),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return _colors.primary;
                }
                return _colors.surface;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.black;
                }
                return Colors.white70;
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Mode 0: +2 single
          if (_asiMode == 0) ...[
            const Text(
              'Select Ability to receive +2:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _colors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF4A4037)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _singleAbility,
                  isExpanded: true,
                  dropdownColor: _theme.cardColor,
                  items: abilities.map((k) {
                    final cur = widget.state.getAbilityScore(k);
                    return DropdownMenuItem(
                      value: k,
                      child: Text(
                        '${abilityLabels[k]} ($cur ➔ ${cur + 2})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _singleAbility = val);
                  },
                ),
              ),
            ),
          ],

          // Mode 1: +1 to two
          if (_asiMode == 1) ...[
            const Text(
              'Select Two Abilities to receive +1 each:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: _colors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF4A4037)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _twoAbilityA,
                        isExpanded: true,
                        dropdownColor: _theme.cardColor,
                        items: abilities.map((k) {
                          final cur = widget.state.getAbilityScore(k);
                          return DropdownMenuItem(
                            value: k,
                            child: Text(
                              '${abilityLabels[k]} ($cur ➔ ${cur + 1})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _twoAbilityA = val);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: _colors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF4A4037)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _twoAbilityB,
                        isExpanded: true,
                        dropdownColor: _theme.cardColor,
                        items: abilities.map((k) {
                          final cur = widget.state.getAbilityScore(k);
                          return DropdownMenuItem(
                            value: k,
                            child: Text(
                              '${abilityLabels[k]} ($cur ➔ ${cur + 1})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _twoAbilityB = val);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (_asiMode == 2) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _colors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'No ability score increase applied. Use the Features tab to record any custom feat or boon taken.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],

        // Milestone Perks Banner
        Text(
          'LEVEL MILESTONE HIGHLIGHTS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: _colors.primary,
          ),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF4A4037)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined, color: _colors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Level $_targetLevel ${widget.state.className}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _resolveMilestoneDescription(
                  _targetLevel,
                  widget.state.className,
                ),
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              if (_newProficiencyBonus > widget.state.proficiencyBonus) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade900.withAlpha(50),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    '⭐ Proficiency Bonus increases from +${widget.state.proficiencyBonus} to +$_newProficiencyBonus!',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _resolveMilestoneDescription(int lvl, String className) {
    final cls = className.toLowerCase();
    if (lvl == 2) {
      if (cls.contains('fighter')) {
        return 'Action Surge (1/Short Rest): Take one additional action on your turn.';
      }
      if (cls.contains('paladin')) {
        return 'Divine Smite & Fighting Style: Channel spell slots for radiant damage.';
      }
      if (cls.contains('wizard')) {
        return 'Arcane Tradition: Choose your school of magic specialization.';
      }
      if (cls.contains('rogue')) {
        return 'Cunning Action: Dash, Disengage, or Hide as a Bonus Action.';
      }
      if (cls.contains('cleric')) {
        return 'Channel Divinity (1/Rest) & Subclass Feature.';
      }
      return 'Core class archetype mechanics and expanded resources unlocked.';
    }
    if (lvl == 3) {
      return 'Subclass archetype chosen! Gain archetype features and access to 2nd-level spell slots (if spellcaster).';
    }
    if (lvl == 5) {
      return 'Major tier transition! Martials gain Extra Attack. Full casters unlock 3rd-level spells (Fireball, Revivify, etc.).';
    }
    if (lvl == 9) {
      return 'Tier 2 master: 5th-level spells unlocked for full spellcasters, plus class defensive bonuses.';
    }
    if (lvl == 11) {
      return 'Tier 3 heroic tier! Fighters gain 3 attacks per action. 6th-level mystic spells available.';
    }
    return 'Expanded Hit Dice (now $_targetLevel), increased total HP, and advancement in your class path.';
  }

  // STEP 3: REVIEW & CONFIRM
  Widget _buildReviewStep() {
    final hpGain = _calculatedHpGain;
    final increases = _buildAbilityIncreases();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _colors.primary),
          ),
          child: Column(
            children: [
              Text(
                'ADVANCEMENT SUMMARY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: _colors.primary,
                ),
              ),
              const SizedBox(height: 14),

              _buildSummaryRow(
                'Character Level',
                'Level ${widget.state.level}',
                'Level $_targetLevel',
                Icons.trending_up,
              ),
              const Divider(color: Color(0xFF4A4037), height: 16),

              _buildSummaryRow(
                'Hit Points',
                'Max HP: (current)',
                '+$hpGain Max HP',
                Icons.favorite,
                highlightColor: Colors.redAccent,
              ),
              const Divider(color: Color(0xFF4A4037), height: 16),

              _buildSummaryRow(
                'Proficiency Bonus',
                '+${widget.state.proficiencyBonus}',
                '+$_newProficiencyBonus',
                Icons.military_tech,
              ),
              const Divider(color: Color(0xFF4A4037), height: 16),

              _buildSummaryRow(
                'Hit Dice Pool',
                '${widget.state.level}d$_hitDie',
                '$_targetLevel d$_hitDie',
                Icons.casino,
              ),

              if (increases.isNotEmpty) ...[
                const Divider(color: Color(0xFF4A4037), height: 16),
                _buildSummaryRow(
                  'Ability Increases',
                  'Base Scores',
                  increases.entries
                      .map((e) => '+${e.value} ${e.key.toUpperCase()}')
                      .join(', '),
                  Icons.fitness_center,
                  highlightColor: _colors.primary,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String from,
    String to,
    IconData icon, {
    Color? highlightColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: highlightColor ?? Colors.grey),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const Spacer(),
        Text(
          to,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: highlightColor ?? _colors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey,
                side: const BorderSide(color: Color(0xFF4A4037)),
              ),
              child: const Text('BACK'),
            )
          else
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
            ),

          if (_currentStep < 2)
            ElevatedButton(
              onPressed: () => setState(() => _currentStep++),
              style: ElevatedButton.styleFrom(
                backgroundColor: _colors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text('NEXT'),
            )
          else
            ElevatedButton.icon(
              onPressed: _confirmLevelUp,
              icon: const Icon(Icons.check, size: 18),
              label: const Text(
                'CONFIRM LEVEL UP',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _colors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
