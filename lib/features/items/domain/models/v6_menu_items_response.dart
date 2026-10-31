import 'dart:convert';
import 'package:get/get.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/storage/menu_collections.dart';
import 'item_model.dart';

/// Response wrapper for /api/v6/menu/items
class V6MenuItemsResponse {
  final int status;
  final String message;
  final String? baseUrl;
  final List<V6MenuCategory> data;

  const V6MenuItemsResponse({
    required this.status,
    required this.message,
    this.baseUrl,
    required this.data,
  });

  bool get isSuccess => status == 1;

  factory V6MenuItemsResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final List<V6MenuCategory> categories = [];
    String? baseUrl;
    dynamic categoryList = rawData;

    if (rawData is Map<String, dynamic>) {
      baseUrl = (rawData['img_base'] ??
              rawData['item_base'] ??
              rawData['item_base_url'] ??
              rawData['base_url'] ??
              rawData['image_base'] ??
              rawData['image_base_url'] ??
              rawData['img_base_url'] ??
              json['img_base'] ??
              json['item_base'] ??
              json['item_base_url'] ??
              json['base_url'])
          ?.toString();
      categoryList = rawData['items'] ?? rawData['categories'] ?? [];
    } else if (json['img_base'] != null || json['item_base'] != null || json['item_base_url'] != null || json['base_url'] != null) {
      baseUrl = (json['img_base'] ?? json['item_base'] ?? json['item_base_url'] ?? json['base_url'])?.toString();
    }

    if (categoryList is List) {
      for (final item in categoryList) {
        if (item is Map<String, dynamic>) {
          final cat = V6MenuCategory.fromJson(item, baseUrl: baseUrl);
          // Filter out virtual FSI category (-1) matching native Eresto app logic
          if (cat.itemCatId == -1 || cat.categoryName.trim().toUpperCase() == 'FSI') {
            continue;
          }
          categories.add(cat);
        }
      }
    }

    return V6MenuItemsResponse(
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      message: json['message']?.toString() ?? '',
      baseUrl: baseUrl,
      data: categories,
    );
  }
}

/// Menu Category containing categorized items
class V6MenuCategory {
  final String categoryName;
  final int menuType;
  final int categoryDisplayOrder;
  final int itemCatId;
  final int en;
  final List<V6ApiMenuItem> items;

  const V6MenuCategory({
    required this.categoryName,
    required this.menuType,
    required this.categoryDisplayOrder,
    required this.itemCatId,
    required this.en,
    required this.items,
  });

  factory V6MenuCategory.fromJson(Map<String, dynamic> json, {String? baseUrl}) {
    final rawItems = json['items'];
    final List<V6ApiMenuItem> itemList = [];
    if (rawItems is List) {
      for (final it in rawItems) {
        if (it is Map<String, dynamic>) {
          itemList.add(V6ApiMenuItem.fromJson(it, fallbackBaseUrl: baseUrl));
        }
      }
    }

    return V6MenuCategory(
      categoryName: json['category_name']?.toString() ?? '',
      menuType: json['menu_type'] is int
          ? json['menu_type'] as int
          : int.tryParse(json['menu_type']?.toString() ?? '1') ?? 1,
      categoryDisplayOrder: json['category_display_order'] is int
          ? json['category_display_order'] as int
          : int.tryParse(json['category_display_order']?.toString() ?? '0') ?? 0,
      itemCatId: json['item_cat_id'] is int
          ? json['item_cat_id'] as int
          : int.tryParse(json['item_cat_id']?.toString() ?? '0') ?? 0,
      en: json['en'] is int
          ? json['en'] as int
          : int.tryParse(json['en']?.toString() ?? '1') ?? 1,
      items: itemList,
    );
  }
}

