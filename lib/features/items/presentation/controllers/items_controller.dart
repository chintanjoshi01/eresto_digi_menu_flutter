import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/services/toast_service.dart';
import '../../domain/models/item_model.dart';
import '../../domain/repositories/items_repository.dart';

class ItemsController extends GetxController with StateMixin<List<ItemModel>> {
  final ItemsRepository _repository;
  ItemsRepository get repository => _repository;

  final searchText = ''.obs;
  final selectedCategory = ''.obs;
  final selectedPtId = 0.obs; // Price template ID (0 = default)
  final selectedPriceTemplateName = 'Default Price'.obs;

  final categoriesList = <String>[].obs;
  final categoryCounts = <String, int>{}.obs;

  Map<String, int> get categoryNameToId => _repository.categoryNameToId;

  final List<ItemModel> _allItemsList = [];
  final isRefreshing = false.obs;

  final RxList<ItemModel> filteredItems = <ItemModel>[].obs;

  // Layout View Mode (true = Grid, false = List / Table rows)
  final isGridView = true.obs;

  void toggleLayout(bool grid) {
    if (isGridView.value != grid) {
      HapticFeedback.selectionClick();
      isGridView.value = grid;
    }
  }

  // Filter Bottom Sheet State
  final filterVegType = 'ALL'.obs; // 'ALL', 'VEG', 'NON_VEG'
  final filterAvailability = 'ALL'.obs; // 'ALL', 'AVAILABLE', 'HIDDEN'
  final filterFsiOnly = false.obs; // true = Starred only
  final filterSortBy = 'DEFAULT'.obs; // 'DEFAULT', 'PRICE_ASC', 'PRICE_DESC', 'NAME_ASC'
  final selectedDietaryTags = <String>{}.obs; // e.g. {'j', 'v', 's'}

  int get activeFiltersCount {
    int count = 0;
    if (filterVegType.value != 'ALL') count++;
    if (filterAvailability.value != 'ALL') count++;
    if (filterFsiOnly.value) count++;
    if (filterSortBy.value != 'DEFAULT') count++;
    if (selectedDietaryTags.isNotEmpty) count += selectedDietaryTags.length;
    return count;
  }

  void resetFilters() {
    filterVegType.value = 'ALL';
    filterAvailability.value = 'ALL';
    filterFsiOnly.value = false;
    filterSortBy.value = 'DEFAULT';
    selectedDietaryTags.clear();
    filterItems();
  }

  ItemsController(this._repository);

  @override
  void onInit() {
    super.onInit();
    // 1. Instant offline-first load
    loadItems(forceRefresh: false);
  }

  /// Load items with ultra-fast instant cache display (0ms),
  /// followed by seamless background synchronization to keep all items up-to-date.
  Future<void> loadItems({bool forceRefresh = false}) async {
    if (forceRefresh) {
      isRefreshing.value = true;
    }

    // 1. Instant 0ms memory & local cache rendering
    if (!forceRefresh) {
      if (_allItemsList.isEmpty) {
        final cachedResult = await _repository.getItems(
          ptId: selectedPtId.value > 0 ? selectedPtId.value : null,
          forceRefresh: false,
        );
        cachedResult.fold(
          (_) {},
          (cachedItems) {
            if (cachedItems.isNotEmpty) {
              _allItemsList.clear();
              _allItemsList.addAll(cachedItems);
              _updateCategoriesAndCounts();
              filterItems();
            }
          },
        );
      } else {
        filterItems();
      }

      // If we already have items to display, sync silently in background without blocking UI
      if (_allItemsList.isNotEmpty) {
        _syncInBackground();
        return;
      }
    }

    // 2. If empty or user initiated pull-down refresh:
    if (_allItemsList.isEmpty) {
      filteredItems.clear();
      change(null, status: RxStatus.loading());
    }

    await _fetchAndApplyRemoteItems();
    isRefreshing.value = false;
  }

  void _syncInBackground() {
    _fetchAndApplyRemoteItems().catchError((_) {});
  }

  Future<void> _fetchAndApplyRemoteItems() async {
    final networkResult = await _repository.getItems(
      ptId: selectedPtId.value > 0 ? selectedPtId.value : null,
      forceRefresh: true,
    );

    networkResult.fold(
      (failure) {
        if (_allItemsList.isEmpty) {
          filteredItems.clear();
          change([], status: RxStatus.error(failure.message));
        }
      },
      (freshItems) {
        _allItemsList.clear();
        if (freshItems.isNotEmpty) {
          _allItemsList.addAll(freshItems);
        }
        _updateCategoriesAndCounts();
        filterItems();
      },
    );
  }

  void _updateCategoriesAndCounts() {
    final Map<String, int> counts = {};
    final Set<String> distinctCats = {};

    counts['ALL'] = _allItemsList.length;

    for (final it in _allItemsList) {
      final cat = it.itemGroup.trim().toUpperCase();
      if (cat.isNotEmpty && cat != 'FSI') {
        distinctCats.add(cat);
        counts[cat] = (counts[cat] ?? 0) + 1;
      }
    }

    categoriesList.assignAll(distinctCats.toList()..sort());
    categoryCounts.assignAll(counts);
  }

