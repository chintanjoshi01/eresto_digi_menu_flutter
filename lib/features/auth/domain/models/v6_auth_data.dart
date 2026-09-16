import 'package:equatable/equatable.dart';

/// Enterprise V6 Authentication Payload Data
class V6AuthData extends Equatable {
  final int ifa;
  final int restoId;
  final String defResto;
  final List<dynamic> restos;
  final int productId;
  final String productIds;
  final int userId;
  final int roleId;
  final int designationId;
  final String userName;
  final String shortName;
  final String pin;
  final String mobile;
  final String email;
  final int userStatus;
  final int userTimeOut;
  final dynamic appGf;
  final String token;
  final int profileStatus;
  final int restoType;
  final String restoLocation;
  final String validity;
  final String subscription;
  final String treasure;
  final dynamic notification;
  final String mods; // Comma-separated module IDs (e.g. "1,2,4,5") - "1" is DigiMenu
  final int mop;
  final String rnp;
  final String rpts;
  final String pids;
  final String mids;
  final int force;
  final String versionMsg;

  const V6AuthData({
    required this.ifa,
    required this.restoId,
    required this.defResto,
    required this.restos,
    required this.productId,
    required this.productIds,
    required this.userId,
    required this.roleId,
    required this.designationId,
    required this.userName,
    required this.shortName,
    required this.pin,
    required this.mobile,
    required this.email,
    required this.userStatus,
    required this.userTimeOut,
    required this.appGf,
    required this.token,
    required this.profileStatus,
    required this.restoType,
    required this.restoLocation,
    required this.validity,
    required this.subscription,
    required this.treasure,
    required this.notification,
    required this.mods,
    required this.mop,
    required this.rnp,
    required this.rpts,
    required this.pids,
    required this.mids,
    required this.force,
    required this.versionMsg,
  });

  factory V6AuthData.fromJson(Map<String, dynamic> json) {
    return V6AuthData(
      ifa: (json['ifa'] as num?)?.toInt() ?? 0,
      restoId: (json['resto_id'] as num?)?.toInt() ?? 0,
      defResto: json['def_resto']?.toString() ?? '',
      restos: (json['restos'] is List) ? json['restos'] as List<dynamic> : const [],
      productId: (json['product_id'] as num?)?.toInt() ?? 9,
      productIds: json['product_ids']?.toString() ?? '',
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      roleId: (json['role_id'] as num?)?.toInt() ?? 0,
      designationId: (json['designation_id'] as num?)?.toInt() ?? 0,
      userName: json['user_name']?.toString() ?? '',
      shortName: json['short_name']?.toString() ?? '',
      pin: json['pin']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      userStatus: (json['user_status'] as num?)?.toInt() ?? 0,
      userTimeOut: (json['user_time_out'] as num?)?.toInt() ?? 0,
      appGf: json['app_gf'],
      token: json['token']?.toString() ?? '',
      profileStatus: (json['profile_status'] as num?)?.toInt() ?? 0,
      restoType: (json['resto_type'] as num?)?.toInt() ?? 1,
      restoLocation: json['resto_location']?.toString() ?? '',
      validity: json['validity']?.toString() ?? '',
      subscription: json['subscription']?.toString() ?? '',
      treasure: json['treasure']?.toString() ?? '',
      notification: json['notification'],
      mods: json['mods']?.toString() ?? '',
      mop: (json['mop'] as num?)?.toInt() ?? 0,
      rnp: json['rnp']?.toString() ?? '',
      rpts: json['rpts']?.toString() ?? '',
      pids: json['pids']?.toString() ?? '',
      mids: json['mids']?.toString() ?? '',
      force: (json['force'] as num?)?.toInt() ?? 0,
      versionMsg: json['version_msg']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'ifa': ifa,
        'resto_id': restoId,
        'def_resto': defResto,
        'restos': restos,
        'product_id': productId,
        'product_ids': productIds,
        'user_id': userId,
        'role_id': roleId,
        'designation_id': designationId,
        'user_name': userName,
        'short_name': shortName,
        'pin': pin,
        'mobile': mobile,
        'email': email,
        'user_status': userStatus,
        'user_time_out': userTimeOut,
        'app_gf': appGf,
        'token': token,
        'profile_status': profileStatus,
        'resto_type': restoType,
        'resto_location': restoLocation,
        'validity': validity,
        'subscription': subscription,
        'treasure': treasure,
        'notification': notification,
        'mods': mods,
        'mop': mop,
        'rnp': rnp,
        'rpts': rpts,
        'pids': pids,
        'mids': mids,
        'force': force,
        'version_msg': versionMsg,
      };

  @override
  List<Object?> get props => [
        restoId,
        defResto,
        userId,
        userName,
        token,
        mods,
        productId,
        productIds,
        roleId,
      ];
}
