/// Top-level API Response wrapper for /api/v6/get_dashboard_data
class V6DashboardResponse {
  final int status;
  final String message;
  final V6DashboardData? data;

  const V6DashboardResponse({
    required this.status,
    required this.message,
    this.data,
  });

  bool get isSuccess => status == 1 && data != null;

  factory V6DashboardResponse.fromJson(Map<String, dynamic> json) {
    return V6DashboardResponse(
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? V6DashboardData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

/// Main dashboard data payload
class V6DashboardData {
  final V6DashboardHero hero;
  final List<V6MenuSessionContainer> menuSessions;
  final V6ScanData scanData;

  const V6DashboardData({
    required this.hero,
    required this.menuSessions,
    required this.scanData,
  });

  // --- Convenience Getters for Interoperability ---
  String get restaurantName => hero.restoName;
  String get restaurantUrl => hero.restoSub;
  bool get isPublished => hero.isPublished;
  int get totalItems => hero.totalItems;
  int get totalCategories => hero.totalCategories;
  int get qrScansToday => hero.scansToday;
  int get yesterdayScans => hero.scansYesterday;
  double get qrScanDeltaPercent => hero.deltaPct.toDouble();

  /// Flattens all sessions from all containers
  List<V6SessionItem> get allSessions =>
      menuSessions.expand((container) => container.sessions).toList();

  /// Live sessions currently active
  List<V6SessionItem> get liveSessions =>
      allSessions.where((s) => s.isLive).toList();

  /// Upcoming sessions for today
  List<V6SessionItem> get upcomingSessions =>
      allSessions.where((s) => s.isUpcoming).toList();

  /// Summary badge text (e.g. "3 live · 1 upcoming")
  String get sessionSummaryText {
    final live = liveSessions.length;
    final upcoming = upcomingSessions.length;
    if (live == 0 && upcoming == 0) return "No active sessions";
    return "$live live · $upcoming upcoming";
  }

  factory V6DashboardData.fromJson(Map<String, dynamic> json) {
    return V6DashboardData(
      hero: json['hero'] != null
          ? V6DashboardHero.fromJson(json['hero'] as Map<String, dynamic>)
          : const V6DashboardHero.empty(),
      menuSessions: (json['menu_sessions'] as List<dynamic>?)
              ?.map((e) => V6MenuSessionContainer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      scanData: json['scan_data'] != null
          ? V6ScanData.fromJson(json['scan_data'] as Map<String, dynamic>)
          : const V6ScanData.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
        'hero': hero.toJson(),
        'menu_sessions': menuSessions.map((e) => e.toJson()).toList(),
        'scan_data': scanData.toJson(),
      };
}

/// Hero section restaurant & scan breakdown
class V6DashboardHero {
  final int restoId;
  final String restoName;
  final String restoSub;
  final String menuUrl;
  final bool isPublished;
  final int totalItems;
  final int totalCategories;
  final int scansToday;
  final int scansYesterday;
  final List<V6HeroBreakdown> breakdown;

  const V6DashboardHero({
    required this.restoId,
    required this.restoName,
    required this.restoSub,
    required this.menuUrl,
    required this.isPublished,
    required this.totalItems,
    required this.totalCategories,
    required this.scansToday,
    required this.scansYesterday,
    required this.breakdown,
  });

  const V6DashboardHero.empty()
      : restoId = 0,
        restoName = 'Trulyy Tadkaaz',
        restoSub = 'menu.eresto.in/trulyy-tadkaaz',
        menuUrl = '',
        isPublished = true,
        totalItems = 247,
        totalCategories = 10,
        scansToday = 247,
        scansYesterday = 209,
        breakdown = const [];

  /// Calculated delta percentage (today vs yesterday)
  int get deltaPct {
    if (scansYesterday == 0) return scansToday > 0 ? 100 : 0;
    return (((scansToday - scansYesterday) / scansYesterday) * 100).round();
  }

  String get deltaText => "${deltaPct >= 0 ? '↑' : '↓'} ${deltaPct.abs()}% vs yesterday";

  factory V6DashboardHero.fromJson(Map<String, dynamic> json) {
    return V6DashboardHero(
      restoId: _asInt(json['resto_id']),
      restoName: json['resto_name']?.toString() ?? 'Trulyy Tadkaaz',
      restoSub: json['resto_sub']?.toString() ?? 'menu.eresto.in/trulyy-tadkaaz',
      menuUrl: json['menu_url']?.toString() ?? '',
      isPublished: _asBool(json['is_published']),
      totalItems: _asInt(json['total_items'], defaultValue: 247),
      totalCategories: _asInt(json['total_categories'], defaultValue: 10),
      scansToday: _asInt(json['scans_today']),
      scansYesterday: _asInt(json['scans_yesterday']),
      breakdown: (json['breakdown'] as List<dynamic>?)
              ?.map((e) => V6HeroBreakdown.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'resto_id': restoId,
        'resto_name': restoName,
        'resto_sub': restoSub,
        'menu_url': menuUrl,
        'is_published': isPublished,
        'total_items': totalItems,
        'total_categories': totalCategories,
        'scans_today': scansToday,
        'scans_yesterday': scansYesterday,
        'breakdown': breakdown.map((e) => e.toJson()).toList(),
      };
}

/// Menu scan breakdown per channel (e.g. Dine-In, IRD)
class V6HeroBreakdown {
  final String sessionFor;
  final String name;
  final int scansToday;
  final int scansYesterday;
  final int sessionsCount;
  final String menuUrl;

  const V6HeroBreakdown({
    required this.sessionFor,
    required this.name,
    required this.scansToday,
    required this.scansYesterday,
    required this.sessionsCount,
    required this.menuUrl,
  });

  int get deltaPct {
    if (scansYesterday == 0) return scansToday > 0 ? 100 : 0;
    return (((scansToday - scansYesterday) / scansYesterday) * 100).round();
  }

  factory V6HeroBreakdown.fromJson(Map<String, dynamic> json) {
    return V6HeroBreakdown(
      sessionFor: json['session_for']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      scansToday: _asInt(json['scans_today']),
      scansYesterday: _asInt(json['scans_yesterday']),
      sessionsCount: _asInt(json['sessions_count']),
      menuUrl: json['menu_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'session_for': sessionFor,
        'name': name,
        'scans_today': scansToday,
        'scans_yesterday': scansYesterday,
        'sessions_count': sessionsCount,
        'menu_url': menuUrl,
      };
}

/// Container grouping sessions by menu type (e.g. Dine-In container, IRD container)
class V6MenuSessionContainer {
  final int id;
  final String sessionFor;
  final String name;
  final String menuUrl;
  final V6RestoInfo? restoInfo;
  final List<V6SessionItem> sessions;

  const V6MenuSessionContainer({
    required this.id,
    required this.sessionFor,
    required this.name,
    required this.menuUrl,
    this.restoInfo,
    required this.sessions,
  });

  factory V6MenuSessionContainer.fromJson(Map<String, dynamic> json) {
    return V6MenuSessionContainer(
      id: _asInt(json['id']),
      sessionFor: json['session_for']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      menuUrl: json['menu_url']?.toString() ?? '',
      restoInfo: json['resto_info'] != null && json['resto_info'] is Map<String, dynamic>
          ? V6RestoInfo.fromJson(json['resto_info'] as Map<String, dynamic>)
          : null,
      sessions: (json['sessions'] as List<dynamic>?)
              ?.map((e) => V6SessionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'session_for': sessionFor,
        'name': name,
        'menu_url': menuUrl,
        'resto_info': restoInfo?.toJson(),
        'sessions': sessions.map((e) => e.toJson()).toList(),
      };
}

/// Optional splash / header info for a menu container
class V6RestoInfo {
  final String title;
  final String subtitle;
  final String logo;

  const V6RestoInfo({
    required this.title,
    required this.subtitle,
    required this.logo,
  });

  factory V6RestoInfo.fromJson(Map<String, dynamic> json) {
    return V6RestoInfo(
      title: json['title']?.toString() ?? json['resto_name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? json['tag_line']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'logo': logo,
      };
}

/// Individual Session entity
class V6SessionItem {
  final int id;
  final String sessionName;
  final String sessionFor;
  final String menuType;
  final int menuTemplateId;
  final String menuTemplateName;
  final String startTime;
  final String endTime;
  final int dayFlag;
  final int enCustOrder;
  final int categoriesCount;
  final int itemsCount;
  final int todayScans;
  final int hasSplash;
  final int offerId;

  const V6SessionItem({
    required this.id,
    required this.sessionName,
    required this.sessionFor,
    required this.menuType,
    required this.menuTemplateId,
    required this.menuTemplateName,
    required this.startTime,
    required this.endTime,
    required this.dayFlag,
    required this.enCustOrder,
    required this.categoriesCount,
    required this.itemsCount,
    required this.todayScans,
    required this.hasSplash,
    required this.offerId,
  });

  // --- Real-Time Timing Evaluation ---
  String get timeRange => "$startTime–$endTime";

  bool get isLive {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = _parseMinutes(startTime);
    final endMinutes = _parseMinutes(endTime);
    if (startMinutes == null || endMinutes == null) return false;

    if (endMinutes >= startMinutes) {
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    } else {
      // Crosses midnight (e.g. 22:00 to 02:00)
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    }
  }

  bool get isUpcoming {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = _parseMinutes(startTime);
    final endMinutes = _parseMinutes(endTime);
    if (startMinutes == null) return false;

    if (endMinutes != null && endMinutes >= startMinutes) {
      return currentMinutes < startMinutes;
    }
    // Crosses midnight
    return currentMinutes < startMinutes && (endMinutes == null || currentMinutes >= endMinutes);
  }

  String get status => isLive ? "LIVE" : (isUpcoming ? "UPCOMING" : "ENDED");

  String get statusLabel {
    if (isLive) return "● Active now";
    if (isUpcoming) return "Starts $startTime";
    return "Ended $endTime";
  }

  String get ordersBadge => enCustOrder == 1 ? "Orders On" : "No Orders";
  String get splashBadge => hasSplash == 1 ? "Splash On" : "Splash Off";
  String get offerBadge => offerId > 0 ? "Offer On" : "No Offer";

  static int? _parseMinutes(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    final parts = timeStr.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return h * 60 + m;
  }

  factory V6SessionItem.fromJson(Map<String, dynamic> json) {
    return V6SessionItem(
      id: _asInt(json['id']),
      sessionName: json['session_name']?.toString() ?? '',
      sessionFor: json['session_for']?.toString() ?? '',
      menuType: json['menu_type']?.toString() ?? 'Dine-In',
      menuTemplateId: _asInt(json['menu_template_id']),
      menuTemplateName: json['menu_template_name']?.toString() ?? 'Main Menu',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      dayFlag: _asInt(json['day_flag']),
      enCustOrder: _asInt(json['en_cust_order'], defaultValue: 1),
      categoriesCount: _asInt(json['categories_count']),
      itemsCount: _asInt(json['items_count']),
      todayScans: _asInt(json['today_scans']),
      hasSplash: _asInt(json['has_splash']),
      offerId: _asInt(json['offer_id']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'session_name': sessionName,
        'session_for': sessionFor,
        'menu_type': menuType,
        'menu_template_id': menuTemplateId,
        'menu_template_name': menuTemplateName,
        'start_time': startTime,
        'end_time': endTime,
        'day_flag': dayFlag,
        'en_cust_order': enCustOrder,
        'categories_count': categoriesCount,
        'items_count': itemsCount,
        'today_scans': todayScans,
        'has_splash': hasSplash,
        'offer_id': offerId,
      };
}

/// 30-Day Daily Scans History Entity
class V6ScanData {
  final String fromDate;
  final String toDate;
  final int scansToday;
  final int scansYesterday;
  final List<V6DailyScan> dailyScans;

  const V6ScanData({
    required this.fromDate,
    required this.toDate,
    required this.scansToday,
    required this.scansYesterday,
    required this.dailyScans,
  });

  const V6ScanData.empty()
      : fromDate = '',
        toDate = '',
        scansToday = 247,
        scansYesterday = 209,
        dailyScans = const [];

  factory V6ScanData.fromJson(Map<String, dynamic> json) {
    return V6ScanData(
      fromDate: json['from_date']?.toString() ?? '',
      toDate: json['to_date']?.toString() ?? '',
      scansToday: _asInt(json['scans_today']),
      scansYesterday: _asInt(json['scans_yesterday']),
      dailyScans: (json['daily_scans'] as List<dynamic>?)
              ?.map((e) => V6DailyScan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'from_date': fromDate,
        'to_date': toDate,
        'scans_today': scansToday,
        'scans_yesterday': scansYesterday,
        'daily_scans': dailyScans.map((e) => e.toJson()).toList(),
      };
}

/// Single day scan entry with per-channel breakdown
class V6DailyScan {
  final String date;
  final int totalScans;
  final Map<String, int> byMenu;

  const V6DailyScan({
    required this.date,
    required this.totalScans,
    required this.byMenu,
  });

  factory V6DailyScan.fromJson(Map<String, dynamic> json) {
    final rawByMenu = json['by_menu'];
    final Map<String, int> parsedByMenu = {};
    if (rawByMenu is Map) {
      rawByMenu.forEach((k, v) {
        parsedByMenu[k.toString()] = _asInt(v);
      });
    }

    return V6DailyScan(
      date: json['date']?.toString() ?? '',
      totalScans: _asInt(json['total_scans']),
      byMenu: parsedByMenu,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'total_scans': totalScans,
        'by_menu': byMenu,
      };
}

// --- Safe Parsing Helpers ---
int _asInt(dynamic val, {int defaultValue = 0}) {
  if (val == null) return defaultValue;
  if (val is int) return val;
  if (val is num) return val.toInt();
  return int.tryParse(val.toString()) ?? defaultValue;
}

bool _asBool(dynamic val, {bool defaultValue = false}) {
  if (val == null) return defaultValue;
  if (val is bool) return val;
  if (val is num) return val == 1;
  final str = val.toString().toLowerCase().trim();
  return str == 'true' || str == '1';
}
