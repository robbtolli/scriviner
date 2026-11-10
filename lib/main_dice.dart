import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/legal/license_registration.dart';
import 'dice_app.dart';

/// Entrypoint for the standalone Dice Caster application.
/// Run via: flutter run -t lib/main_dice.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerScrivenerLicenses();
  runApp(const ProviderScope(child: DiceCasterApp()));
}
