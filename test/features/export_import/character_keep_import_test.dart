import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/features/export_import/services/character_export_service.dart';

void main() {
  late AppDatabase db;
  late CharacterExportService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = CharacterExportService();
  });

  tearDown(() async {
    await db.close();
  });

  group('Character Keep Converted Import Verification', () {
    test('imports Kaun Cro Where successfully', () async {
      final file = File('/home/robb/Downloads/Kaun Cro Where.scrivener.json');
      expect(file.existsSync(), isTrue);

      final jsonContent = await file.readAsString();
      final charId = await service.importCharacterFromJson(
        db,
        jsonContent,
        generateNewId: true,
      );
      expect(charId.isNotEmpty, isTrue);

      final character = await db.getCharacter(charId);
      expect(character, isNotNull);
      expect(character!.name, 'Kaun Cro Where');

      final inventory = await db.getInventoryForCharacter(charId);
      expect(inventory.length, greaterThanOrEqualTo(10));
    });

    test('imports Leslie Thorntail (Sorcerer) successfully', () async {
      final file = File('/home/robb/Downloads/Leslie Thorntail.scrivener.json');
      expect(file.existsSync(), isTrue);

      final jsonContent = await file.readAsString();
      final charId = await service.importCharacterFromJson(
        db,
        jsonContent,
        generateNewId: true,
      );
      expect(charId.isNotEmpty, isTrue);

      final character = await db.getCharacter(charId);
      expect(character, isNotNull);
      expect(character!.name, 'Leslie Thorntail');

      final inventory = await db.getInventoryForCharacter(charId);
      expect(inventory.length, greaterThanOrEqualTo(10));
    });

    test('imports Selunara Alice Tirnothil successfully', () async {
      final file = File(
        '/home/robb/Downloads/Selunara Alice Tirnothil.scrivener.json',
      );
      expect(file.existsSync(), isTrue);

      final jsonContent = await file.readAsString();
      final charId = await service.importCharacterFromJson(
        db,
        jsonContent,
        generateNewId: true,
      );
      expect(charId.isNotEmpty, isTrue);

      final character = await db.getCharacter(charId);
      expect(character, isNotNull);
      expect(character!.name, 'Selunara Alice Tirnothil');

      final inventory = await db.getInventoryForCharacter(charId);
      expect(inventory.length, greaterThanOrEqualTo(10));
    });

    test('imports raw Character Keep .txt export directly', () async {
      final file = File('/home/robb/Downloads/Leslie Thorntail.txt');
      expect(file.existsSync(), isTrue);

      final rawText = await file.readAsString();
      final charId = await service.importCharacterFromJson(
        db,
        rawText,
        generateNewId: true,
      );
      expect(charId.isNotEmpty, isTrue);

      final character = await db.getCharacter(charId);
      expect(character, isNotNull);
      expect(character!.name, 'Leslie Thorntail');

      final inventory = await db.getInventoryForCharacter(charId);
      expect(inventory.isNotEmpty, isTrue);
    });
  });
}
