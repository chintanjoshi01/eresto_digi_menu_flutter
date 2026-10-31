import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/storage/storage_service.dart';

/// Single Session Model within a Channel Group matching Screenshot 2 & 4.
class SessionCardModel {
  final int id;
  final int channelSessionId;
  final int menuTemplateId;
  final String name;
  final String statusText;
  final Color statusBg;
  final Color statusFg;
  final bool isActiveNow;
  final String templateName;
  final String startTime;
  final String endTime;
  final bool customerOrderEnabled;
  final bool geoFenceEnabled;
  final String sectionName;
  final bool hasOffer;
  final bool hasSplash;
  final bool crossesMidnight;
  // Extended configuration fields from Web UI
  final String geoRadius;
  final String orderDestination; // 'pos' or 'whatsapp'
  final String whatsappNumber;
  final bool mandatoryCustomerName;
  final bool mandatoryMobileNumber;
  final bool mandatoryTableNumber;
  final bool notifyOnEachOrder;
  final String submitOrderResponseText;
  final int splashDuration;
  final List<String> splashActiveDays;
  final List<String> splashImages;
  final String offerTitle;
  final List<String> offerActiveDays;
  final List<String> offerImages;

  const SessionCardModel({
    required this.id,
    this.channelSessionId = 1,
    this.menuTemplateId = 1,
    required this.name,
    required this.statusText,
    required this.statusBg,
    required this.statusFg,
    this.isActiveNow = false,
    required this.templateName,
    required this.startTime,
    required this.endTime,
    this.customerOrderEnabled = false,
    this.geoFenceEnabled = false,
    this.sectionName = '---',
    this.hasOffer = false,
    this.hasSplash = false,
    this.crossesMidnight = false,
    this.geoRadius = '0.00',
    this.orderDestination = 'pos',
    this.whatsappNumber = '',
    this.mandatoryCustomerName = false,
    this.mandatoryMobileNumber = false,
    this.mandatoryTableNumber = false,
    this.notifyOnEachOrder = true,
    this.submitOrderResponseText =
        'Thanks for your valuable order, please convey the order number to available attendent in Restaurant',
    this.splashDuration = 5,
    this.splashActiveDays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    this.splashImages = const [],
    this.offerTitle = 'Special Offer',
    this.offerActiveDays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    this.offerImages = const [],
  });

  String get timingFormatted => '${formatTo12Hour(startTime)} – ${formatTo12Hour(endTime)}';

  /// Converts any 12-hour or 24-hour time string (e.g. "07:30 am", "10:30 pm", "22:30", "7:30")
  /// into 24-hour format matching backend requirement: "7:30", "22:30".
  static String formatTo24Hour(String rawTime) {
    final clean = rawTime.trim().toLowerCase();
    if (clean.isEmpty) return '00:00';

    final isPm = clean.contains('pm');
    final isAm = clean.contains('am');
    final stripped = clean.replaceAll('am', '').replaceAll('pm', '').trim();
    final parts = stripped.split(':');
    if (parts.isEmpty) return rawTime;

    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

    if (isPm && hour < 12) hour += 12;
    if (isAm && hour == 12) hour = 0;

    final hourStr = hour.toString().padLeft(2, '0');
    final minStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minStr';
  }

  /// Converts a 24-hour time string (e.g. "7:30", "07:30", "22:30")
  /// into user-friendly 12-hour format with AM/PM (e.g. "07:30 am", "10:30 pm").
  static String formatTo12Hour(String rawTime) {
    final clean = rawTime.trim().toLowerCase();
    if (clean.isEmpty) return '10:30 am';

    if (clean.contains('am') || clean.contains('pm')) {
      final parts = clean.replaceAll('am', '').replaceAll('pm', '').trim().split(':');
      if (parts.length >= 2) {
        final h = (int.tryParse(parts[0]) ?? 0).toString().padLeft(2, '0');
        final m = (int.tryParse(parts[1]) ?? 0).toString().padLeft(2, '0');
        final period = clean.contains('pm') ? 'pm' : 'am';
        return '$h:$m $period';
      }
      return rawTime;
    }

    final parts = clean.split(':');
    if (parts.length < 2) return rawTime;

    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts[1]) ?? 0;

    final period = hour >= 12 ? 'pm' : 'am';
    int hour12 = hour % 12;
    if (hour12 == 0) hour12 = 12;

