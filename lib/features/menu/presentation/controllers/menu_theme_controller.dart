import 'package:get/get.dart';
import '../../../../core/services/toast_service.dart';
import '../../domain/models/template_model.dart';
import '../../domain/models/session_model.dart';
import '../../domain/repositories/menu_repository.dart';

class MenuThemeController extends GetxController {
  final MenuRepository _repository;

  final templates = <TemplateModel>[].obs;
  final sessions = <SessionModel>[].obs;

  final isLoadingTemplates = false.obs;
  final isLoadingSessions = false.obs;
  final isPublishing = false.obs;

  MenuThemeController(this._repository);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData({bool forceRefresh = false}) async {
    fetchTemplates(forceRefresh: forceRefresh);
    fetchSessions(forceRefresh: forceRefresh);
  }

  Future<void> fetchTemplates({bool forceRefresh = false}) async {
    isLoadingTemplates.value = true;
    final result = await _repository.getTemplates(forceRefresh: forceRefresh);
    isLoadingTemplates.value = false;
    result.fold(
      (failure) => ToastService.showError("Failed to load templates: ${failure.message}"),
      (list) => templates.assignAll(list),
    );
  }

  Future<void> fetchSessions({bool forceRefresh = false}) async {
    isLoadingSessions.value = true;
    final result = await _repository.getSessions(forceRefresh: forceRefresh);
    isLoadingSessions.value = false;
    result.fold(
      (failure) => ToastService.showError("Failed to load sessions: ${failure.message}"),
      (list) => sessions.assignAll(list),
    );
  }

  Future<void> selectTheme(int templateId) async {
    // Map current templates list and set active
    final updatedList = templates.map((t) =>
      t.copyWith(isActive: t.id == templateId)
    ).toList();
    templates.assignAll(updatedList);

    // Call update API Mocked or Direct patch
    final target = templates.firstWhere((t) => t.id == templateId);
    final result = await _repository.updateTheme(
      id: templateId,
      primaryColor: target.primaryColor,
      backgroundColor: target.backgroundColor,
      textColor: target.textColor,
    );

    result.fold(
      (failure) {
        ToastService.showError("Failed to switch theme: ${failure.message}");
        loadData(forceRefresh: true); // Rollback state
      },
      (_) => ToastService.showSuccess("Active Theme updated successfully"),
    );
  }

  Future<void> updateThemeColors({
    required int id,
    required String primary,
    required String bg,
    required String text,
  }) async {
    final result = await _repository.updateTheme(
      id: id,
      primaryColor: primary,
      backgroundColor: bg,
      textColor: text,
    );

    result.fold(
      (failure) => ToastService.showError("Failed to update colors: ${failure.message}"),
      (updated) {
        final idx = templates.indexWhere((t) => t.id == id);
        if (idx != -1) {
          templates[idx] = updated;
        }
        ToastService.showSuccess("Theme color palette updated successfully");
      },
    );
  }

  Future<void> updateSessionSettings(int sessionId, Map<String, dynamic> data) async {
    final result = await _repository.updateSession(id: sessionId, data: data);
    result.fold(
      (failure) => ToastService.showError("Failed to update session: ${failure.message}"),
      (updated) {
        final idx = sessions.indexWhere((s) => s.id == sessionId);
        if (idx != -1) {
          sessions[idx] = updated;
        }
        ToastService.showSuccess("Session configurations updated successfully");
      },
    );
  }

  Future<void> publishMenuChanges() async {
    isPublishing.value = true;
    final result = await _repository.publishMenu();
    isPublishing.value = false;
    result.fold(
      (failure) => ToastService.showError("Failed to publish changes: ${failure.message}"),
      (_) => ToastService.showSuccess("Digital Menu changes published successfully!"),
    );
  }
}
