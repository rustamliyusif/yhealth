import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';
import 'storage_service.dart';

class BackupException implements Exception {
  final String code;
  BackupException(this.code);

  @override
  String toString() => 'BackupException($code)';
}

class BackupService {
  static const String format = 'yhealth-backup';
  static const int formatVersion = 1;

  final AppDatabase _db;
  final StorageService _storage;

  BackupService(this._db, this._storage);

  Future<Map<String, dynamic>> buildBackup() async {
    return {
      'format': format,
      'formatVersion': formatVersion,
      'schemaVersion': _db.schemaVersion,
      'createdAt': DateTime.now().toIso8601String(),
      'preferences': _storage.exportPreferences(),
      'tables': {
        'dailyActivity': (await _db.select(_db.dailyActivityEntries).get()).map((e) => e.toJson()).toList(),
        'savedRoutes': (await _db.select(_db.savedRoutesEntries).get()).map((e) => e.toJson()).toList(),
        'migrationMetadata': (await _db.select(_db.migrationMetadataEntries).get()).map((e) => e.toJson()).toList(),
        'sleepRecords': (await _db.select(_db.sleepRecordsEntries).get()).map((e) => e.toJson()).toList(),
        'weeklyReports': (await _db.select(_db.weeklyReportsEntries).get()).map((e) => e.toJson()).toList(),
        'weightRecords': (await _db.select(_db.weightRecordsEntries).get()).map((e) => e.toJson()).toList(),
        'coachMessages': (await _db.select(_db.coachMessagesEntries).get()).map((e) => e.toJson()).toList(),
      },
    };
  }

  Future<String> exportToFile() async {
    final backup = await buildBackup();
    final dir = await getTemporaryDirectory();
    final now = DateTime.now();
    final stamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
        '-${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    final file = File(p.join(dir.path, 'yhealth-backup-$stamp.json'));
    await file.writeAsString(jsonEncode(backup), flush: true);
    return file.path;
  }

  Future<void> importFromFile(String path) async {
    final Map<String, dynamic> backup;
    try {
      backup = jsonDecode(await File(path).readAsString()) as Map<String, dynamic>;
    } catch (_) {
      throw BackupException('invalid_file');
    }
    await restoreBackup(backup);
  }

  Future<void> restoreBackup(Map<String, dynamic> backup) async {
    if (backup['format'] != format) throw BackupException('invalid_file');
    final version = backup['formatVersion'];
    if (version is! int || version > formatVersion) throw BackupException('unsupported_version');

    final tables = backup['tables'];
    if (tables is! Map<String, dynamic>) throw BackupException('invalid_file');

    List<Map<String, dynamic>> rows(String key) {
      final list = tables[key];
      if (list == null) return const [];
      return (list as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }

    try {
      await _db.transaction(() async {
        await _replace(_db.dailyActivityEntries, rows('dailyActivity').map(DailyActivityEntry.fromJson));
        await _replace(_db.savedRoutesEntries, rows('savedRoutes').map(SavedRoutesEntry.fromJson));
        await _replace(_db.migrationMetadataEntries, rows('migrationMetadata').map(MigrationMetadataEntry.fromJson));
        await _replace(_db.sleepRecordsEntries, rows('sleepRecords').map(SleepRecordsEntry.fromJson));
        await _replace(_db.weeklyReportsEntries, rows('weeklyReports').map(WeeklyReportsEntry.fromJson));
        await _replace(_db.weightRecordsEntries, rows('weightRecords').map(WeightRecordsEntry.fromJson));
        await _replace(_db.coachMessagesEntries, rows('coachMessages').map(CoachMessagesEntry.fromJson));
      });
    } on BackupException {
      rethrow;
    } catch (_) {
      throw BackupException('invalid_file');
    }

    final prefs = backup['preferences'];
    if (prefs is Map<String, dynamic>) {
      await _storage.importPreferences(prefs);
    }
  }

  Future<void> _replace<T extends Table, D extends DataClass>(
    TableInfo<T, D> table,
    Iterable<D> entries,
  ) async {
    final list = entries.toList();
    await _db.delete(table).go();
    if (list.isEmpty) return;
    await _db.batch((batch) {
      batch.insertAll(table, list.cast<Insertable<D>>(), mode: InsertMode.insertOrReplace);
    });
  }
}
