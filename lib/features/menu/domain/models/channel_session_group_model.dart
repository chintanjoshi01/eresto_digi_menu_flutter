import 'package:flutter/material.dart';

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

  String get timingFormatted => '$startTime – $endTime';

  /// Resolves raw image filename or relative path to full gallery URL
  static String resolveGalleryUrl(String rawNameOrUrl, [int? restoId]) {
    final clean = rawNameOrUrl.trim();
    if (clean.isEmpty) return '';
    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return clean;
    }
    final rid = restoId ?? 85;
    return 'https://assets.eresto.app/public/treasure/$rid/archive/gallery/$clean';
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
