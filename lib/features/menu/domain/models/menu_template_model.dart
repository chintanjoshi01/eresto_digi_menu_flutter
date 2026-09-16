import 'package:flutter/material.dart';

/// Enterprise Menu Template Model matching prototype & V6 API specifications.
class MenuTemplateModel {
  final int id;
  final String name;
  final bool isActive;
  final String details;
  final int themeId;
  final String themeName;
  final String themeShortName;
  final String themeGroup;
  final Color themeColor;
  final Color iconBg;
  final Color iconFg;
  final bool isMulti;
  final List<String> extraPills;
  final String menuType;
  final String customerTitle;
  final String tagline;
  final String priceList;
  final String language;
  final int itemCategoriesCount;
  final int menuCategoriesCount;
  final int itemsTotal;
  final int sessionsCount;
  final Map<String, bool> displaySettings;

  const MenuTemplateModel({
    required this.id,
    required this.name,
    this.isActive = false,
    required this.details,
    this.themeId = 1,
    required this.themeName,
    this.themeShortName = '1',
    required this.themeGroup,
    required this.themeColor,
    required this.iconBg,
    required this.iconFg,
    this.isMulti = false,
    this.extraPills = const [],
    this.menuType = 'Resto Menu, Single Menu',
    this.customerTitle = 'Truly Tadkaazzz',
    this.tagline = 'Where Every Bite Brings Happiness.',
    this.priceList = 'Default',
    this.language = 'English & Hindi',
    this.itemCategoriesCount = 36,
    this.menuCategoriesCount = 0,
    this.itemsTotal = 344,
    this.sessionsCount = 0,
    this.displaySettings = const {
      'Logo': true,
      'Currency': true,
      'Veg/Non-Veg': true,
      'Quantity': true,
      'Allergens': true,
      'Calories': true,
      'Pure Veg badge': true,
    },
  });

  /// Creates a MenuTemplateModel from API V6 JSON payload
  /// Supports both get_menu_builder_data and get_menu_temp_list_neo
  factory MenuTemplateModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0;
    final name = (json['menu_tmpl_name'] ?? json['name'] ?? 'Menu Template').toString();
    final rawIsMulti = json['is_multi'];
    final isMulti = rawIsMulti == 1 || rawIsMulti == '1' || rawIsMulti == true || json['menu_type'] == 2;
    final themeId = json['theme_id'] is int ? json['theme_id'] as int : int.tryParse(json['theme_id']?.toString() ?? '1') ?? 1;

    // Theme info
    String tName = (json['theme_name'] ?? '').toString().trim();
    String tGroup = (json['theme_group'] ?? '').toString().trim();
    String tShort = (json['theme_short_name'] ?? '').toString().trim();

    if (tGroup.isEmpty) {
      tGroup = 'Basic';
    } else {
      // Capitalize nicely, e.g. "BASIC" -> "Basic"
      tGroup = tGroup[0].toUpperCase() + tGroup.substring(1).toLowerCase();
    }

    if (tName.isEmpty) {
      tName = '$tGroup - $themeId';
    }
    if (tShort.isEmpty) {
      tShort = tName.contains('-') ? tName.split('-').last.trim() : '$themeId';
    }

    final itemsTotal = json['items_total'] is int
        ? json['items_total'] as int
        : int.tryParse(json['items_total']?.toString() ?? '0') ?? 0;

    final itemCatsCount = json['item_categories_count'] is int
        ? json['item_categories_count'] as int
        : int.tryParse(json['item_categories_count']?.toString() ?? '0') ?? 0;

    final menuCatsCount = json['menu_categories_count'] is int
        ? json['menu_categories_count'] as int
        : int.tryParse(json['menu_categories_count']?.toString() ?? '0') ?? 0;

    final sessionsList = json['sessions'] as List? ?? [];
    final sessionsCount = sessionsList.length;

    final tagline = (json['tagline'] ?? '').toString().trim();
    final language = (json['language_name'] ?? 'English').toString().trim();
    final priceListId = json['price_list_id'] is int
        ? json['price_list_id'] as int
        : int.tryParse(json['price_list_id']?.toString() ?? '0') ?? 0;
    final priceList = priceListId == 0 ? 'Default' : 'Price List #$priceListId';