/// Single Menu Item from V6 API
class V6ApiMenuItem {
  final int id;
  final String itemName;
  final String itemShortName;
  final double itemPrice;
  final int itemCatId;
  final int menuType;
  final int? kitchenCatId;
  final int? itemSalesCatId;
  final int isNa; // 0 = available, 1 = sold out (NA)
  final int isFsi; // 1 = frequently sold, 0 = normal
  final String? itemNameAlias;
  final String? qty;
  final int? cal;
  final String? aik;
  final String? itemAtt;
  final String? itemImage;
  final String? spInst;
  final int? menuCatId;
  final String? itemTax;
  final int? taxTmplMastId;
  final int isNonveg; // 0 = veg, 1 = non-veg
  final String? ingredients;
  final String? shortDesc;
  final String? deliveryTime;
  final String? baseUrl;
  final String? vrnt;
  final String? aoi;

  const V6ApiMenuItem({
    required this.id,
    required this.itemName,
    required this.itemShortName,
    required this.itemPrice,
    required this.itemCatId,
    required this.menuType,
    this.kitchenCatId,
    this.itemSalesCatId,
    required this.isNa,
    required this.isFsi,
    this.itemNameAlias,
    this.qty,
    this.cal,
    this.aik,
    this.itemAtt,
    this.itemImage,
    this.spInst,
    this.menuCatId,
    this.itemTax,
    this.taxTmplMastId,
    this.isNonveg = 0,
    this.ingredients,
    this.shortDesc,
    this.deliveryTime,
    this.baseUrl,
    this.vrnt,
    this.aoi,
  });

  bool get isAvailable => isNa == 0;
  bool get isFrequentlySold => isFsi == 1;
  bool get isVeg => isNonveg == 0;

