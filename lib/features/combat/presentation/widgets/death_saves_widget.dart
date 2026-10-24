import 'package:flutter/material.dart';

import '../../../../core/dice/dice_roller.dart';
import '../../providers/combat_session_provider.dart';

class DeathSavesWidget extends StatelessWidget {
  final CombatSessionState state;
  final CombatSessionNotifier notifier;
  final DiceRoller _diceRoller;

  DeathSavesWidget({
    super.key,
    required this.state,
    required this.notifier,
    DiceRoller? diceRoller,
  }) : _diceRoller = diceRoller ?? DiceRoller();

  void _rollDeathSave(BuildContext context) {
    final roll = _diceRoller.rollFormula('1d20');
    final val = roll.total;

    if (val == 20) {
      notifier.recordDeathSave(isSuccess: true, isCritSuccess: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Natural 20! You regain 1 Hit Point and consciousness!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (val == 1) {
      notifier.recordDeathSave(isSuccess: false, isCritFailure: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Natural 1! Suffered 2 Death Save failures!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else if (val >= 10) {
      notifier.recordDeathSave(isSuccess: true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rolled $val: Success!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      notifier.recordDeathSave(isSuccess: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rolled $val: Failure!'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E1C1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.redAccent, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withAlpha(40),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 22),
              const SizedBox(width: 8),
              Text(
                'DEATH SAVING THROWS',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  fontSize: 13,
                  color: Colors.redAccent,
                ),
              ),
              const Spacer(),
              if (state.deathSaveSuccesses > 0 || state.deathSaveFailures > 0)
                TextButton(
                  onPressed: () => notifier.resetDeathSaves(),
                  child: const Text('Reset', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Successes Row
          Row(
            children: [
              const SizedBox(
                width: 80,
                child: Text('Successes', style: TextStyle(fontSize: 13, color: Colors.greenAccent)),
              ),
              ...List.generate(3, (i) {
                final isFilled = i < state.deathSaveSuccesses;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    isFilled ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isFilled ? Colors.greenAccent : Colors.grey,
                    size: 24,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
          // Failures Row
          Row(
            children: [
              const SizedBox(
                width: 80,
                child: Text('Failures', style: TextStyle(fontSize: 13, color: Colors.redAccent)),
              ),
              ...List.generate(3, (i) {
                final isFilled = i < state.deathSaveFailures;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    isFilled ? Icons.cancel : Icons.radio_button_unchecked,
                    color: isFilled ? Colors.redAccent : Colors.grey,
                    size: 24,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 14),
          if (state.isDead) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withAlpha(40),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Text(
                '☠️ HERO HAS FALLEN (Dead)',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
            ),
          ] else if (state.isStabilized) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withAlpha(40),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Text(
                '🛡️ HERO STABILIZED (Unconscious at 0 HP)',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
              ),
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: () => _rollDeathSave(context),
              icon: const Icon(Icons.casino, size: 18),
              label: const Text('ROLL DEATH SAVE (1d20)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
