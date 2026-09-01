// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemModelImpl _$$ItemModelImplFromJson(Map<String, dynamic> json) =>
    _$ItemModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      shortCode: json['shortCode'] as String,
      price: (json['price'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
      isFrequentlySold: json['isFrequentlySold'] as bool,
      vegType: json['vegType'] as String,
      imageUrl: json['imageUrl'] as String?,
      portion: json['portion'] as String?,
      calorificValue: (json['calorificValue'] as num?)?.toInt(),
      serviceTime: (json['serviceTime'] as num?)?.toInt(),
      ingredients: json['ingredients'] as String?,
      shortDescription: json['shortDescription'] as String?,
      itemGroup: json['itemGroup'] as String,
      taxTemplate: json['taxTemplate'] as String,
      kitchenCategory: json['kitchenCategory'] as String?,
      salesCategory: json['salesCategory'] as String?,
      dietaryTags: (json['dietaryTags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ItemModelImplToJson(_$ItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortCode': instance.shortCode,
      'price': instance.price,
      'isAvailable': instance.isAvailable,
      'isFrequentlySold': instance.isFrequentlySold,
      'vegType': instance.vegType,
      'imageUrl': instance.imageUrl,
      'portion': instance.portion,
      'calorificValue': instance.calorificValue,
      'serviceTime': instance.serviceTime,
      'ingredients': instance.ingredients,
      'shortDescription': instance.shortDescription,
      'itemGroup': instance.itemGroup,
      'taxTemplate': instance.taxTemplate,
      'kitchenCategory': instance.kitchenCategory,
      'salesCategory': instance.salesCategory,
      'dietaryTags': instance.dietaryTags,
      'allergens': instance.allergens,
    };
