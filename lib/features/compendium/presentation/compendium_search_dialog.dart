import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/srd_compendium_seed.dart';
import '../models/compendium_entry.dart';

class CompendiumSearchDialog extends ConsumerStatefulWidget {
  final String? initialCategory;
  final void Function(CompendiumEntry entry)? onAddEntry;

  const CompendiumSearchDialog({
    super.key,
    this.initialCategory,
    this.onAddEntry,
  });

  @override
  ConsumerState<CompendiumSearchDialog> createState() =>
      _CompendiumSearchDialogState();
}

class _CompendiumSearchDialogState
    extends ConsumerState<CompendiumSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedCategory;
  List<CompendiumEntry> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'all';
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);

    // Ensure SRD is seeded
    await seedSrdCompendium(db);

    final catFilter = _selectedCategory == 'all' ? null : _selectedCategory;
    final rawResults = await db.searchCompendium(
      'dnd5e',
      category: catFilter,
      query: _searchController.text.trim(),
    );

    setState(() {
      _results = rawResults.map((r) {
        Map<String, dynamic> data = {};
        try {
          data = jsonDecode(r.fullDataJson) as Map<String, dynamic>;
        } catch (_) {}
        return CompendiumEntry(
          id: r.id,
          systemId: r.systemId,
          category: r.category,
          name: r.name,
          summary: r.summary,
          data: data,
        );
      }).toList();
      _isLoading = false;
    });
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
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book, color: theme.colorScheme.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'SRD 5.1 COMPENDIUM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 1.1,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Search Bar
              TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) => _performSearch(),
                decoration: InputDecoration(
                  hintText: 'Search spells, equipment, features...',
                  prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Category Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('all', 'All Categories'),
                    _buildCategoryChip('spell', 'Spells'),
                    _buildCategoryChip('equipment', 'Equipment'),
                    _buildCategoryChip('feature', 'Features'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: theme.dividerColor),

              // Results List
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: theme.colorScheme.primary),
                      )
                    : _results.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off, size: 40, color: theme.colorScheme.onSurface.withAlpha(80)),
                                const SizedBox(height: 8),
                                Text(
                                  'No entries found matching your search.',
                                  style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120)),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: _results.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final entry = _results[index];
                              return _buildResultCard(entry);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String catId, String label) {
    final theme = Theme.of(context);
    final isSelected = _selectedCategory == catId;

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedCategory = catId);
          _performSearch();
        },
        selectedColor: theme.colorScheme.primary.withAlpha(40),
        backgroundColor: theme.cardColor,
        checkmarkColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(180),
        ),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildResultCard(CompendiumEntry entry) {
    final theme = Theme.of(context);
    final isSpell = entry.category == 'spell';
    final isEquip = entry.category == 'equipment';

    String metaSubtitle = '';
    if (isSpell) {
      final lvlStr = entry.spellLevel == 0 ? 'Cantrip' : 'Level ${entry.spellLevel}';
      metaSubtitle = '$lvlStr • ${entry.school} • ${entry.castingTime} • ${entry.range}';
    } else if (isEquip) {
      if (entry.isArmor) {
        metaSubtitle = 'Armor (AC ${entry.armorClass}) • ${entry.weight} lbs • ${entry.cost}';
      } else if (entry.damage.isNotEmpty) {
        metaSubtitle = 'Weapon (${entry.damage}) • ${entry.weight} lbs • ${entry.cost}';
      } else {
        metaSubtitle = 'Item • ${entry.weight} lbs • ${entry.cost}';
      }
    } else {
      metaSubtitle = entry.data['source'] as String? ?? 'General Feature';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  entry.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (widget.onAddEntry != null)
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onAddEntry!(entry);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${entry.name} to character!'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text('ADD', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            metaSubtitle,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            entry.description,
            style: TextStyle(
              fontSize: 12,
              height: 1.3,
              color: theme.colorScheme.onSurface.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}
