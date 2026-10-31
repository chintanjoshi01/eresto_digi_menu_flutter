import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

@freezed
class ItemModel with _$ItemModel {
  const ItemModel._();

  const factory ItemModel({
    required int id,
    required String name,
    required String shortCode,
    required double price,
    required bool isAvailable,
    required bool isFrequentlySold,
    required String vegType,        // veg | non_veg | na
    String? imageUrl,
    String? portion,
    int? calorificValue,
    int? serviceTime,
    String? ingredients,
    String? shortDescription,
    required String itemGroup,
    required String taxTemplate,
    String? kitchenCategory,
    String? salesCategory,
    List<String>? dietaryTags,
    List<String>? allergens,
    String? variantsJson,
    String? addonsJson,
    List<String>? specialInstructions,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  bool get hasVariants {
    final v = variantsJson?.trim() ?? '';
    if (v.isEmpty || v == 'null' || v == '[]' || v == '{}') return false;
    try {
      final decoded = jsonDecode(v);
      if (decoded is List) return decoded.isNotEmpty;
      if (decoded is Map) return decoded.isNotEmpty;
      return false;
    } catch (_) {
      return false;
    }
  }

  bool get hasAddons {
    final a = addonsJson?.trim() ?? '';
    if (a.isEmpty || a == 'null' || a == '[]' || a == '{}') return false;
    try {
      final decoded = jsonDecode(a);
      if (decoded is List) return decoded.isNotEmpty;
      if (decoded is Map) return decoded.isNotEmpty;
      return false;
    } catch (_) {
      return false;
    }
  }

  bool get isCustomizable => hasVariants || hasAddons;

  bool get isVeg => vegType.toLowerCase() == 'veg';

  /// Formatted price or price range string (e.g. "60.00 - 200.00" or "120.00")
  String get formattedPriceRange {
    if (hasVariants) {
      final prices = variantPrices;
      if (prices.isNotEmpty) {
        final minPrice = prices.reduce((a, b) => a < b ? a : b);
        final maxPrice = prices.reduce((a, b) => a > b ? a : b);
        if (minPrice != maxPrice) {
          return '${minPrice.toStringAsFixed(2)} - ${maxPrice.toStringAsFixed(2)}';
        } else {
          return minPrice.toStringAsFixed(2);
        }
      }
    }
    return price.toStringAsFixed(2);
  }

  /// Extracts all variant prices as doubles
  List<double> get variantPrices {
    final v = variantsJson?.trim() ?? '';
    if (v.isEmpty || v == 'null' || v == '[]' || v == '{}') return [];
    try {
      final decoded = jsonDecode(v);
      List list = [];
      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map) {
        list = decoded.values.toList();
      }
      final prices = <double>[];
      for (final item in list) {
        if (item is Map) {
          final pRaw = item['price'] ?? item['b'] ?? item['prc'] ?? item['p'];
          if (pRaw != null) {
            final parsed = double.tryParse(pRaw.toString());
            if (parsed != null && parsed >= 0) {
              prices.add(parsed);
            }
          }
        }
      }
      return prices;
    } catch (_) {
      return [];
    }
  }

  /// Effective price for sorting or calculations (min variant price if variants exist)
  double get effectivePrice {
    if (hasVariants) {
      final prices = variantPrices;
      if (prices.isNotEmpty) {
        return prices.reduce((a, b) => a < b ? a : b);
      }
    }
    return price;
  }
}
