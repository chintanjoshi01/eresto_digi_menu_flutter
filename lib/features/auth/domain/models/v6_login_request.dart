import '../../../../core/services/device_service.dart';

/// Enterprise V6 Login Request DTO matching API specifications
class V6LoginRequest {
  final String userName;
  final String password;
  final int productId; // 5 Plus , 9 for Eresto One/DigiMenu
  final String? cv; // Current app version (e.g. "1.1.4")
  final String? imei; // Hardware ID / Device UUID
  final int loginFrom; // 1 = Mobile, 2 = Browser
  final int tsf; // Troubleshooting flag (0 = standard, 1 = debug)

  const V6LoginRequest({
    required this.userName,
    required this.password,
    this.productId = 9,
    this.cv,
    this.imei,
    this.loginFrom = 1,
    this.tsf = 1,
  });

  Map<String, dynamic> toJson() {
    final resolvedCv = cv ?? DeviceService.appVersion;
    return {
      "user_name": userName,
      "password": password,
      "product_id": productId,
      if (resolvedCv.isNotEmpty) "cv": resolvedCv,
      if (imei != null && imei!.isNotEmpty) "IMEI": imei,
      "login_from": loginFrom,
      "tsf": tsf,
    };
  }
}