    // Parse display settings
    final displayMap = <String, bool>{
      'Logo': true,
      'Currency': true,
      'Veg/Non-Veg': true,
      'Quantity': true,
      'Allergens': false,
      'Calories': false,
      'Pure Veg badge': false,
    };
    if (json['display_settings'] is Map) {
      final ds = json['display_settings'] as Map;
      if (ds.containsKey('logo')) displayMap['Logo'] = ds['logo'] == true || ds['logo'] == 1;
      if (ds.containsKey('currency')) displayMap['Currency'] = ds['currency'] == true || ds['currency'] == 1;
      if (ds.containsKey('veg_nonveg')) displayMap['Veg/Non-Veg'] = ds['veg_nonveg'] == true || ds['veg_nonveg'] == 1;
      if (ds.containsKey('quantity')) displayMap['Quantity'] = ds['quantity'] == true || ds['quantity'] == 1;
      if (ds.containsKey('allergens')) displayMap['Allergens'] = ds['allergens'] == true || ds['allergens'] == 1;
      if (ds.containsKey('calories')) displayMap['Calories'] = ds['calories'] == true || ds['calories'] == 1;
      if (ds.containsKey('pure_veg_badge')) displayMap['Pure Veg badge'] = ds['pure_veg_badge'] == true || ds['pure_veg_badge'] == 1;
    }

    // Determine colors and icon styles based on actual theme group & theme name
    Color themeColor = const Color(0xFFC1272D);
    Color iconBg = const Color(0xFFFEF2F2);
    Color iconFg = const Color(0xFFC1272D);

    final upperGroup = tGroup.toUpperCase();
    final lowerName = tName.toLowerCase();

    if (upperGroup == 'NEO') {
      themeColor = const Color(0xFF7C3AED);
      iconBg = const Color(0xFFEDE9FE);
      iconFg = const Color(0xFF7C3AED);
    } else if (upperGroup == 'TRENDY') {
      if (lowerName.contains('1')) {
        themeColor = const Color(0xFF1E293B);
        iconBg = const Color(0xFFF1F5F9);
        iconFg = const Color(0xFF1E293B);
      } else if (lowerName.contains('2')) {
        themeColor = const Color(0xFF4F46E5);
        iconBg = const Color(0xFFEEF2FF);
        iconFg = const Color(0xFF4F46E5);
      } else if (lowerName.contains('3')) {
        themeColor = const Color(0xFF16A34A);
        iconBg = const Color(0xFFF0FDF4);
        iconFg = const Color(0xFF16A34A);
      } else if (lowerName.contains('4')) {
        themeColor = const Color(0xFFD97706);
        iconBg = const Color(0xFFFFFBEB);
        iconFg = const Color(0xFFD97706);
      } else if (lowerName.contains('5')) {
        themeColor = const Color(0xFF9333EA);
        iconBg = const Color(0xFFFAF5FF);
        iconFg = const Color(0xFF9333EA);
      } else {
        themeColor = const Color(0xFF1E293B);
        iconBg = const Color(0xFFF1F5F9);
        iconFg = const Color(0xFF1E293B);
      }
    } else if (upperGroup == 'CLASSIC') {
      if (lowerName.contains('1')) {
        themeColor = const Color(0xFF0F766E);
        iconBg = const Color(0xFFF0FDFA);
        iconFg = const Color(0xFF0F766E);
      } else if (lowerName.contains('2')) {
        themeColor = const Color(0xFF0284C7);
        iconBg = const Color(0xFFF0F9FF);
        iconFg = const Color(0xFF0284C7);
      } else {
        themeColor = const Color(0xFF334155);
        iconBg = const Color(0xFFF8FAFC);
        iconFg = const Color(0xFF334155);
      }
    } else {
      // BASIC group
      if (lowerName.contains('4')) {
        themeColor = const Color(0xFFF59E0B);
        iconBg = const Color(0xFFFFFBEB);
        iconFg = const Color(0xFFD97706);
      } else if (lowerName.contains('5')) {
        themeColor = const Color(0xFFEA580C);
        iconBg = const Color(0xFFFFF7ED);
        iconFg = const Color(0xFFEA580C);
      } else {
        themeColor = const Color(0xFFC1272D);
        iconBg = const Color(0xFFFEF2F2);
        iconFg = const Color(0xFFC1272D);
      }
    }