  void filterItems() {
    List<ItemModel> filtered = List.from(_allItemsList);

    // 1. Category Filter
    if (selectedCategory.value.isNotEmpty) {
      filtered = filtered.where((e) =>
        e.itemGroup.toUpperCase() == selectedCategory.value.toUpperCase()
      ).toList();
    }

    // 2. Search Text
    if (searchText.value.trim().isNotEmpty) {
      final query = searchText.value.trim().toLowerCase();
      filtered = filtered.where((e) =>
        e.name.toLowerCase().contains(query) ||
        e.shortCode.toLowerCase().contains(query) ||
        (e.shortDescription?.toLowerCase().contains(query) ?? false) ||
        (e.ingredients?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    // 3. Food Type (Veg / Non-Veg)
    if (filterVegType.value == 'VEG') {
      filtered = filtered.where((e) => e.isVeg).toList();
    } else if (filterVegType.value == 'NON_VEG') {
      filtered = filtered.where((e) => !e.isVeg).toList();
    }

    // 4. Availability (In Stock / Hidden)
    if (filterAvailability.value == 'AVAILABLE') {
      filtered = filtered.where((e) => e.isAvailable).toList();
    } else if (filterAvailability.value == 'HIDDEN') {
      filtered = filtered.where((e) => !e.isAvailable).toList();
    }

    // 5. Starred / Frequently Sold (FSI)
    if (filterFsiOnly.value) {
      filtered = filtered.where((e) => e.isFrequentlySold).toList();
    }

    // 6. Dietary Preferences (Jain, Vegan, etc.)
    if (selectedDietaryTags.isNotEmpty) {
      filtered = filtered.where((e) {
        if (e.dietaryTags == null || e.dietaryTags!.isEmpty) return false;
        final itemTags = e.dietaryTags!.map((t) => t.toLowerCase().trim()).toSet();
        return selectedDietaryTags.any((tag) => itemTags.contains(tag.toLowerCase().trim()));
      }).toList();
    }

    // 7. Sort Ordering
    if (filterSortBy.value == 'PRICE_ASC') {
      filtered.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice));
    } else if (filterSortBy.value == 'PRICE_DESC') {
      filtered.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
    } else if (filterSortBy.value == 'NAME_ASC') {
      filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    filteredItems.assignAll(filtered);
    change(filtered, status: RxStatus.success());
  }

  Future<void> refreshItems() async {
    await loadItems(forceRefresh: true);
  }

  /// Optimistic availability toggle (0ms UI latency)
  Future<void> toggleAvailability(int itemId, bool isAvailable) async {
    final idx = _allItemsList.indexWhere((e) => e.id == itemId);
    if (idx == -1) return;

    final original = _allItemsList[idx];
    // 1. Instant local update
    _allItemsList[idx] = original.copyWith(isAvailable: isAvailable);
    filterItems();

    // 2. Background sync
    final result = await _repository.updateAvailability(id: itemId, isAvailable: isAvailable);
    result.fold(
      (failure) {
        // Rollback on failure
        _allItemsList[idx] = original;
        filterItems();
        ToastService.showError("Failed to update availability. Reverted.");
      },
      (_) {
        ToastService.showSuccess("${original.name} is now ${isAvailable ? 'Available' : 'Hidden'}");
      },
    );
  }

  /// Optimistic FSI toggle
  Future<void> toggleFsi(int itemId, bool isFsi) async {
    final idx = _allItemsList.indexWhere((e) => e.id == itemId);
    if (idx == -1) return;

    final original = _allItemsList[idx];
    _allItemsList[idx] = original.copyWith(isFrequentlySold: isFsi);
    filterItems();

    final result = await _repository.updateFsi(id: itemId, isFsi: isFsi);
    result.fold(
      (failure) {
        _allItemsList[idx] = original;
        filterItems();
        ToastService.showError("Failed to update FSI status. Reverted.");
      },
      (_) {
        ToastService.showSuccess("${original.name} ${isFsi ? 'marked as FSI ⭐' : 'removed from FSI'}");
      },
    );
  }

  /// Fetch fresh single item details from V6 API (/api/v6/menu/item/details)
  Future<ItemModel?> getItemDetails(int itemId) async {
    final result = await _repository.getItemDetails(itemId);
    return result.fold(
      (failure) {
        ToastService.showError("Failed to fetch item details: ${failure.message}");
        return null;
      },
      (item) => item,
    );
  }

  /// Update item details with optional image file
  Future<void> updateItemDetails(int itemId, Map<String, dynamic> data, {File? imageFile}) async {
    final result = await _repository.updateItem(id: itemId, data: data, imageFile: imageFile);

    result.fold(
      (failure) {
        ToastService.showError("Failed to update item: ${failure.message}");
      },
      (updatedItem) {
        final idx = _allItemsList.indexWhere((e) => e.id == itemId);
        if (idx != -1) {
          _allItemsList[idx] = updatedItem;
        } else {
          _allItemsList.add(updatedItem);
        }
        _updateCategoriesAndCounts();
        filterItems();
        ToastService.showSuccess("${updatedItem.name} updated successfully");
      },
    );
  }

  /// Create new item with V6 specifications
  Future<ItemModel?> createItem(Map<String, dynamic> data, {File? imageFile}) async {
    final result = await _repository.createItem(data: data, imageFile: imageFile);
    return result.fold(
      (failure) {
        ToastService.showError("Failed to create item: ${failure.message}");
        return null;
      },
      (newItem) {
        _allItemsList.insert(0, newItem);
        _updateCategoriesAndCounts();
        filterItems();
        ToastService.showSuccess("${newItem.name} added successfully");
        return newItem;
      },
    );
  }

  /// Switch price template (e.g. Regular Dine-In, Room Service IRD, Online Delivery)
  void setPriceTemplate(int ptId, String templateName) {
    if (selectedPtId.value != ptId) {
      selectedPtId.value = ptId;
      selectedPriceTemplateName.value = templateName;
      loadItems(forceRefresh: true);
    }
  }

  void changeCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      filterItems();
    }
  }

  void searchItems(String query) {
    searchText.value = query;
    filterItems();
  }
}
