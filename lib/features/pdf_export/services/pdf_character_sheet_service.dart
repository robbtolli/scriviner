import 'dart:convert';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/database/app_database.dart';

class PdfCharacterSheetService {
  const PdfCharacterSheetService();

  /// Generates a complete 2-page portrait PDF document for the character.
  Future<Uint8List> generateCharacterSheetPdf({
    required CharactersTableData character,
    List<InventoryTableData> inventory = const [],
    List<ConditionsTableData> conditions = const [],
    PdfPageFormat pageFormat = PdfPageFormat.letter,
  }) async {
    final pdf = pw.Document();

    // Parse raw character properties
    Map<String, dynamic> props = {};
    try {
      props = jsonDecode(character.rawPropertiesJson) as Map<String, dynamic>;
    } catch (_) {
      props = {};
    }

    final level = props['level'] ?? 1;
    final className = props['class'] ?? 'Adventurer';
    final race = props['race'] ?? 'Human';
    final background = props['background'] ?? 'Folk Hero';
    final int profBonus = (props['proficiencyBonus'] as num?)?.toInt() ?? 2;
    final speed = props['speed'] ?? 30;

    // HP & Armor Class
    final hpMap = props['hp'] as Map<String, dynamic>? ?? {};
    final currentHp = hpMap['current'] ?? 10;
    final maxHp = hpMap['max'] ?? 10;
    final tempHp = hpMap['temp'] ?? 0;
    final ac = props['armorClass'] ?? 10;

    // Abilities
    final abilitiesMap = props['abilities'] as Map<String, dynamic>? ?? {};
    int getScore(String stat) {
      final statData = abilitiesMap[stat];
      if (statData is Map) return statData['score'] ?? 10;
      if (statData is num) return statData.toInt();
      return 10;
    }

    int getMod(String stat) {
      final statData = abilitiesMap[stat];
      if (statData is Map && statData['mod'] != null) return statData['mod'];
      final s = getScore(stat);
      return ((s - 10) / 2).floor();
    }

    final strScore = getScore('str');
    final dexScore = getScore('dex');
    final conScore = getScore('con');
    final intScore = getScore('int');
    final wisScore = getScore('wis');
    final chaScore = getScore('cha');

    final strMod = getMod('str');
    final dexMod = getMod('dex');
    final conMod = getMod('con');
    final intMod = getMod('int');
    final wisMod = getMod('wis');
    final chaMod = getMod('cha');

    final savingThrows =
        (props['savingThrows'] as List?)
            ?.map((e) => e.toString().toLowerCase())
            .toSet() ??
        {};
    final skillProfs =
        (props['skillProficiencies'] as Map?)?.cast<String, dynamic>() ?? {};
    final skillsList =
        (props['skills'] as List?)?.map((e) => e.toString()).toSet() ?? {};

    // 18 Standard 5e Skills
    final allSkills = [
      ('Acrobatics', 'dex'),
      ('Animal Handling', 'wis'),
      ('Arcana', 'int'),
      ('Athletics', 'str'),
      ('Deception', 'cha'),
      ('History', 'int'),
      ('Insight', 'wis'),
      ('Intimidation', 'cha'),
      ('Investigation', 'int'),
      ('Medicine', 'wis'),
      ('Nature', 'int'),
      ('Perception', 'wis'),
      ('Performance', 'cha'),
      ('Persuasion', 'cha'),
      ('Religion', 'int'),
      ('Sleight of Hand', 'dex'),
      ('Stealth', 'dex'),
      ('Survival', 'wis'),
    ];

    int getSkillMod(String skillName, String ability) {
      final baseMod = getMod(ability);
      final profLevel =
          (skillProfs[skillName] as num?)?.toInt() ??
          (skillsList.contains(skillName) ? 1 : 0);
      return baseMod + (profLevel * profBonus);
    }

    int getSkillProfLevel(String skillName) {
      return (skillProfs[skillName] as num?)?.toInt() ??
          (skillsList.contains(skillName) ? 1 : 0);
    }

    // Passive Perception, Insight, Investigation
    final passivePerception = 10 + getSkillMod('Perception', 'wis');
    final passiveInvestigation = 10 + getSkillMod('Investigation', 'int');
    final passiveInsight = 10 + getSkillMod('Insight', 'wis');

    // Attacks & Weapons
    final equipment = (props['equipment'] as List?)?.cast<dynamic>() ?? [];
    final attacks = <Map<String, String>>[];
    if (className.toString().toLowerCase().contains('fighter') ||
        className.toString().toLowerCase().contains('paladin') ||
        className.toString().toLowerCase().contains('barbarian')) {
      attacks.add({
        'name': 'Longsword',
        'bonus': '+${strMod + profBonus}',
        'damage': '1d8 + $strMod Slashing',
      });
      attacks.add({
        'name': 'Shortbow',
        'bonus': '+${dexMod + profBonus}',
        'damage': '1d6 + $dexMod Piercing',
      });
    } else if (className.toString().toLowerCase().contains('rogue')) {
      attacks.add({
        'name': 'Rapier',
        'bonus': '+${dexMod + profBonus}',
        'damage': '1d8 + $dexMod Piercing',
      });
      attacks.add({
        'name': 'Shortbow',
        'bonus': '+${dexMod + profBonus}',
        'damage': '1d6 + $dexMod Piercing',
      });
    } else if (className.toString().toLowerCase().contains('wizard') ||
        className.toString().toLowerCase().contains('sorcerer')) {
      attacks.add({
        'name': 'Fire Bolt',
        'bonus': '+${intMod + profBonus}',
        'damage': '1d10 Fire',
      });
      attacks.add({
        'name': 'Dagger',
        'bonus': '+${dexMod + profBonus}',
        'damage': '1d4 + $dexMod Piercing',
      });
    } else {
      attacks.add({
        'name': 'Primary Weapon',
        'bonus': '+${(strMod > dexMod ? strMod : dexMod) + profBonus}',
        'damage': '1d8 + ${(strMod > dexMod ? strMod : dexMod)}',
      });
    }

    // Spells & Features
    final spells =
        (props['spells'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final features =
        (props['featuresList'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final currency =
        (props['currency'] as Map?)?.cast<String, dynamic>() ??
        {'gp': 15, 'sp': 0, 'cp': 0};
    final bio = (props['bio'] as Map?)?.cast<String, dynamic>() ?? {};

    final helvetica = pw.Font.helvetica();
    final helveticaBold = pw.Font.helveticaBold();
    final helveticaOblique = pw.Font.helveticaOblique();

    String formatMod(int mod) => mod >= 0 ? '+$mod' : '$mod';

    // ==========================================
    // PAGE 1: Core Sheet, Abilities, Skills, Vitals
    // ==========================================
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header Block
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey700, width: 1.5),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(6),
                  ),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            character.name.toUpperCase(),
                            style: pw.TextStyle(
                              font: helveticaBold,
                              fontSize: 18,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.Text(
                            'CHARACTER NAME',
                            style: pw.TextStyle(
                              font: helvetica,
                              fontSize: 7,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      width: 1,
                      height: 32,
                      color: PdfColors.grey400,
                      margin: const pw.EdgeInsets.symmetric(horizontal: 8),
                    ),
                    pw.Expanded(
                      flex: 6,
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHeaderField(
                            'CLASS & LEVEL',
                            '$className $level',
                            helvetica,
                            helveticaBold,
                          ),
                          _buildHeaderField(
                            'RACE',
                            '$race',
                            helvetica,
                            helveticaBold,
                          ),
                          _buildHeaderField(
                            'BACKGROUND',
                            '$background',
                            helvetica,
                            helveticaBold,
                          ),
                          _buildHeaderField(
                            'SYSTEM',
                            'D&D 5e / 2024',
                            helvetica,
                            helveticaBold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Main Body Columns
              pw.Expanded(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // LEFT COLUMN: Abilities, Saving Throws, Skills
                    pw.Container(
                      width: 165,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          // 6 Core Abilities Horizontal Bar
                          pw.Container(
                            padding: const pw.EdgeInsets.all(6),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                color: PdfColors.grey600,
                                width: 1,
                              ),
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(4),
                              ),
                            ),
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                _buildAbilityBox(
                                  'STR',
                                  strScore,
                                  strMod,
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildAbilityBox(
                                  'DEX',
                                  dexScore,
                                  dexMod,
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildAbilityBox(
                                  'CON',
                                  conScore,
                                  conMod,
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildAbilityBox(
                                  'INT',
                                  intScore,
                                  intMod,
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildAbilityBox(
                                  'WIS',
                                  wisScore,
                                  wisMod,
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildAbilityBox(
                                  'CHA',
                                  chaScore,
                                  chaMod,
                                  helvetica,
                                  helveticaBold,
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 8),

                          // Proficiency & Inspiration Row
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.grey500,
                                    ),
                                    borderRadius: const pw.BorderRadius.all(
                                      pw.Radius.circular(4),
                                    ),
                                  ),
                                  child: pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text(
                                        'PROFICIENCY',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                        ),
                                      ),
                                      pw.Text(
                                        '+$profBonus',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              pw.SizedBox(width: 6),
                              pw.Expanded(
                                child: pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.grey500,
                                    ),
                                    borderRadius: const pw.BorderRadius.all(
                                      pw.Radius.circular(4),
                                    ),
                                  ),
                                  child: pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text(
                                        'INSPIRATION',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                        ),
                                      ),
                                      pw.Container(
                                        width: 10,
                                        height: 10,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                            color: PdfColors.black,
                                          ),
                                          shape: pw.BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 8),

                          // Saving Throws Box
                          pw.Container(
                            padding: const pw.EdgeInsets.all(6),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                color: PdfColors.grey600,
                                width: 1,
                              ),
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(4),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'SAVING THROWS',
                                  style: pw.TextStyle(
                                    font: helveticaBold,
                                    fontSize: 8,
                                    color: PdfColors.black,
                                  ),
                                ),
                                pw.SizedBox(height: 3),
                                _buildSaveRow(
                                  'Strength',
                                  strMod +
                                      (savingThrows.contains('strength') ||
                                              savingThrows.contains('str')
                                          ? profBonus
                                          : 0),
                                  savingThrows.contains('strength') ||
                                      savingThrows.contains('str'),
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildSaveRow(
                                  'Dexterity',
                                  dexMod +
                                      (savingThrows.contains('dexterity') ||
                                              savingThrows.contains('dex')
                                          ? profBonus
                                          : 0),
                                  savingThrows.contains('dexterity') ||
                                      savingThrows.contains('dex'),
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildSaveRow(
                                  'Constitution',
                                  conMod +
                                      (savingThrows.contains('constitution') ||
                                              savingThrows.contains('con')
                                          ? profBonus
                                          : 0),
                                  savingThrows.contains('constitution') ||
                                      savingThrows.contains('con'),
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildSaveRow(
                                  'Intelligence',
                                  intMod +
                                      (savingThrows.contains('intelligence') ||
                                              savingThrows.contains('int')
                                          ? profBonus
                                          : 0),
                                  savingThrows.contains('intelligence') ||
                                      savingThrows.contains('int'),
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildSaveRow(
                                  'Wisdom',
                                  wisMod +
                                      (savingThrows.contains('wisdom') ||
                                              savingThrows.contains('wis')
                                          ? profBonus
                                          : 0),
                                  savingThrows.contains('wisdom') ||
                                      savingThrows.contains('wis'),
                                  helvetica,
                                  helveticaBold,
                                ),
                                _buildSaveRow(
                                  'Charisma',
                                  chaMod +
                                      (savingThrows.contains('charisma') ||
                                              savingThrows.contains('cha')
                                          ? profBonus
                                          : 0),
                                  savingThrows.contains('charisma') ||
                                      savingThrows.contains('cha'),
                                  helvetica,
                                  helveticaBold,
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 8),

                          // Skills Box
                          pw.Expanded(
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(6),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                  color: PdfColors.grey600,
                                  width: 1,
                                ),
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(4),
                                ),
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'SKILLS (18)',
                                    style: pw.TextStyle(
                                      font: helveticaBold,
                                      fontSize: 8,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.SizedBox(height: 3),
                                  pw.Expanded(
                                    child: pw.ListView.builder(
                                      itemCount: allSkills.length,
                                      itemBuilder: (ctx, idx) {
                                        final (name, stat) = allSkills[idx];
                                        final mod = getSkillMod(name, stat);
                                        final profLevel = getSkillProfLevel(
                                          name,
                                        );
                                        return _buildSkillRow(
                                          name,
                                          stat,
                                          mod,
                                          profLevel,
                                          helvetica,
                                          helveticaBold,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 6),

                          // Passive Senses Box
                          pw.Container(
                            padding: const pw.EdgeInsets.all(6),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey500),
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(4),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'PASSIVE SENSES',
                                  style: pw.TextStyle(
                                    font: helveticaBold,
                                    fontSize: 8,
                                  ),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                      'Passive Perception: $passivePerception',
                                      style: pw.TextStyle(
                                        font: helvetica,
                                        fontSize: 8,
                                      ),
                                    ),
                                    pw.Text(
                                      'Insight: $passiveInsight',
                                      style: pw.TextStyle(
                                        font: helvetica,
                                        fontSize: 8,
                                      ),
                                    ),
                                    pw.Text(
                                      'Invest: $passiveInvestigation',
                                      style: pw.TextStyle(
                                        font: helvetica,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 12),

                    // CENTER & RIGHT COMBINED AREA
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          // Combat Vitals Row
                          pw.Row(
                            children: [
                              _buildVitalBox(
                                'ARMOR CLASS',
                                '$ac',
                                'Shield / Armor',
                                helvetica,
                                helveticaBold,
                              ),
                              pw.SizedBox(width: 8),
                              _buildVitalBox(
                                'INITIATIVE',
                                formatMod(dexMod),
                                'DEX Mod',
                                helvetica,
                                helveticaBold,
                              ),
                              pw.SizedBox(width: 8),
                              _buildVitalBox(
                                'SPEED',
                                '${speed}ft',
                                'Walk Speed',
                                helvetica,
                                helveticaBold,
                              ),
                              pw.SizedBox(width: 8),
                              _buildVitalBox(
                                'HIT POINTS',
                                '$currentHp / $maxHp',
                                tempHp > 0 ? 'Temp: $tempHp' : 'Max: $maxHp',
                                helvetica,
                                helveticaBold,
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 8),

                          // Hit Dice & Death Saves Row
                          pw.Row(
                            children: [
                              pw.Expanded(
                                flex: 4,
                                child: pw.Container(
                                  padding: const pw.EdgeInsets.all(6),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.grey600,
                                    ),
                                    borderRadius: const pw.BorderRadius.all(
                                      pw.Radius.circular(4),
                                    ),
                                  ),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        'HIT DICE POOL',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                        ),
                                      ),
                                      pw.SizedBox(height: 3),
                                      pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text(
                                            'Total: $level',
                                            style: pw.TextStyle(
                                              font: helvetica,
                                              fontSize: 9,
                                            ),
                                          ),
                                          pw.Text(
                                            'Die: 1d${props['hitDice']?['die'] ?? '8'}',
                                            style: pw.TextStyle(
                                              font: helveticaBold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              pw.SizedBox(width: 8),
                              pw.Expanded(
                                flex: 6,
                                child: pw.Container(
                                  padding: const pw.EdgeInsets.all(6),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.grey600,
                                    ),
                                    borderRadius: const pw.BorderRadius.all(
                                      pw.Radius.circular(4),
                                    ),
                                  ),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        'DEATH SAVING THROWS',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                        ),
                                      ),
                                      pw.SizedBox(height: 3),
                                      pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Row(
                                            children: [
                                              pw.Text(
                                                'Success: ',
                                                style: pw.TextStyle(
                                                  font: helvetica,
                                                  fontSize: 8,
                                                ),
                                              ),
                                              _buildPip(),
                                              _buildPip(),
                                              _buildPip(),
                                            ],
                                          ),
                                          pw.Row(
                                            children: [
                                              pw.Text(
                                                'Failure: ',
                                                style: pw.TextStyle(
                                                  font: helvetica,
                                                  fontSize: 8,
                                                ),
                                              ),
                                              _buildPip(),
                                              _buildPip(),
                                              _buildPip(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 8),

                          // Weapons & Attacks Table
                          pw.Container(
                            padding: const pw.EdgeInsets.all(8),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey600),
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(4),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'ATTACKS & SPELLCASTING',
                                  style: pw.TextStyle(
                                    font: helveticaBold,
                                    fontSize: 9,
                                  ),
                                ),
                                pw.SizedBox(height: 4),
                                pw.Table(
                                  columnWidths: {
                                    0: const pw.FlexColumnWidth(3),
                                    1: const pw.FlexColumnWidth(2),
                                    2: const pw.FlexColumnWidth(4),
                                  },
                                  border: pw.TableBorder.all(
                                    color: PdfColors.grey300,
                                    width: 0.5,
                                  ),
                                  children: [
                                    pw.TableRow(
                                      decoration: const pw.BoxDecoration(
                                        color: PdfColors.grey200,
                                      ),
                                      children: [
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(3),
                                          child: pw.Text(
                                            'NAME / WEAPON',
                                            style: pw.TextStyle(
                                              font: helveticaBold,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(3),
                                          child: pw.Text(
                                            'ATK BONUS',
                                            style: pw.TextStyle(
                                              font: helveticaBold,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(3),
                                          child: pw.Text(
                                            'DAMAGE & TYPE',
                                            style: pw.TextStyle(
                                              font: helveticaBold,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    for (final atk in attacks)
                                      pw.TableRow(
                                        children: [
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(3),
                                            child: pw.Text(
                                              atk['name'] ?? '',
                                              style: pw.TextStyle(
                                                font: helveticaBold,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(3),
                                            child: pw.Text(
                                              atk['bonus'] ?? '',
                                              style: pw.TextStyle(
                                                font: helvetica,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(3),
                                            child: pw.Text(
                                              atk['damage'] ?? '',
                                              style: pw.TextStyle(
                                                font: helvetica,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (attacks.length < 4)
                                      for (
                                        int i = 0;
                                        i < (4 - attacks.length);
                                        i++
                                      )
                                        pw.TableRow(
                                          children: [
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(
                                                5,
                                              ),
                                              child: pw.Text(
                                                ' ',
                                                style: pw.TextStyle(
                                                  font: helvetica,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(
                                                5,
                                              ),
                                              child: pw.Text(
                                                ' ',
                                                style: pw.TextStyle(
                                                  font: helvetica,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(
                                                5,
                                              ),
                                              child: pw.Text(
                                                ' ',
                                                style: pw.TextStyle(
                                                  font: helvetica,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 8),

                          // Active Conditions & Proficiencies
                          pw.Expanded(
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                // Active Conditions
                                pw.Expanded(
                                  flex: 5,
                                  child: pw.Container(
                                    padding: const pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(
                                        color: PdfColors.grey500,
                                      ),
                                      borderRadius: const pw.BorderRadius.all(
                                        pw.Radius.circular(4),
                                      ),
                                    ),
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          'ACTIVE CONDITIONS & BUFFS',
                                          style: pw.TextStyle(
                                            font: helveticaBold,
                                            fontSize: 8,
                                          ),
                                        ),
                                        pw.SizedBox(height: 4),
                                        if (conditions.isEmpty)
                                          pw.Text(
                                            'Normal (No active afflictions)',
                                            style: pw.TextStyle(
                                              font: helveticaOblique,
                                              fontSize: 8,
                                              color: PdfColors.grey700,
                                            ),
                                          )
                                        else
                                          for (final c in conditions)
                                            pw.Padding(
                                              padding:
                                                  const pw.EdgeInsets.symmetric(
                                                    vertical: 2,
                                                  ),
                                              child: pw.Text(
                                                '- ${c.conditionId.toUpperCase()}',
                                                style: pw.TextStyle(
                                                  font: helveticaBold,
                                                  fontSize: 8,
                                                  color: PdfColors.red900,
                                                ),
                                              ),
                                            ),
                                      ],
                                    ),
                                  ),
                                ),
                                pw.SizedBox(width: 8),

                                // Proficiencies & Languages
                                pw.Expanded(
                                  flex: 5,
                                  child: pw.Container(
                                    padding: const pw.EdgeInsets.all(8),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(
                                        color: PdfColors.grey500,
                                      ),
                                      borderRadius: const pw.BorderRadius.all(
                                        pw.Radius.circular(4),
                                      ),
                                    ),
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          'PROFICIENCIES & LANGUAGES',
                                          style: pw.TextStyle(
                                            font: helveticaBold,
                                            fontSize: 8,
                                          ),
                                        ),
                                        pw.SizedBox(height: 4),
                                        pw.Text(
                                          'Armor: Light, Medium, Shields',
                                          style: pw.TextStyle(
                                            font: helvetica,
                                            fontSize: 8,
                                          ),
                                        ),
                                        pw.Text(
                                          'Weapons: Simple, Martial Weapons',
                                          style: pw.TextStyle(
                                            font: helvetica,
                                            fontSize: 8,
                                          ),
                                        ),
                                        pw.Text(
                                          'Languages: Common, Dwarvish, Elvish',
                                          style: pw.TextStyle(
                                            font: helvetica,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Page 1 Footer
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 8),
                padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'SCRIVENER TTRPG COMPANION | tollitech.com',
                      style: pw.TextStyle(
                        font: helvetica,
                        fontSize: 7,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      'PAGE 1 OF 2',
                      style: pw.TextStyle(
                        font: helveticaBold,
                        fontSize: 7,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // ==========================================
    // PAGE 2: Features, Spells, Inventory & Bio
    // ==========================================
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header Sub-banner
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey700),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                  color: PdfColors.grey100,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '${character.name.toUpperCase()} - FEATURES, SPELLS & EQUIPMENT',
                      style: pw.TextStyle(font: helveticaBold, fontSize: 11),
                    ),
                    pw.Text(
                      'LEVEL $level $className',
                      style: pw.TextStyle(
                        font: helveticaBold,
                        fontSize: 10,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Two-column split for Page 2
              pw.Expanded(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // LEFT COLUMN: Features & Traits + Spellbook
                    pw.Expanded(
                      flex: 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          // Features & Traits Block
                          pw.Container(
                            height: 280,
                            padding: const pw.EdgeInsets.all(8),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey600),
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(4),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'FEATURES & TRAITS',
                                  style: pw.TextStyle(
                                    font: helveticaBold,
                                    fontSize: 9,
                                  ),
                                ),
                                pw.SizedBox(height: 4),
                                pw.Expanded(
                                  child: features.isEmpty
                                      ? pw.Text(
                                          'Class features, racial traits, and feats.',
                                          style: pw.TextStyle(
                                            font: helveticaOblique,
                                            fontSize: 8,
                                            color: PdfColors.grey600,
                                          ),
                                        )
                                      : pw.ListView.builder(
                                          itemCount: features.length,
                                          itemBuilder: (ctx, idx) {
                                            final feat = features[idx];
                                            final fName =
                                                feat['name'] ?? 'Feature';
                                            final fDesc =
                                                feat['description'] ?? '';
                                            return pw.Padding(
                                              padding: const pw.EdgeInsets.only(
                                                bottom: 6,
                                              ),
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    '- $fName',
                                                    style: pw.TextStyle(
                                                      font: helveticaBold,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                  if (fDesc.isNotEmpty)
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.only(
                                                            left: 8,
                                                          ),
                                                      child: pw.Text(
                                                        fDesc,
                                                        style: pw.TextStyle(
                                                          font: helvetica,
                                                          fontSize: 7,
                                                          color:
                                                              PdfColors.grey800,
                                                        ),
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 10),

                          // Spells & Spellcasting Block
                          pw.Expanded(
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.grey600),
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(4),
                                ),
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text(
                                        'SPELLCASTING & KNOWN SPELLS',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 9,
                                        ),
                                      ),
                                      pw.Text(
                                        'Spell Save DC: ${8 + profBonus + intMod}  |  Attack: +${profBonus + intMod}',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Expanded(
                                    child: spells.isEmpty
                                        ? pw.Center(
                                            child: pw.Text(
                                              'No prepared spells or spellcasting capabilities.',
                                              style: pw.TextStyle(
                                                font: helveticaOblique,
                                                fontSize: 8,
                                                color: PdfColors.grey600,
                                              ),
                                            ),
                                          )
                                        : pw.ListView.builder(
                                            itemCount: spells.length,
                                            itemBuilder: (ctx, idx) {
                                              final s = spells[idx];
                                              final sName =
                                                  s['name'] ?? 'Spell';
                                              final sLevel = s['level'] ?? 0;
                                              final sSchool = s['school'] ?? '';
                                              final isPrep =
                                                  s['isPrepared'] == true;
                                              return pw.Padding(
                                                padding:
                                                    const pw.EdgeInsets.symmetric(
                                                      vertical: 2,
                                                    ),
                                                child: pw.Row(
                                                  children: [
                                                    pw.Text(
                                                      isPrep ? '[*] ' : '[ ] ',
                                                      style: pw.TextStyle(
                                                        font: helveticaBold,
                                                        fontSize: 7,
                                                      ),
                                                    ),
                                                    pw.Text(
                                                      sName,
                                                      style: pw.TextStyle(
                                                        font: helveticaBold,
                                                        fontSize: 8,
                                                      ),
                                                    ),
                                                    pw.Spacer(),
                                                    pw.Text(
                                                      sLevel == 0
                                                          ? 'Cantrip | $sSchool'
                                                          : 'Lvl $sLevel | $sSchool',
                                                      style: pw.TextStyle(
                                                        font: helvetica,
                                                        fontSize: 7,
                                                        color:
                                                            PdfColors.grey700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 12),

                    // RIGHT COLUMN: Equipment / Inventory & Character Bio / Notes
                    pw.Expanded(
                      flex: 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          // Equipment & Currency Block
                          pw.Container(
                            height: 280,
                            padding: const pw.EdgeInsets.all(8),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey600),
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(4),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                      'EQUIPMENT & GEAR',
                                      style: pw.TextStyle(
                                        font: helveticaBold,
                                        fontSize: 9,
                                      ),
                                    ),
                                    pw.Text(
                                      'Capacity: ${strScore * 15} lbs',
                                      style: pw.TextStyle(
                                        font: helvetica,
                                        fontSize: 8,
                                        color: PdfColors.grey700,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 4),

                                // Currency Row
                                pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: const pw.BoxDecoration(
                                    color: PdfColors.grey100,
                                    borderRadius: pw.BorderRadius.all(
                                      pw.Radius.circular(3),
                                    ),
                                  ),
                                  child: pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceAround,
                                    children: [
                                      pw.Text(
                                        'CP: ${currency['cp'] ?? 0}',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                        ),
                                      ),
                                      pw.Text(
                                        'SP: ${currency['sp'] ?? 0}',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                        ),
                                      ),
                                      pw.Text(
                                        'EP: ${currency['ep'] ?? 0}',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                        ),
                                      ),
                                      pw.Text(
                                        'GP: ${currency['gp'] ?? 0}',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                          color: PdfColors.amber800,
                                        ),
                                      ),
                                      pw.Text(
                                        'PP: ${currency['pp'] ?? 0}',
                                        style: pw.TextStyle(
                                          font: helveticaBold,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                pw.SizedBox(height: 6),

                                // Inventory items list
                                pw.Expanded(
                                  child: inventory.isNotEmpty
                                      ? pw.ListView.builder(
                                          itemCount: inventory.length,
                                          itemBuilder: (ctx, idx) {
                                            final item = inventory[idx];
                                            return pw.Padding(
                                              padding:
                                                  const pw.EdgeInsets.symmetric(
                                                    vertical: 2,
                                                  ),
                                              child: pw.Row(
                                                children: [
                                                  pw.Text(
                                                    item.isEquipped
                                                        ? '[E] '
                                                        : '    ',
                                                    style: pw.TextStyle(
                                                      font: helveticaBold,
                                                      fontSize: 7,
                                                      color: PdfColors.blue800,
                                                    ),
                                                  ),
                                                  pw.Text(
                                                    '${item.quantity}x ${item.name}',
                                                    style: pw.TextStyle(
                                                      font: helvetica,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                  pw.Spacer(),
                                                  pw.Text(
                                                    '${(item.weight * item.quantity).toStringAsFixed(1)} lbs',
                                                    style: pw.TextStyle(
                                                      font: helvetica,
                                                      fontSize: 7,
                                                      color: PdfColors.grey700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : equipment.isNotEmpty
                                      ? pw.ListView.builder(
                                          itemCount: equipment.length,
                                          itemBuilder: (ctx, idx) {
                                            final item = equipment[idx];
                                            return pw.Padding(
                                              padding:
                                                  const pw.EdgeInsets.symmetric(
                                                    vertical: 2,
                                                  ),
                                              child: pw.Text(
                                                '- ${item.toString()}',
                                                style: pw.TextStyle(
                                                  font: helvetica,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : pw.Text(
                                          'Backpack, bedroll, mess kit, tinderbox, 10 torches, 10 days of rations, waterskin.',
                                          style: pw.TextStyle(
                                            font: helvetica,
                                            fontSize: 8,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 10),

                          // Bio, Notes & Personality Block
                          pw.Expanded(
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.grey600),
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(4),
                                ),
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'CHARACTER BACKSTORY, TRAITS & NOTES',
                                    style: pw.TextStyle(
                                      font: helveticaBold,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Expanded(
                                    child: pw.ListView(
                                      children: [
                                        if ((bio['personalityTraits'] ?? '')
                                            .isNotEmpty) ...[
                                          pw.Text(
                                            'Personality Traits:',
                                            style: pw.TextStyle(
                                              font: helveticaBold,
                                              fontSize: 8,
                                            ),
                                          ),
                                          pw.Text(
                                            '${bio['personalityTraits']}',
                                            style: pw.TextStyle(
                                              font: helvetica,
                                              fontSize: 7.5,
                                            ),
                                          ),
                                          pw.SizedBox(height: 4),
                                        ],
                                        if ((bio['ideals'] ?? '')
                                            .isNotEmpty) ...[
                                          pw.Text(
                                            'Ideals:',
                                            style: pw.TextStyle(
                                              font: helveticaBold,
                                              fontSize: 8,
                                            ),
                                          ),
                                          pw.Text(
                                            '${bio['ideals']}',
                                            style: pw.TextStyle(
                                              font: helvetica,
                                              fontSize: 7.5,
                                            ),
                                          ),
                                          pw.SizedBox(height: 4),
                                        ],
                                        if ((bio['bonds'] ?? '')
                                            .isNotEmpty) ...[
                                          pw.Text(
                                            'Bonds:',
                                            style: pw.TextStyle(
                                              font: helveticaBold,
                                              fontSize: 8,
                                            ),
                                          ),
                                          pw.Text(
                                            '${bio['bonds']}',
                                            style: pw.TextStyle(
                                              font: helvetica,
                                              fontSize: 7.5,
                                            ),
                                          ),
                                          pw.SizedBox(height: 4),
                                        ],
                                        if ((bio['flaws'] ?? '')
                                            .isNotEmpty) ...[
                                          pw.Text(
                                            'Flaws:',
                                            style: pw.TextStyle(
                                              font: helveticaBold,
                                              fontSize: 8,
                                            ),
                                          ),
                                          pw.Text(
                                            '${bio['flaws']}',
                                            style: pw.TextStyle(
                                              font: helvetica,
                                              fontSize: 7.5,
                                            ),
                                          ),
                                          pw.SizedBox(height: 4),
                                        ],
                                        pw.Text(
                                          'Chronicle Notes:',
                                          style: pw.TextStyle(
                                            font: helveticaBold,
                                            fontSize: 8,
                                          ),
                                        ),
                                        pw.Text(
                                          character.notes.isNotEmpty
                                              ? character.notes
                                              : 'Hero active in chronicle campaigns.',
                                          style: pw.TextStyle(
                                            font: helvetica,
                                            fontSize: 7.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Page 2 Footer
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 8),
                padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'SCRIVENER TTRPG COMPANION | tollitech.com',
                      style: pw.TextStyle(
                        font: helvetica,
                        fontSize: 7,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      'PAGE 2 OF 2',
                      style: pw.TextStyle(
                        font: helveticaBold,
                        fontSize: 7,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ==========================================
  // Helper Widget Builders
  // ==========================================
  static pw.Widget _buildHeaderField(
    String label,
    String value,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 10,
            color: PdfColors.black,
          ),
        ),
        pw.Text(
          label,
          style: pw.TextStyle(
            font: fontRegular,
            fontSize: 6.5,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildAbilityBox(
    String name,
    int score,
    int mod,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    final modStr = mod >= 0 ? '+$mod' : '$mod';
    return pw.Container(
      width: 22,
      child: pw.Column(
        children: [
          pw.Text(
            name,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 7,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 1),
          pw.Text(
            modStr,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 10,
              color: PdfColors.black,
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 2,
              vertical: 0.5,
            ),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            ),
            child: pw.Text(
              '$score',
              style: pw.TextStyle(font: fontRegular, fontSize: 6.5),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSaveRow(
    String name,
    int mod,
    bool isProficient,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    final modStr = mod >= 0 ? '+$mod' : '$mod';
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
      child: pw.Row(
        children: [
          pw.Container(
            width: 7,
            height: 7,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              border: pw.Border.all(color: PdfColors.black, width: 0.8),
              color: isProficient ? PdfColors.black : PdfColors.white,
            ),
          ),
          pw.SizedBox(width: 4),
          pw.Text(modStr, style: pw.TextStyle(font: fontBold, fontSize: 7.5)),
          pw.SizedBox(width: 4),
          pw.Text(name, style: pw.TextStyle(font: fontRegular, fontSize: 7.5)),
        ],
      ),
    );
  }

  static pw.Widget _buildSkillRow(
    String name,
    String stat,
    int mod,
    int profLevel,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    final modStr = mod >= 0 ? '+$mod' : '$mod';
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1.2),
      child: pw.Row(
        children: [
          pw.Container(
            width: 6,
            height: 6,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              border: pw.Border.all(color: PdfColors.black, width: 0.8),
              color: profLevel > 0 ? PdfColors.black : PdfColors.white,
            ),
          ),
          pw.SizedBox(width: 4),
          pw.Text(modStr, style: pw.TextStyle(font: fontBold, fontSize: 7.5)),
          pw.SizedBox(width: 4),
          pw.Text(
            '$name (${stat.toUpperCase()})',
            style: pw.TextStyle(font: fontRegular, fontSize: 7),
          ),
          if (profLevel >= 2) ...[
            pw.SizedBox(width: 2),
            pw.Text(
              '(E)',
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 6,
                color: PdfColors.amber800,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildVitalBox(
    String label,
    String value,
    String subtext,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey600),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Column(
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 7,
                color: PdfColors.grey800,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              value,
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 13,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 1),
            pw.Text(
              subtext,
              style: pw.TextStyle(
                font: fontRegular,
                fontSize: 6.5,
                color: PdfColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildPip() {
    return pw.Container(
      width: 8,
      height: 8,
      margin: const pw.EdgeInsets.symmetric(horizontal: 2),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.8),
        shape: pw.BoxShape.circle,
      ),
    );
  }
}
