import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../core/dice/dice_roller.dart';
import '../../providers/combat_session_provider.dart';

class RestDialog extends StatefulWidget {
  final CombatSessionState state;
  final CombatSessionNotifier notifier;
  final DiceRoller? diceRoller;

  const RestDialog({
    super.key,
    required this.state,
    required this.notifier,
    this.diceRoller,
  });

  @override
  State<RestDialog> createState() => _RestDialogState();
}

class _RestDialogState extends State<RestDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DiceRoller _diceRoller;

  int _spentDiceThisRest = 0;
  int _healedThisRest = 0;
  final List<String> _rollLogs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _diceRoller = widget.diceRoller ?? DiceRoller();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _remainingHitDice =>
      max(0, widget.state.availableHitDice - _spentDiceThisRest);

  int get _projectedHp =>
      min(widget.state.maxHp, widget.state.currentHp + _healedThisRest);

  void _rollHitDie() {
    if (_remainingHitDice <= 0) return;

    // Roll character's hit die, e.g. "1d10"
    final dieFormula = widget.state.hitDiceDie.isNotEmpty
        ? widget.state.hitDiceDie
        : '1d10';

    final result = _diceRoller.rollFormula(dieFormula);
    final rolledAmount = max(1, result.total);

    setState(() {
      _spentDiceThisRest += 1;
      _healedThisRest += rolledAmount;
      _rollLogs.add('Rolled $dieFormula: ${result.total} HP');
    });
  }

  void _finishShortRest() {
    widget.notifier.shortRest(
      hitDiceSpent: _spentDiceThisRest,
      hitPointsRecovered: _healedThisRest,
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Short Rest finished! Recovered $_healedThisRest HP ($_spentDiceThisRest hit dice spent).',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _finishLongRest() {
    widget.notifier.longRest();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Long Rest complete! Hit points, spell slots, and hit dice restored.',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.colorScheme.onSurface.withAlpha(
                  120,
                ),
                indicatorColor: theme.colorScheme.primary,
                tabs: const [
                  Tab(text: 'Short Rest (1 hr)'),
                  Tab(text: 'Long Rest (8 hrs)'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildShortRestTab(theme),
                    _buildLongRestTab(theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortRestTab(ThemeData theme) {
    final canRoll = _remainingHitDice > 0 && _projectedHp < widget.state.maxHp;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Available Hit Dice: $_remainingHitDice / ${widget.state.hitDiceTotal}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.state.hitDiceDie,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: widget.state.hitDiceTotal > 0
                ? _remainingHitDice / widget.state.hitDiceTotal
                : 0.0,
            backgroundColor: theme.colorScheme.onSurface.withAlpha(20),
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          // Projected HP Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                const Expanded(child: Text('Projected Health:')),
                Text(
                  '$_projectedHp / ${widget.state.maxHp} HP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _healedThisRest > 0
                        ? Colors.greenAccent
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Roll Logs
          if (_rollLogs.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _rollLogs
                    .map(
                      (log) =>
                          Text('• $log', style: const TextStyle(fontSize: 12)),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
          ],
          ElevatedButton.icon(
            onPressed: canRoll ? _rollHitDie : null,
            icon: const Icon(Icons.casino_outlined, size: 18),
            label: Text('ROLL HIT DIE (${widget.state.hitDiceDie})'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withAlpha(10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.autorenew,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recharges: Second Wind & Pact Spell Slots',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withAlpha(170),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _finishShortRest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('FINISH REST'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLongRestTab(ThemeData theme) {
    final halfDice = max(1, (widget.state.hitDiceTotal / 2).floor());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.nightlight_round,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Text(
          'Take an 8-Hour Long Rest',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBenefitRow(
                Icons.favorite,
                'Full HP Restoration (${widget.state.maxHp} HP)',
              ),
              _buildBenefitRow(Icons.shield_outlined, 'Temporary HP cleared'),
              _buildBenefitRow(
                Icons.casino_outlined,
                'Recover up to $halfDice Hit Dice',
              ),
              _buildBenefitRow(Icons.auto_awesome, 'All Spell Slots restored'),
              _buildBenefitRow(
                Icons.refresh,
                'Daily features recharged & Death Saves reset',
              ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: _finishLongRest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('CONFIRM REST'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.greenAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
