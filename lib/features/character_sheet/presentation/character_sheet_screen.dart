import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/models/scrivener_theme_tokens.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/theme_selector_dialog.dart';
import '../../combat/presentation/combat_dashboard_screen.dart';
import '../../combat/presentation/widgets/rest_dialog.dart';
import '../../combat/providers/combat_session_provider.dart';
import '../../dice/presentation/dice_roller_drawer.dart';
import '../../dice/presentation/widgets/floating_dice_fab.dart';
import '../../dice/providers/dice_drawer_provider.dart';
import '../../export_import/presentation/export_character_dialog.dart';
import '../../pdf_export/presentation/pdf_preview_screen.dart';
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

class _CharacterSheetScreenState extends ConsumerState<CharacterSheetScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isEditingName = false;
  late final TextEditingController _nameController;
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 7,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
    final effectiveThemeMode = ref.watch(characterThemeModeProvider(widget.characterId));
    final themeData = AppTheme.getThemeData(effectiveThemeMode);
    final tokens = themeData.extension<ScrivenerThemeTokens>() ?? ScrivenerThemeTokens.defaultTokens;
    final icons = tokens.iconography;

    final sheetState = ref.watch(characterSheetProvider(widget.characterId));
    final sheetNotifier = ref.read(characterSheetProvider(widget.characterId).notifier);
    final combatState = ref.watch(combatSessionProvider(widget.characterId));
    final combatNotifier = ref.read(combatSessionProvider(widget.characterId).notifier);

    if (sheetState == null) {
      return Theme(
        data: themeData,
        child: Scaffold(
          appBar: AppBar(title: const Text('Character Sheet')),
          body: Center(
            child: CircularProgressIndicator(color: themeData.colorScheme.primary),
          ),
        ),
      );
    }

    final pages = [
      (title: 'Stats', icon: icons.tabStats),
      (title: 'Skills', icon: icons.tabSkills),
      (title: 'Combat', icon: icons.tabCombat),
      (title: 'Spells', icon: icons.tabSpells),
      (title: 'Features', icon: icons.tabFeatures),
      (title: 'Gear', icon: icons.tabGear),
      (title: 'Bio & Notes', icon: icons.tabBio),
    ];

    PreferredSizeWidget bottomNav;
    if (tokens.navigationStyle == CharacterNavigationStyle.headerDropdown) {
      bottomNav = PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: themeData.colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: themeData.dividerColor.withAlpha(80)),
            ),
          ),
          child: Row(
            children: [
              Icon(
                pages[_tabController.index].icon,
                size: 20,
                color: themeData.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _tabController.index,
                  dropdownColor: themeData.colorScheme.surface,
                  icon: Icon(Icons.arrow_drop_down, color: themeData.colorScheme.primary),
                  style: TextStyle(
                    color: themeData.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  onChanged: (newIdx) {
                    if (newIdx != null) {
                      _tabController.animateTo(newIdx);
                    }
                  },
                  items: List.generate(pages.length, (idx) {
                    final p = pages[idx];
                    Widget label;
                    switch (tokens.tabContentStyle) {
                      case CharacterTabContentStyle.iconsAndText:
                      case CharacterTabContentStyle.iconsOnly:
                        label = Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              p.icon,
                              size: 18,
                              color: idx == _tabController.index
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onSurface.withAlpha(160),
                            ),
                            const SizedBox(width: 8),
                            Text(p.title),
                          ],
                        );
                        break;
                      case CharacterTabContentStyle.textOnly:
                        label = Text(p.title);
                        break;
                    }
                    return DropdownMenuItem<int>(
                      value: idx,
                      child: label,
                    );
                  }),
                ),
              ),
              const Spacer(),
              Text(
                'Page ${_tabController.index + 1} of ${pages.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: themeData.colorScheme.onSurface.withAlpha(140),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      bottomNav = TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: themeData.colorScheme.primary,
        labelColor: themeData.colorScheme.primary,
        unselectedLabelColor: themeData.colorScheme.onSurface.withAlpha(140),
        tabs: pages.map((page) {
          switch (tokens.tabContentStyle) {
            case CharacterTabContentStyle.iconsAndText:
              return Tab(icon: Icon(page.icon, size: 18), text: page.title);
            case CharacterTabContentStyle.iconsOnly:
              return Tab(icon: Icon(page.icon, size: 20));
            case CharacterTabContentStyle.textOnly:
              return Tab(text: page.title);
          }
        }).toList(),
      );
    }

    return Theme(
      data: themeData,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: themeData.colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit character name',
                      color: themeData.colorScheme.primary.withAlpha(220),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: themeData.colorScheme.primary,
                          ),
                          cursorColor: themeData.colorScheme.primary,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            filled: true,
                            fillColor: themeData.colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: themeData.colorScheme.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: themeData.colorScheme.primary, width: 1.5),
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
                  color: themeData.colorScheme.onSurface.withAlpha(160),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actions: [
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: Icon(icons.themeSelector),
              tooltip: 'Character Theme (${effectiveThemeMode.displayName})',
              color: themeData.colorScheme.primary,
              onPressed: () {
                ThemeSelectorDialog.show(
                  context,
                  title: 'THEME: ${sheetState.name.toUpperCase()}',
                  currentSelectedMode: sheetState.customTheme,
                  isCharacterLevel: true,
                  onThemeSelected: (mode) {
                    sheetNotifier.setTheme(mode);
                  },
                );
              },
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: const Icon(Icons.print_outlined),
              tooltip: 'Print / Export PDF Sheet',
              color: themeData.colorScheme.primary,
              onPressed: () async {
                final db = ref.read(databaseProvider);
                final char = await db.getCharacter(widget.characterId);
                final inventory = await db.getInventoryForCharacter(widget.characterId);
                final conditions = await db.getConditionsForCharacter(widget.characterId);
                if (char != null && context.mounted) {
                  PdfPreviewScreen.show(
                    context,
                    character: char,
                    inventory: inventory,
                    conditions: conditions,
                  );
                }
              },
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: const Icon(Icons.file_download_outlined),
              tooltip: 'Export Character (JSON)',
              color: themeData.colorScheme.primary,
              onPressed: () {
                ExportCharacterDialog.show(
                  context,
                  characterId: widget.characterId,
                  characterName: sheetState.name,
                );
              },
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: Icon(icons.diceAction),
              tooltip: 'Dice Roller (Quick Roll)',
              color: themeData.colorScheme.primary,
              onPressed: () {
                ref.read(diceDrawerProvider.notifier).setQuickRoll();
                FloatingDiceFab.openDiceRoller(context);
              },
            ),
            if (combatState != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () => _showRestDialog(combatState, combatNotifier),
                  icon: Icon(icons.restAction, size: 16),
                  label: const Text('REST'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeData.colorScheme.surface,
                    foregroundColor: themeData.colorScheme.primary,
                    side: BorderSide(color: themeData.colorScheme.primary, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
          ],
          bottom: bottomNav,
        ),
        body: TabBarView(
          controller: _tabController,
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
