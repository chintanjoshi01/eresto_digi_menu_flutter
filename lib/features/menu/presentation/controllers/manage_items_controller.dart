import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/toast_service.dart';

class MenuCategoryGroup {
  final String id;
  String name;
  IconData iconData;
  Color color;
  List<int> catIndices;

  MenuCategoryGroup({
    required this.id,
    required this.name,
    required this.iconData,
    required this.color,
    required this.catIndices,
  });
}

class CategoryItemData {
  final String name;
  final List<String> items;
  List<int> orderedSelected;

  CategoryItemData({
    required this.name,
    required this.items,
    required this.orderedSelected,
  });
}

class ManageItemsController extends GetxController {
  final String templateName;
  final bool isMultiMenu;

  ManageItemsController({
    this.templateName = 'Multi Menu',
    this.isMultiMenu = true,
  });

  // Active Tab: 'select' or 'order'
  final RxString activeTab = 'select'.obs;

  // Active Menu Category (0 for Food, 1 for Beverages, etc.)
  final RxInt activeMenuCat = 0.obs;

  // Reorderable menu categories indices
  final RxList<int> menuCatOrder = <int>[0, 1].obs;

  // Menu Category definitions matching prototype
  final List<MenuCategoryGroup> menuCategories = [
    MenuCategoryGroup(
      id: 'food',
      name: 'Food',
      iconData: Icons.restaurant_rounded,
      color: const Color(0xFF16A34A),
      catIndices: [4, 5, 6, 7, 8, 9],
    ),
    MenuCategoryGroup(
      id: 'beverage',
      name: 'Beverages',
      iconData: Icons.local_bar_rounded,
      color: const Color(0xFF2563EB),
      catIndices: [0, 1, 2, 3],
    ),
  ];

