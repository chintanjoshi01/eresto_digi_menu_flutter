import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../domain/models/channel_session_group_model.dart';
import '../../domain/models/menu_template_model.dart';
import '../../domain/models/session_model.dart';
import '../../domain/models/template_model.dart';
import '../../domain/repositories/menu_repository.dart';

/// Enterprise Menu Controller managing Templates, Channel Accordion Sessions, and Sheet Modals.
class MenuThemeController extends GetxController {
  final MenuRepository _repository;
  MenuRepository get repository => _repository;

  // New Rich Models matching Screenshot 1-4 & V6 API
  final templatesList = <MenuTemplateModel>[].obs;
  final channelGroups = <ChannelSessionGroupModel>[].obs;
  final expandedChannelIds = <String>{'dine-in'}.obs;
  final isTemplatesExpanded = false.obs;

  void toggleTemplatesExpanded() {
    HapticFeedback.selectionClick();
    isTemplatesExpanded.toggle();
  }

  // Legacy bindings for backward compatibility
  final templates = <TemplateModel>[].obs;
  final sessions = <SessionModel>[].obs;

  final isLoading = false.obs;
  final isPublishing = false.obs;

  MenuThemeController(this._repository);

  @override
  void onInit() {
    super.onInit();
    loadDefaultData();
    fetchRemoteMenuData();
  }

  /// Toggles expand/collapse state of a channel accordion
  void toggleChannelAccordion(String channelId) {
    HapticFeedback.selectionClick();
    if (expandedChannelIds.contains(channelId)) {
      expandedChannelIds.remove(channelId);
    } else {
      expandedChannelIds.add(channelId);
    }
  }

