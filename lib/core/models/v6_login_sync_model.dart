/// Top-level response wrapper for /api/v6/get_login_sync_data
class V6LoginSyncResponse {
  final int status;
  final String message;
  final V6LoginSyncData? data;

  const V6LoginSyncResponse({
    required this.status,
    required this.message,
    this.data,
  });

  bool get isSuccess => status == 1 && data != null;

  factory V6LoginSyncResponse.fromJson(Map<String, dynamic> json) {
    return V6LoginSyncResponse(
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? V6LoginSyncData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

/// Main container for restaurant master data synchronized at login
class V6LoginSyncData {
  final List<V6KitchenCat> kitchenCategories;
  final List<V6SalesCat> salesCategories;
  final List<V6RestoSpInst> restoSpecialInstructions;
  final List<V6PriceTemplate> priceTemplates;
  final List<V6TaxTemplate> taxTemplates;
  final DateTime cachedAt;

  const V6LoginSyncData({
    required this.kitchenCategories,
    required this.salesCategories,
    required this.restoSpecialInstructions,
    required this.priceTemplates,
    required this.taxTemplates,
    required this.cachedAt,
  });

  factory V6LoginSyncData.fromJson(Map<String, dynamic> json) {
    // Both kitchen_cat and item_kitchen_cat can be returned by API
    final rawKitchen = (json['kitchen_cat'] as List?) ??
        (json['item_kitchen_cat'] as List?) ??
        [];
    final kitchenList = rawKitchen
        .whereType<Map<String, dynamic>>()
        .map((e) => V6KitchenCat.fromJson(e))
        .toList();

    // Both sales_cat and item_sales_cat can be returned by API
    final rawSales = (json['sales_cat'] as List?) ??
        (json['item_sales_cat'] as List?) ??
        [];
    final salesList = rawSales
        .whereType<Map<String, dynamic>>()
        .map((e) => V6SalesCat.fromJson(e))
        .toList();

    final rawSpInst = (json['resto_sp_inst'] as List?) ?? [];
    final spInstList = rawSpInst
        .whereType<Map<String, dynamic>>()
        .map((e) => V6RestoSpInst.fromJson(e))
        .toList();

    final rawPriceTmpl = (json['price_templates'] as List?) ?? [];
    final priceTmplList = rawPriceTmpl
        .whereType<Map<String, dynamic>>()
        .map((e) => V6PriceTemplate.fromJson(e))
        .toList();

    // Support both tax_templates and tax_tamplates from sync payload
    final rawTax = (json['tax_templates'] as List?) ??
        (json['tax_tamplates'] as List?) ??
        [];
    final taxList = rawTax
        .whereType<Map<String, dynamic>>()
        .map((e) => V6TaxTemplate.fromJson(e))
        .toList();

    final cachedAtMs = json['_cached_at_ms'] as int?;
    final cachedAt = cachedAtMs != null
        ? DateTime.fromMillisecondsSinceEpoch(cachedAtMs)
        : DateTime.now();

    return V6LoginSyncData(
      kitchenCategories: kitchenList,
      salesCategories: salesList,
      restoSpecialInstructions: spInstList,
      priceTemplates: priceTmplList,
      taxTemplates: taxList,
      cachedAt: cachedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'kitchen_cat': kitchenCategories.map((e) => e.toJson()).toList(),
        'sales_cat': salesCategories.map((e) => e.toJson()).toList(),
        'resto_sp_inst': restoSpecialInstructions.map((e) => e.toJson()).toList(),
        'price_templates': priceTemplates.map((e) => e.toJson()).toList(),
        'tax_templates': taxTemplates.map((e) => e.toJson()).toList(),
        '_cached_at_ms': cachedAt.millisecondsSinceEpoch,
      };

  /// Lookup kitchen category name by ID
  String? getKitchenCategoryName(int? id) {
    if (id == null) return null;
    final match = kitchenCategories.firstWhere(
      (e) => e.id == id,
      orElse: () => const V6KitchenCat(id: -1, itemKitchenCat: ''),
    );
    return match.id != -1 ? match.itemKitchenCat : null;
  }

  /// Lookup sales category name by ID
  String? getSalesCategoryName(int? id) {
    if (id == null) return null;
    final match = salesCategories.firstWhere(
      (e) => e.id == id,
      orElse: () => const V6SalesCat(id: -1, itemSalesCat: ''),
    );
    return match.id != -1 ? match.itemSalesCat : null;
  }

  /// Lookup tax template name by ID (e.g. 1 -> "GST @ 5%")
  String? getTaxTemplateName(int? id) {
    if (id == null) return null;
    final match = taxTemplates.firstWhere(
      (e) => e.id == id,
      orElse: () => const V6TaxTemplate(id: -1, taxTmpl: ''),
    );
    return match.id != -1 ? match.taxTmpl : null;
  }

  /// Lookup tax template ID by name
  int? getTaxTemplateId(String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final clean = name.trim().toLowerCase();
    final match = taxTemplates.firstWhere(
      (e) => e.taxTmpl.trim().toLowerCase() == clean,
      orElse: () => const V6TaxTemplate(id: -1, taxTmpl: ''),
    );
    return match.id != -1 ? match.id : null;
  }
}

/// Restaurant Tax Template (e.g. GST @ 5%, New_tax)
class V6TaxTemplate {
  final int id;
  final String taxTmpl;
  final String? taxTmplJson;

  const V6TaxTemplate({
    required this.id,
    required this.taxTmpl,
    this.taxTmplJson,
  });

  factory V6TaxTemplate.fromJson(Map<String, dynamic> json) {
    return V6TaxTemplate(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      taxTmpl: json['tax_tmpl']?.toString() ?? json['name']?.toString() ?? '',
      taxTmplJson: json['tax_tmpl_json']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tax_tmpl': taxTmpl,
        if (taxTmplJson != null) 'tax_tmpl_json': taxTmplJson,
      };
}

/// Kitchen Category for KOT routing and station assignment
class V6KitchenCat {
  final int id;
  final String itemKitchenCat;

  const V6KitchenCat({
    required this.id,
    required this.itemKitchenCat,
  });

  factory V6KitchenCat.fromJson(Map<String, dynamic> json) {
    return V6KitchenCat(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      itemKitchenCat: json['item_kitchen_cat']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'item_kitchen_cat': itemKitchenCat,
      };
}

/// Sales Category for revenue reporting and POS grouping
class V6SalesCat {
  final int id;
  final String itemSalesCat;

  const V6SalesCat({
    required this.id,
    required this.itemSalesCat,
  });

  factory V6SalesCat.fromJson(Map<String, dynamic> json) {
    return V6SalesCat(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      itemSalesCat: json['item_sales_cat']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'item_sales_cat': itemSalesCat,
      };
}

/// Restaurant Custom Cooking Special Instructions / Notes
class V6RestoSpInst {
  final int id;
  final String spInst;

  const V6RestoSpInst({
    required this.id,
    required this.spInst,
  });

  factory V6RestoSpInst.fromJson(Map<String, dynamic> json) {
    return V6RestoSpInst(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      spInst: json['sp_inst']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sp_inst': spInst,
      };
}

/// Menu Pricing Template (e.g. Regular Dine-In, Room Service, Online Delivery)
class V6PriceTemplate {
  final int ptId;
  final int id;
  final String priceTemplate;

  const V6PriceTemplate({
    required this.ptId,
    required this.id,
    required this.priceTemplate,
  });

  factory V6PriceTemplate.fromJson(Map<String, dynamic> json) {
    final ptIdVal = json['pt_id'] is int
        ? json['pt_id'] as int
        : int.tryParse(json['pt_id']?.toString() ?? '0') ?? 0;

    final idVal = json['id'] is int
        ? json['id'] as int
        : int.tryParse(json['id']?.toString() ?? '0') ?? ptIdVal;

    return V6PriceTemplate(
      ptId: ptIdVal,
      id: idVal,
      priceTemplate: json['price_template']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'pt_id': ptId,
        'id': id,
        'price_template': priceTemplate,
      };
}
