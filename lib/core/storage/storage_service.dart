import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/v6_login_sync_model.dart';

/// Enterprise Session & Local Storage Service
class StorageService extends GetxService {
  late final SharedPreferences _prefs;
  V6LoginSyncData? _loginSyncDataCache;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadLoginSyncDataFromCache();
    return this;
  }

  // --- Device Identification ---
  String get deviceId => _prefs.getString('device_id') ?? '';
  Future<void> saveDeviceId(String value) async => await _prefs.setString('device_id', value);

  // --- Authentication State ---
  String get token => _prefs.getString('token') ?? '';
  Future<void> saveToken(String value) async => await _prefs.setString('token', value);
  Future<void> clearToken() async => await _prefs.remove('token');
  bool get isLoggedIn => token.isNotEmpty;

  // --- Restaurant & Business Details ---
  int get restoId => _prefs.getInt('resto_id') ?? 0;
  String get restoName => _prefs.getString('def_resto') ?? 'Trulyy Tadkaaz';
  String get restoLocation => _prefs.getString('resto_location') ?? '';
  String get subscription => _prefs.getString('subscription') ?? '';
  String get validity => _prefs.getString('validity') ?? '';
  String get treasureUrl => _prefs.getString('treasure_url') ?? '';

  // --- User Profile Details ---
  int get userId => _prefs.getInt('user_id') ?? 0;
  String get userName => _prefs.getString('user_name') ?? '';
  String get shortName => _prefs.getString('short_name') ?? '';
  String get email => _prefs.getString('email') ?? '';
  String get mobile => _prefs.getString('mobile') ?? '';
  int get roleId => _prefs.getInt('role_id') ?? 0;
  int get productId => _prefs.getInt('product_id') ?? 9;

  // --- Permissions & Modules ---
  String get mods => _prefs.getString('mods') ?? '';
  String get pids => _prefs.getString('pids') ?? '';
  String get mids => _prefs.getString('mids') ?? '';

  /// Verify if restaurant/user has permission for DigiMenu App (Module '1')
  bool get hasDigiMenuAccess {
    if (mods.isEmpty) return true; // Default permissive if not explicitly restricted
    final moduleList = mods.split(',').map((e) => e.trim()).toList();
    return moduleList.contains('1');
  }

  /// Persist complete V6 authenticated session atomically
  Future<void> saveV6Session({
    required String token,
    required int restoId,
    required String defResto,
    required int userId,
    required String userName,
    required String shortName,
    required String email,
    required String mobile,
    required int roleId,
    required int productId,
    required String subscription,
    required String validity,
    required String treasureUrl,
    required String mods,
    required String pids,
    required String mids,
    String? restoLocation,
  }) async {
    await _prefs.setString('token', token);
    await _prefs.setInt('resto_id', restoId);
    await _prefs.setString('def_resto', defResto);
    await _prefs.setInt('user_id', userId);
    await _prefs.setString('user_name', userName);
    await _prefs.setString('short_name', shortName);
    await _prefs.setString('email', email);
    await _prefs.setString('mobile', mobile);
    await _prefs.setInt('role_id', roleId);
    await _prefs.setInt('product_id', productId);
    await _prefs.setString('subscription', subscription);
    await _prefs.setString('validity', validity);
    await _prefs.setString('treasure_url', treasureUrl);
    await _prefs.setString('mods', mods);
    await _prefs.setString('pids', pids);
    await _prefs.setString('mids', mids);
    if (restoLocation != null) {
      await _prefs.setString('resto_location', restoLocation);
    }
  }

  /// Update base treasure URL dynamically from API responses
  Future<void> setTreasureUrl(String url) async {
    if (url.isNotEmpty) {
      await _prefs.setString('treasure_url', url);
    }
  }

  // --- V6 Login Sync Master Data ---
  V6LoginSyncData? get cachedLoginSyncData => _loginSyncDataCache;
  List<V6KitchenCat> get kitchenCategories => _loginSyncDataCache?.kitchenCategories ?? const [];
  List<V6SalesCat> get salesCategories => _loginSyncDataCache?.salesCategories ?? const [];
  List<V6RestoSpInst> get specialInstructions => _loginSyncDataCache?.restoSpecialInstructions ?? const [];
  List<V6PriceTemplate> get priceTemplates => _loginSyncDataCache?.priceTemplates ?? const [];
  List<V6TaxTemplate> get taxTemplates => _loginSyncDataCache?.taxTemplates ?? const [];

  String? getTaxTemplateName(int? id) => _loginSyncDataCache?.getTaxTemplateName(id);
  int? getTaxTemplateId(String? name) => _loginSyncDataCache?.getTaxTemplateId(name);

  /// Check if local login sync cache is missing or older than 24 hours
  bool get isLoginSyncStale {
    if (_loginSyncDataCache == null) return true;
    final age = DateTime.now().difference(_loginSyncDataCache!.cachedAt);
    return age.inHours >= 24;
  }

  bool get hasValidLoginSync => !isLoginSyncStale;

  /// Persist complete V6 Login Sync master data to local storage and update in-memory cache
  Future<void> saveLoginSyncData(Map<String, dynamic> jsonMap) async {
    final syncData = V6LoginSyncData.fromJson({
      ...jsonMap,
      '_cached_at_ms': DateTime.now().millisecondsSinceEpoch,
    });
    _loginSyncDataCache = syncData;
    await _prefs.setString('v6_login_sync_data', jsonEncode(syncData.toJson()));
    await _prefs.setInt('v6_last_login_sync_time', syncData.cachedAt.millisecondsSinceEpoch);
  }

  void _loadLoginSyncDataFromCache() {
    try {
      final raw = _prefs.getString('v6_login_sync_data');
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        _loginSyncDataCache = V6LoginSyncData.fromJson(decoded);
      }
    } catch (_) {
      _loginSyncDataCache = null;
    }
  }

  Future<void> clearLoginSyncData() async {
    _loginSyncDataCache = null;
    await _prefs.remove('v6_login_sync_data');
    await _prefs.remove('v6_last_login_sync_time');
  }

  /// Clear Session (Preserves device_id)
  Future<void> clearSession() async {
    final currentDeviceId = deviceId;
    await _prefs.clear();
    _loginSyncDataCache = null;
    if (currentDeviceId.isNotEmpty) {
      await saveDeviceId(currentDeviceId);
    }
  }

  // Clear All Storage (Logout)
  Future<void> clear() async {
    await clearSession();
  }
}
