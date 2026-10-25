import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/theme/models/scrivener_theme_tokens.dart';
import '../../../../core/theme/theme_selector_dialog.dart';
import '../../character_sheet/presentation/character_sheet_screen.dart';
import '../../character_wizard/presentation/character_wizard_screen.dart';
import '../../character_wizard/providers/wizard_provider.dart';
import '../../dice/presentation/dice_roller_drawer.dart';
import '../../dice/presentation/widgets/floating_dice_fab.dart';
import '../../dice/providers/dice_drawer_provider.dart';
import '../../export_import/presentation/export_character_dialog.dart';
import '../../export_import/presentation/import_character_dialog.dart';
import '../../pdf_export/presentation/pdf_preview_screen.dart';
import '../../plugins/presentation/plugins_dialog.dart';
import '../providers/home_providers.dart';
import 'widgets/character_card.dart';
import 'widgets/empty_home_state.dart';
import 'widgets/new_character_modal.dart';
import 'widgets/resume_hero_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final void Function(CharactersTableData character)? onOpenCharacter;

  const HomeScreen({
    super.key,
    this.onOpenCharacter,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCharacter(CharactersTableData character) async {
    final db = ref.read(databaseProvider);
    await db.touchCharacterLastPlayed(character.id);

    if (widget.onOpenCharacter != null) {
      widget.onOpenCharacter!(character);
    } else {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CharacterSheetScreen(characterId: character.id),
          ),
        );
      }
    }
  }

  void _duplicateCharacter(CharactersTableData character) async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: const Uuid().v4(),
        name: '${character.name} (Copy)',
        systemId: Value(character.systemId),
        portraitUri: character.portraitUri != null ? Value(character.portraitUri) : const Value.absent(),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: character.rawPropertiesJson,
        notes: Value(character.notes),
      ),
    );
  }

  void _deleteCharacter(CharactersTableData character) async {
    final db = ref.read(databaseProvider);
    await db.deleteCharacter(character.id);
  }

  void _exportCharacter(CharactersTableData character) {
    ExportCharacterDialog.show(
      context,
      characterId: character.id,
      characterName: character.name,
    );
  }

  void _printPdfCharacter(CharactersTableData character) async {
    final db = ref.read(databaseProvider);
    final inventory = await db.getInventoryForCharacter(character.id);
    final conditions = await db.getConditionsForCharacter(character.id);
    if (mounted) {
      PdfPreviewScreen.show(
        context,
        character: character,
        inventory: inventory,
        conditions: conditions,
      );
    }
  }

  void _importCharacter() {
    ImportCharacterDialog.show(
      context,
      onCharacterImported: (newCharId) async {
        final db = ref.read(databaseProvider);
        final char = await db.getCharacter(newCharId);
        if (char != null && mounted) {
          _openCharacter(char);
        }
      },
    );
  }

  void _startCreation(String systemId, CreationMode mode) async {
    ref.read(characterWizardProvider.notifier).reset();

    if (mode == CreationMode.guidedWizard) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CharacterWizardScreen(
            onCharacterCreated: (characterId) async {
              final db = ref.read(databaseProvider);
              final char = await db.getCharacter(characterId);
              if (char != null && mounted) {
                _openCharacter(char);
              }
            },
          ),
        ),
      );
    } else {
      // Freeform / Smart Paper Sheet Mode
      final db = ref.read(databaseProvider);
      final charId = const Uuid().v4();
      final now = DateTime.now();

      final rawProps = {
        'level': 1,
        'class': 'Adventurer',
        'classId': 'custom',
        'race': 'Human',
        'raceId': 'human',
        'background': 'Custom',
        'hp': {
          'current': 10,
          'max': 10,
          'temp': 0,
        },
        'armorClass': 10,
        'speed': 30,
        'proficiencyBonus': 2,
        'abilities': {
          'str': {'score': 10, 'mod': 0},
          'dex': {'score': 10, 'mod': 0},
          'con': {'score': 10, 'mod': 0},
          'int': {'score': 10, 'mod': 0},
          'wis': {'score': 10, 'mod': 0},
          'cha': {'score': 10, 'mod': 0},
        },
        'savingThrows': <String>[],
        'skills': <String>[],
        'skillProficiencies': <String, int>{},
        'spells': <Map<String, dynamic>>[],
        'featuresList': <Map<String, dynamic>>[],
        'hitDice': {
          'total': 1,
          'spent': 0,
          'die': '1d8',
        },
        'spellSlots': <String, dynamic>{},
        'equipment': <String>[],
        'currency': {
          'cp': 0,
          'sp': 0,
          'ep': 0,
          'gp': 15,
          'pp': 0,
        },
        'bio': {
          'personalityTraits': '',
          'ideals': '',
          'bonds': '',
          'flaws': '',
          'backstory': '',
        },
      };

      await db.upsertCharacter(
        CharactersTableCompanion.insert(
          id: charId,
          name: 'New Adventurer',
          systemId: Value(systemId),
          createdAt: now,
          lastPlayedAt: now,
          rawPropertiesJson: jsonEncode(rawProps),
          notes: const Value('Created via Freeform Smart Paper Mode'),
        ),
      );

      final char = await db.getCharacter(charId);
      if (char != null && mounted) {
        _openCharacter(char);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Freeform character created! Tap any field to customize.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;
    final charactersAsync = ref.watch(filteredCharactersProvider);
    final allRecentAsync = ref.watch(recentCharactersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search characters by name or system...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120)),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
                onChanged: (val) {
                  ref.read(characterSearchQueryProvider.notifier).setQuery(val);
                },
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_stories, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'SCRIVENER',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: _isSearching ? 'Close Search' : 'Search Heroes',
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  ref.read(characterSearchQueryProvider.notifier).setQuery('');
                  _isSearching = false;
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: Icon(tokens.iconography.diceAction),
            tooltip: 'Dice Roller (Quick Roll)',
            onPressed: () {
              ref.read(diceDrawerProvider.notifier).setQuickRoll();
              FloatingDiceFab.openDiceRoller(context);
            },
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'App Theme',
            onPressed: () => ThemeSelectorDialog.show(context),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: const Icon(Icons.extension_outlined),
            tooltip: 'Plugins & Compendiums',
            onPressed: () => PluginsDialog.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      endDrawer: const DiceRollerDrawer(),
      body: charactersAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
        error: (err, stack) => Center(child: Text('Error loading characters: $err')),
        data: (characters) {
          final totalCount = allRecentAsync.value?.length ?? 0;

          if (totalCount == 0) {
            final db = ref.read(databaseProvider);
            return EmptyHomeState(
              onCreateNew: () {
                showDialog(
                  context: context,
                  builder: (ctx) => NewCharacterModal(
                    onStartCreation: _startCreation,
                    onImportCharacter: _importCharacter,
                  ),
                );
              },
              onLoadSamples: () => seedSampleCharacters(db),
            );
          }

          if (characters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'No heroes found matching "${ref.read(characterSearchQueryProvider)}"',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final mostRecent = characters.first;
          final remainingCharacters = characters.skip(1).toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1000
                  ? 3
                  : constraints.maxWidth > 600
                      ? 2
                      : 1;

              final childAspectRatio = crossAxisCount == 1 ? 2.5 : 1.9;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: ResumeHeroCard(
                        character: mostRecent,
                        onResume: () => _openCharacter(mostRecent),
                      ),
                    ),
                  ),
                  if (remainingCharacters.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          children: [
                            Text(
                              'RECENT HEROES',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: theme.colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.dividerColor.withAlpha(60)),
                              ),
                              child: Text(
                                '${characters.length}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: childAspectRatio,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final char = remainingCharacters[index];
                            return CharacterCard(
                              character: char,
                              onTap: () => _openCharacter(char),
                              onDuplicate: () => _duplicateCharacter(char),
                              onDelete: () => _deleteCharacter(char),
                              onExport: () => _exportCharacter(char),
                              onPrintPdf: () => _printPdfCharacter(char),
                            );
                          },
                          childCount: remainingCharacters.length,
                        ),
                      ),
                    ),
                  ],
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => NewCharacterModal(
              onStartCreation: _startCreation,
              onImportCharacter: _importCharacter,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
