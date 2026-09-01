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

CategoryViewStat _$CategoryViewStatFromJson(Map<String, dynamic> json) {
  return _CategoryViewStat.fromJson(json);
}

/// @nodoc
mixin _$CategoryViewStat {
  int get rank => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get views => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryViewStatCopyWith<CategoryViewStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryViewStatCopyWith<$Res> {
  factory $CategoryViewStatCopyWith(
          CategoryViewStat value, $Res Function(CategoryViewStat) then) =
      _$CategoryViewStatCopyWithImpl<$Res, CategoryViewStat>;
  @useResult
  $Res call(
      {int rank, String name, int views, double percentage, String colorHex});
}

/// @nodoc
class _$CategoryViewStatCopyWithImpl<$Res, $Val extends CategoryViewStat>
    implements $CategoryViewStatCopyWith<$Res> {
  _$CategoryViewStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? name = null,
    Object? views = null,
    Object? percentage = null,
    Object? colorHex = null,
  }) {
    return _then(_value.copyWith(
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      views: null == views
          ? _value.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryViewStatImplCopyWith<$Res>
    implements $CategoryViewStatCopyWith<$Res> {
  factory _$$CategoryViewStatImplCopyWith(_$CategoryViewStatImpl value,
          $Res Function(_$CategoryViewStatImpl) then) =
      __$$CategoryViewStatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int rank, String name, int views, double percentage, String colorHex});
}

/// @nodoc
class __$$CategoryViewStatImplCopyWithImpl<$Res>
    extends _$CategoryViewStatCopyWithImpl<$Res, _$CategoryViewStatImpl>
    implements _$$CategoryViewStatImplCopyWith<$Res> {
  __$$CategoryViewStatImplCopyWithImpl(_$CategoryViewStatImpl _value,
      $Res Function(_$CategoryViewStatImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? name = null,
    Object? views = null,
    Object? percentage = null,
    Object? colorHex = null,
  }) {
    return _then(_$CategoryViewStatImpl(
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      views: null == views
          ? _value.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryViewStatImpl implements _CategoryViewStat {
  const _$CategoryViewStatImpl(
      {required this.rank,
      required this.name,
      required this.views,
      required this.percentage,
      required this.colorHex});

  factory _$CategoryViewStatImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryViewStatImplFromJson(json);

  @override
  final int rank;
  @override
  final String name;
  @override
  final int views;
  @override
  final double percentage;
  @override
  final String colorHex;

  @override
  String toString() {
    return 'CategoryViewStat(rank: $rank, name: $name, views: $views, percentage: $percentage, colorHex: $colorHex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryViewStatImpl &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, rank, name, views, percentage, colorHex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryViewStatImplCopyWith<_$CategoryViewStatImpl> get copyWith =>
      __$$CategoryViewStatImplCopyWithImpl<_$CategoryViewStatImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryViewStatImplToJson(
      this,
    );
  }
}

abstract class _CategoryViewStat implements CategoryViewStat {
  const factory _CategoryViewStat(
      {required final int rank,
      required final String name,
      required final int views,
      required final double percentage,
      required final String colorHex}) = _$CategoryViewStatImpl;

  factory _CategoryViewStat.fromJson(Map<String, dynamic> json) =
      _$CategoryViewStatImpl.fromJson;

  @override
  int get rank;
  @override
  String get name;
  @override
  int get views;
  @override
  double get percentage;
  @override
  String get colorHex;
  @override
  @JsonKey(ignore: true)
  _$$CategoryViewStatImplCopyWith<_$CategoryViewStatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) {
  return _DashboardModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardModel {
  String get restaurantName => throw _privateConstructorUsedError;
  String get restaurantUrl => throw _privateConstructorUsedError;
  bool get isPublished => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get availableItems => throw _privateConstructorUsedError;
  int get hiddenItems => throw _privateConstructorUsedError;
  int get qrScansToday => throw _privateConstructorUsedError;
  double get qrScanDeltaPercent => throw _privateConstructorUsedError;
  int get avgScansPerHour => throw _privateConstructorUsedError;
  int get peakScans => throw _privateConstructorUsedError;
  int get yesterdayScans => throw _privateConstructorUsedError;
  List<int> get scanChartData => throw _privateConstructorUsedError;
  List<String> get scanChartLabels => throw _privateConstructorUsedError;
  int get unpublishedChangesCount => throw _privateConstructorUsedError;
  String get unpublishedChangesSummary => throw _privateConstructorUsedError;
  String get activeSessionName => throw _privateConstructorUsedError;
  String get activeSessionTime => throw _privateConstructorUsedError;
  List<CategoryViewStat> get topCategories =>
      throw _privateConstructorUsedError;

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
      {String restaurantName,
      String restaurantUrl,
      bool isPublished,
      int totalItems,
      int availableItems,
      int hiddenItems,
      int qrScansToday,
      double qrScanDeltaPercent,
      int avgScansPerHour,
      int peakScans,
      int yesterdayScans,
      List<int> scanChartData,
      List<String> scanChartLabels,
      int unpublishedChangesCount,
      String unpublishedChangesSummary,
      String activeSessionName,
      String activeSessionTime,
      List<CategoryViewStat> topCategories});
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
    Object? restaurantName = null,
    Object? restaurantUrl = null,
    Object? isPublished = null,
    Object? totalItems = null,
    Object? availableItems = null,
    Object? hiddenItems = null,
    Object? qrScansToday = null,
    Object? qrScanDeltaPercent = null,
    Object? avgScansPerHour = null,
    Object? peakScans = null,
    Object? yesterdayScans = null,
    Object? scanChartData = null,
    Object? scanChartLabels = null,
    Object? unpublishedChangesCount = null,
    Object? unpublishedChangesSummary = null,
    Object? activeSessionName = null,
    Object? activeSessionTime = null,
    Object? topCategories = null,
  }) {
    return _then(_value.copyWith(
      restaurantName: null == restaurantName
          ? _value.restaurantName
          : restaurantName // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantUrl: null == restaurantUrl
          ? _value.restaurantUrl
          : restaurantUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isPublished: null == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      availableItems: null == availableItems
          ? _value.availableItems
          : availableItems // ignore: cast_nullable_to_non_nullable
              as int,
      hiddenItems: null == hiddenItems
          ? _value.hiddenItems
          : hiddenItems // ignore: cast_nullable_to_non_nullable
              as int,
      qrScansToday: null == qrScansToday
          ? _value.qrScansToday
          : qrScansToday // ignore: cast_nullable_to_non_nullable
              as int,
      qrScanDeltaPercent: null == qrScanDeltaPercent
          ? _value.qrScanDeltaPercent
          : qrScanDeltaPercent // ignore: cast_nullable_to_non_nullable
              as double,
      avgScansPerHour: null == avgScansPerHour
          ? _value.avgScansPerHour
          : avgScansPerHour // ignore: cast_nullable_to_non_nullable
              as int,
      peakScans: null == peakScans
          ? _value.peakScans
          : peakScans // ignore: cast_nullable_to_non_nullable
              as int,
      yesterdayScans: null == yesterdayScans
          ? _value.yesterdayScans
          : yesterdayScans // ignore: cast_nullable_to_non_nullable
              as int,
      scanChartData: null == scanChartData
          ? _value.scanChartData
          : scanChartData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      scanChartLabels: null == scanChartLabels
          ? _value.scanChartLabels
          : scanChartLabels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unpublishedChangesCount: null == unpublishedChangesCount
          ? _value.unpublishedChangesCount
          : unpublishedChangesCount // ignore: cast_nullable_to_non_nullable
              as int,
      unpublishedChangesSummary: null == unpublishedChangesSummary
          ? _value.unpublishedChangesSummary
          : unpublishedChangesSummary // ignore: cast_nullable_to_non_nullable
              as String,
      activeSessionName: null == activeSessionName
          ? _value.activeSessionName
          : activeSessionName // ignore: cast_nullable_to_non_nullable
              as String,
      activeSessionTime: null == activeSessionTime
          ? _value.activeSessionTime
          : activeSessionTime // ignore: cast_nullable_to_non_nullable
              as String,
      topCategories: null == topCategories
          ? _value.topCategories
          : topCategories // ignore: cast_nullable_to_non_nullable
              as List<CategoryViewStat>,
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
      {String restaurantName,
      String restaurantUrl,
      bool isPublished,
      int totalItems,
      int availableItems,
      int hiddenItems,
      int qrScansToday,
      double qrScanDeltaPercent,
      int avgScansPerHour,
      int peakScans,
      int yesterdayScans,
      List<int> scanChartData,
      List<String> scanChartLabels,
      int unpublishedChangesCount,
      String unpublishedChangesSummary,
      String activeSessionName,
      String activeSessionTime,
      List<CategoryViewStat> topCategories});
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
    Object? restaurantName = null,
    Object? restaurantUrl = null,
    Object? isPublished = null,
    Object? totalItems = null,
    Object? availableItems = null,
    Object? hiddenItems = null,
    Object? qrScansToday = null,
    Object? qrScanDeltaPercent = null,
    Object? avgScansPerHour = null,
    Object? peakScans = null,
    Object? yesterdayScans = null,
    Object? scanChartData = null,
    Object? scanChartLabels = null,
    Object? unpublishedChangesCount = null,
    Object? unpublishedChangesSummary = null,
    Object? activeSessionName = null,
    Object? activeSessionTime = null,
    Object? topCategories = null,
  }) {
    return _then(_$DashboardModelImpl(
      restaurantName: null == restaurantName
          ? _value.restaurantName
          : restaurantName // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantUrl: null == restaurantUrl
          ? _value.restaurantUrl
          : restaurantUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isPublished: null == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      availableItems: null == availableItems
          ? _value.availableItems
          : availableItems // ignore: cast_nullable_to_non_nullable
              as int,
      hiddenItems: null == hiddenItems
          ? _value.hiddenItems
          : hiddenItems // ignore: cast_nullable_to_non_nullable
              as int,
      qrScansToday: null == qrScansToday
          ? _value.qrScansToday
          : qrScansToday // ignore: cast_nullable_to_non_nullable
              as int,
      qrScanDeltaPercent: null == qrScanDeltaPercent
          ? _value.qrScanDeltaPercent
          : qrScanDeltaPercent // ignore: cast_nullable_to_non_nullable
              as double,
      avgScansPerHour: null == avgScansPerHour
          ? _value.avgScansPerHour
          : avgScansPerHour // ignore: cast_nullable_to_non_nullable
              as int,
      peakScans: null == peakScans
          ? _value.peakScans
          : peakScans // ignore: cast_nullable_to_non_nullable
              as int,
      yesterdayScans: null == yesterdayScans
          ? _value.yesterdayScans
          : yesterdayScans // ignore: cast_nullable_to_non_nullable
              as int,
      scanChartData: null == scanChartData
          ? _value._scanChartData
          : scanChartData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      scanChartLabels: null == scanChartLabels
          ? _value._scanChartLabels
          : scanChartLabels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unpublishedChangesCount: null == unpublishedChangesCount
          ? _value.unpublishedChangesCount
          : unpublishedChangesCount // ignore: cast_nullable_to_non_nullable
              as int,
      unpublishedChangesSummary: null == unpublishedChangesSummary
          ? _value.unpublishedChangesSummary
          : unpublishedChangesSummary // ignore: cast_nullable_to_non_nullable
              as String,
      activeSessionName: null == activeSessionName
          ? _value.activeSessionName
          : activeSessionName // ignore: cast_nullable_to_non_nullable
              as String,
      activeSessionTime: null == activeSessionTime
          ? _value.activeSessionTime
          : activeSessionTime // ignore: cast_nullable_to_non_nullable
              as String,
      topCategories: null == topCategories
          ? _value._topCategories
          : topCategories // ignore: cast_nullable_to_non_nullable
              as List<CategoryViewStat>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardModelImpl implements _DashboardModel {
  const _$DashboardModelImpl(
      {required this.restaurantName,
      required this.restaurantUrl,
      required this.isPublished,
      required this.totalItems,
      required this.availableItems,
      required this.hiddenItems,
      required this.qrScansToday,
      required this.qrScanDeltaPercent,
      required this.avgScansPerHour,
      required this.peakScans,
      required this.yesterdayScans,
      required final List<int> scanChartData,
      required final List<String> scanChartLabels,
      required this.unpublishedChangesCount,
      required this.unpublishedChangesSummary,
      required this.activeSessionName,
      required this.activeSessionTime,
      required final List<CategoryViewStat> topCategories})
      : _scanChartData = scanChartData,
        _scanChartLabels = scanChartLabels,
        _topCategories = topCategories;

  factory _$DashboardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardModelImplFromJson(json);

  @override
  final String restaurantName;
  @override
  final String restaurantUrl;
  @override
  final bool isPublished;
  @override
  final int totalItems;
  @override
  final int availableItems;
  @override
  final int hiddenItems;
  @override
  final int qrScansToday;
  @override
  final double qrScanDeltaPercent;
  @override
  final int avgScansPerHour;
  @override
  final int peakScans;
  @override
  final int yesterdayScans;
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
  final int unpublishedChangesCount;
  @override
  final String unpublishedChangesSummary;
  @override
  final String activeSessionName;
  @override
  final String activeSessionTime;
  final List<CategoryViewStat> _topCategories;
  @override
  List<CategoryViewStat> get topCategories {
    if (_topCategories is EqualUnmodifiableListView) return _topCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topCategories);
  }

  @override
  String toString() {
    return 'DashboardModel(restaurantName: $restaurantName, restaurantUrl: $restaurantUrl, isPublished: $isPublished, totalItems: $totalItems, availableItems: $availableItems, hiddenItems: $hiddenItems, qrScansToday: $qrScansToday, qrScanDeltaPercent: $qrScanDeltaPercent, avgScansPerHour: $avgScansPerHour, peakScans: $peakScans, yesterdayScans: $yesterdayScans, scanChartData: $scanChartData, scanChartLabels: $scanChartLabels, unpublishedChangesCount: $unpublishedChangesCount, unpublishedChangesSummary: $unpublishedChangesSummary, activeSessionName: $activeSessionName, activeSessionTime: $activeSessionTime, topCategories: $topCategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardModelImpl &&
            (identical(other.restaurantName, restaurantName) ||
                other.restaurantName == restaurantName) &&
            (identical(other.restaurantUrl, restaurantUrl) ||
                other.restaurantUrl == restaurantUrl) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.availableItems, availableItems) ||
                other.availableItems == availableItems) &&
            (identical(other.hiddenItems, hiddenItems) ||
                other.hiddenItems == hiddenItems) &&
            (identical(other.qrScansToday, qrScansToday) ||
                other.qrScansToday == qrScansToday) &&
            (identical(other.qrScanDeltaPercent, qrScanDeltaPercent) ||
                other.qrScanDeltaPercent == qrScanDeltaPercent) &&
            (identical(other.avgScansPerHour, avgScansPerHour) ||
                other.avgScansPerHour == avgScansPerHour) &&
            (identical(other.peakScans, peakScans) ||
                other.peakScans == peakScans) &&
            (identical(other.yesterdayScans, yesterdayScans) ||
                other.yesterdayScans == yesterdayScans) &&
            const DeepCollectionEquality()
                .equals(other._scanChartData, _scanChartData) &&
            const DeepCollectionEquality()
                .equals(other._scanChartLabels, _scanChartLabels) &&
            (identical(
                    other.unpublishedChangesCount, unpublishedChangesCount) ||
                other.unpublishedChangesCount == unpublishedChangesCount) &&
            (identical(other.unpublishedChangesSummary,
                    unpublishedChangesSummary) ||
                other.unpublishedChangesSummary == unpublishedChangesSummary) &&
            (identical(other.activeSessionName, activeSessionName) ||
                other.activeSessionName == activeSessionName) &&
            (identical(other.activeSessionTime, activeSessionTime) ||
                other.activeSessionTime == activeSessionTime) &&
            const DeepCollectionEquality()
                .equals(other._topCategories, _topCategories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      restaurantName,
      restaurantUrl,
      isPublished,
      totalItems,
      availableItems,
      hiddenItems,
      qrScansToday,
      qrScanDeltaPercent,
      avgScansPerHour,
      peakScans,
      yesterdayScans,
      const DeepCollectionEquality().hash(_scanChartData),
      const DeepCollectionEquality().hash(_scanChartLabels),
      unpublishedChangesCount,
      unpublishedChangesSummary,
      activeSessionName,
      activeSessionTime,
      const DeepCollectionEquality().hash(_topCategories));

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
          {required final String restaurantName,
          required final String restaurantUrl,
          required final bool isPublished,
          required final int totalItems,
          required final int availableItems,
          required final int hiddenItems,
          required final int qrScansToday,
          required final double qrScanDeltaPercent,
          required final int avgScansPerHour,
          required final int peakScans,
          required final int yesterdayScans,
          required final List<int> scanChartData,
          required final List<String> scanChartLabels,
          required final int unpublishedChangesCount,
          required final String unpublishedChangesSummary,
          required final String activeSessionName,
          required final String activeSessionTime,
          required final List<CategoryViewStat> topCategories}) =
      _$DashboardModelImpl;

  factory _DashboardModel.fromJson(Map<String, dynamic> json) =
      _$DashboardModelImpl.fromJson;

  @override
  String get restaurantName;
  @override
  String get restaurantUrl;
  @override
  bool get isPublished;
  @override
  int get totalItems;
  @override
  int get availableItems;
  @override
  int get hiddenItems;
  @override
  int get qrScansToday;
  @override
  double get qrScanDeltaPercent;
  @override
  int get avgScansPerHour;
  @override
  int get peakScans;
  @override
  int get yesterdayScans;
  @override
  List<int> get scanChartData;
  @override
  List<String> get scanChartLabels;
  @override
  int get unpublishedChangesCount;
  @override
  String get unpublishedChangesSummary;
  @override
  String get activeSessionName;
  @override
  String get activeSessionTime;
  @override
  List<CategoryViewStat> get topCategories;
  @override
  @JsonKey(ignore: true)
  _$$DashboardModelImplCopyWith<_$DashboardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
