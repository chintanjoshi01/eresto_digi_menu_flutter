// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) {
  return _ItemModel.fromJson(json);
}

/// @nodoc
mixin _$ItemModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get shortCode => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  bool get isFrequentlySold => throw _privateConstructorUsedError;
  String get vegType =>
      throw _privateConstructorUsedError; // veg | non_veg | na
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get portion => throw _privateConstructorUsedError;
  int? get calorificValue => throw _privateConstructorUsedError;
  int? get serviceTime => throw _privateConstructorUsedError;
  String? get ingredients => throw _privateConstructorUsedError;
  String? get shortDescription => throw _privateConstructorUsedError;
  String get itemGroup => throw _privateConstructorUsedError;
  String get taxTemplate => throw _privateConstructorUsedError;
  String? get kitchenCategory => throw _privateConstructorUsedError;
  String? get salesCategory => throw _privateConstructorUsedError;
  List<String>? get dietaryTags => throw _privateConstructorUsedError;
  List<String>? get allergens => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemModelCopyWith<ItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemModelCopyWith<$Res> {
  factory $ItemModelCopyWith(ItemModel value, $Res Function(ItemModel) then) =
      _$ItemModelCopyWithImpl<$Res, ItemModel>;
  @useResult
  $Res call(
      {int id,
      String name,
      String shortCode,
      double price,
      bool isAvailable,
      bool isFrequentlySold,
      String vegType,
      String? imageUrl,
      String? portion,
      int? calorificValue,
      int? serviceTime,
      String? ingredients,
      String? shortDescription,
      String itemGroup,
      String taxTemplate,
      String? kitchenCategory,
      String? salesCategory,
      List<String>? dietaryTags,
      List<String>? allergens});
}

/// @nodoc
class _$ItemModelCopyWithImpl<$Res, $Val extends ItemModel>
    implements $ItemModelCopyWith<$Res> {
  _$ItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortCode = null,
    Object? price = null,
    Object? isAvailable = null,
    Object? isFrequentlySold = null,
    Object? vegType = null,
    Object? imageUrl = freezed,
    Object? portion = freezed,
    Object? calorificValue = freezed,
    Object? serviceTime = freezed,
    Object? ingredients = freezed,
    Object? shortDescription = freezed,
    Object? itemGroup = null,
    Object? taxTemplate = null,
    Object? kitchenCategory = freezed,
    Object? salesCategory = freezed,
    Object? dietaryTags = freezed,
    Object? allergens = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortCode: null == shortCode
          ? _value.shortCode
          : shortCode // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFrequentlySold: null == isFrequentlySold
          ? _value.isFrequentlySold
          : isFrequentlySold // ignore: cast_nullable_to_non_nullable
              as bool,
      vegType: null == vegType
          ? _value.vegType
          : vegType // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portion: freezed == portion
          ? _value.portion
          : portion // ignore: cast_nullable_to_non_nullable
              as String?,
      calorificValue: freezed == calorificValue
          ? _value.calorificValue
          : calorificValue // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceTime: freezed == serviceTime
          ? _value.serviceTime
          : serviceTime // ignore: cast_nullable_to_non_nullable
              as int?,
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      itemGroup: null == itemGroup
          ? _value.itemGroup
          : itemGroup // ignore: cast_nullable_to_non_nullable
              as String,
      taxTemplate: null == taxTemplate
          ? _value.taxTemplate
          : taxTemplate // ignore: cast_nullable_to_non_nullable
              as String,
      kitchenCategory: freezed == kitchenCategory
          ? _value.kitchenCategory
          : kitchenCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      salesCategory: freezed == salesCategory
          ? _value.salesCategory
          : salesCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      dietaryTags: freezed == dietaryTags
          ? _value.dietaryTags
          : dietaryTags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      allergens: freezed == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemModelImplCopyWith<$Res>
    implements $ItemModelCopyWith<$Res> {
  factory _$$ItemModelImplCopyWith(
          _$ItemModelImpl value, $Res Function(_$ItemModelImpl) then) =
      __$$ItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String shortCode,
      double price,
      bool isAvailable,
      bool isFrequentlySold,
      String vegType,
      String? imageUrl,
      String? portion,
      int? calorificValue,
      int? serviceTime,
      String? ingredients,
      String? shortDescription,
      String itemGroup,
      String taxTemplate,
      String? kitchenCategory,
      String? salesCategory,
      List<String>? dietaryTags,
      List<String>? allergens});
}

