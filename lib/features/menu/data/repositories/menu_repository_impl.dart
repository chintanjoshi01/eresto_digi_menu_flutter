import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/storage/database_service.dart';
import '../../../../core/storage/menu_collections.dart';
import '../../domain/models/template_model.dart';
import '../../domain/models/session_model.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource _remoteDataSource;
  final DatabaseService _dbService;

  MenuRepositoryImpl(this._remoteDataSource, this._dbService);

  @override
  Future<Either<ApiException, List<TemplateModel>>> getTemplates({bool forceRefresh = false}) async {
    final isar = _dbService.isar;
    if (!forceRefresh) {
      final cached = await isar.menuTemplateCollections.where().findAll();
      if (cached.isNotEmpty) {
        final models = cached.map((t) => TemplateModel(
          id: t.remoteId,
          name: t.name,
          primaryColor: t.primaryColor,
          backgroundColor: t.backgroundColor,
          textColor: t.textColor,
          isActive: t.isActive,
        )).toList();
        return Right(models);
      }
    }

    try {
      final remoteList = await _remoteDataSource.getTemplates();
      await isar.writeTxn(() async {
        for (final item in remoteList) {
          final existing = await isar.menuTemplateCollections.filter().remoteIdEqualTo(item.id).findFirst();
          final dbObj = existing ?? MenuTemplateCollection()..remoteId = item.id;
          dbObj.name = item.name;
          dbObj.primaryColor = item.primaryColor;
          dbObj.backgroundColor = item.backgroundColor;
          dbObj.textColor = item.textColor;
          dbObj.isActive = item.isActive;
          await isar.menuTemplateCollections.put(dbObj);
        }
      });
      return Right(remoteList);
    } catch (e) {
      final cached = await isar.menuTemplateCollections.where().findAll();
      if (cached.isNotEmpty) {
        final models = cached.map((t) => TemplateModel(
          id: t.remoteId,
          name: t.name,
          primaryColor: t.primaryColor,
          backgroundColor: t.backgroundColor,
          textColor: t.textColor,
          isActive: t.isActive,
        )).toList();
        return Right(models);
      }
      if (e is ApiException) return Left(e);
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, TemplateModel>> updateTheme({
    required int id,
    required String primaryColor,
    required String backgroundColor,
    required String textColor,
  }) async {
    final isar = _dbService.isar;
    try {
      final updated = await _remoteDataSource.updateTheme(
        id: id,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
        textColor: textColor,
      );
      final existing = await isar.menuTemplateCollections.filter().remoteIdEqualTo(id).findFirst();
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.primaryColor = primaryColor;
          existing.backgroundColor = backgroundColor;
          existing.textColor = textColor;
          await isar.menuTemplateCollections.put(existing);
        });
      }
      return Right(updated);
    } catch (e) {
      if (e is ApiException) return Left(e);
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, List<SessionModel>>> getSessions({bool forceRefresh = false}) async {
    final isar = _dbService.isar;
    if (!forceRefresh) {
      final cached = await isar.menuSessionCollections.where().findAll();
      if (cached.isNotEmpty) {
        final models = cached.map((s) => SessionModel(
          id: s.remoteId,
          name: s.name,
          startTime: s.startTime,
          endTime: s.endTime,
          isActive: s.isActive,
          splashImageUrl: s.splashImageUrl,
          offerImageUrl: s.offerImageUrl,
          offerDescription: s.offerDescription,
        )).toList();
        return Right(models);
      }
    }

    try {
      final remoteList = await _remoteDataSource.getSessions();
      await isar.writeTxn(() async {
        for (final item in remoteList) {
          final existing = await isar.menuSessionCollections.filter().remoteIdEqualTo(item.id).findFirst();
          final dbObj = existing ?? MenuSessionCollection()..remoteId = item.id;
          dbObj.name = item.name;
          dbObj.startTime = item.startTime;
          dbObj.endTime = item.endTime;
          dbObj.isActive = item.isActive;
          dbObj.splashImageUrl = item.splashImageUrl;
          dbObj.offerImageUrl = item.offerImageUrl;
          dbObj.offerDescription = item.offerDescription;
          await isar.menuSessionCollections.put(dbObj);
        }
      });
      return Right(remoteList);
    } catch (e) {
      final cached = await isar.menuSessionCollections.where().findAll();
      if (cached.isNotEmpty) {
        final models = cached.map((s) => SessionModel(
          id: s.remoteId,
          name: s.name,
          startTime: s.startTime,
          endTime: s.endTime,
          isActive: s.isActive,
          splashImageUrl: s.splashImageUrl,
          offerImageUrl: s.offerImageUrl,
          offerDescription: s.offerDescription,
        )).toList();
        return Right(models);
      }
      if (e is ApiException) return Left(e);
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, SessionModel>> updateSession({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final isar = _dbService.isar;
    try {
      final updated = await _remoteDataSource.updateSession(id: id, data: data);
      final existing = await isar.menuSessionCollections.filter().remoteIdEqualTo(id).findFirst();
      if (existing != null) {
        await isar.writeTxn(() async {
          existing.name = updated.name;
          existing.startTime = updated.startTime;
          existing.endTime = updated.endTime;
          existing.isActive = updated.isActive;
          existing.splashImageUrl = updated.splashImageUrl;
          existing.offerImageUrl = updated.offerImageUrl;
          existing.offerDescription = updated.offerDescription;
          await isar.menuSessionCollections.put(existing);
        });
      }
      return Right(updated);
    } catch (e) {
      if (e is ApiException) return Left(e);
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> publishMenu() async {
    try {
      await _remoteDataSource.publishMenu();
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(e);
      return Left(ApiException(message: e.toString()));
    }
  }
}
