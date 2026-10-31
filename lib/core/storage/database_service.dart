import 'dart:io';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../services/logger_service.dart';
import 'menu_collections.dart';

class DatabaseService extends GetxService {
  Isar? _isar;

  /// Safe nullable getter for Isar instance. Returns null if database failed to open.
  Isar? get isar => _isar;

  /// Returns non-nullable Isar instance. Must only be called when [isReady] is true.
  Isar getIsar() {
    final instance = _isar;
    if (instance == null) {
      throw StateError('Isar database is not initialized or failed to open.');
    }
    return instance;
  }

  /// Returns true if Isar database is successfully opened and ready for queries.
  bool get isReady => _isar != null && _isar!.isOpen;

  LoggerService? get _log => Get.isRegistered<LoggerService>() ? Get.find<LoggerService>() : null;

  Future<DatabaseService> init() async {
    try {
      await _initIsar();
    } catch (e, stack) {
      _log?.e("Failed to initialize Isar database", error: e, stackTrace: stack);
    }
    return this;
  }

  Future<void> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    const schemas = [
      MenuItemCollectionSchema,
      MenuTemplateCollectionSchema,
      MenuSessionCollectionSchema,
      DashboardAnalyticsCollectionSchema,
    ];
    try {
      _isar = await Isar.open(
        schemas,
        directory: dir.path,
        name: 'default',
      );
      _log?.i("Isar database initialized successfully at: ${dir.path}");
    } catch (e) {
      _log?.w(
        "Primary Isar.open() failed (likely corrupt database or schema mismatch). Attempting auto-recovery: $e",
      );

      // Automatic Recovery Mode: Delete corrupt database files and retry
      try {
        final dbFile = File('${dir.path}/default.isar');
        final lockFile = File('${dir.path}/default.isar.lock');

        if (await dbFile.exists()) {
          await dbFile.delete();
          _log?.i("Deleted corrupt database file: default.isar");
        }
        if (await lockFile.exists()) {
          await lockFile.delete();
          _log?.i("Deleted lock file: default.isar.lock");
        }

        // Retry opening Isar after clearing corrupt local state
        _isar = await Isar.open(
          schemas,
          directory: dir.path,
          name: 'default',
        );
        _log?.i("Isar database successfully recovered and reopened.");
      } catch (recoveryError, recoveryStack) {
        _log?.e(
          "Critical: Isar database recovery failed. Application will fallback to remote V6 API.",
          error: recoveryError,
          stackTrace: recoveryStack,
        );
        _isar = null;
      }
    }
  }

  Future<void> clearAll() async {
    await clearAllData();
  }

  Future<void> clearAllData() async {
    final db = _isar;
    if (db != null && db.isOpen) {
      await db.writeTxn(() async {
        await db.clear();
      });
      _log?.i("Cleared all Isar local data");
    }
  }
}
