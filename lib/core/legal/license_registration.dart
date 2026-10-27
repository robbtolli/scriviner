import 'package:flutter/foundation.dart';

/// Registers Scrivener's Mozilla Public License 2.0 and bundled D&D 5e SRD 5.1
/// Creative Commons (CC-BY-4.0) attribution into Flutter's [LicenseRegistry].
void registerScrivenerLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['scrivener'],
      '''Mozilla Public License Version 2.0
Copyright (c) 2026 Robert Tolliver (tollitech.com)

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/.''',
    );

    yield const LicenseEntryWithLineBreaks(
      ['dnd5e_srd_5.1'],
      '''System Reference Document 5.1 (SRD 5.1)
Copyright (c) 2023 Wizards of the Coast LLC

This work includes material taken from the System Reference Document 5.1
("SRD 5.1") by Wizards of the Coast LLC and available at:
https://dnd.wizards.com/resources/systems-reference-document

The SRD 5.1 is licensed under the Creative Commons Attribution 4.0
International License available at:
https://creativecommons.org/licenses/by/4.0/legalcode''',
    );
  });
}