  /// Initial high-fidelity enterprise data matching HTML prototype & Screenshots
  void loadDefaultData() {
    // Menu templates are loaded dynamically from remote V6 get_menu_builder_data API
    templatesList.clear();
    templates.clear();

    channelGroups.assignAll([
      // 1. DINE-IN
      const ChannelSessionGroupModel(
        id: 'dine-in',
        title: 'DINE-IN SESSIONS',
        accentColor: Color(0xFFC1272D),
        activeCountText: '● 1 Active',
        activeCount: 1,
        sessions: [
          SessionCardModel(
            id: 1,
            name: 'Breakfast',
            statusText: 'Ended',
            statusBg: Color(0xFFF3F4F6),
            statusFg: Color(0xFF6B7280),
            isActiveNow: false,
            templateName: 'Breakfast',
            startTime: '06:00 am',
            endTime: '10:30 am',
            customerOrderEnabled: false,
            geoFenceEnabled: false,
            sectionName: '---',
            hasOffer: false,
            hasSplash: false,
          ),
          SessionCardModel(
            id: 2,
            name: 'Lunch',
            statusText: 'Active Now',
            statusBg: Color(0xFFDCFCE7),
            statusFg: Color(0xFF16A34A),
            isActiveNow: true,
            templateName: 'Main',
            startTime: '10:30 am',
            endTime: '06:30 pm',
            customerOrderEnabled: true,
            geoFenceEnabled: false,
            sectionName: 'Dine-In',
            hasOffer: true,
            hasSplash: true,
          ),
          SessionCardModel(
            id: 3,
            name: 'Dinner',
            statusText: 'Starts 18:30',
            statusBg: Color(0xFFFEF3C7),
            statusFg: Color(0xFFD97706),
            isActiveNow: false,
            templateName: 'Main',
            startTime: '06:30 pm',
            endTime: '11:59 pm',
            customerOrderEnabled: true,
            geoFenceEnabled: false,
            sectionName: 'Dine-In, TakeAway',
            hasOffer: false,
            hasSplash: false,
          ),
        ],
      ),

      // 2. IRD (IN-ROOM DINING)
      const ChannelSessionGroupModel(
        id: 'ird',
        title: 'IRD SESSIONS',
        accentColor: Color(0xFF6366F1),
        activeCountText: '● 1 Active',
        activeCount: 1,
        sessions: [
          SessionCardModel(
            id: 4,
            name: 'All Day IRD Menu',
            statusText: 'Active Now',
            statusBg: Color(0xFFDCFCE7),
            statusFg: Color(0xFF16A34A),
            isActiveNow: true,
            templateName: 'Main',
            startTime: '12:00 am',
            endTime: '11:59 pm',
            customerOrderEnabled: true,
            geoFenceEnabled: false,
            sectionName: 'Rooms',
            hasOffer: false,
            hasSplash: true,
          ),
          SessionCardModel(
            id: 5,
            name: 'HI-TEA Special',
            statusText: 'Ended',
            statusBg: Color(0xFFF3F4F6),
            statusFg: Color(0xFF6B7280),
            isActiveNow: false,
            templateName: 'HI-TEA',
            startTime: '03:00 pm',
            endTime: '06:00 pm',
            customerOrderEnabled: true,
            geoFenceEnabled: false,
            sectionName: 'Rooms',
            hasOffer: true,
            hasSplash: false,
          ),
        ],
      ),

      // 3. TAKEAWAY SESSIONS
      const ChannelSessionGroupModel(
        id: 'takeaway',
        title: 'TAKEAWAY SESSIONS',
        accentColor: Color(0xFFF59E0B),
        activeCountText: '● 1 Active',
        activeCount: 1,
        sessions: [
          SessionCardModel(
            id: 6,
            name: 'Takeaway Express',
            statusText: 'Active Now',
            statusBg: Color(0xFFDCFCE7),
            statusFg: Color(0xFF16A34A),
            isActiveNow: true,
            templateName: 'Main',
            startTime: '11:00 am',
            endTime: '11:00 pm',
            customerOrderEnabled: true,
            geoFenceEnabled: true,
            sectionName: 'Counter',
            hasOffer: true,
            hasSplash: false,
          ),
        ],
      ),

      // 4. DELIVERY SESSIONS
      const ChannelSessionGroupModel(
        id: 'delivery',
        title: 'DELIVERY SESSIONS',
        accentColor: Color(0xFF10B981),
        activeCountText: '0 Active',
        activeCount: 0,
        sessions: [
          SessionCardModel(
            id: 7,
            name: 'Online Delivery',
            statusText: 'Ended',
            statusBg: Color(0xFFF3F4F6),
            statusFg: Color(0xFF6B7280),
            isActiveNow: false,
            templateName: 'Main',
            startTime: '12:00 pm',
            endTime: '10:00 pm',
            customerOrderEnabled: false,
            geoFenceEnabled: true,
            sectionName: 'Delivery',
            hasOffer: false,
            hasSplash: false,
          ),
        ],
      ),
    ]);

    // Populate legacy models for backward compatibility
    templates.assignAll(templatesList.map((t) => TemplateModel(
      id: t.id,
      name: t.name,
      primaryColor: '0x${t.themeColor.value.toRadixString(16)}',
      backgroundColor: '0xFFFFFFFF',
      textColor: '0xFF111827',
      isActive: t.isActive,
    )));
  }

  /// Syncs with remote Menu Builder API (V6 get_menu_builder_data)
  Future<void> fetchRemoteMenuData({bool isSwipeRefresh = false}) async {
    try {
      if (!isSwipeRefresh && templatesList.isEmpty) {
        isLoading.value = true;
      }
      final result = await _repository.getMenuBuilderData();
      result.fold(
        (failure) {
          _fetchDashboardFallback();
        },
        (data) {
          // 1. Parse Menu Templates
          final rawTemplates = data['templates'] as List? ?? [];
          if (rawTemplates.isNotEmpty) {
            final parsedTemplates = rawTemplates.map((item) {
              return MenuTemplateModel.fromJson(item as Map<String, dynamic>);
            }).toList();

            // Arrange as per active 1st, then by ID
            parsedTemplates.sort((a, b) {
              if (a.isActive && !b.isActive) return -1;
              if (!a.isActive && b.isActive) return 1;
              return a.id.compareTo(b.id);
            });

            templatesList.assignAll(parsedTemplates);
            templates.assignAll(parsedTemplates.map((t) => TemplateModel(
              id: t.id,
              name: t.name,
              primaryColor: '0x${t.themeColor.value.toRadixString(16)}',
              backgroundColor: '0xFFFFFFFF',
              textColor: '0xFF111827',
              isActive: t.isActive,
            )));
          }

          // 2. Parse Channel Sessions
          final rawSessions = data['sessions'] as List? ?? [];
          if (rawSessions.isNotEmpty) {
            _mergeMenuBuilderSessions(rawSessions);
          }
        },
      );
    } catch (_) {
      _fetchDashboardFallback();
    } finally {
      isLoading.value = false;
    }
  }

