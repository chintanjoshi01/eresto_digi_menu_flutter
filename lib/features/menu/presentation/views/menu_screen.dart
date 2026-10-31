import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/eresto_top_header.dart';
import '../../domain/models/channel_session_group_model.dart';
import '../../domain/models/menu_template_model.dart';
import '../controllers/menu_theme_controller.dart';
import '../widgets/session_edit_sheet.dart';
import '../widgets/template_options_sheet.dart';

/// Enterprise Menu Templates & Sessions Screen matching Screenshots 1-4 & eresto_menu_mobile_v41.html.
class MenuScreen extends GetView<MenuThemeController> {
  final bool isEmbedded;

  const MenuScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final content = RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.lightImpact();
        await controller.fetchRemoteMenuData(isSwipeRefresh: true);
      },
      color: AppColors.primary,
      backgroundColor: Colors.white,
      displacement: 32.h,
      strokeWidth: 2.5,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. MENU TEMPLATES SECTION ──
            _buildTemplatesHeader(),
            SizedBox(height: 8.h),
            _buildMenuTemplatesCard(),

            SizedBox(height: 18.h),

            // ── 2. SESSIONS SECTION WITH ACCORDIONS ──
            _buildSessionsHeader(),
            SizedBox(height: 10.h),
            _buildChannelAccordionsList(),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );

    if (isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.h),
        child: const ErestoTopHeader(),
      ),
      body: SafeArea(child: content),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 1. MENU TEMPLATES SECTION
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildTemplatesHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.layers_rounded,
              size: 16.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Menu Templates",
                  style: GoogleFonts.poppins(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Tap a template to change theme or manage items",
                  style: GoogleFonts.poppins(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTemplatesCard() {
    return Obx(() {
      if (controller.isLoading.value && controller.templatesList.isEmpty) {
        return _buildShimmerTemplatesCard();
      }

      final templates = controller.templatesList;
      if (templates.isEmpty) {
        return Container(
          padding: EdgeInsets.all(24.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
          ),
          child: Text(
            "No menu templates found",
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
        );
      }

      final isExpanded = controller.isTemplatesExpanded.value;
      final visibleCount = isExpanded ? templates.length : (templates.length > 5 ? 5 : templates.length);
      final hasMore = templates.length > 5;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ...List.generate(visibleCount, (index) {
              final tmpl = templates[index];
              final isLast = index == visibleCount - 1 && !hasMore;

              return TweenAnimationBuilder<double>(
                key: ValueKey<int>(tmpl.id),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 220 + (index * 35)),
                curve: Curves.easeOutCubic,
                builder: (context, val, child) {
                  return Opacity(
                    opacity: val,
                    child: Transform.translate(
                      offset: Offset(0, 8 * (1 - val)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    _buildTemplateRow(tmpl),
                    if (!isLast) const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  ],
                ),
              );
            }),
            if (hasMore) ...[
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              InkWell(
                onTap: controller.toggleTemplatesExpanded,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r)),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isExpanded
                            ? "Show Less"
                            : "View All Templates (+${templates.length - 5})",
                        style: GoogleFonts.poppins(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 17.sp,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildShimmerTemplatesCard() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
        ),
        child: Column(
          children: List.generate(5, (index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              width: 160.w,
                              height: 9.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 44.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < 4) const Divider(height: 1, color: Color(0xFFF3F4F6)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildShimmerSessions() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: Column(
        children: List.generate(2, (index) {
          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  child: Row(
                    children: [
                      Container(
                        width: 3.5.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 110.w,
                        height: 13.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 55.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r)),
                  ),
                  child: Container(
                    height: 85.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTemplateRow(MenuTemplateModel tmpl) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        Get.bottomSheet(
          TemplateOptionsSheet(menuTemplate: tmpl, isMultiMenu: tmpl.isMulti),
          isScrollControlled: true,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        child: Row(
          children: [
            // Left Document / Grid Icon Box
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: tmpl.iconBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                tmpl.isMulti ? Icons.grid_view_rounded : Icons.description_outlined,
                size: 17.sp,
                color: tmpl.iconFg,
              ),
            ),
            SizedBox(width: 12.w),

            // Middle Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Active / Multi Badge
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          tmpl.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                      if (tmpl.isActive) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "Active",
                            style: GoogleFonts.poppins(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF16A34A),
                            ),
                          ),
                        ),
                      ],
                      if (tmpl.isMulti) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "MULTI",
                            style: GoogleFonts.poppins(
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Subtitle info
                  Text(
                    tmpl.details,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Theme indicator row & Category Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: tmpl.themeColor,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          tmpl.themeName,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        if (tmpl.extraPills.isNotEmpty) ...[
                          SizedBox(width: 5.w),
                          ...tmpl.extraPills.map((pill) {
                            return Container(
                              margin: EdgeInsets.only(left: 4.w),
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                pill,
                                style: GoogleFonts.poppins(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF7C3AED),
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right Action: Edit Button
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                HapticFeedback.lightImpact();
                Get.bottomSheet(
                  TemplateOptionsSheet(menuTemplate: tmpl, isMultiMenu: tmpl.isMulti),
                  isScrollControlled: true,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: 12.sp, color: AppColors.primary),
                    SizedBox(width: 4.w),
                    Text(
                      "Edit",
                      style: GoogleFonts.poppins(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 2. SESSIONS SECTION WITH ACCORDIONS
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSessionsHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sessions",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "View & manage channel session settings",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() {
            final count = controller.channelGroups.length;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                "$count Channels",
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B5563),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChannelAccordionsList() {
    return Obx(() {
      final groups = controller.channelGroups;

      if (controller.isLoading.value && groups.isEmpty) {
        return _buildShimmerSessions();
      }

      return Column(
        children: groups.asMap().entries.map((entry) {
          final index = entry.key;
          final group = entry.value;
          final isExpanded = controller.expandedChannelIds.contains(group.id);

          return TweenAnimationBuilder<double>(
            key: ValueKey<String>(group.id),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 250 + (index * 45)),
            curve: Curves.easeOutCubic,
            builder: (context, val, child) {
              return Opacity(
                opacity: val,
                child: Transform.translate(
                  offset: Offset(0, 10 * (1 - val)),
                  child: child,
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Accordion Header Bar
                  InkWell(
                    borderRadius: isExpanded
                        ? BorderRadius.vertical(top: Radius.circular(14.r))
                        : BorderRadius.circular(14.r),
                    onTap: () => controller.toggleChannelAccordion(group.id),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isExpanded ? Colors.white : const Color(0xFFF9FAFB),
                        borderRadius: isExpanded
                            ? BorderRadius.vertical(top: Radius.circular(14.r))
                            : BorderRadius.circular(14.r),
                        border: isExpanded
                            ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6)))
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left: Accent Bar + Title + Active Badge
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 3.5.w,
                                  height: 16.h,
                                  decoration: BoxDecoration(
                                    color: group.accentColor,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Flexible(
                                  child: Text(
                                    group.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF111827),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: group.activeCount > 0
                                        ? const Color(0xFFDCFCE7)
                                        : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    group.activeCountText,
                                    style: GoogleFonts.poppins(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w500,
                                      color: group.activeCount > 0
                                          ? const Color(0xFF15803D)
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),

                          // Right: Session Count + Rotating Chevron
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${group.sessionsCount} ${group.sessionsCount == 1 ? 'Session' : 'Sessions'}",
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeInOutCubic,
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18.sp,
                                  color: const Color(0xFF4B5563),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Accordion Body
                  if (isExpanded)
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 4.h),
                      child: Column(
                        children: group.sessions.map((session) {
                          return _buildSessionCard(session);
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildSessionCard(SessionCardModel session) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: session.isActiveNow ? const Color(0xFFBBF7D0) : const Color(0xFFF3F4F6),
          width: session.isActiveNow ? 1.5.w : 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Session Top Row (Title + Status Badge + Actions)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        session.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: session.statusBg,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (session.isActiveNow) ...[
                            Container(
                              width: 5.w,
                              height: 5.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFF16A34A),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                          ],
                          Text(
                            session.statusText,
                            style: GoogleFonts.poppins(
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w500,
                              color: session.statusFg,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              // Action Button: Edit Only (Delete removed per request)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.bottomSheet(
                    SessionEditSheet(sessionCard: session),
                    isScrollControlled: true,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined, size: 12.sp, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(
                        "Edit",
                        style: GoogleFonts.poppins(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // 2. Middle 2-Column Info Grid (Menu Template & Timing)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: session.isActiveNow ? const Color(0xFFF0FDF4) : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: session.isActiveNow ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Menu Template
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "MENU TEMPLATE",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w500,
                            color: session.isActiveNow ? const Color(0xFF166534) : const Color(0xFF9CA3AF),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                session.templateName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF111827),
                                  height: 1.2,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 11.sp,
                              color: session.isActiveNow ? const Color(0xFF16A34A) : const Color(0xFF9CA3AF),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 1.w,
                    margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    color: session.isActiveNow ? const Color(0xFFDCFCE7) : const Color(0xFFE5E7EB),
                  ),

                  // Right: Timing
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "TIMING",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w500,
                            color: session.isActiveNow ? const Color(0xFF166534) : const Color(0xFF9CA3AF),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 11.5.sp,
                              color: session.isActiveNow ? const Color(0xFF16A34A) : const Color(0xFF6B7280),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  session.timingFormatted,
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF111827),
                                    height: 1.2,
                                  ),
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
            ),
          ),

          SizedBox(height: 8.h),

          // 3. Bottom Row Feature Badges
          Wrap(
            spacing: 5.w,
            runSpacing: 4.h,
            children: [
              // Customer Order Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: session.customerOrderEnabled ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  session.customerOrderEnabled ? "Customer Order: Enabled" : "Customer Order: ---",
                  style: GoogleFonts.poppins(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: session.customerOrderEnabled ? const Color(0xFF15803D) : const Color(0xFF9CA3AF),
                  ),
                ),
              ),

              // Section Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: session.sectionName != '---' ? const Color(0xFFEFF6FF) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "Section: ${session.sectionName}",
                  style: GoogleFonts.poppins(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: session.sectionName != '---' ? const Color(0xFF1D4ED8) : const Color(0xFF9CA3AF),
                  ),
                ),
              ),

              // Offer Badge
              if (session.hasOffer)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: const Color(0xFFFFEDD5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded, size: 10.5.sp, color: const Color(0xFFEA580C)),
                      SizedBox(width: 3.w),
                      Text(
                        "Special Offer",
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFEA580C),
                        ),
                      ),
                    ],
                  ),
                ),

              // Splash Badge
              if (session.hasSplash)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF2F8),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: const Color(0xFFFCE7F3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded, size: 10.5.sp, color: const Color(0xFFBE185D)),
                      SizedBox(width: 3.w),
                      Text(
                        "Splash Screen",
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFBE185D),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
