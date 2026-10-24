import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../compendium/presentation/compendium_search_dialog.dart';
import '../../models/character_sheet_data.dart';
import '../../providers/character_sheet_provider.dart';

class FeaturesTab extends StatelessWidget {
  final CharacterSheetState state;
  final CharacterSheetNotifier notifier;

  const FeaturesTab({
    super.key,
    required this.state,
    required this.notifier,
  });

  void _openAddFeatureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CompendiumSearchDialog(
        initialCategory: 'feature',
        onAddEntry: (entry) {
          final feat = CharacterFeatureItem(
            id: 'feat_${entry.name.toLowerCase().replaceAll(' ', '_')}',
            name: entry.name,
            source: entry.data['source'] as String? ?? 'Class',
            recharge: entry.data['recharge'] as String? ?? 'Short or Long Rest',
            usesMax: (entry.data['usesMax'] as num?)?.toInt() ?? 0,
            usesSpent: 0,
            description: entry.description,
          );
          notifier.addFeature(feat);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If features list in state is empty, provide sensible defaults from race/class
    final featuresList = state.features.isNotEmpty
        ? state.features
        : [
            CharacterFeatureItem(
              id: 'feat_second_wind',
              name: 'Second Wind',
              source: state.className,
              recharge: 'Short Rest',
              usesMax: 1,
              description: 'You have a limited well of stamina that you can draw on to protect yourself from harm. Regain 1d10 + Level HP as a bonus action.',
            ),
            CharacterFeatureItem(
              id: 'feat_racial_traits',
              name: '${state.raceName} Lineage Traits',
              source: 'Racial Trait',
              description: 'Special biological and cultural traits granted by your heritage, including natural senses and resistances.',
            ),
          ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CLASS FEATURES & RACIAL TRAITS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppTheme.primaryGold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _openAddFeatureDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('ADD FEATURE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...featuresList.map((feat) => _buildFeatureCard(context, feat)),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, CharacterFeatureItem feat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF4A4037)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(
          feat.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
        subtitle: Text(
          '${feat.source} • ${feat.recharge}',
          style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(150)),
        ),
        trailing: feat.usesMax > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.primaryGold.withAlpha(80)),
                ),
                child: Text(
                  '${feat.availableUses} / ${feat.usesMax} uses',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGold,
                  ),
                ),
              )
            : const Icon(Icons.expand_more, color: Colors.grey),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(
              feat.description,
              style: TextStyle(fontSize: 13, height: 1.4, color: Colors.white.withAlpha(200)),
            ),
          ),
        ],
      ),
    );
  }
}
