import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class PolyhedralDiceTray extends StatelessWidget {
  final Map<int, int> diceCounts;
  final int flatModifier;
  final void Function(int sides) onAddDie;
  final void Function(int sides) onRemoveDie;
  final void Function(int delta) onAdjustModifier;

  const PolyhedralDiceTray({
    super.key,
    required this.diceCounts,
    required this.flatModifier,
    required this.onAddDie,
    required this.onRemoveDie,
    required this.onAdjustModifier,
  });

  static const List<int> standardSides = [4, 6, 8, 10, 12, 20, 100];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Polyhedral Dice Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: standardSides.map((sides) {
              final count = diceCounts[sides] ?? 0;
              final isSelected = count > 0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => onAddDie(sides),
                  onLongPress: () => onRemoveDie(sides),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 52,
                    height: 58,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryGold.withAlpha(30)
                          : AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryGold
                            : const Color(0xFF4A4037),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              sides == 20
                                  ? Icons.casino
                                  : Icons.change_history,
                              size: 16,
                              color: isSelected
                                  ? AppTheme.primaryGold
                                  : Colors.white70,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'd$sides',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppTheme.primaryGold
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (count > 0)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryGold,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),

        // Flat modifier stepper
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF4A4037)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Flat Modifier:',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onAdjustModifier(-1),
                    color: AppTheme.primaryGold,
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 36),
                    alignment: Alignment.center,
                    child: Text(
                      flatModifier >= 0 ? '+$flatModifier' : '$flatModifier',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onAdjustModifier(1),
                    color: AppTheme.primaryGold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
