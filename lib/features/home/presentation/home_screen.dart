import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../character_sheet/presentation/character_sheet_screen.dart';
import '../../character_wizard/presentation/character_wizard_screen.dart';
import '../../character_wizard/providers/wizard_provider.dart';
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

  void _startCreation(String systemId, CreationMode mode) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Freeform Sheet Mode starting soon! Launching Guided Wizard...'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CharacterWizardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(filteredCharactersProvider);
    final allRecentAsync = ref.watch(recentCharactersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search characters by name or system...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white.withAlpha(120)),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (val) {
                  ref.read(characterSearchQueryProvider.notifier).setQuery(val);
                },
              )
            : Row(
                children: [
                  const Icon(Icons.auto_stories, color: AppTheme.primaryGold),
                  const SizedBox(width: 10),
                  Text(
                    'SCRIVENER',
                    style: TextStyle(
                      color: AppTheme.primaryGold,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
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
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => NewCharacterModal(onStartCreation: _startCreation),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('NEW HERO'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: charactersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryGold)),
        error: (err, stack) => Center(child: Text('Error loading characters: $err')),
        data: (characters) {
          final totalCount = allRecentAsync.value?.length ?? 0;

          if (totalCount == 0) {
            final db = ref.read(databaseProvider);
            return EmptyHomeState(
              onCreateNew: () {
                showDialog(
                  context: context,
                  builder: (ctx) => NewCharacterModal(onStartCreation: _startCreation),
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
                                    color: AppTheme.primaryGold,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.cardDark,
                                borderRadius: BorderRadius.circular(10),
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
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => NewCharacterModal(onStartCreation: _startCreation),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
