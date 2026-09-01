class Endpoints {
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
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
