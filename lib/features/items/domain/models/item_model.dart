import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

@freezed
class ItemModel with _$ItemModel {
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
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
}
