import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eresto_menu/core/api/api_exception.dart';
import 'package:eresto_menu/features/items/domain/models/item_model.dart';
import 'package:eresto_menu/features/items/domain/repositories/items_repository.dart';
import 'package:eresto_menu/features/items/presentation/controllers/items_controller.dart';

class MockItemsRepository implements ItemsRepository {
  List<ItemModel> mockItems = [];

  @override
  Map<String, int> get categoryNameToId => {};

  @override
  Future<Either<ApiException, List<ItemModel>>> getItems({
    String? category,
    String? search,
    int? ptId,
    bool forceRefresh = false,
  }) async {
    return Right(mockItems);
  }

  @override
  Future<Either<ApiException, ItemModel>> getItemDetails(int itemId) async {
    return Right(mockItems.firstWhere((e) => e.id == itemId));
  }

  @override
  Future<Either<ApiException, void>> updateAvailability({required int id, required bool isAvailable}) async {
    return const Right(null);
  }

  @override
  Future<Either<ApiException, void>> updateFsi({required int id, required bool isFsi}) async {
    return const Right(null);
  }

  @override
  Future<Either<ApiException, void>> updateQuickPrice({required int id, required double price}) async {
    return const Right(null);
  }

  @override
  Future<Either<ApiException, ItemModel>> updateItem({required int id, required Map<String, dynamic> data, File? imageFile}) async {
    return Right(mockItems.firstWhere((e) => e.id == id));
  }

  @override
  Future<Either<ApiException, ItemModel>> createItem({required Map<String, dynamic> data, File? imageFile}) async {
    return Right(mockItems.first);
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> deleteItem({required int id, int isForce = 0}) async {
    return const Right({'status': 1});
  }

  @override
  Future<List<String>> getCategories() async => [];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockItemsRepository mockRepo;
  late ItemsController controller;

  const List<ItemModel> sampleItems = [
    ItemModel(
      id: 1,
      name: 'Tea',
      shortCode: 'Te',
      price: 30.0,
      itemGroup: 'Hot Beverages',
      taxTemplate: 'GST',
      isAvailable: true,
      isFrequentlySold: false,
      vegType: 'veg',
    ),
    ItemModel(
      id: 2,
      name: 'Cold Coffee',
      shortCode: 'CC',
      price: 80.0,
      itemGroup: 'Cold Beverages',
      taxTemplate: 'GST',
      isAvailable: true,
      isFrequentlySold: false,
      vegType: 'veg',
    ),
    ItemModel(
      id: 3,
      name: 'Cheese Burger',
      shortCode: 'CB',
      price: 120.0,
      itemGroup: 'Fast Food',
      taxTemplate: 'GST',
      isAvailable: true,
      isFrequentlySold: false,
      vegType: 'non_veg',
    ),
  ];

  setUp(() {
    mockRepo = MockItemsRepository();
    mockRepo.mockItems = sampleItems;
    controller = ItemsController(mockRepo);
  });

  test('ItemsController.filteredItems is reactive and notifies listeners on load', () async {
    final List<int> observedLengths = [];

    // Simulate Obx listening to filteredItems.length
    controller.filteredItems.listen((items) {
      observedLengths.add(items.length);
    });

    expect(controller.filteredItems.length, equals(0));

    await controller.loadItems(forceRefresh: true);

    expect(controller.filteredItems.length, equals(3));
    expect(observedLengths, contains(3));
    expect(controller.categoryCounts['ALL'], equals(3));
  });

  test('ItemsController dynamically filters and updates filteredItems length', () async {
    await controller.loadItems(forceRefresh: true);
    expect(controller.filteredItems.length, equals(3));

    // Filter by category
    controller.changeCategory('Hot Beverages');
    expect(controller.filteredItems.length, equals(1));
    expect(controller.filteredItems.first.name, equals('Tea'));

    // Filter by veg
    controller.changeCategory('');
    controller.filterVegType.value = 'VEG';
    controller.filterItems();
    expect(controller.filteredItems.length, equals(2));

    // Reset filters
    controller.resetFilters();
    expect(controller.filteredItems.length, equals(3));
  });
}