/// @nodoc
class __$$ItemModelImplCopyWithImpl<$Res>
    extends _$ItemModelCopyWithImpl<$Res, _$ItemModelImpl>
    implements _$$ItemModelImplCopyWith<$Res> {
  __$$ItemModelImplCopyWithImpl(
      _$ItemModelImpl _value, $Res Function(_$ItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortCode = null,
    Object? price = null,
    Object? isAvailable = null,
    Object? isFrequentlySold = null,
    Object? vegType = null,
    Object? imageUrl = freezed,
    Object? portion = freezed,
    Object? calorificValue = freezed,
    Object? serviceTime = freezed,
    Object? ingredients = freezed,
    Object? shortDescription = freezed,
    Object? itemGroup = null,
    Object? taxTemplate = null,
    Object? kitchenCategory = freezed,
    Object? salesCategory = freezed,
    Object? dietaryTags = freezed,
    Object? allergens = freezed,
  }) {
    return _then(_$ItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortCode: null == shortCode
          ? _value.shortCode
          : shortCode // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFrequentlySold: null == isFrequentlySold
          ? _value.isFrequentlySold
          : isFrequentlySold // ignore: cast_nullable_to_non_nullable
              as bool,
      vegType: null == vegType
          ? _value.vegType
          : vegType // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portion: freezed == portion
          ? _value.portion
          : portion // ignore: cast_nullable_to_non_nullable
              as String?,
      calorificValue: freezed == calorificValue
          ? _value.calorificValue
          : calorificValue // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceTime: freezed == serviceTime
          ? _value.serviceTime
          : serviceTime // ignore: cast_nullable_to_non_nullable
              as int?,
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      itemGroup: null == itemGroup
          ? _value.itemGroup
          : itemGroup // ignore: cast_nullable_to_non_nullable
              as String,
      taxTemplate: null == taxTemplate
          ? _value.taxTemplate
          : taxTemplate // ignore: cast_nullable_to_non_nullable
              as String,
      kitchenCategory: freezed == kitchenCategory
          ? _value.kitchenCategory
          : kitchenCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      salesCategory: freezed == salesCategory
          ? _value.salesCategory
          : salesCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      dietaryTags: freezed == dietaryTags
          ? _value._dietaryTags
          : dietaryTags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      allergens: freezed == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemModelImpl implements _ItemModel {
  const _$ItemModelImpl(
      {required this.id,
      required this.name,
      required this.shortCode,
      required this.price,
      required this.isAvailable,
      required this.isFrequentlySold,
      required this.vegType,
      this.imageUrl,
      this.portion,
      this.calorificValue,
      this.serviceTime,
      this.ingredients,
      this.shortDescription,
      required this.itemGroup,
      required this.taxTemplate,
      this.kitchenCategory,
      this.salesCategory,
      final List<String>? dietaryTags,
      final List<String>? allergens})
      : _dietaryTags = dietaryTags,
        _allergens = allergens;

  factory _$ItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String shortCode;
  @override
  final double price;
  @override
  final bool isAvailable;
  @override
  final bool isFrequentlySold;
  @override
  final String vegType;
// veg | non_veg | na
  @override
  final String? imageUrl;
  @override
  final String? portion;
  @override
  final int? calorificValue;
  @override
  final int? serviceTime;
  @override
  final String? ingredients;
  @override
  final String? shortDescription;
  @override
  final String itemGroup;
  @override
  final String taxTemplate;
  @override
  final String? kitchenCategory;
  @override
  final String? salesCategory;
  final List<String>? _dietaryTags;
  @override
  List<String>? get dietaryTags {
    final value = _dietaryTags;
    if (value == null) return null;
    if (_dietaryTags is EqualUnmodifiableListView) return _dietaryTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _allergens;
  @override
  List<String>? get allergens {
    final value = _allergens;
    if (value == null) return null;
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ItemModel(id: $id, name: $name, shortCode: $shortCode, price: $price, isAvailable: $isAvailable, isFrequentlySold: $isFrequentlySold, vegType: $vegType, imageUrl: $imageUrl, portion: $portion, calorificValue: $calorificValue, serviceTime: $serviceTime, ingredients: $ingredients, shortDescription: $shortDescription, itemGroup: $itemGroup, taxTemplate: $taxTemplate, kitchenCategory: $kitchenCategory, salesCategory: $salesCategory, dietaryTags: $dietaryTags, allergens: $allergens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortCode, shortCode) ||
                other.shortCode == shortCode) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isFrequentlySold, isFrequentlySold) ||
                other.isFrequentlySold == isFrequentlySold) &&
            (identical(other.vegType, vegType) || other.vegType == vegType) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.portion, portion) || other.portion == portion) &&
            (identical(other.calorificValue, calorificValue) ||
                other.calorificValue == calorificValue) &&
            (identical(other.serviceTime, serviceTime) ||
                other.serviceTime == serviceTime) &&
            (identical(other.ingredients, ingredients) ||
                other.ingredients == ingredients) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.itemGroup, itemGroup) ||
                other.itemGroup == itemGroup) &&
            (identical(other.taxTemplate, taxTemplate) ||
                other.taxTemplate == taxTemplate) &&
            (identical(other.kitchenCategory, kitchenCategory) ||
                other.kitchenCategory == kitchenCategory) &&
            (identical(other.salesCategory, salesCategory) ||
                other.salesCategory == salesCategory) &&
            const DeepCollectionEquality()
                .equals(other._dietaryTags, _dietaryTags) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        shortCode,
        price,
        isAvailable,
        isFrequentlySold,
        vegType,
        imageUrl,
        portion,
        calorificValue,
        serviceTime,
        ingredients,
        shortDescription,
        itemGroup,
        taxTemplate,
        kitchenCategory,
        salesCategory,
        const DeepCollectionEquality().hash(_dietaryTags),
        const DeepCollectionEquality().hash(_allergens)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemModelImplCopyWith<_$ItemModelImpl> get copyWith =>
      __$$ItemModelImplCopyWithImpl<_$ItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemModelImplToJson(
      this,
    );
  }
}

