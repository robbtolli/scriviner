import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

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
                          ? theme.colorScheme.primary.withAlpha(30)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
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
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withAlpha(180),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'd$sides',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
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
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
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
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Flat Modifier:',
                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withAlpha(180)),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onAdjustModifier(-1),
                    color: theme.colorScheme.primary,
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 36),
                    alignment: Alignment.center,
                    child: Text(
                      flatModifier >= 0 ? '+$flatModifier' : '$flatModifier',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onAdjustModifier(1),
                    color: theme.colorScheme.primary,
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
