import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/legal/license_registration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerScrivenerLicenses();
  runApp(const ProviderScope(child: ScrivenerApp()));
}
