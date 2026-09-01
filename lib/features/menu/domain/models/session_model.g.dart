// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionModelImpl _$$SessionModelImplFromJson(Map<String, dynamic> json) =>
    _$SessionModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isActive: json['isActive'] as bool,
      splashImageUrl: json['splashImageUrl'] as String?,
      offerImageUrl: json['offerImageUrl'] as String?,
      offerDescription: json['offerDescription'] as String?,
    );

Map<String, dynamic> _$$SessionModelImplToJson(_$SessionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isActive': instance.isActive,
      'splashImageUrl': instance.splashImageUrl,
      'offerImageUrl': instance.offerImageUrl,
      'offerDescription': instance.offerDescription,
    };
