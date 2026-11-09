import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/errors/app_error_type.dart';
import '../../../../core/services/app_update_service.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../domain/menu_service_stat.dart';
import '../../domain/models/v6_dashboard_response.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../widgets/subscription_renew_sheet.dart';

/// Presentation state entity consumed by DashboardScreen
class DashboardViewState {
  final V6DashboardData rawData;
  final String restaurantName;
  final String restaurantUrl;
  final List<String> menuUrls;
  final bool isPublished;
  final int totalItems;
  final int totalCategories;
  final int totalScans;
  final double deltaPercent;
  final String peakHour;
  final int peakScans;
  final int yesterdayScans;
  final List<int> scanChartData;
  final List<String> scanChartLabels;
  final List<V6SessionItem> activeSessions;
  final String sessionSummaryText;

  const DashboardViewState({
    required this.rawData,
    required this.restaurantName,
    required this.restaurantUrl,
    this.menuUrls = const [],
    required this.isPublished,
    required this.totalItems,
    required this.totalCategories,
    required this.totalScans,
    required this.deltaPercent,
    required this.peakHour,
    required this.peakScans,
    required this.yesterdayScans,
    required this.scanChartData,
    required this.scanChartLabels,
    required this.activeSessions,
    required this.sessionSummaryText,
  });

  // Backward-compatibility aliases
  int get qrScansToday => totalScans;
  double get qrScanDeltaPercent => deltaPercent;
}