    final hStr = hour12.toString().padLeft(2, '0');
    final mStr = minute.toString().padLeft(2, '0');
    return '$hStr:$mStr $period';
  }

  /// Resolves raw image filename or relative path to full gallery URL
  static String resolveGalleryUrl(String rawNameOrUrl, [int? restoId]) {
    final clean = rawNameOrUrl.trim();
    if (clean.isEmpty) return '';

    final dynamicAssetsBase = Endpoints.activeAssetsBaseUrl;
    final targetHost = Uri.tryParse(dynamicAssetsBase)?.host ?? 'assets.eresto.in';

    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      final uri = Uri.tryParse(clean);
      if (uri != null &&
          (uri.host.contains('assets.eresto.in') || uri.host.contains('assets.eresto.app')) &&
          uri.path.contains('/public/treasure/')) {
        if (uri.host.startsWith('assets.') && uri.host != targetHost) {
          return clean.replaceFirst(uri.host, targetHost);
        }
      }
      return clean;
    }

    final storage = Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;
    final effectiveRestoId = (restoId != null && restoId > 0) ? restoId : (storage?.restoId ?? 85);
    final rid = effectiveRestoId > 0 ? effectiveRestoId : 85;

    return '$dynamicAssetsBase/public/treasure/$rid/archive/gallery/$clean';
  }

  SessionCardModel copyWith({
    int? id,
    int? channelSessionId,
    int? menuTemplateId,
    String? name,
    String? statusText,
    Color? statusBg,
    Color? statusFg,
    bool? isActiveNow,
    String? templateName,
    String? startTime,
    String? endTime,
    bool? customerOrderEnabled,
    bool? geoFenceEnabled,
    String? sectionName,
    bool? hasOffer,
    bool? hasSplash,
    bool? crossesMidnight,
    String? geoRadius,
    String? orderDestination,
    String? whatsappNumber,
    bool? mandatoryCustomerName,
    bool? mandatoryMobileNumber,
    bool? mandatoryTableNumber,
    bool? notifyOnEachOrder,
    String? submitOrderResponseText,
    int? splashDuration,
    List<String>? splashActiveDays,
    List<String>? splashImages,
    String? offerTitle,
    List<String>? offerActiveDays,
    List<String>? offerImages,
  }) {
    return SessionCardModel(
      id: id ?? this.id,
      channelSessionId: channelSessionId ?? this.channelSessionId,
      menuTemplateId: menuTemplateId ?? this.menuTemplateId,
      name: name ?? this.name,
      statusText: statusText ?? this.statusText,
      statusBg: statusBg ?? this.statusBg,
      statusFg: statusFg ?? this.statusFg,
      isActiveNow: isActiveNow ?? this.isActiveNow,
      templateName: templateName ?? this.templateName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      customerOrderEnabled: customerOrderEnabled ?? this.customerOrderEnabled,
      geoFenceEnabled: geoFenceEnabled ?? this.geoFenceEnabled,
      sectionName: sectionName ?? this.sectionName,
      hasOffer: hasOffer ?? this.hasOffer,
      hasSplash: hasSplash ?? this.hasSplash,
      crossesMidnight: crossesMidnight ?? this.crossesMidnight,
      geoRadius: geoRadius ?? this.geoRadius,
      orderDestination: orderDestination ?? this.orderDestination,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      mandatoryCustomerName: mandatoryCustomerName ?? this.mandatoryCustomerName,
      mandatoryMobileNumber: mandatoryMobileNumber ?? this.mandatoryMobileNumber,
      mandatoryTableNumber: mandatoryTableNumber ?? this.mandatoryTableNumber,
      notifyOnEachOrder: notifyOnEachOrder ?? this.notifyOnEachOrder,
      submitOrderResponseText: submitOrderResponseText ?? this.submitOrderResponseText,
      splashDuration: splashDuration ?? this.splashDuration,
      splashActiveDays: splashActiveDays ?? this.splashActiveDays,
      splashImages: splashImages ?? this.splashImages,
      offerTitle: offerTitle ?? this.offerTitle,
      offerActiveDays: offerActiveDays ?? this.offerActiveDays,
      offerImages: offerImages ?? this.offerImages,
    );
  }
}

/// Channel Session Group Model (Dine-In, IRD, Takeaway, Delivery) matching Screenshot 1 & 2.
class ChannelSessionGroupModel {
  final String id;
  final int channelSessionId;
  final String title;
  final Color accentColor;
  final String activeCountText;
  final int activeCount;
  final List<SessionCardModel> sessions;

  const ChannelSessionGroupModel({
    required this.id,
    this.channelSessionId = 1,
    required this.title,
    required this.accentColor,
    required this.activeCountText,
    required this.activeCount,
    required this.sessions,
  });

  int get sessionsCount => sessions.length;

  static String resolveGalleryUrl(String rawNameOrUrl, [int? restoId]) =>
      SessionCardModel.resolveGalleryUrl(rawNameOrUrl, restoId);

  ChannelSessionGroupModel copyWith({
    String? id,
    int? channelSessionId,
    String? title,
    Color? accentColor,
    String? activeCountText,
    int? activeCount,
    List<SessionCardModel>? sessions,
  }) {
    return ChannelSessionGroupModel(
      id: id ?? this.id,
      channelSessionId: channelSessionId ?? this.channelSessionId,
      title: title ?? this.title,
      accentColor: accentColor ?? this.accentColor,
      activeCountText: activeCountText ?? this.activeCountText,
      activeCount: activeCount ?? this.activeCount,
      sessions: sessions ?? this.sessions,
    );
  }
}
