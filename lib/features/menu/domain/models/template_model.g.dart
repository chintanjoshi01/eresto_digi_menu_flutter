// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateModelImpl _$$TemplateModelImplFromJson(Map<String, dynamic> json) =>
    _$TemplateModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      primaryColor: json['primaryColor'] as String,
      backgroundColor: json['backgroundColor'] as String,
      textColor: json['textColor'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$TemplateModelImplToJson(_$TemplateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'primaryColor': instance.primaryColor,
      'backgroundColor': instance.backgroundColor,
      'textColor': instance.textColor,
      'isActive': instance.isActive,
    };
