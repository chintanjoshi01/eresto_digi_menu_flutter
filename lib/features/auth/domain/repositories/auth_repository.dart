import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/v6_login_request.dart';
import '../models/v6_login_response.dart';

/// Domain repository contract for Authentication
abstract class AuthRepository {
  Future<Either<Failure, V6LoginResponse>> login(V6LoginRequest request);
  Future<Either<Failure, void>> logout();
}
