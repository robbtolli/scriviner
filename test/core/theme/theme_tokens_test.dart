import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/theme/app_theme.dart';
import 'package:scrivener/core/theme/models/scrivener_theme_tokens.dart';

void main() {
  group('ScrivenerThemeTokens Unit & Integration Tests', () {
    test(
      'Every AppThemeMode attaches a valid ScrivenerThemeTokens extension',
      () {
        for (final mode in AppThemeMode.values) {
          final theme = AppTheme.getThemeData(mode);
          final tokens = theme.extension<ScrivenerThemeTokens>();

          expect(
            tokens,
            isNotNull,
            reason: 'Tokens missing for ${mode.displayName}',
          );
          expect(tokens!.cardGradient, isNotNull);
          expect(tokens.cardBorder, isNotNull);
          expect(tokens.cardRadius, greaterThan(0));
          expect(tokens.cardPadding, isNotNull);
          expect(tokens.iconography, isNotNull);
          expect(tokens.navigationStyle, isNotNull);
          expect(tokens.tabContentStyle, isNotNull);
        }
      },
    );

    test('Theme-specific navigation and tab content configuration rules', () {
      // 1. Ancient Tome: standard horizontal tabs, icons + text
      final ancient = AppTheme.getThemeData(
        AppThemeMode.ancientTome,
      ).extension<ScrivenerThemeTokens>()!;
      expect(ancient.navigationStyle, CharacterNavigationStyle.horizontalTabs);
      expect(ancient.tabContentStyle, CharacterTabContentStyle.iconsAndText);

      // 2. Scholar's Desk: standard horizontal tabs, text only
      final scholar = AppTheme.getThemeData(
        AppThemeMode.scholarsDesk,
      ).extension<ScrivenerThemeTokens>()!;
      expect(scholar.navigationStyle, CharacterNavigationStyle.horizontalTabs);
      expect(scholar.tabContentStyle, CharacterTabContentStyle.textOnly);

      // 3. Midnight Arcana: standard horizontal tabs, icons + text
      final arcana = AppTheme.getThemeData(
        AppThemeMode.midnightArcana,
      ).extension<ScrivenerThemeTokens>()!;
      expect(arcana.navigationStyle, CharacterNavigationStyle.horizontalTabs);
      expect(arcana.tabContentStyle, CharacterTabContentStyle.iconsAndText);

      // 4. Dungeon OLED: header dropdown, icons + text
      final dungeon = AppTheme.getThemeData(
        AppThemeMode.dungeonOled,
      ).extension<ScrivenerThemeTokens>()!;
      expect(dungeon.navigationStyle, CharacterNavigationStyle.headerDropdown);
      expect(dungeon.tabContentStyle, CharacterTabContentStyle.iconsAndText);

      // 5. Emerald Enclave: horizontal tabs, icons + text
      final enclave = AppTheme.getThemeData(
        AppThemeMode.emeraldEnclave,
      ).extension<ScrivenerThemeTokens>()!;
      expect(enclave.navigationStyle, CharacterNavigationStyle.horizontalTabs);
      expect(enclave.tabContentStyle, CharacterTabContentStyle.iconsAndText);

      // 6. Infernal Brimstone: header dropdown, icons only
      final brimstone = AppTheme.getThemeData(
        AppThemeMode.infernalBrimstone,
      ).extension<ScrivenerThemeTokens>()!;
      expect(
        brimstone.navigationStyle,
        CharacterNavigationStyle.headerDropdown,
      );
      expect(brimstone.tabContentStyle, CharacterTabContentStyle.iconsOnly);
    });

    test('ScrivenerThemeTokens copyWith and lerp', () {
      final base = ScrivenerThemeTokens.ancientTomeTokens;
      final modified = base.copyWith(
        cardRadius: 24.0,
        navigationStyle: CharacterNavigationStyle.headerDropdown,
      );

      expect(modified.cardRadius, 24.0);
      expect(modified.navigationStyle, CharacterNavigationStyle.headerDropdown);
      expect(modified.tabContentStyle, base.tabContentStyle);

      final lerped = base.lerp(modified, 0.5);
      expect(lerped, isA<ScrivenerThemeTokens>());
      expect(lerped.cardRadius, 18.0); // (12 + 24) / 2
    });

    testWidgets(
      'BuildContextThemeX extensions retrieve theme and tokens correctly',
      (tester) async {
        late BuildContext capturedContext;

        final theme = AppTheme.getThemeData(AppThemeMode.emeraldEnclave);

        await tester.pumpWidget(
          Theme(
            data: theme,
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(
          capturedContext.theme.colorScheme.primary,
          const Color(0xFF00E676),
        );
        expect(capturedContext.tokens.cardRadius, 12.0);
        expect(capturedContext.icons.tabStats, Icons.forest_outlined);
      },
    );
  });
}
