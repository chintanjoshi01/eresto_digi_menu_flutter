import 'package:dartz/dartz.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/database_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../items/data/repositories/items_repository_impl.dart';
import '../../domain/models/v6_login_request.dart';
import '../../domain/models/v6_login_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Enterprise Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService;
  final ApiClient _apiClient;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._storageService,
    this._apiClient,
  );

  @override
  Future<Either<Failure, V6LoginResponse>> login(V6LoginRequest request) async {
    try {
      final response = await _remoteDataSource.login(request);

      // On successful authentication, automatically persist the full session
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        await _storageService.saveV6Session(
          token: data.token,
          restoId: data.restoId,
          defResto: data.defResto,
          userId: data.userId,
          userName: data.userName,
          shortName: data.shortName,
          email: data.email,
          mobile: data.mobile,
          roleId: data.roleId,
          productId: data.productId,
          subscription: data.subscription,
          validity: data.validity,
          treasureUrl: data.treasure,
          mods: data.mods,
          pids: data.pids,
          mids: data.mids,
          restoLocation: data.restoLocation,
        );
      }

      return Right(response);
    } on ApiException catch (e) {
      if (e.statusCode == 0) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.message, statusCode: e.statusCode, details: e.details));
    } catch (e) {
      return Left(_apiClient.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // 1. Attempt remote logout on server
    try {
      await _remoteDataSource.logout();
    } catch (_) {
      // Ignore remote errors (e.g. offline, timeout, expired token)
      // to ensure local data wiping is NEVER blocked.
    }

    // 2. Clear Session & Storage (Preserves device_id)
    await _storageService.clearSession();

    // 3. Clear Local Offline NoSQL Database (Isar: items, templates, sessions, analytics)
    if (Get.isRegistered<DatabaseService>()) {
      await Get.find<DatabaseService>().clearAll();
    }

    // 4. Clear static in-memory lookup cache
    ItemsRepositoryImpl.clearCache();

    // 5. Clear In-Memory and Disk Image Cache
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      await DefaultCacheManager().emptyCache();
    } catch (_) {}

    return const Right(null);
  }
}
