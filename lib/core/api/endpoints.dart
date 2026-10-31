import 'package:get/get.dart';
import '../storage/storage_service.dart';

class Endpoints {
  static const String defaultBaseUrl = 'https://plus.eresto.in';
  static String baseUrl = defaultBaseUrl;

  /// Extracts the root domain from a given URL or active baseUrl (e.g. 'eresto.in' or 'eresto.app')
  static String extractRootDomain([String? url]) {
    try {
      final target = (url != null && url.trim().isNotEmpty) ? url.trim() : baseUrl;
      final uri = Uri.parse(target);
      final host = uri.host;
      final parts = host.split('.');
      if (parts.length >= 2) {
        return parts.sublist(parts.length - 2).join('.');
      }
      return host.isNotEmpty ? host : 'eresto.in';
    } catch (_) {
      return 'eresto.in';
    }
  }

  /// Extracts the domain TLD extension (e.g. 'in' or 'app')
  static String get domainExtension => extractRootDomain().split('.').last;

  /// Returns the corresponding assets host, e.g. 'https://assets.eresto.in' or 'https://assets.eresto.app'
  static String get assetsBaseUrl => 'https://assets.${extractRootDomain()}';

  /// Returns the active assets base URL considering dynamic StorageService.treasureUrl or active API base URL
  static String get activeAssetsBaseUrl {
    // 1. If StorageService has an explicit treasure URL from API, dynamically extract its assets host
    if (Get.isRegistered<StorageService>()) {
      final tUrl = Get.find<StorageService>().treasureUrl.trim();
      if (tUrl.isNotEmpty) {
        final tUri = Uri.tryParse(tUrl);
        if (tUri != null && tUri.host.startsWith('assets.')) {
          return '${tUri.scheme}://${tUri.host}';
        }
      }
    }
    // 2. Otherwise derive dynamically from active API base URL
    return assetsBaseUrl;
  }

  // --- Auth & Session (V6) ---
  static const String v6Login = '/api/v6/login';
  static const String v6Dashboard = '/api/v6/get_dashboard_data';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';

  // --- Sync & Master Data (V6) ---
  static const String v6LoginSync = '/api/v6/get_login_sync_data';

  // --- Menu & Items Management (V6) ---
  static const String v6MenuItems = '/api/v6/menu/items';
  static const String v6ItemDetails = '/api/v6/menu/item/details';
  static const String v6ItemUpdateQuick = '/api/v6/menu/item/update-quick';
  static const String v6ItemUpdateImage = '/api/v6/menu/item/update-image';
  static const String v6ItemUpdate = '/api/v6/menu/item/update';
  static const String v6ItemCreate = '/api/v6/menu/item/create';
  static const String v6ItemDelete = '/api/v6/menu/item/delete';

  // --- Menu Builder & Templates (V6) ---
  static const String v6MenuBuilderData = '/api/v6/menu_builder/get_menu_builder_data';
  static const String v6MenuTempListNeo = '/api/v6/menu_builder/get_menu_temp_list_neo';
  static const String v6ChangeTheme = '/api/v6/menu_builder/change_theme';
  static const String v6GetThemes = '/api/v6/menu_builder/get_themes';
  static const String v6GetSession = '/api/v6/menu_builder/get_session';
  static const String v6UpdateSession = '/api/v6/menu_builder/update_session';
  static const String v6GetMenuTemplate = '/api/v6/menu_builder/get_menu_template';
  static const String v6UpdateTemplateItems = '/api/v6/menu_builder/update_template_items';
  static const String v6GetGallery = '/api/v6/menu_builder/get_gallery';

  // --- Gallery & Asset Uploads (V4/V6) ---
  static const String uploadGalleryNeo = '/api/v4/upload_resto_gallery_neo';

  // --- Share, PDF & QR Codes (V6) ---
  static const String v6DigitalMenuLinks = '/api/v6/get_digital_menu_links';
  static const String v6DownloadTableQrZip = '/api/v6/dwn_tbl_qr_zip';
  static const String v6DownloadTemplatePdf = '/api/v6/menu_builder/download_template_pdf';
  static const String v6GetTnc = '/api/v6/menu_builder/get_tnc';

  // --- Terms & Conditions Master (V6) ---
  static const String v6TermsList = '/api/v6/terms/list';
  static const String v6TermsDetails = '/api/v6/terms/details';
  static const String v6TermsCreate = '/api/v6/terms/create';
  static const String v6TermsUpdate = '/api/v6/terms/update';
  static const String v6TermsDelete = '/api/v6/terms/delete';

  // --- Menu Management ---
  static const String menuItems = '/menu-items';
  static String itemAvailability(int id) => '/menu-items/$id/availability';
  static String updateItem(int id) => '/menu-items/$id';
  static const String templates = '/menu-templates';
  static String updateTheme(int id) => '/menu-templates/$id/theme';
  static const String sessions = '/sessions';
  static String updateSession(int id) => '/sessions/$id';
  static const String scanStats = '/dashboard/scan-stats';
  static const String qrCodes = '/qr-codes';
  static const String publishMenu = '/menu/publish';
}
