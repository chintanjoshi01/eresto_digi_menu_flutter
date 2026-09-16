/// Enterprise V6 Login Request DTO matching API specifications
class V6LoginRequest {
  final String userName;
  final String password;
  final int productId; // 5 Plus , 9 for Eresto One/DigiMenu
  final String? cv; // Current app version (e.g. "1.0.0" or null)
  final String? imei; // Hardware ID / Device UUID
  final int loginFrom; // 1 = Mobile, 2 = Browser
  final int tsf; // Troubleshooting flag (0 = standard, 1 = debug)

  const V6LoginRequest({
    required this.userName,
    required this.password,
    this.productId = 9,
    this.cv = "1.0.0",
    this.imei,
    this.loginFrom = 1,
    this.tsf = 1,
  });

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "password": password,
        "product_id": productId,
        if (cv != null) "cv": cv,
        if (imei != null && imei!.isNotEmpty) "IMEI": imei,
        "login_from": loginFrom,
        "tsf": tsf,
      };
}
