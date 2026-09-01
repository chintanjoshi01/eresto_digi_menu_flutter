import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exception.dart';
import '../models/auth_model.dart';

abstract class AuthRepository {
  Future<Either<ApiException, AuthModel>> login({
    required String email,
    required String password,
  });
  Future<Either<ApiException, void>> logout();
}
