import 'package:get/get.dart';
import '../../domain/dashboard_model.dart';
import '../../domain/repositories/dashboard_repository.dart';

class MenuDashboardController extends GetxController with StateMixin<DashboardModel> {
  final DashboardRepository _repository;

  final selectedPeriod = 'today'.obs;

  MenuDashboardController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics({bool forceRefresh = false}) async {
    change(null, status: RxStatus.loading());
    final result = await _repository.getAnalytics(
      period: selectedPeriod.value,
      forceRefresh: forceRefresh,
    );
    result.fold(
      (failure) => change(null, status: RxStatus.error(failure.message)),
      (data) => change(data, status: RxStatus.success()),
    );
  }

  void changePeriod(String period) {
    if (selectedPeriod.value != period) {
      selectedPeriod.value = period;
      fetchAnalytics();
    }
  }
}
