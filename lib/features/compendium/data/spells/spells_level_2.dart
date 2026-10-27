import '../../models/compendium_entry.dart';

/// SRD 5.1 2nd-Level Spells
final List<CompendiumEntry> srdSpellsLevel2 = [
  CompendiumEntry(
    id: 'srd_spell_acid_arrow',
    category: 'spell',
    name: 'Acid Arrow',
    summary:
        'A shimmering green arrow streaks toward target dealing 4d4 acid damage + 2d4 at end of its next turn.',
    data: {
      'level': 2,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '90 feet',
      'components': 'V, S, M (powdered rhubarb leaf and an adder\'s stomach)',
      'duration': 'Instantaneous',
      'classes': ['wizard'],
      'description':
          'A shimmering green arrow streaks toward a target within range and bursts in a spray of acid. Make a ranged spell attack against the target. On a hit, the target takes 4d4 acid damage immediately and 2d4 acid damage at the end of its next turn. On a miss, the arrow splashes the target with acid for half as much of the initial damage and no damage at the end of its next turn.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_aid',
    category: 'spell',
    name: 'Aid',
    summary:
        'Bolster up to 3 allies with toughness: each target\'s hit point maximum and current hit points increase by 5 for 8 hours.',
    data: {
      'level': 2,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S, M (a tiny strip of white cloth)',
      'duration': '8 hours',
      'classes': ['cleric', 'paladin'],
      'description':
          'Your spell bolsters your allies with toughness and resolve. Choose up to three creatures within range. Each target\'s hit point maximum and current hit points increase by 5 for the duration.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_alter_self',
    category: 'spell',
    name: 'Alter Self',
    summary:
        'Assume a new form: aquatic adaptation (swim speed + breathe water), change appearance, or natural weapons (1d6+1).',
    data: {
      'level': 2,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You assume a different form. When you cast the spell, choose one of the following options: Aquatic Adaptation (breathe underwater and gain swim speed equal to walking speed), Change Appearance (alter your form and voice), or Natural Weapons (grow claws, fangs, or horns dealing 1d6 + 1 damage).',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_barkskin',
    category: 'spell',
    name: 'Barkskin',
    summary:
        'Touch a willing creature: target\'s AC can\'t be less than 16, regardless of what armor it is wearing.',
    data: {
      'level': 2,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (a handful of oak bark)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['druid', 'ranger'],
      'description':
          'You touch a willing creature. Until the spell ends, the target\'s skin has a rough, bark-like appearance, and the target\'s AC can\'t be less than 16, regardless of what kind of armor it is wearing.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_blindness_deafness',
    category: 'spell',
    name: 'Blindness/Deafness',
    summary:
        'Inflict blindness or deafness on a foe for 1 minute on a failed CON save (repeat save each turn).',
    data: {
      'level': 2,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V',
      'duration': '1 minute',
      'classes': ['bard', 'cleric', 'sorcerer', 'wizard'],
      'description':
          'You can blind or deafen a foe. Choose one creature that you can see within range to make a Constitution saving throw. If it fails, the target is either blinded or deafened (your choice) for the duration. At the end of each of its turns, the target can make a Constitution saving throw to end the effect.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_blur',
    category: 'spell',
    name: 'Blur',
    summary:
        'Your body blurs: attackers have disadvantage on attack rolls against you for up to 1 minute.',
    data: {
      'level': 2,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'Your body becomes blurred, shifting and wavering to all who can see you. For the duration, any creature has disadvantage on attack rolls against you. An attacker is immune to this effect if it doesn\'t rely on sight, as with blindsight, or can see through illusions, as with truesight.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_darkness',
    category: 'spell',
    name: 'Darkness',
    summary:
        'Magical darkness spreads from a point in a 15-foot radius; darkvision cannot see through it.',
    data: {
      'level': 2,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, M (bat fur and a drop of pitch or piece of coal)',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['sorcerer', 'warlock', 'wizard'],
      'description':
          'Magical darkness spreads from a point you choose within range to fill a 15-foot-radius sphere for the duration. The darkness spreads around corners. A creature with darkvision can\'t see through this darkness, and nonmagical light can\'t illuminate it.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_darkvision',
    category: 'spell',
    name: 'Darkvision',
    summary:
        'Touch a willing creature to grant it darkvision out to a range of 60 feet for 8 hours.',
    data: {
      'level': 2,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (either a pinch of dried carrot or an agate)',
      'duration': '8 hours',
      'classes': ['druid', 'ranger', 'sorcerer', 'wizard'],
      'description':
          'You touch a willing creature to grant it the ability to see in the dark. For the duration, that creature has darkvision out to a range of 60 feet.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_enhance_ability',
    category: 'spell',
    name: 'Enhance Ability',
    summary:
        'Touch a creature to bestow magical enhancement: advantage on ability checks of chosen attribute.',
    data: {
      'level': 2,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (fur or a feather from a beast)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['bard', 'cleric', 'druid', 'sorcerer'],
      'description':
          'You touch a creature and bestow upon it a magical enhancement. Choose one ability: Bear\'s Endurance (adv on CON checks + 2d6 temp HP), Bull\'s Strength (adv on STR checks + doubled carrying capacity), Cat\'s Grace (adv on DEX checks + no fall damage up to 20 ft), Eagle\'s Splendor (adv on CHA checks), Fox\'s Cunning (adv on INT checks), or Owl\'s Wisdom (adv on WIS checks).',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_flaming_sphere',
    category: 'spell',
    name: 'Flaming Sphere',
    summary:
        'A 5-ft diameter sphere of fire rolls at your command dealing 2d6 fire damage (DEX save half).',
    data: {
      'level': 2,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '60 feet',
      'components':
          'V, S, M (a bit of tallow, a pinch of brimstone, and a dusting of powdered iron)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['druid', 'wizard'],
      'description':
          'A 5-foot-diameter sphere of fire appears in an unoccupied space of your choice within range. Any creature that ends its turn within 5 feet of the sphere must make a Dexterity saving throw, taking 2d6 fire damage on a failed save, or half on a success. As a bonus action, you can move the sphere up to 30 feet.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_heat_metal',
    category: 'spell',
    name: 'Heat Metal',
    summary:
        'Manufactured metal object glows red-hot, dealing 2d8 fire damage each turn with bonus action.',
    data: {
      'level': 2,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a piece of iron and a flame)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'druid'],
      'description':
          'Choose a manufactured metal object, such as a metal weapon or a suit of heavy or medium metal armor, that you can see within range. You cause the object to glow red-hot. Any creature in physical contact with the object takes 2d8 fire damage when you cast the spell. Until the spell ends, you can use a bonus action on each of your subsequent turns to cause this damage again.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_hold_person',
    category: 'spell',
    name: 'Hold Person',
    summary:
        'Paralyze a humanoid within 60 ft for up to 1 minute on a failed WIS save (repeat save each turn).',
    data: {
      'level': 2,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a small, straight piece of iron)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'cleric', 'druid', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'Choose a humanoid that you can see within range. The target must succeed on a Wisdom saving throw or be paralyzed for the duration. At the end of each of its turns, the target can make another Wisdom saving throw. On a success, the spell ends on the target.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_invisibility',
    category: 'spell',
    name: 'Invisibility',
    summary:
        'Touch a creature to make it invisible for up to 1 hour or until it attacks or casts a spell.',
    data: {
      'level': 2,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (an eyelash encased in gum arabic)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'A creature you touch becomes invisible until the spell ends. Anything the target is wearing or carrying is invisible as long as it is on the target\'s person. The spell ends for a target that attacks or casts a spell.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_knock',
    category: 'spell',
    name: 'Knock',
    summary:
        'Instantly unlock or unbar an object, door, or chest. Emits a loud knock audible 300 feet away.',
    data: {
      'level': 2,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'Choose an object that you can see within range. The object can be a door, a box, a chest, a set of manacles, a padlock, or another object that contains a mundane or magical means that prevents access. A target that is held shut by a mundane lock or that is stuck or barred becomes unlocked, unstuck, or unbarred. When you cast the spell, a loud knock emanates from the target object, audible up to 300 feet away.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_lesser_restoration',
    category: 'spell',
    name: 'Lesser Restoration',
    summary:
        'Touch a creature to end either one disease or one condition: blinded, deafened, paralyzed, or poisoned.',
    data: {
      'level': 2,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['bard', 'cleric', 'druid', 'paladin', 'ranger'],
      'description':
          'You touch a creature and can end either one disease or one condition afflicting it. The condition can be blinded, deafened, paralyzed, or poisoned.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_levitate',
    category: 'spell',
    name: 'Levitate',
    summary:
        'One creature or object rises vertically up to 20 feet and remains suspended in midair.',
    data: {
      'level': 2,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a small leather loop or a piece of golden wire)',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'One creature or object of your choice that you can see within range rises vertically, up to 20 feet, and remains suspended there for the duration. The spell can levitate a target that weighs up to 500 pounds. An unwilling creature that succeeds on a Constitution saving throw is unaffected.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_mirror_image',
    category: 'spell',
    name: 'Mirror Image',
    summary:
        'Create three illusory duplicates of yourself: attacks may strike the duplicates instead of you.',
    data: {
      'level': 2,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S',
      'duration': '1 minute',
      'classes': ['sorcerer', 'warlock', 'wizard'],
      'description':
          'Three illusory duplicates of yourself appear in your space. Until the spell ends, the duplicates move with you and mimic your actions, shifting position so it\'s impossible to track which image is real. Each time a creature targets you with an attack during the spell\'s duration, roll a d20 to determine whether the attack instead targets one of your duplicates.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_misty_step',
    category: 'spell',
    name: 'Misty Step',
    summary:
        'Bonus action: Briefly surrounded by silvery mist, teleport up to 30 feet to an unoccupied space.',
    data: {
      'level': 2,
      'school': 'Conjuration',
      'castingTime': '1 bonus action',
      'range': 'Self',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'warlock', 'wizard'],
      'description':
          'Briefly surrounded by silvery mist, you teleport up to 30 feet to an unoccupied space that you can see.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_moonbeam',
    category: 'spell',
    name: 'Moonbeam',
    summary:
        'Silvery cylinder deals 2d10 radiant damage (CON save half); shapechangers have disadv on save.',
    data: {
      'level': 2,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components':
          'V, S, M (several seeds of any moonseed plant and a piece of opalescent feldspar)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['druid'],
      'description':
          'A silvery beam of pale light shines down in a 5-foot-radius, 40-foot-high cylinder centered on a point within range. When a creature enters the spell\'s area for the first time on a turn or starts its turn there, it is engulfed in ghostly flames that cause searing pain, and it must make a Constitution saving throw. It takes 2d10 radiant damage on a failed save, or half as much on a successful one. A shapechanger makes its saving throw with disadvantage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_pass_without_trace',
    category: 'spell',
    name: 'Pass without Trace',
    summary:
        'A veil of shadows masks chosen companions within 30 ft: +10 bonus to Stealth and leave no tracks.',
    data: {
      'level': 2,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Self',
      'components':
          'V, S, M (ashes from a burned leaf of mistletoe and a sprig of spruce)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['druid', 'ranger'],
      'description':
          'A veil of shadows and silence radiates from you, masking you and your companions from detection. For the duration, each creature you choose within 30 feet of you (including you) has a +10 bonus to Dexterity (Stealth) checks and can\'t be tracked except by magical means. A creature that receives this bonus leaves behind no tracks or other traces of its passage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_prayer_of_healing',
    category: 'spell',
    name: 'Prayer of Healing',
    summary:
        'Up to six creatures of your choice within 30 feet regain 2d8 + spellcasting modifier HP.',
    data: {
      'level': 2,
      'school': 'Evocation',
      'castingTime': '10 minutes',
      'range': '30 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['cleric'],
      'description':
          'Up to six creatures of your choice that you can see within range each regain hit points equal to 2d8 + your spellcasting ability modifier. This spell has no effect on undead or constructs.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_scorching_ray',
    category: 'spell',
    name: 'Scorching Ray',
    summary:
        'Hurls 3 rays of fire: make a ranged spell attack for each ray dealing 2d6 fire damage on hit.',
    data: {
      'level': 2,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You create three rays of fire and hurl them at targets within range. You can hurl them at one target or several. Make a ranged spell attack for each ray. On a hit, the target takes 2d6 fire damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_see_invisibility',
    category: 'spell',
    name: 'See Invisibility',
    summary:
        'See invisible creatures and objects as if they were visible, and see into the Ethereal Plane.',
    data: {
      'level': 2,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Self',
      'components':
          'V, S, M (a pinch of talc and a small sprinkling of powdered silver)',
      'duration': '1 hour',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'For the duration, you see invisible creatures and objects as if they were concentrated visible, and you can see into the Ethereal Plane. Ethereal creatures and objects appear ghostly and translucent.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_shatter',
    category: 'spell',
    name: 'Shatter',
    summary:
        'A sudden loud ringing noise painfully buffets creatures in a 10-ft sphere for 3d8 thunder damage (CON save half).',
    data: {
      'level': 2,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a chip of mica)',
      'duration': 'Instantaneous',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'A sudden loud ringing noise, painfully intense, erupts from a point of your choice within range. Each creature in a 10-foot-radius sphere centered on that point must make a Constitution saving throw. A creature takes 3d8 thunder damage on a failed save, or half as much damage on a successful one. A creature made of inorganic material such as stone, crystal, or metal has disadvantage on this saving throw.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_silence',
    category: 'spell',
    name: 'Silence',
    summary:
        'No sound can be created or pass through a 20-foot sphere. Immune to thunder damage and prevents verbal casting. Ritual.',
    data: {
      'level': 2,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 10 minutes',
      'ritual': true,
      'classes': ['bard', 'cleric', 'ranger'],
      'description':
          'For the duration, no sound can be created within or pass through a 20-foot-radius sphere centered on a point you choose within range. Any creature or object entirely inside the sphere is immune to thunder damage, and creatures are deafened while entirely inside it. Casting a spell that includes a verbal component is impossible there.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_spiritual_weapon',
    category: 'spell',
    name: 'Spiritual Weapon',
    summary:
        'Bonus action: Create a floating spectral weapon that attacks for 1d8 + spellcasting modifier force damage.',
    data: {
      'level': 2,
      'school': 'Evocation',
      'castingTime': '1 bonus action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': '1 minute',
      'classes': ['cleric'],
      'description':
          'You create a floating, spectral weapon within range that lasts for the duration or until you cast this spell again. When you cast the spell, you can make a melee spell attack against a creature within 5 feet of the weapon. On a hit, the target takes force damage equal to 1d8 + your spellcasting ability modifier. As a bonus action on your turn, you can move the weapon up to 20 feet and repeat the attack.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_suggestion',
    category: 'spell',
    name: 'Suggestion',
    summary:
        'Suggest a course of activity to a creature that must follow it on a failed WIS save for up to 8 hours.',
    data: {
      'level': 2,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '30 feet',
      'components':
          'V, M (a snake\'s tongue and either a bit of honeycomb or a drop of sweet oil)',
      'duration': 'Concentration, up to 8 hours',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You suggest a course of activity (limited to a sentence or two) and magically influence a creature you can see within range that can hear and understand you. Creatures that can\'t be charmed are immune to this effect. The suggestion must be worded in such a manner as to make the course of action sound reasonable. The target must make a Wisdom saving throw. On a failed save, it pursues the course of action you described.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_web',
    category: 'spell',
    name: 'Web',
    summary:
        'Thick, sticky webs fill a 20-foot cube: difficult terrain, lightly obscured, and restrains creatures on failed DEX save.',
    data: {
      'level': 2,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a bit of spiderweb)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You conjure a mass of thick, sticky webbing at a point of your choice within range. The webs fill a 20-foot cube from that point for the duration. The webs are difficult terrain and lightly obscure their area. If the webs aren\'t anchored between two solid masses or layered across a floor, wall, or ceiling, the conjured web collapses on itself at the start of your next turn. Each creature that starts its turn in the webs or that enters them during its turn must make a Dexterity saving throw or be restrained.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_zone_of_truth',
    category: 'spell',
    name: 'Zone of Truth',
    summary:
        'Creates a magical zone in a 15-ft radius that prevents creatures from speaking deliberate lies on failed CHA save.',
    data: {
      'level': 2,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': '10 minutes',
      'classes': ['bard', 'cleric', 'paladin'],
      'description':
          'You create a magical zone that guards against deception in a 15-foot-radius sphere centered on a point of your choice within range. Until the spell ends, a creature that enters the spell\'s area for the first time on a turn or starts its turn there must make a Charisma saving throw. On a failed save, a creature can\'t speak a deliberate lie while in the radius. You know whether each creature succeeds or fails on its saving throw.',
    },
  ),
];
