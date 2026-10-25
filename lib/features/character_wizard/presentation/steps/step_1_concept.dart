import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/srd_starter_data.dart';
import '../../models/wizard_draft.dart';
import '../../providers/wizard_provider.dart';

enum NameGender {
  male('Male'),
  female('Female');

  final String label;
  const NameGender(this.label);
}

class Step1Concept extends ConsumerStatefulWidget {
  const Step1Concept({super.key});

  @override
  ConsumerState<Step1Concept> createState() => _Step1ConceptState();
}

class _Step1ConceptState extends ConsumerState<Step1Concept> {
  late TextEditingController _nameController;
  NameGender _selectedGender = NameGender.male;

  static const List<String> _maleFirstNames = [
    'Eldrin',
    'Thorgar',
    'Aelar',
    'Doran',
    'Kaelen',
    'Morgran',
    'Roran',
    'Gareth',
    'Cedric',
    'Varis',
    'Brom',
    'Faelar',
    'Theris',
    'Orin',
    'Kazador',
    'Branden',
    'Soren',
    'Corin',
    'Tavian',
    'Jarek',
  ];

  static const List<String> _femaleFirstNames = [
    'Valthea',
    'Lyanna',
    'Kaelith',
    'Silaqui',
    'Andrea',
    'Morwen',
    'Talia',
    'Elenora',
    'Rowena',
    'Mira',
    'Seraphina',
    'Breena',
    'Bryn',
    'Dalia',
    'Yael',
    'Faelynn',
    'Kayla',
    'Vespera',
    'Shava',
    'Mara',
  ];

  static const List<String> _surnames = [
    'Swiftblade',
    'Stoneguard',
    'Moonwhisper',
    'Blackwood',
    'Brightflame',
    'Ironbreaker',
    'Stormchaser',
    'Deepdelver',
    'Dawnstrider',
    'Shadowweaver',
    'Silverthorn',
    'Oakenshield',
    'Fireforge',
    'Windrunner',
    'Starfall',
    'Frostmantle',
    'Ravenscar',
    'Goldseeker',
    'Wyrmbane',
    'Trueheart',
  ];

  @override
  void initState() {
    super.initState();
    final currentDraft = ref.read(characterWizardProvider);
    _nameController = TextEditingController(
      text: currentDraft.name,
    );
    if (currentDraft.gender == 'female') {
      _selectedGender = NameGender.female;
    } else {
      _selectedGender = NameGender.male;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _generateRandomName() {
    final rand = Random();
    final String firstName = _selectedGender == NameGender.female
        ? _femaleFirstNames[rand.nextInt(_femaleFirstNames.length)]
        : _maleFirstNames[rand.nextInt(_maleFirstNames.length)];

    final surname = _surnames[rand.nextInt(_surnames.length)];
    final fullName = '$firstName $surname';
    _nameController.text = fullName;
    ref.read(characterWizardProvider.notifier).setName(fullName);
    ref.read(characterWizardProvider.notifier).setGender(_selectedGender.name);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<WizardDraft>(characterWizardProvider, (previous, next) {
      if (next.name != _nameController.text) {
        _nameController.text = next.name;
      }
    });

    final draft = ref.watch(characterWizardProvider);
    final notifier = ref.read(characterWizardProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1: Character Concept & Identity',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Every great adventure begins with an identity. Give your hero a name and choose their combat archetype.',
            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              const Text(
                'CHARACTER NAME',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppTheme.primaryGold,
                ),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  const Text(
                    'Gender: ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SegmentedButton<NameGender>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: NameGender.male,
                        label: Text('Male'),
                        icon: Icon(Icons.male, size: 16),
                      ),
                      ButtonSegment(
                        value: NameGender.female,
                        label: Text('Female'),
                        icon: Icon(Icons.female, size: 16),
                      ),
                    ],
                    selected: {_selectedGender},
                    onSelectionChanged: (set) {
                      setState(() {
                        _selectedGender = set.first;
                        ref.read(characterWizardProvider.notifier).setGender(_selectedGender.name);
                      });
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Gandalf the Grey, Thorin Oakenshield',
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryGold),
                  ),
                  onChanged: (val) => notifier.setName(val),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _generateRandomName,
                icon: const Icon(Icons.casino, size: 18),
                label: const Text('RANDOM'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'COMBAT & PLAYSTYLE ARCHETYPE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Filter classes by what role you want to play in your party:',
            style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 13),
          ),
          const SizedBox(height: 12),
          ...PlaystyleArchetype.values.map((archetype) {
            final isSelected = draft.archetype == archetype;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  if (isSelected) {
                    notifier.setArchetype(null);
                  } else {
                    notifier.setArchetype(archetype);
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryGold.withAlpha(30) : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(20),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getArchetypeIcon(archetype),
                        color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(180),
                        size: 26,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              archetype.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isSelected ? AppTheme.primaryGold : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              archetype.description,
                              style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppTheme.primaryGold, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _getArchetypeIcon(PlaystyleArchetype archetype) {
    switch (archetype) {
      case PlaystyleArchetype.warrior:
        return Icons.shield;
      case PlaystyleArchetype.skirmisher:
        return Icons.navigation;
      case PlaystyleArchetype.divine:
        return Icons.favorite_border;
      case PlaystyleArchetype.arcane:
        return Icons.auto_awesome;
    }
  }
}
