import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exception.dart';
import '../models/template_model.dart';
import '../models/session_model.dart';

abstract class MenuRepository {
  // --- V6 Menu Builder APIs (Official) ---
  Future<Either<ApiException, Map<String, dynamic>>> getMenuBuilderData();
  Future<Either<ApiException, Map<String, dynamic>>> changeTheme({
    required int templateId,
    required int themeId,
  });
  Future<Either<ApiException, List<dynamic>>> getThemesCatalog();
  Future<Either<ApiException, Map<String, dynamic>>> updateChannelSession({
    required int sessionId,
    required String op,
    required Map<String, dynamic> sessionJson,
  });

  // --- Legacy Methods ---
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
