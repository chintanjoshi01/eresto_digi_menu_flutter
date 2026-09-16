import 'package:equatable/equatable.dart';

/// Base Failure class for Clean Architecture domain layer
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Generic server-side failure
class ServerFailure extends Failure {
  final dynamic details;

  const ServerFailure(super.message, {super.statusCode, this.details});

  @override
  List<Object?> get props => [message, statusCode, details];
}

/// Network connectivity / timeout failure
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "Unable to connect to the server. Please check your internet connection."]);
}

/// Authentication / Token expiration failure (HTTP 401)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = "Session expired. Please log in again."])
      : super(statusCode: 401);
}

/// App upgrade required (force: 1 or force: 2 / error_code: UPGRADE-APP)
class AppUpgradeRequiredFailure extends Failure {
  final int force; // 1 = optional, 2 = mandatory force
  final String? storeUrl;

  const AppUpgradeRequiredFailure(
    super.message, {
    this.force = 1,
    this.storeUrl,
  });

  @override
  List<Object?> get props => [message, force, storeUrl];
}

/// Forced password change required (status: 9)
class PasswordChangeRequiredFailure extends Failure {
  const PasswordChangeRequiredFailure([super.message = "Login successful. Please change your password."])
      : super(statusCode: 200);
}

/// Product or Module authorization permission failure
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Field validation errors (e.g. HTTP 404 with field maps)
class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure(super.message, {this.fieldErrors = const {}});

  @override
  List<Object?> get props => [message, fieldErrors];
}
