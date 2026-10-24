import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../combat/presentation/combat_dashboard_screen.dart';
import '../../combat/presentation/widgets/rest_dialog.dart';
import '../../combat/providers/combat_session_provider.dart';
import '../../dice/presentation/dice_roller_drawer.dart';
import '../../dice/presentation/widgets/floating_dice_fab.dart';
import '../providers/character_sheet_provider.dart';
import 'tabs/bio_notes_tab.dart';
import 'tabs/features_tab.dart';
import 'tabs/inventory_tab.dart';
import 'tabs/skills_tab.dart';
import 'tabs/spells_tab.dart';
import 'tabs/stats_tab.dart';

class CharacterSheetScreen extends ConsumerStatefulWidget {
  final String characterId;
  final int initialTabIndex;

  const CharacterSheetScreen({
    super.key,
    required this.characterId,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends ConsumerState<CharacterSheetScreen> {
  void _showRestDialog(CombatSessionState combatState, CombatSessionNotifier combatNotifier) {
    showDialog(
      context: context,
      builder: (ctx) => RestDialog(
        state: combatState,
        notifier: combatNotifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sheetState = ref.watch(characterSheetProvider(widget.characterId));
    final sheetNotifier = ref.read(characterSheetProvider(widget.characterId).notifier);
    final combatState = ref.watch(combatSessionProvider(widget.characterId));
    final combatNotifier = ref.read(combatSessionProvider(widget.characterId).notifier);

    if (sheetState == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Character Sheet')),
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryGold),
        ),
      );
    }

    return DefaultTabController(
      length: 7,
      initialIndex: widget.initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sheetState.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.primaryGold,
                ),
              ),
              Text(
                'Level ${sheetState.level} ${sheetState.className} (${sheetState.raceName})',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withAlpha(160),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.casino_outlined),
              tooltip: 'Dice Roller',
              color: AppTheme.primaryGold,
              onPressed: () => FloatingDiceFab.openDiceRoller(context),
            ),
            if (combatState != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () => _showRestDialog(combatState, combatNotifier),
                  icon: const Icon(Icons.hotel_outlined, size: 16),
                  label: const Text('REST'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surfaceDark,
                    foregroundColor: AppTheme.primaryGold,
                    side: const BorderSide(color: AppTheme.primaryGold, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppTheme.primaryGold,
            labelColor: AppTheme.primaryGold,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.analytics_outlined, size: 18), text: 'Stats'),
              Tab(icon: Icon(Icons.psychology_outlined, size: 18), text: 'Skills'),
              Tab(icon: Icon(Icons.sports_martial_arts, size: 18), text: 'Combat'),
              Tab(icon: Icon(Icons.auto_awesome, size: 18), text: 'Spells'),
              Tab(icon: Icon(Icons.shield_outlined, size: 18), text: 'Features'),
              Tab(icon: Icon(Icons.inventory_2_outlined, size: 18), text: 'Gear'),
              Tab(icon: Icon(Icons.history_edu, size: 18), text: 'Bio & Notes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StatsTab(state: sheetState, notifier: sheetNotifier),
            SkillsTab(state: sheetState, notifier: sheetNotifier),
            CombatDashboardView(characterId: widget.characterId),
            SpellsTab(state: sheetState, notifier: sheetNotifier),
            FeaturesTab(state: sheetState, notifier: sheetNotifier),
            InventoryTab(state: sheetState, notifier: sheetNotifier),
            BioNotesTab(state: sheetState, notifier: sheetNotifier),
          ],
        ),
        endDrawer: const DiceRollerDrawer(),
        floatingActionButton: const FloatingDiceFab(),
      ),
    );
  }
}
