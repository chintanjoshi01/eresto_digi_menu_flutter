import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
class SessionModel with _$SessionModel {
  const factory SessionModel({
    required int id,
    required String name,
    required String startTime,
    required String endTime,
    required bool isActive,
    String? splashImageUrl,
    String? offerImageUrl,
    String? offerDescription,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}