  // Master Categories matching prototype
  final List<CategoryItemData> categories = [
    CategoryItemData(
      name: 'MOCKTAILS',
      items: [
        'Aqua Marine',
        'Go Green',
        'Strawberry Rhapsody',
        'Virgin Colada – The Original!',
        "Daffodil's Punch",
        'Adams Bite',
        'Indian Masti',
        'Virgin Mojito',
        'A Devil In The Deep Sea',
        'Pink Fruit Punch',
        'Plum Passion',
        'Lychee Lemony Float',
        'Hawaiian Beach Cooler',
        'Orange Blossom',
        'Pink Lady',
      ],
      orderedSelected: [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
    ),
    CategoryItemData(
      name: 'AERATED DRINKS & WATER',
      items: [
        'Himalayan Bottled Water',
        'Bottled Mineral Water',
        'Dom Perrier Sparkling Water',
        'Coke/sprite/fanta/diet/zero',
        'Nimbu Pani',
        'Fresh Lime Soda',
        'Iced Tea',
        'Virgin Mojito Special',
      ],
      orderedSelected: [0, 1, 2, 3, 4, 5, 6, 7],
    ),
    CategoryItemData(
      name: 'HOT & COLD BEVERAGES',
      items: [
        'Masala Chai',
        'Ginger Tea',
        'Green Tea',
        'Cold Coffee',
        'Hot Chocolate',
        'Lemonade',
      ],
      orderedSelected: [0, 1, 2, 3, 4, 5],
    ),
    CategoryItemData(
      name: 'COFFEES',
      items: [
        'Espresso',
        'Cappuccino',
        'Latte',
        'Americano',
        'Macchiato',
        'Cold Brew',
        'Iced Latte',
      ],
      orderedSelected: [0, 1, 2, 3, 4, 5, 6],
    ),
    CategoryItemData(
      name: 'SALADS',
      items: [
        'Garden Fresh Salad',
        'Caesar Salad',
        'Greek Salad',
        'Pasta Salad',
        'Coleslaw',
        'Fruit Salad',
      ],
      orderedSelected: [0, 1, 2, 3, 4, 5],
    ),
    CategoryItemData(
      name: 'SOUPS',
      items: [
        'Tomato Soup',
        'Mushroom Soup',
        'Sweet Corn Soup',
        'Hot & Sour Soup',
        'Lemon Coriander',
        'Minestrone',
        'Veg Clear Soup',
        'Dal Shorba',
        'Broccoli Soup',
        'Pumpkin Soup',
        'Mulligatawny',
        'Malabar Shorba',
      ],
      orderedSelected: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    ),
    CategoryItemData(
      name: 'SIZZLING STARTERS',
      items: [
        'Paneer Tikka Sizzler',
        'Chicken Sizzler',
        'Mix Veg Sizzler',
        'Mushroom Sizzler',
        'Tofu Sizzler',
        'Seekh Kebab Sizzler',
        'Fish Sizzler',
        'Prawn Sizzler',
        'Cajun Sizzler',
      ],
      orderedSelected: [0, 1, 2, 3, 4, 5, 6, 7, 8],
    ),
    CategoryItemData(
      name: 'STARTERS',
      items: [
        'Veg Spring Rolls',
        'Paneer 65',
        'Gobi Manchurian',
        'Hara Bhara Kabab',
        'Shammi Kebab',
        'Galouti Kebab',
        'Seekh Kebab',
        'Chicken 65',
        'Fish Finger',
        'Prawn Tempura',
        'Chilli Chicken',
        'Cajun Potatoes',
        'Peri Peri Wings',
        'Cheese Balls',
        'Nachos',
        'Bruschetta',
      ],
      orderedSelected: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
    ),
    CategoryItemData(
      name: 'MAIN COURSE BOWLS',
      items: [
        'Dal Makhani',
        'Paneer Butter Masala',
        'Kadai Paneer',
        'Shahi Paneer',
        'Veg Biryani',
        'Murgh Makhani',
        'Rogan Josh',
        'Dal Tadka',
        'Palak Paneer',
        'Matar Paneer',
        'Aloo Jeera',
        'Chana Masala',
      ],
      orderedSelected: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
    ),
    CategoryItemData(
      name: 'RICE',
      items: [
        'Steamed Rice',
        'Jeera Rice',
        'Veg Biryani',
        'Chicken Biryani',
        'Mutton Biryani',
        'Prawn Biryani',
        'Veg Fried Rice',
        'Egg Fried Rice',
        'Schezwan Fried Rice',
        'Lemon Rice',
        'Curd Rice',
        'Peas Pulao',
        'Kashmiri Pulao',
        'Malabar Biryani',
        'Lucknowi Biryani',
        'Hyderabadi Biryani',
        'Dum Biryani',
      ],
      orderedSelected: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
    ),
  ];

  // Selected category index for item selection drill-down in Select tab
  final RxnInt selectedCatIndexForItems = RxnInt();

  // Selected category index for item reorder drill-down in Order tab
  final RxnInt selectedCatIndexForOrder = RxnInt();

  // Search filter query
  final RxString categorySearchQuery = ''.obs;

  // Track modification state
  final RxBool hasChanges = false.obs;

  List<int> get activeCatIndices {
    if (!isMultiMenu) {
      return List.generate(categories.length, (i) => i);
    }
    if (activeMenuCat.value >= menuCatOrder.length) return [];
    final currentMcIndex = menuCatOrder[activeMenuCat.value];
    return menuCategories[currentMcIndex].catIndices;
  }

  MenuCategoryGroup get currentMenuCategory {
    if (activeMenuCat.value >= menuCatOrder.length) return menuCategories[0];
    return menuCategories[menuCatOrder[activeMenuCat.value]];
  }

  int get selectedItemsInCurrentSection {
    int sum = 0;
    for (final ci in activeCatIndices) {
      if (ci < categories.length) {
        sum += categories[ci].orderedSelected.length;
      }
    }
    return sum;
  }

  int get totalItemsInCurrentSection {
    int sum = 0;
    for (final ci in activeCatIndices) {
      if (ci < categories.length) {
        sum += categories[ci].items.length;
      }
    }
    return sum;
  }

  int get totalSelectedAll {
    return categories.fold(0, (sum, c) => sum + c.orderedSelected.length);
  }

  int get totalItemsAll {
    return categories.fold(0, (sum, c) => sum + c.items.length);
  }

  void setTab(String tab) {
    activeTab.value = tab;
    // Reset drill-down views when switching tabs
    selectedCatIndexForItems.value = null;
    selectedCatIndexForOrder.value = null;
  }

  void setActiveMenuCategory(int pos) {
    activeMenuCat.value = pos;
    selectedCatIndexForItems.value = null;
    selectedCatIndexForOrder.value = null;
  }

  void toggleAllInCat(int catIndex) {
    if (catIndex < 0 || catIndex >= categories.length) return;
    final cat = categories[catIndex];
    if (cat.orderedSelected.length == cat.items.length) {
      cat.orderedSelected.clear();
    } else {
      cat.orderedSelected = List.generate(cat.items.length, (i) => i);
    }
    hasChanges.value = true;
    update();
  }

  void openCategoryForItems(int catIndex) {
    selectedCatIndexForItems.value = catIndex;
  }

  void closeCategoryForItems() {
    selectedCatIndexForItems.value = null;
  }

  void toggleItem(int catIndex, int itemIndex) {
    if (catIndex < 0 || catIndex >= categories.length) return;
    final cat = categories[catIndex];
    if (cat.orderedSelected.contains(itemIndex)) {
      cat.orderedSelected.remove(itemIndex);
    } else {
      cat.orderedSelected.add(itemIndex);
    }
    hasChanges.value = true;
    update();
  }

  void selectAllItemsInActiveCat(bool selectAll) {
    final catIdx = selectedCatIndexForItems.value;
    if (catIdx == null || catIdx < 0 || catIdx >= categories.length) return;
    final cat = categories[catIdx];
    if (selectAll) {
      cat.orderedSelected = List.generate(cat.items.length, (i) => i);
    } else {
      cat.orderedSelected.clear();
    }
    hasChanges.value = true;
    update();
  }

  void navCategory(int dir) {
    final catIdx = selectedCatIndexForItems.value;
    if (catIdx == null) return;
    final indices = activeCatIndices;
    final pos = indices.indexOf(catIdx);
    final nxt = pos + dir;
    if (nxt >= 0 && nxt < indices.length) {
      selectedCatIndexForItems.value = indices[nxt];
    }
  }

  void openCategoryForOrder(int catIndex) {
    selectedCatIndexForOrder.value = catIndex;
  }

  void closeCategoryForOrder() {
    selectedCatIndexForOrder.value = null;
  }

  void moveCategory(int pos, int dir) {
    final indices = activeCatIndices;
    final nxt = pos + dir;
    if (nxt < 0 || nxt >= indices.length) return;
    final temp = indices[pos];
    indices[pos] = indices[nxt];
    indices[nxt] = temp;
    hasChanges.value = true;
    update();
  }

  void moveItem(int pos, int dir) {
    final catIdx = selectedCatIndexForOrder.value;
    if (catIdx == null || catIdx < 0 || catIdx >= categories.length) return;
    final cat = categories[catIdx];
    final nxt = pos + dir;
    if (nxt < 0 || nxt >= cat.orderedSelected.length) return;
    final temp = cat.orderedSelected[pos];
    cat.orderedSelected[pos] = cat.orderedSelected[nxt];
    cat.orderedSelected[nxt] = temp;
    hasChanges.value = true;
    update();
  }

  void moveMenuCategory(int pos, int dir) {
    final nxt = pos + dir;
    if (nxt < 0 || nxt >= menuCatOrder.length) return;
    final temp = menuCatOrder[pos];
    menuCatOrder[pos] = menuCatOrder[nxt];
    menuCatOrder[nxt] = temp;
    if (activeMenuCat.value == pos) {
      activeMenuCat.value = nxt;
    } else if (activeMenuCat.value == nxt) {
      activeMenuCat.value = pos;
    }
    hasChanges.value = true;
    update();
  }

  void addMenuCategory() {
    final names = ['Desserts', 'Snacks', 'Specials', 'Kids Menu'];
    final icons = [
      Icons.cake_outlined,
      Icons.fastfood_outlined,
      Icons.star_outline_rounded,
      Icons.child_care_rounded,
    ];
    final colors = [
      const Color(0xFFF59E0B),
      const Color(0xFFC1272D),
      const Color(0xFF7C3AED),
      const Color(0xFF0891B2),
    ];
    final n = menuCategories.length;
    menuCategories.add(
      MenuCategoryGroup(
        id: 'cat$n',
        name: names[n % names.length],
        iconData: icons[n % icons.length],
        color: colors[n % colors.length],
        catIndices: [],
      ),
    );
    menuCatOrder.add(n);
    hasChanges.value = true;
    update();
  }

  void saveChanges() {
    hasChanges.value = false;
    ToastService.showSuccess("Menu item modifications saved successfully!");
    Get.back();
  }
}
