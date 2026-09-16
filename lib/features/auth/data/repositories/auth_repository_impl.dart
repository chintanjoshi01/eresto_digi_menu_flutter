import 'package:dartz/dartz.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/storage_service.dart';
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
    try {
      await _remoteDataSource.logout();
      await _storageService.clearSession();
      return const Right(null);
    } on ApiException catch (e) {
      await _storageService.clearSession();
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      await _storageService.clearSession();
      return Left(_apiClient.mapExceptionToFailure(e));
    }
  }
}
