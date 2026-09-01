// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthModelImpl _$$AuthModelImplFromJson(Map<String, dynamic> json) =>
    _$AuthModelImpl(
      token: json['token'] as String,
      restoId: (json['restoId'] as num).toInt(),
      restoName: json['restoName'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$$AuthModelImplToJson(_$AuthModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'restoId': instance.restoId,
      'restoName': instance.restoName,
      'email': instance.email,
    };
