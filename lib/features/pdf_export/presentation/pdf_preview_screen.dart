import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../core/database/app_database.dart';
import '../services/pdf_character_sheet_service.dart';

class PdfPreviewScreen extends StatelessWidget {
  final CharactersTableData character;
  final List<InventoryTableData> inventory;
  final List<ConditionsTableData> conditions;

  const PdfPreviewScreen({
    super.key,
    required this.character,
    this.inventory = const [],
    this.conditions = const [],
  });

  static void show(
    BuildContext context, {
    required CharactersTableData character,
    List<InventoryTableData> inventory = const [],
    List<ConditionsTableData> conditions = const [],
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PdfPreviewScreen(
          character: character,
          inventory: inventory,
          conditions: conditions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const service = PdfCharacterSheetService();
    final sanitizedName = character.name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${character.name} — Printable Sheet',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: PdfPreview(
        build: (format) => service.generateCharacterSheetPdf(
          character: character,
          inventory: inventory,
          conditions: conditions,
          pageFormat: format,
        ),
        canChangePageFormat: true,
        canChangeOrientation: false,
        allowPrinting: true,
        allowSharing: true,
        initialPageFormat: PdfPageFormat.letter,
        pdfFileName: '${sanitizedName}_CharacterSheet.pdf',
      ),
    );
  }
}