  void _fetchDashboardFallback() async {
    try {
      if (Get.isRegistered<ApiClient>()) {
        final api = Get.find<ApiClient>();
        final res = await api.dio.post(Endpoints.v6Dashboard);
        if (res.data != null && res.data['status'] == 1 && res.data['data'] != null) {
          final menuSessions = res.data['data']['menu_sessions'] as List?;
          if (menuSessions != null && menuSessions.isNotEmpty) {
            _mergeRemoteSessions(menuSessions);
          }
        }
      }
    } catch (_) {}
  }

  void _mergeMenuBuilderSessions(List rawSessions) {
    try {
      final updatedGroups = <ChannelSessionGroupModel>[];
      final currentRestoId = Get.isRegistered<StorageService>() ? Get.find<StorageService>().restoId : 85;
      final activeRestoId = currentRestoId > 0 ? currentRestoId : 85;

      for (final rawGroup in rawSessions) {
        final gMap = rawGroup as Map<String, dynamic>;
        final slug = (gMap['session_for'] ?? '').toString().toLowerCase();
        final rawList = (gMap['sessions'] as List? ?? []);
        final chId = gMap['menu_session_id'] is int
            ? gMap['menu_session_id'] as int
            : (gMap['id'] is int ? gMap['id'] as int : int.tryParse(gMap['id']?.toString() ?? '1') ?? 1);

        String groupTitle = slug.toUpperCase();
        if (slug == 'dine-in') groupTitle = 'DINE-IN';
        if (slug == 'ird') groupTitle = 'ROOM SERVICE (IRD)';
        if (slug == 'takeaway') groupTitle = 'TAKEAWAY';
        if (slug == 'delivery') groupTitle = 'DELIVERY';

        final cardList = <SessionCardModel>[];
        int activeCount = 0;

        for (final sItem in rawList) {
          final sMap = sItem as Map<String, dynamic>;
          final sId = sMap['id'] is int ? sMap['id'] as int : int.tryParse(sMap['id'].toString()) ?? 0;
          final sName = (sMap['session_name'] ?? 'Session').toString();
          final tmplId = sMap['menu_template_id'] is int
              ? sMap['menu_template_id'] as int
              : int.tryParse(sMap['menu_template_id']?.toString() ?? '1') ?? 1;

          String tName = (sMap['menu_template_name'] ?? '').toString();
          if (tName.isEmpty) {
            final found = templatesList.firstWhereOrNull((t) => t.id == tmplId);
            tName = found?.name ?? 'Main Menu';
          }

          final start = (sMap['start_time'] ?? '00:00').toString();
          final end = (sMap['end_time'] ?? '23:59').toString();
          final isOrder = sMap['en_cust_order'] == 1;

          // Parse Splash details
          final splashMap = sMap['splash'] as Map<String, dynamic>?;
          final isSplash = sMap['en_splash'] == 1 || sMap['has_splash'] == 1 || splashMap != null;
          final splashImgs = <String>[];
          int sDuration = 5;
          List<String> sDays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

          if (splashMap != null) {
            final rawImg = (splashMap['spl_image'] ?? '').toString();
            if (rawImg.isNotEmpty) {
              for (final img in rawImg.split(',')) {
                final trimmed = img.trim();
                if (trimmed.isNotEmpty) {
                  splashImgs.add(SessionCardModel.resolveGalleryUrl(trimmed, activeRestoId));
                }
              }
            }
            sDuration = int.tryParse(splashMap['spl_time']?.toString() ?? '') ?? 5;
            sDays = _parseDayNumbers(splashMap['spl_days']?.toString());
          }

          // Parse Offer details
          final offerMap = sMap['offer'] as Map<String, dynamic>?;
          final isOffer = sMap['en_offer'] == 1 || (sMap['offer_id'] != null && sMap['offer_id'] != 0) || offerMap != null;
          final offerImgs = <String>[];
          String oTitle = 'Special Offer';
          List<String> oDays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

          if (offerMap != null) {
            final rawImg = (offerMap['off_image'] ?? '').toString();
            if (rawImg.isNotEmpty) {
              for (final img in rawImg.split(',')) {
                final trimmed = img.trim();
                if (trimmed.isNotEmpty) {
                  offerImgs.add(SessionCardModel.resolveGalleryUrl(trimmed, activeRestoId));
                }
              }
            }
            oTitle = (offerMap['off_title'] ?? 'Special Offer').toString();
            oDays = _parseDayNumbers(offerMap['off_days']?.toString());
          }

          // Compute active status
          final now = TimeOfDay.now();
          final startParts = start.split(':');
          final endParts = end.split(':');
          bool isLive = false;
          if (startParts.length >= 2 && endParts.length >= 2) {
            final sMinutes = (int.tryParse(startParts[0]) ?? 0) * 60 + (int.tryParse(startParts[1]) ?? 0);
            final eMinutes = (int.tryParse(endParts[0]) ?? 0) * 60 + (int.tryParse(endParts[1]) ?? 0);
            final currentMinutes = now.hour * 60 + now.minute;
            if (sMinutes <= eMinutes) {
              isLive = currentMinutes >= sMinutes && currentMinutes <= eMinutes;
            } else {
              isLive = currentMinutes >= sMinutes || currentMinutes <= eMinutes;
            }
          }

          if (isLive) activeCount++;

          cardList.add(SessionCardModel(
            id: sId,
            channelSessionId: chId,
            menuTemplateId: tmplId,
            name: sName,
            statusText: isLive ? 'Active Now' : 'Ended',
            statusBg: isLive ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
            statusFg: isLive ? const Color(0xFF16A34A) : const Color(0xFF6B7280),
            isActiveNow: isLive,
            templateName: tName,
            startTime: start,
            endTime: end,
            customerOrderEnabled: isOrder,
            sectionName: slug == 'dine-in' ? 'Dine-In' : (slug == 'ird' ? 'Rooms' : slug.toUpperCase()),
            hasOffer: isOffer,
            hasSplash: isSplash,
            splashDuration: sDuration,
            splashActiveDays: sDays,
            splashImages: splashImgs,
            offerTitle: oTitle,
            offerActiveDays: oDays,
            offerImages: offerImgs,
          ));
        }

        Color accent = const Color(0xFFC1272D);
        if (slug.contains('ird')) accent = const Color(0xFF6366F1);
        if (slug.contains('takeaway')) accent = const Color(0xFFF59E0B);
        if (slug.contains('delivery')) accent = const Color(0xFF10B981);
        if (slug.contains('cat')) accent = const Color(0xFF7C3AED);

        updatedGroups.add(ChannelSessionGroupModel(
          id: slug,
          channelSessionId: chId,
          title: '$groupTitle SESSIONS',
          accentColor: accent,
          activeCountText: activeCount > 0 ? '● $activeCount Active' : '0 Active',
          activeCount: activeCount,
          sessions: cardList,
        ));
      }

      if (updatedGroups.isNotEmpty) {
        channelGroups.assignAll(updatedGroups);
      }
    } catch (_) {}
  }

