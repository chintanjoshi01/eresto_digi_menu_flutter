import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exception.dart';
import '../models/template_model.dart';
import '../models/session_model.dart';

abstract class MenuRepository {
  Future<Either<ApiException, List<TemplateModel>>> getTemplates({bool forceRefresh = false});
  Future<Either<ApiException, TemplateModel>> updateTheme({
    required int id,
    required String primaryColor,
    required String backgroundColor,
    required String textColor,
  });
  
  Future<Either<ApiException, List<SessionModel>>> getSessions({bool forceRefresh = false});
  Future<Either<ApiException, SessionModel>> updateSession({
    required int id,
    required Map<String, dynamic> data,
  });
  
  Future<Either<ApiException, void>> publishMenu();
}
