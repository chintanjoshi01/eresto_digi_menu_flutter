import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/models/auth_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  AuthRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<Either<ApiException, AuthModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final authModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      
      // Save local session state
      await _storageService.saveToken(authModel.token);
      await _storageService.saveRestoId(authModel.restoId);
      
      return Right(authModel);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _storageService.clear();
      return const Right(null);
    } on ApiException catch (e) {
      await _storageService.clear(); // Safe clean local data anyway
      return Left(e);
    } catch (e) {
      await _storageService.clear();
      return Left(ApiException(message: e.toString()));
    }
  }
}
