import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/legal/license_registration.dart';
import 'dice_app.dart';

/// Returns the root application widget for the given Flutter [flavor].
Widget rootAppForFlavor(String? flavor) {
  return switch (flavor) {
    'dice' => const DiceCasterApp(),
    _ => const ScrivenerApp(),
  };
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerScrivenerLicenses();
  runApp(ProviderScope(child: rootAppForFlavor(appFlavor)));
}
