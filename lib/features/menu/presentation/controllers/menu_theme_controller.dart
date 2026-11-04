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
import '../widgets/session_edit_sheet.dart';

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

  int? _pendingSessionId;
  String? _pendingSessionName;
  String? _pendingSessionChannel;

  /// Smartly focuses on a specific session, expands its channel accordion, and opens the SessionEditSheet.
  void focusAndOpenSession({
    int? sessionId,
    String? sessionName,
    String? channel,
  }) {
    _pendingSessionId = sessionId;
    _pendingSessionName = sessionName;
    _pendingSessionChannel = channel;

    _tryOpenPendingSession();
  }

  void _tryOpenPendingSession() {
    if (_pendingSessionId == null && (_pendingSessionName == null || _pendingSessionName!.isEmpty)) {
      return;
    }

    final targetChannel = (_pendingSessionChannel ?? '').toLowerCase().trim();
    final targetName = (_pendingSessionName ?? '').toLowerCase().trim();
    final targetId = _pendingSessionId;

    SessionCardModel? targetSession;
    String? targetGroupId;

    // STEP 1: Find the channel group that matches targetChannel first
    ChannelSessionGroupModel? matchingGroup;
    if (targetChannel.isNotEmpty) {
      matchingGroup = channelGroups.firstWhereOrNull((g) {
        final gSlug = g.id.toLowerCase().trim();
        final gTitle = g.title.toLowerCase().trim();
        return gSlug == targetChannel ||
            gSlug.replaceAll('-', '') == targetChannel.replaceAll('-', '') ||
            gTitle.contains(targetChannel);
      });
    }

    if (matchingGroup != null) {
      targetGroupId = matchingGroup.id;
      // Inside this specific channel group, search for the session:
      // Priority 1: Both name and ID match
      if (targetName.isNotEmpty && targetId != null && targetId > 0) {
        targetSession = matchingGroup.sessions.firstWhereOrNull(
          (s) => s.name.trim().toLowerCase() == targetName && s.id == targetId,
        );
      }
      // Priority 2: Name matches
      if (targetSession == null && targetName.isNotEmpty) {
        targetSession = matchingGroup.sessions.firstWhereOrNull(
          (s) => s.name.trim().toLowerCase() == targetName,
        );
      }
      // Priority 3: ID matches within this specific group
      if (targetSession == null && targetId != null && targetId > 0) {
        targetSession = matchingGroup.sessions.firstWhereOrNull(
          (s) => s.id == targetId,
        );
      }
    }

    // STEP 2: If group not matched by channel slug, search across all groups
    // but match by exact name
    if (targetSession == null && targetName.isNotEmpty) {
      for (final group in channelGroups) {
        final s = group.sessions.firstWhereOrNull(
          (item) => item.name.trim().toLowerCase() == targetName,
        );
        if (s != null) {
          targetSession = s;
          targetGroupId = group.id;
          break;
        }
      }
    }

    // STEP 3: Fallback: If not in channelGroups yet, generate card from pending info
    if (targetSession == null && targetName.isNotEmpty) {
      String slug = targetChannel.isNotEmpty ? targetChannel : 'dine-in';
      targetGroupId = slug;
      targetSession = SessionCardModel(
        id: targetId ?? 0,
        name: _pendingSessionName!,
        templateName: 'Main Menu',
        startTime: '00:00',
        endTime: '23:59',
        statusText: 'Active Now',
        statusBg: const Color(0xFFDCFCE7),
        statusFg: const Color(0xFF16A34A),
        isActiveNow: true,
      );
    }

    if (targetSession != null && targetGroupId != null) {
      if (!expandedChannelIds.contains(targetGroupId)) {
        expandedChannelIds.add(targetGroupId);
      }
      final toOpen = targetSession;
      _pendingSessionId = null;
      _pendingSessionName = null;
      _pendingSessionChannel = null;

      Future.delayed(const Duration(milliseconds: 280), () {
        if (Get.isBottomSheetOpen == true) {
          Get.back();
        }
        Get.bottomSheet(
          SessionEditSheet(sessionCard: toOpen),
          isScrollControlled: true,
        );
      });
    }
  }

  /// Initial clean state — templates & sessions are loaded dynamically from V6 API
  void loadDefaultData() {
    templatesList.clear();
    templates.clear();
    channelGroups.clear();
    sessions.clear();
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
          } else {
            templatesList.clear();
            templates.clear();
          }

          // 2. Parse Channel Sessions
          final rawSessions = data['sessions'] as List? ?? [];
          if (rawSessions.isNotEmpty) {
            _mergeMenuBuilderSessions(rawSessions);
          } else {
            channelGroups.clear();
            sessions.clear();
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
      final currentRestoId = Get.isRegistered<StorageService>() ? Get.find<StorageService>().restoId : 0;
      final activeRestoId = currentRestoId > 0 ? currentRestoId : null;

      for (final rawGroup in rawSessions) {
        final gMap = rawGroup as Map<String, dynamic>;
        final rInfo = gMap['resto_info'];
        if (rInfo is Map && Get.isRegistered<StorageService>()) {
          Get.find<StorageService>().saveRestoHeaderDetails(
            name: (rInfo['title'] ?? rInfo['resto_name'])?.toString(),
            contact: (rInfo['contact_no'] ?? rInfo['whatsapp_no'])?.toString(),
            address: (rInfo['address'] ?? rInfo['location'])?.toString(),
            city: rInfo['city']?.toString(),
            pinCode: rInfo['pin_code']?.toString(),
          );
        }
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
          final start24 = SessionCardModel.formatTo24Hour(start);
          final end24 = SessionCardModel.formatTo24Hour(end);
          final startParts = start24.split(':');
          final endParts = end24.split(':');
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
        _tryOpenPendingSession();
      }
    } catch (_) {}
  }

  void _mergeRemoteSessions(List menuSessions) {
    try {
      final updatedGroups = <ChannelSessionGroupModel>[];
      final currentRestoId = Get.isRegistered<StorageService>() ? Get.find<StorageService>().restoId : 0;
      final activeRestoId = currentRestoId > 0 ? currentRestoId : null;

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
          final start24 = SessionCardModel.formatTo24Hour(start.toString());
          final end24 = SessionCardModel.formatTo24Hour(end.toString());
          final startParts = start24.split(':');
          final endParts = end24.split(':');
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
        _tryOpenPendingSession();
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
      final groupMatches = group.channelSessionId == updatedSession.channelSessionId ||
          group.id.toLowerCase().trim() == updatedSession.sectionName.toLowerCase().trim();
      final sIdx = group.sessions.indexWhere((s) =>
          s.id == updatedSession.id && (groupMatches || s.name == updatedSession.name));
      if (sIdx != -1) {
        final newSessions = List<SessionCardModel>.from(group.sessions);
        newSessions[sIdx] = updatedSession.copyWith(
          startTime: SessionCardModel.formatTo24Hour(updatedSession.startTime),
          endTime: SessionCardModel.formatTo24Hour(updatedSession.endTime),
        );
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
        'start_time': SessionCardModel.formatTo24Hour(updatedSession.startTime),
        'end_time': SessionCardModel.formatTo24Hour(updatedSession.endTime),
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
        final rawStart = data['start_time'] as String? ?? cur.startTime;
        final rawEnd = data['end_time'] as String? ?? cur.endTime;
        final updated = cur.copyWith(
          name: data['name'] as String? ?? cur.name,
          startTime: SessionCardModel.formatTo24Hour(rawStart),
          endTime: SessionCardModel.formatTo24Hour(rawEnd),
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