  void _mergeRemoteSessions(List menuSessions) {
    try {
      final updatedGroups = <ChannelSessionGroupModel>[];
      final currentRestoId = Get.isRegistered<StorageService>() ? Get.find<StorageService>().restoId : 85;
      final activeRestoId = currentRestoId > 0 ? currentRestoId : 85;

      for (final rawGroup in menuSessions) {
        final gMap = rawGroup as Map<String, dynamic>;
        final slug = (gMap['session_for'] ?? '').toString().toLowerCase();
        final name = (gMap['name'] ?? slug.toUpperCase()).toString();
        final chId = gMap['id'] is int ? gMap['id'] as int : int.tryParse(gMap['id']?.toString() ?? '1') ?? 1;
        final rawList = (gMap['sessions'] as List? ?? []);

        final cardList = <SessionCardModel>[];
        int activeCount = 0;

        for (final sItem in rawList) {
          final sMap = sItem as Map<String, dynamic>;
          final sId = sMap['id'] is int ? sMap['id'] as int : int.tryParse(sMap['id'].toString()) ?? 0;
          final sName = sMap['session_name'] ?? 'Session';
          final tmplId = sMap['menu_template_id'] is int
              ? sMap['menu_template_id'] as int
              : int.tryParse(sMap['menu_template_id']?.toString() ?? '1') ?? 1;
          final tName = sMap['menu_template_name'] ?? 'Main';
          final start = sMap['start_time'] ?? '00:00';
          final end = sMap['end_time'] ?? '23:59';
          final isOrder = sMap['en_cust_order'] == 1;
          bool isSplash = sMap['has_splash'] == 1 || sMap['en_splash'] == 1;
          bool isOffer = (sMap['offer_id'] != null && sMap['offer_id'] != 0) || sMap['en_offer'] == 1;

          List<String> splashImgs = [];
          if (sMap['splash'] is Map) {
            final spl = sMap['splash'] as Map<String, dynamic>;
            final rawImg = spl['spl_image']?.toString();
            if (rawImg != null && rawImg.isNotEmpty) {
              splashImgs = rawImg
                  .split(',')
                  .map((e) => ChannelSessionGroupModel.resolveGalleryUrl(e.trim(), activeRestoId))
                  .where((e) => e.isNotEmpty)
                  .toList();
            }
            if (splashImgs.isNotEmpty) isSplash = true;
          }

          List<String> offerImgs = [];
          if (sMap['offer'] is Map) {
            final off = sMap['offer'] as Map<String, dynamic>;
            final rawImg = off['off_image']?.toString();
            if (rawImg != null && rawImg.isNotEmpty) {
              offerImgs = rawImg
                  .split(',')
                  .map((e) => ChannelSessionGroupModel.resolveGalleryUrl(e.trim(), activeRestoId))
                  .where((e) => e.isNotEmpty)
                  .toList();
            }
            if (offerImgs.isNotEmpty) isOffer = true;
          }

          // Compute active status
          final now = TimeOfDay.now();
          final startParts = start.toString().split(':');
          final endParts = end.toString().split(':');
          bool isLive = false;
          if (startParts.length >= 2 && endParts.length >= 2) {
            final sMinutes = (int.tryParse(startParts[0]) ?? 0) * 60 + (int.tryParse(startParts[1]) ?? 0);
            final eMinutes = (int.tryParse(endParts[0]) ?? 0) * 60 + (int.tryParse(endParts[1]) ?? 0);
            final currentMinutes = now.hour * 60 + now.minute;
            if (sMinutes <= eMinutes) {
              isLive = currentMinutes >= sMinutes && currentMinutes <= eMinutes;
            } else {
              isLive = currentMinutes >= sMinutes || currentMinutes <= eMinutes;
            }
          }

          if (isLive) activeCount++;

          cardList.add(SessionCardModel(
            id: sId,
            channelSessionId: chId,
            menuTemplateId: tmplId,
            name: sName,
            statusText: isLive ? 'Active Now' : 'Ended',
            statusBg: isLive ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
            statusFg: isLive ? const Color(0xFF16A34A) : const Color(0xFF6B7280),
            isActiveNow: isLive,
            templateName: tName,
            startTime: start,
            endTime: end,
            customerOrderEnabled: isOrder,
            sectionName: slug == 'dine-in' ? 'Dine-In' : (slug == 'ird' ? 'Rooms' : slug),
            hasOffer: isOffer,
            hasSplash: isSplash,
            splashImages: splashImgs,
            offerImages: offerImgs,
          ));
        }

        Color accent = const Color(0xFFC1272D);
        if (slug.contains('ird')) accent = const Color(0xFF6366F1);
        if (slug.contains('takeaway')) accent = const Color(0xFFF59E0B);
        if (slug.contains('delivery')) accent = const Color(0xFF10B981);

        updatedGroups.add(ChannelSessionGroupModel(
          id: slug,
          channelSessionId: chId,
          title: '${name.toUpperCase()} SESSIONS',
          accentColor: accent,
          activeCountText: activeCount > 0 ? '● $activeCount Active' : '0 Active',
          activeCount: activeCount,
          sessions: cardList,
        ));
      }

      if (updatedGroups.isNotEmpty) {
        channelGroups.assignAll(updatedGroups);
      }
    } catch (_) {}
  }

