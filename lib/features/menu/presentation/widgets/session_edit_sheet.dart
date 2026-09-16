import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/channel_session_group_model.dart';
import '../../domain/models/session_model.dart';
import '../controllers/menu_theme_controller.dart';
import 'gallery_selection_sheet.dart';

/// Pixel-perfect Enterprise Session Edit Bottom Sheet matching Screenshots 1, 2, 3, 4.
class SessionEditSheet extends StatefulWidget {
  final SessionCardModel? sessionCard;
  final SessionModel? session;

  const SessionEditSheet({
    super.key,
    this.sessionCard,
    this.session,
  });

  @override
  State<SessionEditSheet> createState() => _SessionEditSheetState();
}

class _SessionEditSheetState extends State<SessionEditSheet> {
  final _controller = Get.find<MenuThemeController>();

  bool _isSaving = false;
  late String _activeTab; // 'details', 'orders', 'splash', 'offer'
  late final TextEditingController _nameController;
  late String _selectedTemplate;
  int _selectedTemplateId = 0;
  late String _startTime;
  late String _endTime;
  late bool _crossesMidnight;
  late bool _allowOrders;
  late bool _hasSplash;
  late bool _hasOffer;

  // Channel order configuration (Screenshot 1)
  String _selectedOrderChannel = 'dine_in';
  late bool _geoFenceEnabled;
  late String _orderDestination; // 'pos' or 'whatsapp'
  late final TextEditingController _whatsappController;
  late bool _mandatoryCustomerName;
  late bool _mandatoryMobileNumber;
  late bool _mandatoryTableNumber;
  late final TextEditingController _responseMsgController;

  // Splash screen configuration (Screenshot 2)
  int _splashDuration = 5;
  late List<String> _splashActiveDays;
  late List<String> _splashImages;

  // Special offer configuration (Screenshot 3)
  late final TextEditingController _offerTitleController;
  late List<String> _offerActiveDays;
  late List<String> _offerImages;

  final List<String> _allDays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _activeTab = 'details';

    final sCard = widget.sessionCard;
    final sLegacy = widget.session;

    _nameController = TextEditingController(text: sCard?.name ?? sLegacy?.name ?? 'Lunch');

    // Bind dynamically to real templates from MenuThemeController
    final templates = _controller.templatesList;
    final cardTmplId = sCard?.menuTemplateId ?? 0;
    final cardTmplName = sCard?.templateName ?? '';

    final matchById = templates.firstWhereOrNull((t) => t.id == cardTmplId);
    if (matchById != null) {
      _selectedTemplateId = matchById.id;
      _selectedTemplate = matchById.name;
    } else {
      final matchByName = templates.firstWhereOrNull(
        (t) => t.name.toLowerCase() == cardTmplName.toLowerCase(),
      );
      if (matchByName != null) {
        _selectedTemplateId = matchByName.id;
        _selectedTemplate = matchByName.name;
      } else if (templates.isNotEmpty) {
        _selectedTemplateId = templates.first.id;
        _selectedTemplate = templates.first.name;
      } else {
        _selectedTemplateId = cardTmplId > 0 ? cardTmplId : 1;
        _selectedTemplate = cardTmplName.isNotEmpty ? cardTmplName : 'Main';
      }
    }

    _startTime = sCard?.startTime ?? sLegacy?.startTime ?? '10:30 am';
    _endTime = sCard?.endTime ?? sLegacy?.endTime ?? '06:30 pm';
    _crossesMidnight = sCard?.crossesMidnight ?? false;
    _allowOrders = sCard?.customerOrderEnabled ?? true;
    _hasSplash = sCard?.hasSplash ?? (sLegacy?.isActive ?? true);
    _hasOffer = sCard?.hasOffer ?? false;

    // Order configuration
    _geoFenceEnabled = sCard?.geoFenceEnabled ?? false;
    _orderDestination = sCard?.orderDestination ?? 'pos';
    _whatsappController = TextEditingController(
      text: (sCard?.whatsappNumber != null && sCard!.whatsappNumber.isNotEmpty)
          ? sCard.whatsappNumber
          : '919898014195',
    );
    _mandatoryCustomerName = sCard?.mandatoryCustomerName ?? true;
    _mandatoryMobileNumber = sCard?.mandatoryMobileNumber ?? true;
    _mandatoryTableNumber = sCard?.mandatoryTableNumber ?? true;
    _responseMsgController = TextEditingController(
      text: sCard?.submitOrderResponseText ??
          'Thanks for your valuable order, please convey the order number to available attendent in Restaurant',
    );

