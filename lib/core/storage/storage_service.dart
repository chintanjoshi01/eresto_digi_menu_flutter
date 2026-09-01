import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Token Management
  String get token => _prefs.getString('token') ?? '';
  Future<void> saveToken(String value) async => await _prefs.setString('token', value);
  Future<void> clearToken() async => await _prefs.remove('token');

  // Restaurant ID
  int get restoId => _prefs.getInt('resto_id') ?? 0;
  Future<void> saveRestoId(int value) async => await _prefs.setInt('resto_id', value);

  // Authentication State
  bool get isLoggedIn => token.isNotEmpty;

  // Clear All Storage (Logout)
  Future<void> clear() async {
    await _prefs.clear();
  }
}