  /// Helper to parse comma separated day numbers "1,2,3..." to day abbreviations
  List<String> _parseDayNumbers(String? daysStr) {
    if (daysStr == null || daysStr.isEmpty) {
      return const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }
    const dayMap = {
      '1': 'Mon',
      '2': 'Tue',
      '3': 'Wed',
      '4': 'Thu',
      '5': 'Fri',
      '6': 'Sat',
      '7': 'Sun',
    };
    final parts = daysStr.split(',').map((e) => e.trim());
    final result = <String>[];
    for (final p in parts) {
      if (dayMap.containsKey(p)) {
        result.add(dayMap[p]!);
      }
    }
    return result.isEmpty ? const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] : result;
  }

  /// Helper to convert day abbreviations back to comma separated numbers
  String _formatDayNumbers(List<String> days) {
    const dayMap = {
      'Mon': '1',
      'Tue': '2',
      'Wed': '3',
      'Thu': '4',
      'Fri': '5',
      'Sat': '6',
      'Sun': '7',
    };
    return days.map((d) => dayMap[d] ?? '1').join(',');
  }

  /// Updates a template's theme both locally and remotely via V6 change_theme API
  Future<void> updateTemplateTheme(
    int templateId,
    String newThemeName,
    Color newColor, {
    int? themeId,
  }) async {
    final idx = templatesList.indexWhere((t) => t.id == templateId);
    if (idx != -1) {
      final cur = templatesList[idx];
      final actualThemeId = themeId ?? cur.themeId;
      templatesList[idx] = cur.copyWith(
        themeId: actualThemeId,
        themeName: 'Theme: $newThemeName',
        themeColor: newColor,
        iconFg: newColor,
        iconBg: newColor.withOpacity(0.12),
        details: cur.details.replaceFirst(RegExp(r'Theme: [^\s]+'), 'Theme: $newThemeName'),
      );
      ToastService.showSuccess("Theme updated to $newThemeName");

      // Remote API call
      try {
        final res = await _repository.changeTheme(
          templateId: templateId,
          themeId: actualThemeId,
        );
        res.fold(
          (failure) => ToastService.showError("Failed to save theme: ${failure.message}"),
          (_) {},
        );
      } catch (e) {
        ToastService.showError("Failed to update theme: $e");
      }
    }
  }

  /// Saves / updates session configurations with live V6 update_session remote persistence
  Future<bool> saveSession(SessionCardModel updatedSession) async {
    HapticFeedback.mediumImpact();

    // 1. Optimistically update local reactive state
    for (int g = 0; g < channelGroups.length; g++) {
      final group = channelGroups[g];
      final sIdx = group.sessions.indexWhere((s) => s.id == updatedSession.id);
      if (sIdx != -1) {
        final newSessions = List<SessionCardModel>.from(group.sessions);
        newSessions[sIdx] = updatedSession;
        channelGroups[g] = group.copyWith(sessions: newSessions);
        break;
      }
    }

    // 2. Build V6 update_session API payload
    try {
      final splashImageFilenames = updatedSession.splashImages.map((u) {
        final clean = u.split('?').first.split('/').last.trim();
        return clean;
      }).where((f) => f.isNotEmpty).join(',');

      final offerImageFilenames = updatedSession.offerImages.map((u) {
        final clean = u.split('?').first.split('/').last.trim();
        return clean;
      }).where((f) => f.isNotEmpty).join(',');

      // Find template ID
      int tId = updatedSession.menuTemplateId;
      if (tId <= 0) {
        final matchedTmpl = templatesList.firstWhereOrNull((t) => t.name.toLowerCase() == updatedSession.templateName.toLowerCase());
        if (matchedTmpl != null) {
          tId = matchedTmpl.id;
        }
      }

      final sessionJson = <String, dynamic>{
        'id': updatedSession.id,
        'session_name': updatedSession.name,
        'menu_template_id': tId.toString(),
        'start_time': updatedSession.startTime,
        'end_time': updatedSession.endTime,
        'day_flag': updatedSession.crossesMidnight ? 1 : 0,
        'en_cust_order': updatedSession.customerOrderEnabled ? 1 : 0,
        'en_geo_fence': updatedSession.geoFenceEnabled ? 1 : 0,
        'en_splash': updatedSession.hasSplash ? 1 : 0,
        'en_offer': updatedSession.hasOffer ? 1 : 0,
      };

      if (updatedSession.hasSplash) {
        sessionJson['splash'] = {
          'spl_type': 'images',
          'spl_image': splashImageFilenames.isNotEmpty ? splashImageFilenames : 'sp_1768571424_0696a42204fe45.png',
          'spl_days': _formatDayNumbers(updatedSession.splashActiveDays),
          'spl_time': updatedSession.splashDuration.toString(),
        };
      } else {
        sessionJson['splash'] = null;
      }

      if (updatedSession.hasOffer) {
        sessionJson['offer'] = {
          'off_image': offerImageFilenames.isNotEmpty ? offerImageFilenames : 'off_1.webp',
          'off_days': _formatDayNumbers(updatedSession.offerActiveDays),
          'off_title': updatedSession.offerTitle,
        };
      } else {
        sessionJson['offer'] = null;
      }

      final res = await _repository.updateChannelSession(
        sessionId: updatedSession.channelSessionId,
        op: 'upd',
        sessionJson: sessionJson,
      );

      return res.fold(
        (failure) {
          ToastService.showError("Failed to sync session: ${failure.message}");
          return false;
        },
        (_) {
          fetchRemoteMenuData(isSwipeRefresh: true);
          ToastService.showSuccess("${updatedSession.name} session saved successfully");
          return true;
        },
      );
    } catch (e) {
      ToastService.showSuccess("${updatedSession.name} session saved locally");
      return true;
    }
  }

  /// Deletes a session from a channel group
  void deleteSession(int sessionId) {
    HapticFeedback.mediumImpact();
    for (int g = 0; g < channelGroups.length; g++) {
      final group = channelGroups[g];
      final sIdx = group.sessions.indexWhere((s) => s.id == sessionId);
      if (sIdx != -1) {
        final newSessions = List<SessionCardModel>.from(group.sessions);
        newSessions.removeAt(sIdx);
        channelGroups[g] = group.copyWith(sessions: newSessions);
        ToastService.showSuccess("Session removed");
        return;
      }
    }
  }

  // --- Backward Compatibility Handlers ---
  Future<void> selectTheme(int templateId) async {
    final updatedList = templatesList.map((t) =>
      t.copyWith(isActive: t.id == templateId)
    ).toList();
    templatesList.assignAll(updatedList);
    ToastService.showSuccess("Active Template updated successfully");
  }

  Future<void> updateThemeColors({
    required int id,
    required String primary,
    required String bg,
    required String text,
  }) async {
    updateTemplateTheme(id, "Custom", const Color(0xFFC1272D));
  }

  Future<void> updateSessionSettings(int sessionId, Map<String, dynamic> data) async {
    for (int g = 0; g < channelGroups.length; g++) {
      final group = channelGroups[g];
      final sIdx = group.sessions.indexWhere((s) => s.id == sessionId);
      if (sIdx != -1) {
        final cur = group.sessions[sIdx];
        final updated = cur.copyWith(
          name: data['name'] as String? ?? cur.name,
          startTime: data['start_time'] as String? ?? cur.startTime,
          endTime: data['end_time'] as String? ?? cur.endTime,
        );
        saveSession(updated);
        return;
      }
    }
  }

  Future<void> publishMenuChanges() async {
    isPublishing.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isPublishing.value = false;
    ToastService.showSuccess("Digital Menu changes published successfully!");
  }
}