/// Enterprise Menu Dashboard Controller managing real-time analytics calculations,
/// live session states, pull-to-refresh, and period/menu filtering.
class MenuDashboardController extends GetxController
    with StateMixin<DashboardViewState> {
  final DashboardRepository? _dashboardRepository;

  MenuDashboardController([this._dashboardRepository]);

  final selectedPeriod = 'today'.obs;
  final selectedMenuFilter = 'all'.obs; // 'all', 'dine-in', 'ird'
  final menuServices = <MenuServiceStat>[].obs;
  final isForceUpdateRequired = false.obs;
  final latestAvailableVersion = ''.obs;
  final forceUpdateMessage = ''.obs;
  final isSubscriptionExpired = false.obs;
  final Rxn<V6SubscriptionInfo> subscriptionInfo = Rxn<V6SubscriptionInfo>();
  bool _hasShownSoftUpdate = false;

  V6DashboardData? _rawData;
  V6DashboardData? get rawData => _rawData;

  static const List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const List<String> _monthShortNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static String _formatHourLabel(int hour24) {
    final h = ((hour24 % 24) + 24) % 24;
    if (h == 0) return '12am';
    if (h < 12) return '${h}am';
    if (h == 12) return '12pm';
    return '${h - 12}pm';
  }

  /// Generates 6 chronological time labels for Today ending at 'Now'
  /// so no future hour (like 12pm/3pm/6pm at 11am) ever appears before 'Now'.
  static List<String> _buildTodayTimeLabels(DateTime now) {
    final currentHour = now.hour;
    if (currentHour >= 19) {
      return const ['6am', '9am', '12pm', '3pm', '6pm', 'Now'];
    }
    if (currentHour >= 11) {
      // Pick 5 evenly spaced past hours from 6am up to (currentHour - 1), plus 'Now'
      final span = (currentHour - 1) - 6; // >= 4
      final labels = <String>[];
      for (int i = 0; i < 5; i++) {
        final h = 6 + ((span * i) / 4).round();
        labels.add(_formatHourLabel(h));
      }
      labels.add('Now');
      return labels;
    }
    // Early morning (< 11am): 5 preceding 1-hour slots leading up to 'Now'
    final labels = <String>[];
    for (int i = 5; i >= 1; i--) {
      labels.add(_formatHourLabel(currentHour - i));
    }
    labels.add('Now');
    return labels;
  }

  @override
  void onInit() {
    super.onInit();
    _loadDashboard();
  }

  @override
  void onReady() {
    super.onReady();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    // Wait briefly so the dashboard transition animation finishes smoothly
    await Future.delayed(const Duration(milliseconds: 600));
    if (Get.isRegistered<FcmService>()) {
      await Get.find<FcmService>().requestNotificationPermissions();
    }
  }

  /// Initial or triggered fetch from the /api/v6/get_dashboard_data endpoint
  Future<void> _loadDashboard({bool isRefresh = false}) async {
    if (!isRefresh && _rawData == null) {
      change(null, status: RxStatus.loading());
    }

    final repo = _dashboardRepository ?? (Get.isRegistered<DashboardRepository>() ? Get.find<DashboardRepository>() : null);

    if (repo == null) {
      _loadFallbackData();
      return;
    }

    final result = await repo.getDashboardData(forceRefresh: isRefresh);

    result.fold(
      (failure) {
        final errorType = AppErrorClassifier.classify(failure, message: failure.message);

        // 1. Mandatory App Update Check (force == 1 or 2)
        if (errorType == AppErrorType.appUpdate) {
          _rawData = null;
          isForceUpdateRequired.value = true;
          forceUpdateMessage.value = failure.message.isNotEmpty
              ? failure.message
              : "Please Upgrade to Latest Version of Eresto Digimenu....";
          if (failure.details is Map) {
            final nv = (failure.details as Map)['nv']?.toString();
            if (nv != null && nv.isNotEmpty) {
              latestAvailableVersion.value = nv;
            }
          }
          change(null, status: RxStatus.error(forceUpdateMessage.value));
          _triggerForceUpdatePrompt(
            message: forceUpdateMessage.value,
            latestVersion: latestAvailableVersion.value,
          );
          return;
        }

        // 2. Mandatory Subscription Expired Check (Flag 0 or 4)
        if (errorType == AppErrorType.subscriptionExpired) {
          _rawData = null;
          isSubscriptionExpired.value = true;
          if (failure.details is Map) {
            final details = failure.details as Map;
            subscriptionInfo.value = V6SubscriptionInfo(
              flag: details['flag'] is int
                  ? details['flag'] as int
                  : int.tryParse(details['flag']?.toString() ?? '4') ?? 4,
              message: failure.message,
              validity: details['validity']?.toString() ?? '',
              daysLeft: details['days_left'] is int ? details['days_left'] as int : 0,
              extDays: details['ext_days'] is int ? details['ext_days'] as int : 0,
              extValidity: '',
            );
          }
          final msg = failure.message.isNotEmpty
              ? failure.message
              : "Subscription has expired. Please renew your subscription to continue using services.";
          change(null, status: RxStatus.error(msg));
          return;
        }

        if (_rawData != null) {
          // If we already have cached data, don't wipe the screen on pull-to-refresh
          ToastService.showError(
            failure.message.isNotEmpty
                ? failure.message
                : "Could not refresh dashboard data.",
          );
        } else {
          // Fallback to sample data for smooth testing if backend is temporarily offline
          if (failure.statusCode == 0 || failure.statusCode == 401 || failure.statusCode == 404) {
            _loadFallbackData();
          } else {
            change(null, status: RxStatus.error(failure.message));
          }
        }
      },
      (data) {
        // 1. Mandatory App Update Check (defense-in-depth on data payload)
        if (data.version != null && data.version!.isForceUpgrade) {
          _rawData = null;
          isForceUpdateRequired.value = true;
          latestAvailableVersion.value = data.version!.nv;
          final msg = data.version!.msg.isNotEmpty
              ? data.version!.msg
              : "Please Upgrade to Latest Version of Eresto Digimenu....";
          forceUpdateMessage.value = msg;
          change(null, status: RxStatus.error(msg));
          _triggerForceUpdatePrompt(
            message: msg,
            latestVersion: data.version!.nv,
          );
          return;
        }

        // 2. Subscription Status Handling
        if (data.subscription != null) {
          subscriptionInfo.value = data.subscription;

          // Flag 0: Expired (Validity and grace period both elapsed) -> Blocks app
          if (data.subscription!.isExpired) {
            _rawData = null;
            isSubscriptionExpired.value = true;
            final msg = data.subscription!.displayMessage;
            change(null, status: RxStatus.error(msg));
            return;
          }
        }
        isSubscriptionExpired.value = false;

        // 3. Soft update notification if optional (force == 0)
        if (data.version != null && data.version!.hasUpdate && !data.version!.isForceUpgrade) {
          _handleSoftUpdateNotice(data.version!);
        }

        isForceUpdateRequired.value = false;
        _rawData = data;
        _persistRestoHeaderFromDashboard(data);
        _populateMenuServices(data);
        _recalculateView();
      },
    );
  }

  void _persistRestoHeaderFromDashboard(V6DashboardData data) {
    if (!Get.isRegistered<StorageService>()) return;
    final storage = Get.find<StorageService>();
    V6RestoInfo? info;
    for (final container in data.menuSessions) {
      if (container.restoInfo != null) {
        info = container.restoInfo;
        break;
      }
    }
    final name = (info?.title.trim().isNotEmpty == true)
        ? info!.title.trim()
        : data.hero.restoName.trim();
    storage.saveRestoHeaderDetails(
      name: name.isNotEmpty ? name : null,
      address: info?.address.trim(),
      city: info?.city.trim(),
      pinCode: info?.pinCode.trim(),
      contact: info?.contactNo.trim(),
    );
  }

  void _triggerForceUpdatePrompt({required String message, String? latestVersion}) {
    HapticFeedback.heavyImpact();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isDialogOpen != true) {
        AppDialog.showUpdate(
          title: "App Update Required",
          message: message,
          versionTag: latestVersion != null && latestVersion.isNotEmpty
              ? "v$latestVersion"
              : "Latest Version",
          buttonText: "Update Now",
          isForceUpgrade: true,
          onUpdate: () => AppUpdateService.openPlayStore(),
        );
      }
    });
  }


  /// Opens the enterprise renewal and support modal sheet
  void handleSubscriptionRenewal() {
    if (Get.context != null) {
      final effectiveSub = subscriptionInfo.value ??
          (isSubscriptionExpired.value
              ? const V6SubscriptionInfo(
                  flag: 4,
                  message:
                      "Subscription has expired. Please renew your subscription to continue using services.",
                  validity: "",
                  daysLeft: 0,
                  extDays: 0,
                  extValidity: "",
                )
              : const V6SubscriptionInfo.empty());

      SubscriptionRenewSheet.show(
        Get.context!,
        subscription: effectiveSub,
        onCheckStatus: () => fetchAnalytics(forceRefresh: true),
      );
    }
  }

  /// Re-triggers update prompt if user attempts unauthorized action
  void promptUpdateAgain() {
    _triggerForceUpdatePrompt(
      message: forceUpdateMessage.value.isNotEmpty
          ? forceUpdateMessage.value
          : "Please Upgrade to Latest Version of Eresto Digimenu....",
      latestVersion: latestAvailableVersion.value,
    );
  }

  void _handleSoftUpdateNotice(V6AppVersionInfo version) {
    if (_hasShownSoftUpdate) return;
    _hasShownSoftUpdate = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        AppUpdateService.showUpdateBottomSheet(
          context: Get.context!,
          latestVersion: version.nv,
          message: version.msg.isNotEmpty
              ? version.msg
              : "A new version of Eresto Digimenu is available with new features and improvements.",
        );
      }
    });
  }

  /// Pull-to-refresh handler invoked by RefreshIndicator
  Future<void> refreshDashboard() async {
    await _loadDashboard(isRefresh: true);
  }

  /// Retry action invoked on error view
  Future<void> fetchAnalytics({bool forceRefresh = true}) async {
    await _loadDashboard(isRefresh: forceRefresh);
  }

  /// Switch to offline mode using cached or sample operational data
  void loadOfflineMode() {
    if (isForceUpdateRequired.value) {
      ToastService.showError("Cannot use offline mode. Please update the app to continue.");
      promptUpdateAgain();
      return;
    }
    if (isSubscriptionExpired.value) {
      ToastService.showError("Cannot use offline mode. Please renew your subscription to continue.");
      handleSubscriptionRenewal();
      return;
    }
    _loadFallbackData();
    ToastService.showInfo("Running in Offline Preview Mode");
  }

  /// Simulate dummy error for UI testing and demonstration
  void simulateError([String? message]) {
    change(
      null,
      status: RxStatus.error(
        message ?? "Please update the app to the latest version.",
      ),
    );
  }

  /// Simulate specific enterprise scenario (appUpdate, network, maintenance, unauthorized, serverError)
  void simulateScenario(AppErrorType type, [String? customMessage]) {
    final visuals = AppErrorClassifier.getVisuals(type, customMessage: customMessage);
    change(
      null,
      status: RxStatus.error(visuals.defaultMessage),
    );
  }

  /// Change active trend period (Today / Week / Month) - Zero network latency
  void changePeriod(String period) {
    if (selectedPeriod.value != period) {
      selectedPeriod.value = period;
      _recalculateView();
    }
  }

  /// Change active menu filter (All / Dine-In / IRD) - Zero network latency
  void changeMenuFilter(String filter) {
    // Normalize filter keys ('dine_in' -> 'dine-in')
    final normalized = filter == 'dine_in' ? 'dine-in' : filter;
    if (selectedMenuFilter.value != normalized) {
      selectedMenuFilter.value = normalized;
      _recalculateView();
    }
  }

  /// Build the dynamic menu services list from API breakdown
  void _populateMenuServices(V6DashboardData data) {
    final services = <MenuServiceStat>[];

    // 1. All menus tab
    int totalSessions = 0;
    for (final b in data.hero.breakdown) {
      totalSessions += b.sessionsCount;
    }
    if (totalSessions == 0) {
      totalSessions = data.allSessions.length;
    }

    services.add(MenuServiceStat(
      id: 'all',
      name: 'All menus',
      scansCount: data.hero.scansToday,
      sessionsCount: totalSessions,
    ));

    // 2. Breakdown tabs (Dine-In, IRD)
    for (final b in data.hero.breakdown) {
      services.add(MenuServiceStat(
        id: b.sessionFor,
        name: b.name,
        scansCount: b.scansToday,
        sessionsCount: b.sessionsCount,
      ));
    }

    menuServices.assignAll(services);
  }

  /// Client-side compute engine: recalculates chart points, peaks, and active sessions
  void _recalculateView() {
    if (_rawData == null) return;
    final data = _rawData!;

    try {
      final period = selectedPeriod.value;
      final menuFilter = selectedMenuFilter.value;

      int totalScans = 0;
      int yesterdayScans = 0;
      double deltaPercent = 0.0;
      String peakHour = "—";
      int peakScans = 0;
      List<int> chartData = [];
      List<String> chartLabels = [];

      // Helper to extract filtered scan count for a single daily scan entry
      int extractDayScans(V6DailyScan day) {
        if (menuFilter == 'all') return day.totalScans;
        final normKey = menuFilter.toLowerCase();
        return day.byMenu[normKey] ??
            day.byMenu[normKey.replaceAll('_', '-')] ??
            day.byMenu[normKey.replaceAll('-', '_')] ??
            0;
      }

      String fmtDateKey(DateTime dt) =>
          '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

      // Build calendar-accurate lookup map from sparse dailyScans
      final Map<String, int> scansByDate = {};
      DateTime? latestScanDate;
      for (final day in data.scanData.dailyScans) {
        final parsed = DateTime.tryParse(day.date.trim());
        if (parsed != null) {
          final normalized = DateTime(parsed.year, parsed.month, parsed.day);
          final key = fmtDateKey(normalized);
          scansByDate[key] = (scansByDate[key] ?? 0) + extractDayScans(day);
          if (latestScanDate == null || normalized.isAfter(latestScanDate)) {
            latestScanDate = normalized;
          }
        }
      }

      // Resolve live today & yesterday scans for the active filter
      int liveTodayScans = 0;
      int liveYesterdayScans = 0;
      if (menuFilter == 'all') {
        liveTodayScans = data.hero.scansToday;
        liveYesterdayScans = data.hero.scansYesterday;
      } else {
        final b = data.hero.breakdown.firstWhereOrNull((e) =>
            e.sessionFor.toLowerCase() == menuFilter.toLowerCase() ||
            e.sessionFor.replaceAll('-', '_').toLowerCase() ==
                menuFilter.replaceAll('-', '_').toLowerCase());
        liveTodayScans = b?.scansToday ?? 0;
        liveYesterdayScans = b?.scansYesterday ?? 0;
      }

      // Determine reference end date for the calendar window
      final parsedToDate = DateTime.tryParse(data.scanData.toDate.trim());
      final rawEndDate = parsedToDate ?? latestScanDate ?? DateTime.now();
      final endDate = DateTime(rawEndDate.year, rawEndDate.month, rawEndDate.day);

      // Ensure today's live scan count is reflected on endDate if higher
      final endKey = fmtDateKey(endDate);
      if (liveTodayScans > (scansByDate[endKey] ?? 0)) {
        scansByDate[endKey] = liveTodayScans;
      }

      // Helper to sum scans for any channel across a date range
      int sumChannelForDays(String channelId, int startDaysAgo, int endDaysAgo) {
        int sum = 0;
        for (int i = startDaysAgo; i >= endDaysAgo; i--) {
          final d = endDate.subtract(Duration(days: i));
          final key = fmtDateKey(d);
          if (i == 0 && channelId == 'all' && liveTodayScans > 0) {
            // handled via dailyScans or liveTodayScans
          }
          for (final day in data.scanData.dailyScans) {
            final parsed = DateTime.tryParse(day.date.trim());
            if (parsed != null &&
                parsed.year == d.year &&
                parsed.month == d.month &&
                parsed.day == d.day) {
              if (channelId == 'all') {
                sum += day.totalScans;
              } else {
                final norm = channelId.toLowerCase();
                sum += day.byMenu[norm] ??
                    day.byMenu[norm.replaceAll('_', '-')] ??
                    day.byMenu[norm.replaceAll('-', '_')] ??
                    0;
              }
            }
          }
          if (key == endKey) {
            // If today's live scan count is greater than what's in dailyScans for today
            int todayRecorded = 0;
            for (final day in data.scanData.dailyScans) {
              final parsed = DateTime.tryParse(day.date.trim());
              if (parsed != null && fmtDateKey(parsed) == endKey) {
                if (channelId == 'all') {
                  todayRecorded += day.totalScans;
                } else {
                  final norm = channelId.toLowerCase();
                  todayRecorded += day.byMenu[norm] ??
                      day.byMenu[norm.replaceAll('_', '-')] ??
                      day.byMenu[norm.replaceAll('-', '_')] ??
                      0;
                }
              }
            }
            int liveChannelToday = 0;
            if (channelId == 'all') {
              liveChannelToday = data.hero.scansToday;
            } else {
              final b = data.hero.breakdown.firstWhereOrNull((e) =>
                  e.sessionFor.toLowerCase() == channelId.toLowerCase() ||
                  e.sessionFor.replaceAll('-', '_').toLowerCase() ==
                      channelId.replaceAll('-', '_').toLowerCase());
              liveChannelToday = b?.scansToday ?? 0;
            }
            if (liveChannelToday > todayRecorded) {
              sum += (liveChannelToday - todayRecorded);
            }
          }
        }
        return sum;
      }

      // Update top menu filter tabs to reflect scan counts for the active period
      final updatedServices = <MenuServiceStat>[];
      int totalSessions = 0;
      for (final b in data.hero.breakdown) {
        totalSessions += b.sessionsCount;
      }
      if (totalSessions == 0) totalSessions = data.allSessions.length;

      final periodDaysBack = period == 'week' ? 6 : (period == 'month' ? 29 : 0);
      final allTabScans = period == 'today'
          ? data.hero.scansToday
          : sumChannelForDays('all', periodDaysBack, 0);

      updatedServices.add(MenuServiceStat(
        id: 'all',
        name: 'All menus',
        scansCount: allTabScans,
        sessionsCount: totalSessions,
      ));
      for (final b in data.hero.breakdown) {
        final chScans = period == 'today'
            ? b.scansToday
            : sumChannelForDays(b.sessionFor, periodDaysBack, 0);
        updatedServices.add(MenuServiceStat(
          id: b.sessionFor,
          name: b.name,
          scansCount: chScans,
          sessionsCount: b.sessionsCount,
        ));
      }
      menuServices.assignAll(updatedServices);

      // --- 1. Compute Analytics per period ---
      if (period == 'week') {
        chartLabels = [];
        chartData = [];
        int weekSum = 0;
        int maxVal = 0;
        String maxDay = _weekDays[endDate.weekday - 1];

        // Generate the exact 7 consecutive calendar days ending on endDate
        for (int i = 6; i >= 0; i--) {
          final d = endDate.subtract(Duration(days: i));
          final label = _weekDays[d.weekday - 1];
          final scans = scansByDate[fmtDateKey(d)] ?? 0;

          chartLabels.add(label);
          chartData.add(scans);
          weekSum += scans;
          if (scans >= maxVal && scans > 0) {
            maxVal = scans;
            maxDay = label;
          }
        }

        // Sum prior 7 calendar days (endDate - 13 .. endDate - 7) for true week-over-week comparison
        int prevWeekSum = 0;
        for (int i = 13; i >= 7; i--) {
          final d = endDate.subtract(Duration(days: i));
          prevWeekSum += scansByDate[fmtDateKey(d)] ?? 0;
        }

        totalScans = weekSum;
        peakScans = maxVal;
        peakHour = maxVal > 0 ? maxDay : "—";
        yesterdayScans = prevWeekSum;
        deltaPercent = prevWeekSum > 0
            ? (((totalScans - prevWeekSum) / prevWeekSum) * 100).toDouble()
            : (totalScans > 0 ? 100.0 : 0.0);
      } else if (period == 'month') {
        chartLabels = [];
        chartData = [0, 0, 0, 0];

        // Bucket the 28-day (4 calendar weeks) window ending on endDate chronologically
        // and label each point with its actual calendar week start-date (e.g. "13 Oct", "20 Oct")
        for (int w = 0; w < 4; w++) {
          int bucketSum = 0;
          final startOffset = (3 - w) * 7 + 6;
          final endOffset = (3 - w) * 7;
          final bucketStartDate = endDate.subtract(Duration(days: startOffset));
          final bucketEndDate = endDate.subtract(Duration(days: endOffset));
          final startMonth = _monthShortNames[bucketStartDate.month - 1];
          final endMonth = _monthShortNames[bucketEndDate.month - 1];
          final weekLabel = bucketStartDate.month == bucketEndDate.month
              ? '${bucketStartDate.day}–${bucketEndDate.day} $startMonth'
              : '${bucketStartDate.day} $startMonth–${bucketEndDate.day} $endMonth';
          chartLabels.add(weekLabel);

          for (int dayOffset = startOffset; dayOffset >= endOffset; dayOffset--) {
            final d = endDate.subtract(Duration(days: dayOffset));
            bucketSum += scansByDate[fmtDateKey(d)] ?? 0;
          }
          chartData[w] = bucketSum;
        }

        // Include any scans older than 28 days (e.g. day 28..30 in a 30-day API window) into bucket 0
        final parsedFromDate = DateTime.tryParse(data.scanData.fromDate.trim());
        if (parsedFromDate != null) {
          final startDate = DateTime(parsedFromDate.year, parsedFromDate.month, parsedFromDate.day);
          final oldestBucketStart = endDate.subtract(const Duration(days: 27));
          if (startDate.isBefore(oldestBucketStart)) {
            final firstBucketEnd = endDate.subtract(const Duration(days: 21));
            final sMonth = _monthShortNames[startDate.month - 1];
            final eMonth = _monthShortNames[firstBucketEnd.month - 1];
            chartLabels[0] = startDate.month == firstBucketEnd.month
                ? '${startDate.day}–${firstBucketEnd.day} $sMonth'
                : '${startDate.day} $sMonth–${firstBucketEnd.day} $eMonth';
            for (DateTime d = startDate;
                d.isBefore(oldestBucketStart);
                d = d.add(const Duration(days: 1))) {
              chartData[0] += scansByDate[fmtDateKey(d)] ?? 0;
            }
          }
        }

        totalScans = chartData.reduce((a, b) => a + b);
        peakScans = chartData.reduce((a, b) => a > b ? a : b);
        int maxWkIdx = 0;
        for (int i = 0; i < chartData.length; i++) {
          if (chartData[i] == peakScans && peakScans > 0) maxWkIdx = i;
        }
        peakHour = peakScans > 0 ? chartLabels[maxWkIdx] : "—";
        final prevWeek = chartData[2];
        final currWeek = chartData[3];
        yesterdayScans = prevWeek;
        deltaPercent = prevWeek > 0
            ? (((currWeek - prevWeek) / prevWeek) * 100).toDouble()
            : (totalScans > 0 ? 100.0 : 0.0);
      } else {
        // 'today' — dynamic time labels up to current hour so no future hour appears before 'Now'
        final now = DateTime.now();
        chartLabels = _buildTodayTimeLabels(now);
        totalScans = liveTodayScans;
        yesterdayScans = liveYesterdayScans;

        if (totalScans > 0) {
          chartData = [
            (totalScans * 0.05).round(),
            (totalScans * 0.11).round(),
            (totalScans * 0.18).round(),
            (totalScans * 0.36).round(),
            (totalScans * 0.58).round(),
            totalScans,
          ];
          peakHour = "Now";
          peakScans = totalScans;
        } else {
          chartData = const [0, 0, 0, 0, 0, 0];
          peakHour = "—";
          peakScans = 0;
        }

        deltaPercent = yesterdayScans > 0
            ? (((totalScans - yesterdayScans) / yesterdayScans) * 100).toDouble()
            : (totalScans > 0 ? 100.0 : 0.0);
      }

      // --- 2. Active Sessions Sorter & Filter ---
      final allSessions = List<V6SessionItem>.from(data.allSessions);
      // Sort: LIVE first, then UPCOMING, then others
      allSessions.sort((a, b) {
        if (a.isLive && !b.isLive) return -1;
        if (!a.isLive && b.isLive) return 1;
        if (a.isUpcoming && !b.isUpcoming) return -1;
        if (!a.isUpcoming && b.isUpcoming) return 1;
        return 0;
      });

      final viewState = DashboardViewState(
        rawData: data,
        restaurantName: data.restaurantName,
        restaurantUrl: data.restaurantUrl,
        menuUrls: data.menuUrls,
        isPublished: data.isPublished,
        totalItems: data.totalItems,
        totalCategories: data.totalCategories,
        totalScans: totalScans,
        deltaPercent: deltaPercent,
        peakHour: peakHour,
        peakScans: peakScans,
        yesterdayScans: yesterdayScans,
        scanChartData: chartData,
        scanChartLabels: chartLabels,
        activeSessions: allSessions,
        sessionSummaryText: data.sessionSummaryText,
      );

      change(viewState, status: RxStatus.success());
    } catch (e, stack) {
      // Fail-safe: ensure UI never hangs in loading state
      Get.log("Error recalculating dashboard view: $e\n$stack", isError: true);
      change(
        DashboardViewState(
          rawData: data,
          restaurantName: data.restaurantName,
          restaurantUrl: data.restaurantUrl,
          menuUrls: data.menuUrls,
          isPublished: data.isPublished,
          totalItems: data.totalItems,
          totalCategories: data.totalCategories,
          totalScans: data.hero.scansToday,
          deltaPercent: data.hero.deltaPct.toDouble(),
          peakHour: "—",
          peakScans: 0,
          yesterdayScans: data.hero.scansYesterday,
          scanChartData: const [0, 0, 0, 0, 0, 0],
          scanChartLabels: const ['6am', '9am', '12pm', '3pm', '6pm', 'Now'],
          activeSessions: data.allSessions,
          sessionSummaryText: data.sessionSummaryText,
        ),
        status: RxStatus.success(),
      );
    }
  }

  /// High-fidelity fallback dataset for instant prototype demonstration
  /// High-fidelity fallback dataset matching latest live response
  void _loadFallbackData() {
    const sampleData = V6DashboardData(
      hero: V6DashboardHero(
        restoId: 85,
        restoName: 'VRG Resorts',
        restoSub: 'pmenu.eresto.app/vrg',
        menuUrl: 'https://pmenu.eresto.app/vrg/dine-in',
        menuUrls: [
          'https://pmenu.eresto.app/vrg/dine-in',
          'https://pmenu.eresto.app/vrg/ird',
          'https://pmenu.eresto.app/vrg/cat2',
          'https://pmenu.eresto.app/vrg/cat3',
          'https://pmenu.eresto.app/vrg/cat4',
          'https://pmenu.eresto.app/vrg/cat5',
          'https://pmenu.eresto.app/vrg/cat6',
        ],
        isPublished: true,
        totalItems: 548,
        totalCategories: 52,
        scansToday: 0,
        scansYesterday: 6,
        breakdown: [
          V6HeroBreakdown(
            sessionFor: 'dine-in',
            name: 'Dine-IN',
            scansToday: 0,
            scansYesterday: 6,
            sessionsCount: 1,
            menuUrl: 'https://pmenu.eresto.app/vrg/dine-in',
          ),
          V6HeroBreakdown(
            sessionFor: 'ird',
            name: 'IRD',
            scansToday: 0,
            scansYesterday: 0,
            sessionsCount: 1,
            menuUrl: 'https://pmenu.eresto.app/vrg/ird',
          ),
          V6HeroBreakdown(
            sessionFor: 'cat2',
            name: 'Cat2',
            scansToday: 0,
            scansYesterday: 0,
            sessionsCount: 2,
            menuUrl: 'https://pmenu.eresto.app/vrg/cat2',
          ),
          V6HeroBreakdown(
            sessionFor: 'cat3',
            name: 'Cat3',
            scansToday: 0,
            scansYesterday: 0,
            sessionsCount: 1,
            menuUrl: 'https://pmenu.eresto.app/vrg/cat3',
          ),
          V6HeroBreakdown(
            sessionFor: 'cat4',
            name: 'Cat4',
            scansToday: 0,
            scansYesterday: 0,
            sessionsCount: 2,
            menuUrl: 'https://pmenu.eresto.app/vrg/cat4',
          ),
          V6HeroBreakdown(
            sessionFor: 'cat5',
            name: 'Cat5',
            scansToday: 0,
            scansYesterday: 0,
            sessionsCount: 1,
            menuUrl: 'https://pmenu.eresto.app/vrg/cat5',
          ),
          V6HeroBreakdown(
            sessionFor: 'cat6',
            name: 'Cat6',
            scansToday: 0,
            scansYesterday: 0,
            sessionsCount: 1,
            menuUrl: 'https://pmenu.eresto.app/vrg/cat6',
          ),
        ],
      ),
      menuSessions: [
        V6MenuSessionContainer(
          id: 1,
          sessionFor: 'dine-in',
          name: 'Dine-IN',
          menuUrl: 'https://pmenu.eresto.app/vrg/dine-in',
          restoInfo: V6RestoInfo(
            title: 'VRG Resorts',
            subtitle: '',
            logo: '',
            address: '36, Lallubhai Park Road, Andheri (West)',
            city: 'Ahmedabad',
            pinCode: '380059',
            contactNo: '9898014195',
            whatsappNo: '',
            location: '21.7561° N, 72.9988° E',
            website: 'https://vgr.com',
            restoCurrency: '₹',
          ),
          sessions: [
            V6SessionItem(
              id: 2,
              sessionName: 'Breakfast',
              sessionFor: 'dine-in',
              menuType: 'Dine-IN',
              menuTemplateId: 8,
              menuTemplateName: 'Parsi New Year',
              startTime: '07:30',
              endTime: '10:30',
              dayFlag: 0,
              enCustOrder: 0,
              categoriesCount: 49,
              itemsCount: 501,
              todayScans: 0,
              hasSplash: 1,
              offerId: 0,
            ),
          ],
        ),
        V6MenuSessionContainer(
          id: 2,
          sessionFor: 'ird',
          name: 'IRD',
          menuUrl: 'https://pmenu.eresto.app/vrg/ird',
          sessions: [
            V6SessionItem(
              id: 1,
              sessionName: '24*7',
              sessionFor: 'ird',
              menuType: 'IRD',
              menuTemplateId: 8,
              menuTemplateName: 'Parsi New Year',
              startTime: '00:00',
              endTime: '22:00',
              dayFlag: 0,
              enCustOrder: 0,
              categoriesCount: 49,
              itemsCount: 501,
              todayScans: 0,
              hasSplash: 1,
              offerId: 0,
            ),
          ],
        ),
        V6MenuSessionContainer(
          id: 3,
          sessionFor: 'cat2',
          name: 'Cat2',
          menuUrl: 'https://pmenu.eresto.app/vrg/cat2',
          sessions: [
            V6SessionItem(
              id: 1,
              sessionName: 'ONE',
              sessionFor: 'cat2',
              menuType: 'Cat2',
              menuTemplateId: 8,
              menuTemplateName: 'Parsi New Year',
              startTime: '12:00',
              endTime: '22:00',
              dayFlag: 0,
              enCustOrder: 1,
              categoriesCount: 49,
              itemsCount: 501,
              todayScans: 0,
              hasSplash: 1,
              offerId: 0,
            ),
            V6SessionItem(
              id: 2,
              sessionName: 'two ',
              sessionFor: 'cat2',
              menuType: 'Cat2',
              menuTemplateId: 8,
              menuTemplateName: 'Parsi New Year',
              startTime: '10:25',
              endTime: '11:25',
              dayFlag: 0,
              enCustOrder: 1,
              categoriesCount: 49,
              itemsCount: 501,
              todayScans: 0,
              hasSplash: 1,
              offerId: 0,
            ),
          ],
        ),
        V6MenuSessionContainer(
          id: 4,
          sessionFor: 'cat3',
          name: 'Cat3',
          menuUrl: 'https://pmenu.eresto.app/vrg/cat3',
          sessions: [
            V6SessionItem(
              id: 1,
              sessionName: 'One',
              sessionFor: 'cat3',
              menuType: 'Cat3',
              menuTemplateId: 15,
              menuTemplateName: 'Multi Cat 3',
              startTime: '00:00',
              endTime: '22:00',
              dayFlag: 0,
              enCustOrder: 0,
              categoriesCount: 14,
              itemsCount: 195,
              todayScans: 0,
              hasSplash: 1,
              offerId: 0,
            ),
          ],
        ),
        V6MenuSessionContainer(
          id: 5,
          sessionFor: 'cat4',
          name: 'Cat4',
          menuUrl: 'https://pmenu.eresto.app/vrg/cat4',
          sessions: [
            V6SessionItem(
              id: 1,
              sessionName: 'ONE',
              sessionFor: 'cat4',
              menuType: 'Cat4',
              menuTemplateId: 16,
              menuTemplateName: 'Multi Cat 4',
              startTime: '00:00',
              endTime: '08:00',
              dayFlag: 0,
              enCustOrder: 0,
              categoriesCount: 16,
              itemsCount: 248,
              todayScans: 0,
              hasSplash: 1,
              offerId: 0,
            ),
            V6SessionItem(
              id: 2,
              sessionName: 'Cat 3',
              sessionFor: 'cat4',
              menuType: 'Cat4',
              menuTemplateId: 15,
              menuTemplateName: 'Multi Cat 3',
              startTime: '09:00',
              endTime: '10:00',
              dayFlag: 0,
              enCustOrder: 0,
              categoriesCount: 14,
              itemsCount: 195,
              todayScans: 0,
              hasSplash: 1,
              offerId: 0,
            ),
          ],
        ),
        V6MenuSessionContainer(
          id: 6,
          sessionFor: 'cat5',
          name: 'Cat5',
          menuUrl: 'https://pmenu.eresto.app/vrg/cat5',
          sessions: [
            V6SessionItem(
              id: 1,
              sessionName: 'ONE',
              sessionFor: 'cat5',
              menuType: 'Cat5',
              menuTemplateId: 11,
              menuTemplateName: 'SMC18-7',
              startTime: '00:00',
              endTime: '22:00',
              dayFlag: 0,
              enCustOrder: 0,
              categoriesCount: 5,
              itemsCount: 28,
              todayScans: 0,
              hasSplash: 1,
              offerId: 0,
            ),
          ],
        ),
        V6MenuSessionContainer(
          id: 7,
          sessionFor: 'cat6',
          name: 'Cat6',
          menuUrl: 'https://pmenu.eresto.app/vrg/cat6',
          sessions: [
            V6SessionItem(
              id: 1,
              sessionName: 'ONE',
              sessionFor: 'cat6',
              menuType: 'Cat6',
              menuTemplateId: 18,
              menuTemplateName: 'Multi Cat 6',
              startTime: '00:00',
              endTime: '22:00',
              dayFlag: 0,
              enCustOrder: 0,
              categoriesCount: 25,
              itemsCount: 335,
              todayScans: 0,
              hasSplash: 1,
              offerId: 0,
            ),
          ],
        ),
      ],
      scanData: V6ScanData(
        fromDate: '2026-08-19',
        toDate: '2026-09-18',
        scansToday: 0,
        scansYesterday: 6,
        dailyScans: [
          V6DailyScan(date: '2026-08-30', totalScans: 4, byMenu: {'dine-in': 4}),
          V6DailyScan(date: '2026-09-07', totalScans: 2, byMenu: {'dine-in': 2}),
          V6DailyScan(date: '2026-09-11', totalScans: 5, byMenu: {'dine-in': 5}),
          V6DailyScan(date: '2026-09-13', totalScans: 1, byMenu: {'dine-in': 1}),
          V6DailyScan(
            date: '2026-09-15',
            totalScans: 28,
            byMenu: {'cat2': 1, 'cat3': 1, 'dine-in': 25, 'ird': 1},
          ),
          V6DailyScan(date: '2026-09-16', totalScans: 4, byMenu: {'cat4': 4}),
          V6DailyScan(date: '2026-09-17', totalScans: 6, byMenu: {'dine-in': 6}),
        ],
      ),
    );

    _rawData = sampleData;
    _populateMenuServices(sampleData);
    _recalculateView();
  }
}