abstract class _ItemModel implements ItemModel {
  const factory _ItemModel(
      {required final int id,
      required final String name,
      required final String shortCode,
      required final double price,
      required final bool isAvailable,
      required final bool isFrequentlySold,
      required final String vegType,
      final String? imageUrl,
      final String? portion,
      final int? calorificValue,
      final int? serviceTime,
      final String? ingredients,
      final String? shortDescription,
      required final String itemGroup,
      required final String taxTemplate,
      final String? kitchenCategory,
      final String? salesCategory,
      final List<String>? dietaryTags,
      final List<String>? allergens}) = _$ItemModelImpl;

  factory _ItemModel.fromJson(Map<String, dynamic> json) =
      _$ItemModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get shortCode;
  @override
  double get price;
  @override
  bool get isAvailable;
  @override
  bool get isFrequentlySold;
  @override
  String get vegType;
  @override // veg | non_veg | na
  String? get imageUrl;
  @override
  String? get portion;
  @override
  int? get calorificValue;
  @override
  int? get serviceTime;
  @override
  String? get ingredients;
  @override
  String? get shortDescription;
  @override
  String get itemGroup;
  @override
  String get taxTemplate;
  @override
  String? get kitchenCategory;
  @override
  String? get salesCategory;
  @override
  List<String>? get dietaryTags;
  @override
  List<String>? get allergens;
  @override
  @JsonKey(ignore: true)
  _$$ItemModelImplCopyWith<_$ItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
