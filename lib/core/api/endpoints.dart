class Endpoints {
  static const String baseUrl = 'https://new.eresto.app';

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