    // Splash configuration
    _splashDuration = sCard?.splashDuration ?? 5;
    _splashActiveDays = List<String>.from(sCard?.splashActiveDays ?? _allDays);
    if (sCard != null && sCard.splashImages.isNotEmpty) {
      _splashImages = sCard.splashImages.map((img) => SessionCardModel.resolveGalleryUrl(img)).toList();
    } else if (_hasSplash) {
      _splashImages = [
        'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1768571424_0696a42204fe45.png'
      ];
    } else {
      _splashImages = [];
    }

    // Offer configuration
    _offerTitleController = TextEditingController(
      text: (sCard?.offerTitle != null && sCard!.offerTitle.isNotEmpty)
          ? sCard.offerTitle
          : 'Weekend Special Offer',
    );
    _offerActiveDays = List<String>.from(sCard?.offerActiveDays ?? _allDays);
    if (sCard != null && sCard.offerImages.isNotEmpty) {
      _offerImages = sCard.offerImages.map((img) => SessionCardModel.resolveGalleryUrl(img)).toList();
    } else if (_hasOffer) {
      _offerImages = [
        'https://assets.eresto.app/public/treasure/85/archive/gallery/off_1.webp'
      ];
    } else {
      _offerImages = [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    _responseMsgController.dispose();
    _offerTitleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    HapticFeedback.selectionClick();
    final timeStr = isStart ? _startTime : _endTime;
    TimeOfDay initial = TimeOfDay.now();

    try {
      final clean = timeStr.replaceAll('am', '').replaceAll('pm', '').trim();
      final parts = clean.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        if (timeStr.toLowerCase().contains('pm') && hour < 12) hour += 12;
        if (timeStr.toLowerCase().contains('am') && hour == 12) hour = 0;
        initial = TimeOfDay(hour: hour, minute: int.parse(parts[1]));
      }
    } catch (_) {}

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xFF111827),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final min = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'am' : 'pm';
      final formatted = "${hour.toString().padLeft(2, '0')}:$min $period";
      setState(() {
        if (isStart) {
          _startTime = formatted;
        } else {
          _endTime = formatted;
        }
      });
    }
  }

  Future<void> _openGallery({required String mode, required int maxCount}) async {
    HapticFeedback.lightImpact();
    final initialUrls = mode == 'splash' ? _splashImages : _offerImages;

    final result = await Get.bottomSheet<List<String>>(
      GallerySelectionSheet(
        initialSelectedUrls: initialUrls,
        maxSelection: maxCount,
        mode: mode,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (result != null) {
      setState(() {
        if (mode == 'splash') {
          _splashImages = result;
        } else {
          _offerImages = result;
        }
      });
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;
    HapticFeedback.mediumImpact();
    setState(() => _isSaving = true);
    final sCard = widget.sessionCard;
    if (sCard != null) {
      final updated = sCard.copyWith(
        name: _nameController.text.trim(),
        templateName: _selectedTemplate,
        menuTemplateId: _selectedTemplateId,
        startTime: _startTime,
        endTime: _endTime,
        crossesMidnight: _crossesMidnight,
        customerOrderEnabled: _allowOrders,
        hasSplash: _hasSplash,
        hasOffer: _hasOffer,
        geoFenceEnabled: _geoFenceEnabled,
        orderDestination: _orderDestination,
        whatsappNumber: _whatsappController.text.trim(),
        mandatoryCustomerName: _mandatoryCustomerName,
        mandatoryMobileNumber: _mandatoryMobileNumber,
        mandatoryTableNumber: _mandatoryTableNumber,
        submitOrderResponseText: _responseMsgController.text.trim(),
        splashDuration: _splashDuration,
        splashActiveDays: _splashActiveDays,
        splashImages: _splashImages,
        offerTitle: _offerTitleController.text.trim(),
        offerActiveDays: _offerActiveDays,
        offerImages: _offerImages,
      );
      await _controller.saveSession(updated);
    } else if (widget.session != null) {
      await _controller.updateSessionSettings(widget.session!.id, {
        'name': _nameController.text.trim(),
        'start_time': _startTime,
        'end_time': _endTime,
      });
    }
    if (mounted) {
      setState(() => _isSaving = false);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _nameController.text.isNotEmpty ? _nameController.text : 'Session';

    return Container(
      constraints: BoxConstraints(maxHeight: 0.90.sh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Draggable Top Grab Bar
          Container(
            margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
            width: 44.w,
            height: 4.5.h,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          // 2. Header Title Strip
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SESSIONS",
                      style: GoogleFonts.nunito(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.back(),
                  child: Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 14.sp, color: const Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
          ),

          // 3. Dynamic Tab Navigation Pills (Details, Orders, Splash, Offer)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildTabPill("Details", 'details', icon: Icons.description_outlined),
                  if (_allowOrders) ...[
                    SizedBox(width: 8.w),
                    _buildTabPill("Orders", 'orders', icon: Icons.shopping_bag_outlined),
                  ],
                  if (_hasSplash) ...[
                    SizedBox(width: 8.w),
                    _buildTabPill("Splash", 'splash', icon: Icons.image_outlined),
                  ],
                  if (_hasOffer) ...[
                    SizedBox(width: 8.w),
                    _buildTabPill("Offer", 'offer', icon: Icons.local_offer_outlined),
                  ],
                ],
              ),
            ),
          ),

          const Divider(height: 12, color: Color(0xFFF3F4F6)),

          // 4. Scrollable Active Tab Content
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              child: _buildCurrentTabContent(),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // 5. Sticky Bottom Feature Checkboxes & Action Buttons
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Feature Checkboxes Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFeatureCheckbox("Allow Orders", _allowOrders, (v) {
                      setState(() {
                        _allowOrders = v;
                        if (!v && _activeTab == 'orders') {
                          _activeTab = 'details';
                        }
                      });
                    }),
                    _buildFeatureCheckbox("Splash Screen", _hasSplash, (v) {
                      setState(() {
                        _hasSplash = v;
                        if (v && _splashImages.isEmpty) {
                          _splashImages = [
                            'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1768571424_0696a42204fe45.png'
                          ];
                        }
                        if (!v && _activeTab == 'splash') {
                          _activeTab = 'details';
                        }
                      });
                    }),
                    _buildFeatureCheckbox("Special Offer", _hasOffer, (v) {
                      setState(() {
                        _hasOffer = v;
                        if (v && _offerImages.isEmpty) {
                          _offerImages = [
                            'https://assets.eresto.app/public/treasure/85/archive/gallery/off_1.webp'
                          ];
                        }
                        if (!v && _activeTab == 'offer') {
                          _activeTab = 'details';
                        }
                      });
                    }),
                  ],
                ),
                SizedBox(height: 10.h),

                // Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.r)),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.nunito(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                          elevation: 2,
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.r)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isSaving) ...[
                              SizedBox(
                                width: 14.w,
                                height: 14.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ] else ...[
                              Icon(Icons.save_outlined, size: 16.sp, color: Colors.white),
                              SizedBox(width: 6.w),
                            ],
                            Text(
                              _isSaving ? "Saving..." : "Save Session",
                              style: GoogleFonts.nunito(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB ROUTER
  // ==========================================
  Widget _buildCurrentTabContent() {
    Widget content;
    switch (_activeTab) {
      case 'orders':
        content = _buildOrdersTab();
        break;
      case 'splash':
        content = _buildSplashTab();
        break;
      case 'offer':
        content = _buildOfferTab();
        break;
      case 'details':
      default:
        content = _buildDetailsTab();
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey<String>(_activeTab),
        child: content,
      ),
    );
  }

  // ==========================================
  // 1. DETAILS TAB (BASIC SESSION INFO)
  // ==========================================
  Widget _buildDetailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header
              Row(
                children: [
                  Icon(Icons.description_outlined, size: 14.sp, color: AppColors.primary),
                  SizedBox(width: 6.w),
                  Text(
                    "BASIC SESSION INFO",
                    style: GoogleFonts.nunito(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Field 1: SESSION NAME
              Text(
                "SESSION NAME *",
                style: GoogleFonts.nunito(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: TextField(
                  controller: _nameController,
                  style: GoogleFonts.nunito(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 9),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(height: 12.h),

              // Field 2: SELECT TEMPLATE
              Text(
                "SELECT TEMPLATE *",
                style: GoogleFonts.nunito(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 4.h),
              Obx(() {
                final templates = _controller.templatesList;
                if (templates.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: Text(
                      _selectedTemplate.isNotEmpty ? _selectedTemplate : "Loading templates...",
                      style: GoogleFonts.nunito(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  );
                }

                // Check if current selection matches by ID or by Name
                final hasMatchId = templates.any((t) => t.id == _selectedTemplateId);
                final currentId = hasMatchId
                    ? _selectedTemplateId
                    : (templates.firstWhereOrNull((t) => t.name.toLowerCase() == _selectedTemplate.toLowerCase())?.id ??
                        templates.first.id);

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: currentId,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6B7280)),
                      items: templates.map((tmpl) {
                        return DropdownMenuItem<int>(
                          value: tmpl.id,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tmpl.name,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111827),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (tmpl.themeName.isNotEmpty) ...[
                                SizedBox(width: 6.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    tmpl.themeName.replaceFirst('Theme: ', '').trim(),
                                    style: GoogleFonts.nunito(
                                      fontSize: 10.sp,
                                      color: const Color(0xFF6B7280),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          final picked = templates.firstWhereOrNull((t) => t.id == val);
                          if (picked != null) {
                            setState(() {
                              _selectedTemplateId = picked.id;
                              _selectedTemplate = picked.name;
                            });
                          }
                        }
                      },
                    ),
                  ),
                );
              }),
              SizedBox(height: 12.h),

              // Field 3: START TIME & END TIME
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "START TIME *",
                          style: GoogleFonts.nunito(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF6B7280),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _pickTime(true),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: const Color(0xFFD1D5DB)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _startTime,
                                  style: GoogleFonts.nunito(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                Icon(Icons.access_time_rounded, size: 16.sp, color: const Color(0xFF9CA3AF)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "END TIME *",
                          style: GoogleFonts.nunito(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF6B7280),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _pickTime(false),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: const Color(0xFFD1D5DB)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _endTime,
                                  style: GoogleFonts.nunito(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                Icon(Icons.access_time_rounded, size: 16.sp, color: const Color(0xFF9CA3AF)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Checkbox: Session crosses midnight
              Row(
                children: [
                  SizedBox(
                    width: 22.w,
                    height: 22.h,
                    child: Checkbox(
                      value: _crossesMidnight,
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                      onChanged: (val) => setState(() => _crossesMidnight = val ?? false),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      "Session crosses midnight (e.g. 11:00 PM – 07:00 AM)",
                      style: GoogleFonts.nunito(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Help Banner
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFFED7AA), width: 1.w),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.help_outline_rounded, size: 16.sp, color: const Color(0xFFEA580C)),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Need Help?",
                            style: GoogleFonts.nunito(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF9A3412),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "Set up your session details and configure features for a seamless customer ordering experience.",
                            style: GoogleFonts.nunito(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFC2410C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. ORDERS TAB (CUSTOMER ORDERS CONFIG)
  // Exact layout from Screenshot 1
  // ==========================================
  Widget _buildOrdersTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. TARGET ORDER SECTION (2x2 Grid of Channels)
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TARGET ORDER SECTION",
                style: GoogleFonts.nunito(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(child: _buildChannelGridCard("Dine-In", 'dine_in', Icons.restaurant_rounded)),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildChannelGridCard("TakeAway", 'takeaway', Icons.shopping_bag_outlined)),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(child: _buildChannelGridCard("Rooms", 'rooms', Icons.meeting_room_outlined)),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildChannelGridCard("Deliveries", 'delivery', Icons.delivery_dining_rounded)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),

        // 2. Enable Geo Fencing for Channel Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enable Geo Fencing for ${_getChannelDisplayName(_selectedOrderChannel)}",
                style: GoogleFonts.nunito(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: Checkbox(
                  value: _geoFenceEnabled,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.r)),
                  onChanged: (v) => setState(() => _geoFenceEnabled = v ?? false),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),

        // 3. SUBMIT DINE-IN ORDERS ON Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SUBMIT ${_getChannelDisplayName(_selectedOrderChannel).toUpperCase()} ORDERS ON *",
                style: GoogleFonts.nunito(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 8.h),
              _buildRadioOption("Eresto OMS / POS", 'pos'),
              SizedBox(height: 6.h),
              _buildRadioOption("WhatsApp", 'whatsapp'),
              if (_orderDestination == 'whatsapp') ...[
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                  ),
                  child: TextField(
                    controller: _whatsappController,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.nunito(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "91XXXXXXXXXX",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 10.h),

        // 4. MANDATORY CUSTOMER FIELDS Card (2 Columns from Screenshot 1)
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MANDATORY CUSTOMER FIELDS",
                style: GoogleFonts.nunito(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSettingsCheckbox(
                          "Customer Name",
                          _mandatoryCustomerName,
                          (v) => setState(() => _mandatoryCustomerName = v),
                        ),
                        SizedBox(height: 4.h),
                        _buildSettingsCheckbox(
                          "Table Number",
                          _mandatoryTableNumber,
                          (v) => setState(() => _mandatoryTableNumber = v),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSettingsCheckbox(
                          "Mobile Number",
                          _mandatoryMobileNumber,
                          (v) => setState(() => _mandatoryMobileNumber = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),

        // 5. SUBMIT ORDER RESPONSE TEXT Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SUBMIT ORDER RESPONSE TEXT",
                style: GoogleFonts.nunito(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: _responseMsgController,
                  maxLines: 3,
                  style: GoogleFonts.nunito(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 3. SPLASH TAB (SPLASH SCREEN CONFIG)
  // Exact layout from Screenshot 2
  // ==========================================
  Widget _buildSplashTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Gallery Row: Selected Images (Max 3) + "+ Select from Gallery"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected Images (Max 3)",
                    style: GoogleFonts.nunito(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openGallery(mode: 'splash', maxCount: 3),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.primary, width: 1.w),
                      ),
                      child: Text(
                        "+ Select from Gallery",
                        style: GoogleFonts.nunito(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Image Slots Row (Exactly 3 slots for Max 3)
              Row(
                children: List.generate(3, (index) {
                  final hasImage = index < _splashImages.length;
                  final imageUrl = hasImage ? _splashImages[index] : null;

                  return Expanded(
                    child: Container(
                      height: 85.h,
                      margin: EdgeInsets.only(right: index < 2 ? 8.w : 0),
                      child: hasImage
                          ? _buildSelectedThumbnail(
                              imageUrl: imageUrl!,
                              label: "Splash ${index + 1}",
                              onRemove: () {
                                HapticFeedback.lightImpact();
                                setState(() => _splashImages.removeAt(index));
                              },
                            )
                          : _buildDashedUploadPlaceholder(
                              label: index == 0 ? "Upload" : "",
                              onTap: () => _openGallery(mode: 'splash', maxCount: 3),
                            ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16.h),

              // DISPLAY DURATION PER IMAGE *
              Text(
                "DISPLAY DURATION PER IMAGE *",
                style: GoogleFonts.nunito(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Container(
                    width: 58.w,
                    height: 32.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$_splashDuration",
                          style: GoogleFonts.nunito(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_splashDuration < 30) {
                                  setState(() => _splashDuration++);
                                }
                              },
                              child: Icon(Icons.arrow_drop_up_rounded, size: 14.sp, color: const Color(0xFF4B5563)),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_splashDuration > 1) {
                                  setState(() => _splashDuration--);
                                }
                              },
                              child: Icon(Icons.arrow_drop_down_rounded, size: 14.sp, color: const Color(0xFF4B5563)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "seconds (Max 30)",
                    style: GoogleFonts.nunito(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // ACTIVE ON DAYS
              Text(
                "ACTIVE ON DAYS",
                style: GoogleFonts.nunito(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 6.h),
              _buildDayPills(_splashActiveDays, (updated) {
                setState(() => _splashActiveDays = updated);
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. OFFER TAB (SPECIAL OFFER CONFIG)
  // Exact layout from Screenshot 3
  // ==========================================
  Widget _buildOfferTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // OFFER TITLE *
              Text(
                "OFFER TITLE *",
                style: GoogleFonts.nunito(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: TextField(
                  controller: _offerTitleController,
                  style: GoogleFonts.nunito(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "e.g. Weekend Special Offer",
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // ACTIVE ON DAYS
              Text(
                "ACTIVE ON DAYS",
                style: GoogleFonts.nunito(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 6.h),
              _buildDayPills(_offerActiveDays, (updated) {
                setState(() => _offerActiveDays = updated);
              }),
              SizedBox(height: 16.h),

              // Offer Images (Max 10) + Select from Gallery
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Offer Images (Max 10)",
                    style: GoogleFonts.nunito(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openGallery(mode: 'offer', maxCount: 10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.primary, width: 1.w),
                      ),
                      child: Text(
                        "Select from Gallery",
                        style: GoogleFonts.nunito(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Horizontal scrollable row of offer images
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    ..._offerImages.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final url = entry.value;

                      return Container(
                        width: 85.w,
                        height: 85.h,
                        margin: EdgeInsets.only(right: 8.w),
                        child: _buildSelectedThumbnail(
                          imageUrl: url,
                          label: "Offer ${idx + 1}",
                          onRemove: () {
                            HapticFeedback.lightImpact();
                            setState(() => _offerImages.removeAt(idx));
                          },
                        ),
                      );
                    }),
                    if (_offerImages.length < 10)
                      SizedBox(
                        width: 85.w,
                        height: 85.h,
                        child: _buildDashedUploadPlaceholder(
                          label: "",
                          onTap: () => _openGallery(mode: 'offer', maxCount: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================

  Widget _buildTabPill(String label, String tabKey, {IconData? icon}) {
    final isSel = _activeTab == tabKey;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _activeTab = tabKey);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFFFEF2F2) : Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSel ? AppColors.primary : const Color(0xFFE5E7EB),
            width: 1.2.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13.sp,
                color: isSel ? AppColors.primary : const Color(0xFF6B7280),
              ),
              SizedBox(width: 5.w),
            ],
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 10.5.sp,
                fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                color: isSel ? AppColors.primary : const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelGridCard(String label, String channelKey, IconData icon) {
    final isSel = _selectedOrderChannel == channelKey;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedOrderChannel = channelKey);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFFFEF2F2) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSel ? AppColors.primary : const Color(0xFFE5E7EB),
            width: isSel ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15.sp,
              color: isSel ? AppColors.primary : const Color(0xFF6B7280),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 11.sp,
                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                  color: isSel ? AppColors.primary : const Color(0xFF374151),
                ),
              ),
            ),
            if (isSel)
              Icon(Icons.check_rounded, size: 14.sp, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  String _getChannelDisplayName(String key) {
    switch (key) {
      case 'takeaway':
        return 'TakeAway';
      case 'rooms':
        return 'Rooms';
      case 'delivery':
        return 'Deliveries';
      case 'dine_in':
      default:
        return 'Dine-In';
    }
  }

  Widget _buildRadioOption(String label, String value) {
    final isSel = _orderDestination == value;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _orderDestination = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSel ? AppColors.primary : const Color(0xFF9CA3AF),
                width: 1.5.w,
              ),
            ),
            padding: EdgeInsets.all(2.5.w),
            child: isSel
                ? Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCheckbox(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18.w,
          height: 18.h,
          child: Checkbox(
            value: value,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.r)),
            onChanged: (v) => onChanged(v ?? false),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }

  Widget _buildDayPills(List<String> activeDays, Function(List<String>) onUpdate) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _allDays.map((day) {
          final isDayActive = activeDays.contains(day);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final list = List<String>.from(activeDays);
              if (list.contains(day)) {
                list.remove(day);
              } else {
                list.add(day);
              }
              onUpdate(list);
            },
            child: Container(
              margin: EdgeInsets.only(right: 6.w),
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isDayActive ? AppColors.primary : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                day,
                style: GoogleFonts.nunito(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isDayActive ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureCheckbox(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: Checkbox(
            value: value,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.r)),
            onChanged: (v) => onChanged(v ?? false),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedThumbnail({
    required String imageUrl,
    String? label,
    required VoidCallback onRemove,
  }) {
    final cleanUrl = SessionCardModel.resolveGalleryUrl(imageUrl);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: cleanUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: const Color(0xFFF3F4F6),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                return Container(
                  color: const Color(0xFFFFF7ED),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 22.sp, color: const Color(0xFFEA580C)),
                      SizedBox(height: 3.h),
                      Text(
                        label ?? "Selected",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF9A3412),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Delete close icon button at top-right
            Positioned(
              top: 4.h,
              right: 4.w,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onRemove,
                child: Container(
                  width: 18.w,
                  height: 18.h,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded, size: 12.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedUploadPlaceholder({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedRectPainter(color: const Color(0xFFD1D5DB), strokeWidth: 1.2, gap: 4),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 20.sp, color: const Color(0xFF9CA3AF)),
              if (label.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for dashed rounded border
class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(8),
      ));

    final Path dashedPath = Path();
    double distance = 0.0;
    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final double next = distance + gap;
        dashedPath.addPath(
          metric.extractPath(distance, next),
          Offset.zero,
        );
        distance = next + gap;
      }
      distance = 0.0;
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