  List<String>? get parsedAllergens {
    if (aik != null && aik!.trim().isNotEmpty) {
      return aik!
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) {
            final lower = e.toLowerCase();
            if (lower.contains('crust')) return 'Crustacean';
            if (lower.contains('gluten') || lower.contains('cereal')) return 'Gluten';
            if (lower.contains('soya') || lower.contains('soy')) return 'Soyabean';
            if (lower.contains('peanut') || lower.contains('pean')) return 'Peanuts';
            if (lower.contains('egg')) return 'Eggs';
            if (lower.contains('fish')) return 'Fish';
            if (lower.contains('milk') || lower.contains('dairy')) return 'Milk';
            if (lower.contains('nut') || lower.contains('tree')) return 'Nuts';
            return e;
          })
          .toList();
    }
    return null;
  }

  List<String>? get parsedDietaryTags {
    if (itemAtt != null && itemAtt!.trim().isNotEmpty) {
      return itemAtt!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return null;
  }

  List<String>? get parsedSpecialInstructions {
    if (spInst != null && spInst!.trim().isNotEmpty && spInst != '[]' && spInst != 'null') {
      try {
        final decoded = jsonDecode(spInst!);
        if (decoded is List) {
          return decoded.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
        }
      } catch (_) {
        return spInst!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
    }
    return null;
  }

  /// Safely resolves full image URL from relative path or complete URL
  static String? resolveImageUrl({
    String? itemImage,
    String? baseUrl,
    String? treasureUrl,
    int? restoId,
  }) {
    if (itemImage == null || itemImage.trim().isEmpty || itemImage.trim() == 'null') {
      return null;
    }
    var cleanPath = itemImage.trim();

    final storage = Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;
    final effectiveRestoId = (restoId != null && restoId > 0) ? restoId : (storage?.restoId ?? 0);
    final dynamicAssetsBase = Endpoints.activeAssetsBaseUrl;
    final targetHost = Uri.tryParse(dynamicAssetsBase)?.host ?? 'assets.eresto.in';

    // If already a full URL:
    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      final uri = Uri.tryParse(cleanPath);
      if (uri != null &&
          (uri.host.contains('assets.eresto.app') ||
              uri.host.contains('assets.eresto.in') ||
              uri.host.contains('eresto.in') ||
              uri.host.contains('eresto.app')) &&
          uri.path.contains('/public/treasure/')) {
        // Dynamically align domain with active API base domain
        if (uri.host.startsWith('assets.') && uri.host != targetHost) {
          cleanPath = cleanPath.replaceFirst(uri.host, targetHost);
        }

        if (!uri.path.contains('/archive/item_images/')) {
          final parts = cleanPath.split('/public/treasure/');
          if (parts.length == 2) {
            final postTreasure = parts[1];
            final slashIdx = postTreasure.indexOf('/');
            if (slashIdx != -1) {
              final restoPrefix = postTreasure.substring(0, slashIdx);
              final filename = postTreasure.substring(slashIdx + 1);
              if (!filename.startsWith('archive/item_images/')) {
                return Uri.encodeFull('${parts[0]}/public/treasure/$restoPrefix/archive/item_images/$filename');
              }
            } else if (effectiveRestoId > 0) {
              return Uri.encodeFull('${parts[0]}/public/treasure/$effectiveRestoId/archive/item_images/$postTreasure');
            }
          }
        }
      }
      return Uri.encodeFull(cleanPath);
    }

    var effectiveBase = (baseUrl != null && baseUrl.trim().isNotEmpty)
        ? baseUrl.trim()
        : (treasureUrl != null && treasureUrl.trim().isNotEmpty
            ? treasureUrl.trim()
            : (storage?.treasureUrl.trim() ?? ''));

    // Align effectiveBase assets domain with active targetHost if applicable
    final effUri = Uri.tryParse(effectiveBase);
    if (effUri != null && effUri.host.startsWith('assets.') && effUri.host != targetHost) {
      effectiveBase = effectiveBase.replaceFirst(effUri.host, targetHost);
    }

    // Default fallback if base is empty and restaurant ID is known
    if (effectiveBase.isEmpty && effectiveRestoId > 0) {
      effectiveBase = '$dynamicAssetsBase/public/treasure/$effectiveRestoId/archive/item_images/';
    }

    if (effectiveBase.isEmpty) {
      return null;
    }

    var base = effectiveBase.endsWith('/') ? effectiveBase : '$effectiveBase/';
    var path = cleanPath.startsWith('/') ? cleanPath.substring(1) : cleanPath;

    // Handle when base is like "https://assets.eresto.in/public/treasure/" without restoId
    if ((base.endsWith('/public/treasure/') || base.endsWith('/public/treasure')) && effectiveRestoId > 0) {
      base = base.endsWith('/') ? '$base$effectiveRestoId/archive/item_images/' : '$base/$effectiveRestoId/archive/item_images/';
    }

    // If base doesn't have archive/item_images/ and path doesn't start with archive/item_images,
    // and it's an Eresto treasure URL, insert archive/item_images/
    if (!base.contains('archive/item_images') && !path.startsWith('archive/item_images')) {
      if (base.contains('treasure') ||
          base.contains('assets.eresto.in') ||
          base.contains('assets.eresto.app') ||
          base.contains('eresto.in') ||
          base.contains('eresto.app')) {
        base = base.endsWith('/') ? '${base}archive/item_images/' : '$base/archive/item_images/';
      }
    }

    return Uri.encodeFull('$base$path');
  }

  factory V6ApiMenuItem.fromJson(Map<String, dynamic> json, {String? fallbackBaseUrl}) {
    // Parse item_price safely from num, String, etc.
    double parsedPrice = 0.0;
    if (json['item_price'] != null) {
      if (json['item_price'] is num) {
        parsedPrice = (json['item_price'] as num).toDouble();
      } else {
        parsedPrice = double.tryParse(json['item_price'].toString()) ?? 0.0;
      }
    }

    // Safely extract integer digits from calorie strings like "20 Kcal" or 20
    int? parsedCal;
    if (json['cal'] != null) {
      if (json['cal'] is int) {
        parsedCal = json['cal'] as int;
      } else {
        final match = RegExp(r'\d+').firstMatch(json['cal'].toString());
        if (match != null) {
          parsedCal = int.tryParse(match.group(0)!);
        }
      }
    }

    // Safely parse vrnt & aoi as normalized JSON strings
    String? safeJsonString(dynamic v) {
      if (v == null) return null;
      if (v is String) {
        final s = v.trim();
        if (s.isEmpty || s == 'null' || s == '[]' || s == '{}') return null;
        return s;
      }
      try {
        return jsonEncode(v);
      } catch (_) {
        return null;
      }
    }

    final rawVrnt = json['vrnt'] ?? json['vrnt_json'] ?? json['Vrnt'] ?? json['variants'] ?? json['variant'];
    final rawAoi = json['aoi'] ?? json['aoi_json'] ?? json['Aoi'] ?? json['addons'] ?? json['customizations'];

    return V6ApiMenuItem(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      itemName: json['item_name']?.toString() ?? '',
      itemShortName: json['item_short_name']?.toString() ?? '',
      itemPrice: parsedPrice,
      itemCatId: json['item_cat_id'] is int
          ? json['item_cat_id'] as int
          : int.tryParse(json['item_cat_id']?.toString() ?? '0') ?? 0,
      menuType: json['menu_type'] is int
          ? json['menu_type'] as int
          : int.tryParse(json['menu_type']?.toString() ?? '1') ?? 1,
      kitchenCatId: json['kitchen_cat_id'] is int
          ? json['kitchen_cat_id'] as int
          : int.tryParse(json['kitchen_cat_id']?.toString() ?? ''),
      itemSalesCatId: json['item_sales_cat_id'] is int
          ? json['item_sales_cat_id'] as int
          : int.tryParse(json['item_sales_cat_id']?.toString() ?? ''),
      isNa: json['is_na'] is int
          ? json['is_na'] as int
          : int.tryParse(json['is_na']?.toString() ?? '0') ?? 0,
      isFsi: json['is_fsi'] is int
          ? json['is_fsi'] as int
          : int.tryParse(json['is_fsi']?.toString() ?? '0') ?? 0,
      itemNameAlias: json['item_name_alias']?.toString(),
      qty: json['qty']?.toString(),
      cal: parsedCal,
      aik: json['aik']?.toString(),
      itemAtt: json['item_att']?.toString(),
      itemImage: json['item_image']?.toString(),
      spInst: json['sp_inst']?.toString(),
      menuCatId: json['menu_cat_id'] is int
          ? json['menu_cat_id'] as int
          : int.tryParse(json['menu_cat_id']?.toString() ?? ''),
      itemTax: json['item_tax']?.toString(),
      taxTmplMastId: json['tax_tmpl_mast_id'] is int
          ? json['tax_tmpl_mast_id'] as int
          : (json['tax_tmpl_id'] is int
              ? json['tax_tmpl_id'] as int
              : (json['item_tax_tmpl_id'] is int
                  ? json['item_tax_tmpl_id'] as int
                  : int.tryParse(json['tax_tmpl_mast_id']?.toString() ??
                      json['tax_tmpl_id']?.toString() ??
                      json['item_tax_tmpl_id']?.toString() ?? ''))),
      isNonveg: json['is_nonveg'] is int
          ? json['is_nonveg'] as int
          : int.tryParse(json['is_nonveg']?.toString() ?? '0') ?? 0,
      ingredients: json['ingredients']?.toString(),
      shortDesc: json['short_desc']?.toString(),
      deliveryTime: json['delivery_time']?.toString(),
      baseUrl: (json['img_base'] ??
              json['item_base'] ??
              json['item_base_url'] ??
              json['base_url'] ??
              json['image_base'] ??
              json['image_base_url'] ??
              json['img_base_url'] ??
              fallbackBaseUrl)
          ?.toString(),
      vrnt: safeJsonString(rawVrnt),
      aoi: safeJsonString(rawAoi),
    );
  }

  /// Map to domain ItemModel used by UI
  ItemModel toItemModel({
    required String categoryName,
    String? treasureUrl,
    String? kitchenCategoryName,
    String? salesCategoryName,
    String? taxTemplateName,
  }) {
    final fullImageUrl = resolveImageUrl(
      itemImage: itemImage,
      baseUrl: baseUrl,
      treasureUrl: treasureUrl,
    );

    final parsedServiceTime = int.tryParse(
      RegExp(r'\d+').firstMatch(deliveryTime ?? '')?.group(0) ?? '',
    ) ?? 15;

    final resolvedTax = (taxTemplateName != null && taxTemplateName.isNotEmpty)
        ? taxTemplateName
        : ((itemTax != null && itemTax!.isNotEmpty && !itemTax!.startsWith('['))
            ? itemTax!
            : 'GST @ 5%');

    return ItemModel(
      id: id,
      name: itemName,
      shortCode: itemShortName.isNotEmpty ? itemShortName : itemName,
      price: itemPrice,
      isAvailable: isAvailable,
      isFrequentlySold: isFrequentlySold,
      vegType: isVeg ? 'veg' : 'non_veg',
      portion: (qty != null && qty!.trim().isNotEmpty) ? qty!.trim() : null,
      calorificValue: cal,
      serviceTime: parsedServiceTime,
      ingredients: ingredients,
      shortDescription: (shortDesc != null && shortDesc!.isNotEmpty) ? shortDesc : null,
      itemGroup: categoryName.toUpperCase(),
      taxTemplate: resolvedTax,
      kitchenCategory: kitchenCategoryName,
      salesCategory: salesCategoryName,
      dietaryTags: parsedDietaryTags,
      allergens: parsedAllergens,
      imageUrl: fullImageUrl,
      variantsJson: vrnt,
      addonsJson: aoi,
      specialInstructions: parsedSpecialInstructions,
    );
  }

  /// Map to Isar collection record for offline caching
  MenuItemCollection toIsarCollection({
    required String categoryName,
    String? treasureUrl,
    String? kitchenCategoryName,
    String? salesCategoryName,
    String? taxTemplateName,
    MenuItemCollection? existingRecord,
  }) {
    final record = existingRecord ?? (MenuItemCollection()..remoteId = id);

    final fullImageUrl = resolveImageUrl(
      itemImage: itemImage,
      baseUrl: baseUrl,
      treasureUrl: treasureUrl,
    );

    final parsedServiceTime = int.tryParse(
      RegExp(r'\d+').firstMatch(deliveryTime ?? '')?.group(0) ?? '',
    ) ?? 15;

    final resolvedTax = (taxTemplateName != null && taxTemplateName.isNotEmpty)
        ? taxTemplateName
        : ((itemTax != null && itemTax!.isNotEmpty && !itemTax!.startsWith('['))
            ? itemTax!
            : 'GST @ 5%');

    record.name = itemName;
    record.shortCode = itemShortName.isNotEmpty ? itemShortName : itemName;
    record.price = itemPrice;
    record.isAvailable = isAvailable;
    record.isFrequentlySold = isFrequentlySold;
    record.vegType = isVeg ? 'veg' : 'non_veg';
    record.portion = (qty != null && qty!.trim().isNotEmpty) ? qty!.trim() : null;
    record.calorificValue = cal;
    record.serviceTime = parsedServiceTime;
    record.ingredients = ingredients;
    record.shortDescription = (shortDesc != null && shortDesc!.isNotEmpty) ? shortDesc : null;
    record.itemGroup = categoryName.toUpperCase();
    record.taxTemplate = resolvedTax;
    record.kitchenCategory = kitchenCategoryName;
    record.salesCategory = salesCategoryName;
    record.dietaryTags = parsedDietaryTags;
    record.allergens = parsedAllergens;
    record.imageUrl = fullImageUrl;
    record.variantsJson = vrnt;
    record.addonsJson = aoi;
    record.specialInstructions = parsedSpecialInstructions;

    return record;
  }
}
