import '../../models/compendium_entry.dart';
import 'spells_cantrips.dart';
import 'spells_level_1.dart';
import 'spells_level_2.dart';
import 'spells_level_3.dart';
import 'spells_level_4.dart';
import 'spells_level_5.dart';
import 'spells_level_6.dart';
import 'spells_level_7.dart';
import 'spells_level_8.dart';
import 'spells_level_9.dart';

/// Aggregated list of all SRD 5.1 spells across levels 0 through 9.
final List<CompendiumEntry> allSrdSpells = [
  ...srdCantrips,
  ...srdSpellsLevel1,
  ...srdSpellsLevel2,
  ...srdSpellsLevel3,
  ...srdSpellsLevel4,
  ...srdSpellsLevel5,
  ...srdSpellsLevel6,
  ...srdSpellsLevel7,
  ...srdSpellsLevel8,
  ...srdSpellsLevel9,
];