    // Compose high-fidelity detail subtitle matching V6 API specification
    final String details;
    final sessionsText = '$sessionsCount ${sessionsCount == 1 ? "session" : "sessions"}';
    if (isMulti) {
      final catTxt = menuCatsCount > 0 ? '$menuCatsCount menu cats · ' : '';
      details = '$tGroup · $tShort · $catTxt$itemsTotal items · $sessionsText';
    } else {
      final itemsTxt = itemsTotal > 0 ? ' · $itemsTotal items' : '';
      final sessionTxt = sessionsCount > 0 ? 'Used in $sessionsText' : '0 sessions';
      details = '$tGroup · $tShort · $sessionTxt$itemsTxt';
    }

    // Only actual category pills if present (no hardcoded fake pills)
    final extraPills = <String>[];

    final isActive = sessionsCount > 0 || (json['is_active'] == 1 || json['is_active'] == true);

    return MenuTemplateModel(
      id: id,
      name: name,
      isActive: isActive,
      details: details,
      themeId: themeId,
      themeName: 'Theme: $tName',
      themeShortName: tShort,
      themeGroup: tGroup,
      themeColor: themeColor,
      iconBg: iconBg,
      iconFg: iconFg,
      isMulti: isMulti,
      extraPills: extraPills,
      menuType: isMulti ? 'Multi Category Menu' : 'Single Menu',
      customerTitle: json['customer_title']?.toString() ?? '',
      tagline: tagline,
      priceList: priceList,
      language: language.isNotEmpty ? language : 'English',
      itemCategoriesCount: itemCatsCount,
      menuCategoriesCount: menuCatsCount,
      itemsTotal: itemsTotal,
      sessionsCount: sessionsCount,
      displaySettings: displayMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_tmpl_name': name,
      'is_multi': isMulti ? 1 : 0,
      'theme_id': themeId,
      'theme_name': themeName.replaceFirst('Theme: ', ''),
      'theme_short_name': themeShortName,
      'theme_group': themeGroup,
      'items_total': itemsTotal,
      'item_categories_count': itemCategoriesCount,
      'menu_categories_count': menuCategoriesCount,
      'sessions_count': sessionsCount,
      'tagline': tagline,
      'language_name': language,
    };
  }

  MenuTemplateModel copyWith({
    int? id,
    String? name,
    bool? isActive,
    String? details,
    int? themeId,
    String? themeName,
    String? themeShortName,
    String? themeGroup,
    Color? themeColor,
    Color? iconBg,
    Color? iconFg,
    bool? isMulti,
    List<String>? extraPills,
    String? menuType,
    String? customerTitle,
    String? tagline,
    String? priceList,
    String? language,
    int? itemCategoriesCount,
    int? menuCategoriesCount,
    int? itemsTotal,
    int? sessionsCount,
    Map<String, bool>? displaySettings,
  }) {
    return MenuTemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      details: details ?? this.details,
      themeId: themeId ?? this.themeId,
      themeName: themeName ?? this.themeName,
      themeShortName: themeShortName ?? this.themeShortName,
      themeGroup: themeGroup ?? this.themeGroup,
      themeColor: themeColor ?? this.themeColor,
      iconBg: iconBg ?? this.iconBg,
      iconFg: iconFg ?? this.iconFg,
      isMulti: isMulti ?? this.isMulti,
      extraPills: extraPills ?? this.extraPills,
      menuType: menuType ?? this.menuType,
      customerTitle: customerTitle ?? this.customerTitle,
      tagline: tagline ?? this.tagline,
      priceList: priceList ?? this.priceList,
      language: language ?? this.language,
      itemCategoriesCount: itemCategoriesCount ?? this.itemCategoriesCount,
      menuCategoriesCount: menuCategoriesCount ?? this.menuCategoriesCount,
      itemsTotal: itemsTotal ?? this.itemsTotal,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      displaySettings: displaySettings ?? this.displaySettings,
    );
  }
}
