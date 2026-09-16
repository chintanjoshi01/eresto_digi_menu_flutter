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
}
