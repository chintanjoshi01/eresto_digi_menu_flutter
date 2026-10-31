/// Version and upgrade policy information returned from /api/v6/get_dashboard_data
class V6AppVersionInfo {
  final int nvId;
  final String nv;
  final String msg;
  final int force;

  const V6AppVersionInfo({
    required this.nvId,
    required this.nv,
    required this.msg,
    required this.force,
  });

  const V6AppVersionInfo.empty()
      : nvId = 0,
        nv = '',
        msg = '',
        force = 0;

  bool get isForceUpgrade => force == 1 || force == 2;
  bool get hasUpdate => nv.isNotEmpty;

  factory V6AppVersionInfo.fromJson(Map<String, dynamic> json) {
    return V6AppVersionInfo(
      nvId: json['nv_id'] is int
          ? json['nv_id'] as int
          : int.tryParse(json['nv_id']?.toString() ?? '0') ?? 0,
      nv: json['nv']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      force: json['force'] is int
          ? json['force'] as int
          : int.tryParse(json['force']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'nv_id': nvId,
        'nv': nv,
        'msg': msg,
        'force': force,
      };
}

/// Enterprise Subscription status and validity details returned from /api/v6/get_dashboard_data
class V6SubscriptionInfo {
  final int flag;
  final String message;
  final String validity;
  final int daysLeft;
  final int extDays;
  final String extValidity;

  const V6SubscriptionInfo({
    required this.flag,
    required this.message,
    required this.validity,
    required this.daysLeft,
    required this.extDays,
    required this.extValidity,
  });

  const V6SubscriptionInfo.empty()
      : flag = 1,
        message = 'Subscription is active.',
        validity = '',
        daysLeft = 365,
        extDays = 0,
        extValidity = '';

  /// Flag 1: Active (> 7 days remaining)
  bool get isActive => flag == 1;

  /// Flag 2: Expiring Soon (0 to 7 days remaining)
  bool get isExpiringSoon => flag == 2;

  /// Flag 3: Grace Period (Validity expired, but within ext_days)
  bool get isInGracePeriod => flag == 3;

  /// Flag 0 or 4: Expired (Validity and grace period both elapsed) -> Blocks app
  bool get isExpired =>
      flag == 0 ||
      flag == 4 ||
      (daysLeft <= 0 && extDays <= 0 && (message.toLowerCase().contains('expired') || flag > 3));

  /// Helper to check if warning banner should be displayed (Flag 2 or Flag 3)
  bool get shouldShowWarningBanner => isExpiringSoon || isInGracePeriod;

  /// Display text for warning banners or dialogs
  String get displayMessage {
    if (message.isNotEmpty) return message;
    if (isExpired) {
      return "Subscription has expired. Please renew your subscription to continue using services.";
    }
    if (isExpiringSoon) {
      if (daysLeft <= 0) {
        return "Your subscription expires today. Please renew now.";
      } else if (daysLeft == 1) {
        return "Your subscription will expire tomorrow. Please renew now.";
      } else {
        return "Your subscription will expire in $daysLeft days. Please renew now.";
      }
    }
    if (isInGracePeriod) {
      final days = extDays > 0 ? extDays : daysLeft;
      return "Subscription expired. Grace period is active for $days more days. Please renew now.";
    }
    return "Subscription is active.";
  }

  factory V6SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return V6SubscriptionInfo(
      flag: json['flag'] is int
          ? json['flag'] as int
          : int.tryParse(json['flag']?.toString() ?? '1') ?? 1,
      message: json['message']?.toString() ?? '',
      validity: json['validity']?.toString() ?? '',
      daysLeft: json['days_left'] is int
          ? json['days_left'] as int
          : int.tryParse(json['days_left']?.toString() ?? '0') ?? 0,
      extDays: json['ext_days'] is int
          ? json['ext_days'] as int
          : int.tryParse(json['ext_days']?.toString() ?? '0') ?? 0,
      extValidity: json['ext_validity']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'flag': flag,
        'message': message,
        'validity': validity,
        'days_left': daysLeft,
        'ext_days': extDays,
        'ext_validity': extValidity,
      };
}

/// Top-level API Response wrapper for /api/v6/get_dashboard_data
class V6DashboardResponse {
  final int status;
  final String message;
  final V6DashboardData? data;
  final V6AppVersionInfo? topLevelVersion;
  final V6SubscriptionInfo? topLevelSubscription;

  const V6DashboardResponse({
    required this.status,
    required this.message,
    this.data,
    this.topLevelVersion,
    this.topLevelSubscription,
  });

  bool get isSuccess => status == 1 && data != null;

  V6AppVersionInfo? get version => data?.version ?? topLevelVersion;
  bool get isForceUpgrade => version?.isForceUpgrade ?? false;
  String get upgradeMessage => version?.msg.isNotEmpty == true ? version!.msg : message;
  String get newVersion => version?.nv ?? '';

  V6SubscriptionInfo? get subscription => data?.subscription ?? topLevelSubscription;
  bool get isSubscriptionExpired => subscription?.isExpired ?? false;

  factory V6DashboardResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final dataMap = rawData is Map<String, dynamic> ? rawData : null;

    final rawVersion = json['version'];
    final topVer = rawVersion is Map<String, dynamic>
        ? V6AppVersionInfo.fromJson(rawVersion)
        : null;

    final rawSub = json['subscription'];
    final topSub = rawSub is Map<String, dynamic>
        ? V6SubscriptionInfo.fromJson(rawSub)
        : null;

    return V6DashboardResponse(
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      message: json['message']?.toString() ?? '',
      data: dataMap != null ? V6DashboardData.fromJson(dataMap) : null,
      topLevelVersion: topVer,
      topLevelSubscription: topSub,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
        if (topLevelVersion != null) 'version': topLevelVersion?.toJson(),
        if (topLevelSubscription != null) 'subscription': topLevelSubscription?.toJson(),
      };
}

/// Main dashboard data payload
class V6DashboardData {
  final V6AppVersionInfo? version;
  final V6SubscriptionInfo? subscription;
  final V6DashboardHero hero;
  final List<V6MenuSessionContainer> menuSessions;
  final V6ScanData scanData;

  const V6DashboardData({
    this.version,
    this.subscription,
    required this.hero,
    required this.menuSessions,
    required this.scanData,
  });

  // --- Convenience Getters for Interoperability ---
  String get restaurantName => hero.restoName;
  String get restaurantUrl => hero.restoSub;
  List<String> get menuUrls => hero.allMenuUrls;
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
      version: json['version'] != null && json['version'] is Map<String, dynamic>
          ? V6AppVersionInfo.fromJson(json['version'] as Map<String, dynamic>)
          : null,
      subscription: json['subscription'] != null && json['subscription'] is Map<String, dynamic>
          ? V6SubscriptionInfo.fromJson(json['subscription'] as Map<String, dynamic>)
          : null,
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
        if (version != null) 'version': version!.toJson(),
        if (subscription != null) 'subscription': subscription!.toJson(),
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
  final List<String> menuUrls;
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
    this.menuUrls = const [],
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
        menuUrls = const [],
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

  /// Unified list of all menu URLs
  List<String> get allMenuUrls {
    if (menuUrls.isNotEmpty) return menuUrls;
    if (menuUrl.isNotEmpty) return [menuUrl];
    return const [];
  }

  factory V6DashboardHero.fromJson(Map<String, dynamic> json) {
    // 1. Parse menu_url (supports List<dynamic> from new API and String from legacy API)
    final List<String> parsedMenuUrls = [];
    String parsedPrimaryMenuUrl = '';

    final rawMenuUrl = json['menu_url'];
    if (rawMenuUrl is List) {
      for (final item in rawMenuUrl) {
        if (item != null) {
          // Normalize double slashes e.g. "https://pmenu.eresto.app//vrg/dine-in" -> "https://pmenu.eresto.app/vrg/dine-in"
          final url = item.toString().replaceAll(RegExp(r'(?<!:)/{2,}'), '/');
          parsedMenuUrls.add(url);
        }
      }
      if (parsedMenuUrls.isNotEmpty) {
        parsedPrimaryMenuUrl = parsedMenuUrls.first;
      }
    } else if (rawMenuUrl != null && rawMenuUrl.toString().isNotEmpty) {
      final url = rawMenuUrl.toString().replaceAll(RegExp(r'(?<!:)/{2,}'), '/');
      parsedPrimaryMenuUrl = url;
      parsedMenuUrls.add(url);
    }

    // 2. Parse resto_sub (or cleanly extract domain/slug from menu_url if absent)
    String parsedRestoSub = json['resto_sub']?.toString() ?? '';
    if (parsedRestoSub.isEmpty) {
      if (parsedPrimaryMenuUrl.isNotEmpty) {
        // e.g. "https://pmenu.eresto.app/vrg/dine-in" -> "pmenu.eresto.app/vrg"
        final uri = Uri.tryParse(parsedPrimaryMenuUrl);
        if (uri != null && uri.pathSegments.isNotEmpty) {
          final firstSeg = uri.pathSegments.first;
          parsedRestoSub = "${uri.host}/$firstSeg";
        } else {
          parsedRestoSub = parsedPrimaryMenuUrl.replaceFirst(RegExp(r'^https?://'), '');
        }
      } else {
        final slug = json['resto_name']?.toString().toLowerCase().replaceAll(RegExp(r'\s+'), '') ?? 'vrg';
        parsedRestoSub = 'pmenu.eresto.app/$slug';
      }
    }

    return V6DashboardHero(
      restoId: _asInt(json['resto_id']),
      restoName: json['resto_name']?.toString() ?? 'Trulyy Tadkaaz',
      restoSub: parsedRestoSub,
      menuUrl: parsedPrimaryMenuUrl,
      menuUrls: parsedMenuUrls,
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
        'menu_urls': menuUrls,
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
    final rawUrl = json['menu_url']?.toString() ?? '';
    final cleanUrl = rawUrl.replaceAll(RegExp(r'(?<!:)/{2,}'), '/');
    return V6HeroBreakdown(
      sessionFor: json['session_for']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      scansToday: _asInt(json['scans_today']),
      scansYesterday: _asInt(json['scans_yesterday']),
      sessionsCount: _asInt(json['sessions_count']),
      menuUrl: cleanUrl,
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
    final rawUrl = json['menu_url']?.toString() ?? '';
    final cleanUrl = rawUrl.replaceAll(RegExp(r'(?<!:)/{2,}'), '/');
    return V6MenuSessionContainer(
      id: _asInt(json['id']),
      sessionFor: json['session_for']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      menuUrl: cleanUrl,
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
  final String address;
  final String city;
  final String pinCode;
  final String contactNo;
  final String whatsappNo;
  final String location;
  final String website;
  final String restoCurrency;
  final Map<String, dynamic>? smLinks;
  final Map<String, dynamic>? zsLinks;

  const V6RestoInfo({
    required this.title,
    required this.subtitle,
    required this.logo,
    this.address = '',
    this.city = '',
    this.pinCode = '',
    this.contactNo = '',
    this.whatsappNo = '',
    this.location = '',
    this.website = '',
    this.restoCurrency = '₹',
    this.smLinks,
    this.zsLinks,
  });

  factory V6RestoInfo.fromJson(Map<String, dynamic> json) {
    return V6RestoInfo(
      title: json['title']?.toString() ?? json['resto_name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? json['tag_line']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      pinCode: json['pin_code']?.toString() ?? '',
      contactNo: json['contact_no']?.toString() ?? '',
      whatsappNo: json['whatsapp_no']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      restoCurrency: json['resto_currency']?.toString() ?? '₹',
      smLinks: json['sm_links'] is Map<String, dynamic> ? json['sm_links'] as Map<String, dynamic> : null,
      zsLinks: json['zs_links'] is Map<String, dynamic> ? json['zs_links'] as Map<String, dynamic> : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'logo': logo,
        'address': address,
        'city': city,
        'pin_code': pinCode,
        'contact_no': contactNo,
        'whatsapp_no': whatsappNo,
        'location': location,
        'website': website,
        'resto_currency': restoCurrency,
        'sm_links': smLinks,
        'zs_links': zsLinks,
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
