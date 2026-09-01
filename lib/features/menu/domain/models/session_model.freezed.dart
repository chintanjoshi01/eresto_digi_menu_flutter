// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) {
  return _SessionModel.fromJson(json);
}

/// @nodoc
mixin _$SessionModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get splashImageUrl => throw _privateConstructorUsedError;
  String? get offerImageUrl => throw _privateConstructorUsedError;
  String? get offerDescription => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionModelCopyWith<SessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionModelCopyWith<$Res> {
  factory $SessionModelCopyWith(
          SessionModel value, $Res Function(SessionModel) then) =
      _$SessionModelCopyWithImpl<$Res, SessionModel>;
  @useResult
  $Res call(
      {int id,
      String name,
      String startTime,
      String endTime,
      bool isActive,
      String? splashImageUrl,
      String? offerImageUrl,
      String? offerDescription});
}

/// @nodoc
class _$SessionModelCopyWithImpl<$Res, $Val extends SessionModel>
    implements $SessionModelCopyWith<$Res> {
  _$SessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isActive = null,
    Object? splashImageUrl = freezed,
    Object? offerImageUrl = freezed,
    Object? offerDescription = freezed,
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
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      splashImageUrl: freezed == splashImageUrl
          ? _value.splashImageUrl
          : splashImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      offerImageUrl: freezed == offerImageUrl
          ? _value.offerImageUrl
          : offerImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      offerDescription: freezed == offerDescription
          ? _value.offerDescription
          : offerDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionModelImplCopyWith<$Res>
    implements $SessionModelCopyWith<$Res> {
  factory _$$SessionModelImplCopyWith(
          _$SessionModelImpl value, $Res Function(_$SessionModelImpl) then) =
      __$$SessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String startTime,
      String endTime,
      bool isActive,
      String? splashImageUrl,
      String? offerImageUrl,
      String? offerDescription});
}

/// @nodoc
class __$$SessionModelImplCopyWithImpl<$Res>
    extends _$SessionModelCopyWithImpl<$Res, _$SessionModelImpl>
    implements _$$SessionModelImplCopyWith<$Res> {
  __$$SessionModelImplCopyWithImpl(
      _$SessionModelImpl _value, $Res Function(_$SessionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isActive = null,
    Object? splashImageUrl = freezed,
    Object? offerImageUrl = freezed,
    Object? offerDescription = freezed,
  }) {
    return _then(_$SessionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      splashImageUrl: freezed == splashImageUrl
          ? _value.splashImageUrl
          : splashImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      offerImageUrl: freezed == offerImageUrl
          ? _value.offerImageUrl
          : offerImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      offerDescription: freezed == offerDescription
          ? _value.offerDescription
          : offerDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionModelImpl implements _SessionModel {
  const _$SessionModelImpl(
      {required this.id,
      required this.name,
      required this.startTime,
      required this.endTime,
      required this.isActive,
      this.splashImageUrl,
      this.offerImageUrl,
      this.offerDescription});

  factory _$SessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final bool isActive;
  @override
  final String? splashImageUrl;
  @override
  final String? offerImageUrl;
  @override
  final String? offerDescription;

  @override
  String toString() {
    return 'SessionModel(id: $id, name: $name, startTime: $startTime, endTime: $endTime, isActive: $isActive, splashImageUrl: $splashImageUrl, offerImageUrl: $offerImageUrl, offerDescription: $offerDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.splashImageUrl, splashImageUrl) ||
                other.splashImageUrl == splashImageUrl) &&
            (identical(other.offerImageUrl, offerImageUrl) ||
                other.offerImageUrl == offerImageUrl) &&
            (identical(other.offerDescription, offerDescription) ||
                other.offerDescription == offerDescription));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, startTime, endTime,
      isActive, splashImageUrl, offerImageUrl, offerDescription);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      __$$SessionModelImplCopyWithImpl<_$SessionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionModelImplToJson(
      this,
    );
  }
}

abstract class _SessionModel implements SessionModel {
  const factory _SessionModel(
      {required final int id,
      required final String name,
      required final String startTime,
      required final String endTime,
      required final bool isActive,
      final String? splashImageUrl,
      final String? offerImageUrl,
      final String? offerDescription}) = _$SessionModelImpl;

  factory _SessionModel.fromJson(Map<String, dynamic> json) =
      _$SessionModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  bool get isActive;
  @override
  String? get splashImageUrl;
  @override
  String? get offerImageUrl;
  @override
  String? get offerDescription;
  @override
  @JsonKey(ignore: true)
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
