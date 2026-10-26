import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/models/scrivener_theme_tokens.dart';
import '../../../compendium/presentation/compendium_search_dialog.dart';
import '../../models/character_sheet_data.dart';
import '../../providers/character_sheet_provider.dart';

class InventoryTab extends StatelessWidget {
  final CharacterSheetState state;
  final CharacterSheetNotifier notifier;

  const InventoryTab({super.key, required this.state, required this.notifier});

  void _openAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CompendiumSearchDialog(
        initialCategory: 'equipment',
        onAddEntry: (entry) {
          final item = InventoryTableCompanion.insert(
            id: const Uuid().v4(),
            characterId: state.characterId,
            name: entry.name,
            weight: drift.Value(entry.weight),
            quantity: const drift.Value(1),
            isEquipped: const drift.Value(false),
            itemDataJson: drift.Value(jsonEncode(entry.data)),
          );
          notifier.addInventoryItem(item);
        },
      ),
    );
  }

  void _showCurrencyEditDialog(BuildContext context) {
    final gpCtrl = TextEditingController(text: '${state.currency.gp}');
    final spCtrl = TextEditingController(text: '${state.currency.sp}');
    final cpCtrl = TextEditingController(text: '${state.currency.cp}');
    final epCtrl = TextEditingController(text: '${state.currency.ep}');
    final ppCtrl = TextEditingController(text: '${state.currency.pp}');

    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.primary),
        ),
        title: Text(
          'Edit Currency',
          style: TextStyle(color: theme.colorScheme.primary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCurrencyField('Gold (GP)', gpCtrl),
              _buildCurrencyField('Silver (SP)', spCtrl),
              _buildCurrencyField('Copper (CP)', cpCtrl),
              _buildCurrencyField('Electrum (EP)', epCtrl),
              _buildCurrencyField('Platinum (PP)', ppCtrl),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newCurr = CharacterCurrency(
                gp: int.tryParse(gpCtrl.text) ?? state.currency.gp,
                sp: int.tryParse(spCtrl.text) ?? state.currency.sp,
                cp: int.tryParse(cpCtrl.text) ?? state.currency.cp,
                ep: int.tryParse(epCtrl.text) ?? state.currency.ep,
                pp: int.tryParse(ppCtrl.text) ?? state.currency.pp,
              );
              notifier.updateCurrency(newCurr);
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens =
        theme.extension<ScrivenerThemeTokens>() ??
        ScrivenerThemeTokens.ancientTomeTokens;
    final encumbered = state.isEncumbered;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Currency Wallet Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(tokens.cardRadius),
            border: Border.fromBorderSide(tokens.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CURRENCY WALLET',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  InkWell(
                    onTap: () => _showCurrencyEditDialog(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 13,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildCoinBox(
                    context,
                    'GP',
                    state.currency.gp,
                    Colors.amberAccent,
                  ),
                  _buildCoinBox(context, 'SP', state.currency.sp, Colors.grey),
                  _buildCoinBox(
                    context,
                    'CP',
                    state.currency.cp,
                    Colors.brown.shade300,
                  ),
                  _buildCoinBox(
                    context,
                    'EP',
                    state.currency.ep,
                    Colors.blueGrey,
                  ),
                  _buildCoinBox(
                    context,
                    'PP',
                    state.currency.pp,
                    Colors.cyanAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Weight & Encumbrance Meter
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(tokens.cardRadius),
            border: Border.all(
              color: encumbered ? Colors.redAccent : theme.dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WEIGHT & CAPACITY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: encumbered
                          ? Colors.redAccent
                          : theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    '${state.carriedWeight} / ${state.carryingCapacity} lbs',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: encumbered
                          ? Colors.redAccent
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: state.encumbrancePercent,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.onSurface.withAlpha(25),
                  valueColor: AlwaysStoppedAnimation(
                    encumbered ? Colors.redAccent : theme.colorScheme.primary,
                  ),
                ),
              ),
              if (encumbered) ...[
                const SizedBox(height: 6),
                const Text(
                  '⚠️ Encumbered! Speed drops by 10 feet.',
                  style: TextStyle(fontSize: 11, color: Colors.redAccent),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Equipment List Header & Add Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  tokens.iconography.inventory,
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'INVENTORY (${state.inventoryItems.length} ITEMS)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _openAddItemDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('ADD ITEM'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (state.inventoryItems.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(
                    tokens.iconography.inventory,
                    size: 48,
                    color: theme.colorScheme.onSurface.withAlpha(50),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Inventory is empty',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _openAddItemDialog(context),
                    icon: const Icon(Icons.search, size: 16),
                    label: const Text('Add items from Compendium'),
                  ),
                ],
              ),
            ),
          )
        else
          ...state.inventoryItems.map(
            (item) => _buildInventoryCard(context, item),
          ),
      ],
    );
  }

  Widget _buildCoinBox(
    BuildContext context,
    String unit,
    int amount,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Column(
          children: [
            Text(
              '$amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(BuildContext context, InventoryTableData item) {
    final theme = Theme.of(context);
    final tokens =
        theme.extension<ScrivenerThemeTokens>() ??
        ScrivenerThemeTokens.ancientTomeTokens;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(tokens.cardRadius * 0.8),
        border: Border.all(
          color: item.isEquipped
              ? theme.colorScheme.primary
              : theme.dividerColor,
          width: item.isEquipped ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Equipped Checkbox
          Checkbox(
            value: item.isEquipped,
            activeColor: theme.colorScheme.primary,
            checkColor: theme.colorScheme.onPrimary,
            onChanged: (val) {
              if (val != null) {
                notifier.toggleItemEquipped(item.id, val);
              }
            },
          ),
          const SizedBox(width: 4),

          // Name and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: item.isEquipped
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.weight} lbs each • ${item.isEquipped ? 'Equipped' : 'In Backpack'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withAlpha(140),
                  ),
                ),
              ],
            ),
          ),

          // Quantity Stepper
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            visualDensity: VisualDensity.compact,
            onPressed: () => notifier.adjustItemQuantity(item.id, -1),
          ),
          Text(
            '${item.quantity}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            visualDensity: VisualDensity.compact,
            onPressed: () => notifier.adjustItemQuantity(item.id, 1),
          ),

          // Delete
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              size: 18,
              color: Colors.redAccent,
            ),
            visualDensity: VisualDensity.compact,
            onPressed: () => notifier.deleteInventoryItem(item.id),
          ),
        ],
      ),
    );
  }
}
