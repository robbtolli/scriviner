import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../combat/presentation/combat_dashboard_screen.dart';
import '../../combat/presentation/widgets/rest_dialog.dart';
import '../../combat/providers/combat_session_provider.dart';
import '../../dice/presentation/dice_roller_drawer.dart';
import '../../dice/presentation/widgets/floating_dice_fab.dart';
import '../../export_import/presentation/export_character_dialog.dart';
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
  bool _isEditingName = false;
  late final TextEditingController _nameController;
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _startEditingName(String currentName) {
    setState(() {
      _nameController.text = currentName;
      _isEditingName = true;
    });
    _nameFocusNode.requestFocus();
  }

  void _saveName(String newName, CharacterSheetNotifier notifier) {
    final trimmed = newName.trim();
    if (trimmed.isNotEmpty) {
      notifier.updateName(trimmed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Character name updated to "$trimmed"!'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    setState(() {
      _isEditingName = false;
    });
  }

  void _cancelEditingName() {
    setState(() {
      _isEditingName = false;
    });
  }

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
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isEditingName)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        sheetState.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppTheme.primaryGold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit character name',
                      color: AppTheme.primaryGold.withAlpha(220),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      onPressed: () => _startEditingName(sheetState.name),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.primaryGold,
                          ),
                          cursorColor: AppTheme.primaryGold,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            filled: true,
                            fillColor: AppTheme.surfaceDark,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: AppTheme.primaryGold),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: AppTheme.primaryGold, width: 1.5),
                            ),
                          ),
                          onSubmitted: (val) => _saveName(val, sheetNotifier),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.check, size: 20),
                      tooltip: 'Confirm new name',
                      color: Colors.greenAccent,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      onPressed: () => _saveName(_nameController.text, sheetNotifier),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      tooltip: 'Cancel edit',
                      color: Colors.redAccent,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      onPressed: _cancelEditingName,
                    ),
                  ],
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
              icon: const Icon(Icons.file_download_outlined),
              tooltip: 'Export Character (JSON)',
              color: AppTheme.primaryGold,
              onPressed: () {
                ExportCharacterDialog.show(
                  context,
                  characterId: widget.characterId,
                  characterName: sheetState.name,
                );
              },
            ),
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
