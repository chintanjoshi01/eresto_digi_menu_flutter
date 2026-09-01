// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) {
  return _DashboardModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardModel {
  int get totalScans => throw _privateConstructorUsedError;
  List<int> get scanChartData => throw _privateConstructorUsedError;
  List<String> get scanChartLabels => throw _privateConstructorUsedError;
  String? get activeSessionName => throw _privateConstructorUsedError;
  String? get activeTemplateName => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get publishedItemsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardModelCopyWith<DashboardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardModelCopyWith<$Res> {
  factory $DashboardModelCopyWith(
          DashboardModel value, $Res Function(DashboardModel) then) =
      _$DashboardModelCopyWithImpl<$Res, DashboardModel>;
  @useResult
  $Res call(
      {int totalScans,
      List<int> scanChartData,
      List<String> scanChartLabels,
      String? activeSessionName,
      String? activeTemplateName,
      int totalItems,
      int publishedItemsCount});
}

/// @nodoc
class _$DashboardModelCopyWithImpl<$Res, $Val extends DashboardModel>
    implements $DashboardModelCopyWith<$Res> {
  _$DashboardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalScans = null,
    Object? scanChartData = null,
    Object? scanChartLabels = null,
    Object? activeSessionName = freezed,
    Object? activeTemplateName = freezed,
    Object? totalItems = null,
    Object? publishedItemsCount = null,
  }) {
    return _then(_value.copyWith(
      totalScans: null == totalScans
          ? _value.totalScans
          : totalScans // ignore: cast_nullable_to_non_nullable
              as int,
      scanChartData: null == scanChartData
          ? _value.scanChartData
          : scanChartData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      scanChartLabels: null == scanChartLabels
          ? _value.scanChartLabels
          : scanChartLabels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activeSessionName: freezed == activeSessionName
          ? _value.activeSessionName
          : activeSessionName // ignore: cast_nullable_to_non_nullable
              as String?,
      activeTemplateName: freezed == activeTemplateName
          ? _value.activeTemplateName
          : activeTemplateName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      publishedItemsCount: null == publishedItemsCount
          ? _value.publishedItemsCount
          : publishedItemsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardModelImplCopyWith<$Res>
    implements $DashboardModelCopyWith<$Res> {
  factory _$$DashboardModelImplCopyWith(_$DashboardModelImpl value,
          $Res Function(_$DashboardModelImpl) then) =
      __$$DashboardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalScans,
      List<int> scanChartData,
      List<String> scanChartLabels,
      String? activeSessionName,
      String? activeTemplateName,
      int totalItems,
      int publishedItemsCount});
}

/// @nodoc
class __$$DashboardModelImplCopyWithImpl<$Res>
    extends _$DashboardModelCopyWithImpl<$Res, _$DashboardModelImpl>
    implements _$$DashboardModelImplCopyWith<$Res> {
  __$$DashboardModelImplCopyWithImpl(
      _$DashboardModelImpl _value, $Res Function(_$DashboardModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalScans = null,
    Object? scanChartData = null,
    Object? scanChartLabels = null,
    Object? activeSessionName = freezed,
    Object? activeTemplateName = freezed,
    Object? totalItems = null,
    Object? publishedItemsCount = null,
  }) {
    return _then(_$DashboardModelImpl(
      totalScans: null == totalScans
          ? _value.totalScans
          : totalScans // ignore: cast_nullable_to_non_nullable
              as int,
      scanChartData: null == scanChartData
          ? _value._scanChartData
          : scanChartData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      scanChartLabels: null == scanChartLabels
          ? _value._scanChartLabels
          : scanChartLabels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activeSessionName: freezed == activeSessionName
          ? _value.activeSessionName
          : activeSessionName // ignore: cast_nullable_to_non_nullable
              as String?,
      activeTemplateName: freezed == activeTemplateName
          ? _value.activeTemplateName
          : activeTemplateName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      publishedItemsCount: null == publishedItemsCount
          ? _value.publishedItemsCount
          : publishedItemsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardModelImpl implements _DashboardModel {
  const _$DashboardModelImpl(
      {required this.totalScans,
      required final List<int> scanChartData,
      required final List<String> scanChartLabels,
      required this.activeSessionName,
      required this.activeTemplateName,
      required this.totalItems,
      required this.publishedItemsCount})
      : _scanChartData = scanChartData,
        _scanChartLabels = scanChartLabels;

  factory _$DashboardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardModelImplFromJson(json);

  @override
  final int totalScans;
  final List<int> _scanChartData;
  @override
  List<int> get scanChartData {
    if (_scanChartData is EqualUnmodifiableListView) return _scanChartData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scanChartData);
  }

  final List<String> _scanChartLabels;
  @override
  List<String> get scanChartLabels {
    if (_scanChartLabels is EqualUnmodifiableListView) return _scanChartLabels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scanChartLabels);
  }

  @override
  final String? activeSessionName;
  @override
  final String? activeTemplateName;
  @override
  final int totalItems;
  @override
  final int publishedItemsCount;

  @override
  String toString() {
    return 'DashboardModel(totalScans: $totalScans, scanChartData: $scanChartData, scanChartLabels: $scanChartLabels, activeSessionName: $activeSessionName, activeTemplateName: $activeTemplateName, totalItems: $totalItems, publishedItemsCount: $publishedItemsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardModelImpl &&
            (identical(other.totalScans, totalScans) ||
                other.totalScans == totalScans) &&
            const DeepCollectionEquality()
                .equals(other._scanChartData, _scanChartData) &&
            const DeepCollectionEquality()
                .equals(other._scanChartLabels, _scanChartLabels) &&
            (identical(other.activeSessionName, activeSessionName) ||
                other.activeSessionName == activeSessionName) &&
            (identical(other.activeTemplateName, activeTemplateName) ||
                other.activeTemplateName == activeTemplateName) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.publishedItemsCount, publishedItemsCount) ||
                other.publishedItemsCount == publishedItemsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalScans,
      const DeepCollectionEquality().hash(_scanChartData),
      const DeepCollectionEquality().hash(_scanChartLabels),
      activeSessionName,
      activeTemplateName,
      totalItems,
      publishedItemsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardModelImplCopyWith<_$DashboardModelImpl> get copyWith =>
      __$$DashboardModelImplCopyWithImpl<_$DashboardModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardModelImplToJson(
      this,
    );
  }
}

abstract class _DashboardModel implements DashboardModel {
  const factory _DashboardModel(
      {required final int totalScans,
      required final List<int> scanChartData,
      required final List<String> scanChartLabels,
      required final String? activeSessionName,
      required final String? activeTemplateName,
      required final int totalItems,
      required final int publishedItemsCount}) = _$DashboardModelImpl;

  factory _DashboardModel.fromJson(Map<String, dynamic> json) =
      _$DashboardModelImpl.fromJson;

  @override
  int get totalScans;
  @override
  List<int> get scanChartData;
  @override
  List<String> get scanChartLabels;
  @override
  String? get activeSessionName;
  @override
  String? get activeTemplateName;
  @override
  int get totalItems;
  @override
  int get publishedItemsCount;
  @override
  @JsonKey(ignore: true)
  _$$DashboardModelImplCopyWith<_$DashboardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
