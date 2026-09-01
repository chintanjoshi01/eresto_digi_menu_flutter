import 'package:get/get.dart';
import '../../../../core/services/toast_service.dart';
import '../../domain/models/item_model.dart';
import '../../domain/repositories/items_repository.dart';

class ItemsController extends GetxController with StateMixin<List<ItemModel>> {
  final ItemsRepository _repository;

  final searchText = ''.obs;
  final selectedCategory = ''.obs;
  final categoriesList = <String>[].obs;

  ItemsController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems({bool forceRefresh = false}) async {
    change(null, status: RxStatus.loading());
    final result = await _repository.getItems(
      category: selectedCategory.value,
      search: searchText.value,
      forceRefresh: forceRefresh,
    );

    result.fold(
      (failure) => change(null, status: RxStatus.error(failure.message)),
      (items) {
        // Extract unique categories for filter tabs dynamically if empty
        if (categoriesList.isEmpty) {
          final categories = items.map((e) => e.itemGroup).toSet().toList();
          categoriesList.assignAll(categories);
        }
        change(items, status: RxStatus.success());
      },
    );
  }

  Future<void> toggleAvailability(int itemId, bool isAvailable) async {
    if (state == null) return;

    // Optimistic Update
    final updatedList = state!.map((item) =>
      item.id == itemId ? item.copyWith(isAvailable: isAvailable) : item
    ).toList();
    change(updatedList, status: RxStatus.success());

    final result = await _repository.updateAvailability(id: itemId, isAvailable: isAvailable);
    result.fold(
      (failure) {
        // Rollback
        final rollbackList = state!.map((item) =>
          item.id == itemId ? item.copyWith(isAvailable: !isAvailable) : item
        ).toList();
        change(rollbackList, status: RxStatus.success());
        ToastService.showError("Failed to update availability: ${failure.message}");
      },
      (_) {
        ToastService.showSuccess("Item availability updated");
      },
    );
  }

  Future<void> updateItemDetails(int itemId, Map<String, dynamic> data) async {
    if (state == null) return;

    final result = await _repository.updateItem(id: itemId, data: data);
    result.fold(
      (failure) {
        ToastService.showError("Failed to update item: ${failure.message}");
      },
      (updatedItem) {
        // Update in-memory state list
        final updatedList = state!.map((item) =>
          item.id == itemId ? updatedItem : item
        ).toList();
        change(updatedList, status: RxStatus.success());
        ToastService.showSuccess("${updatedItem.name} updated successfully");
      },
    );
  }

  void changeCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      fetchItems();
    }
  }

  void searchItems(String query) {
    searchText.value = query;
    fetchItems();
  }
}
