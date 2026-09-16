import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/share_controller.dart';

class DownloadMenuPdfSheet extends StatelessWidget {
  const DownloadMenuPdfSheet({super.key});

  static void show(BuildContext context) {
    final controller = Get.find<ShareController>();
    controller.resetPdfWizard();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DownloadMenuPdfSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShareController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 38.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Modal Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Download Menu as PDF",
                        style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      Text(
                        "A4 portrait print-ready layout & styles",
                        style: GoogleFonts.nunito(
                          fontSize: 11.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, color: const Color(0xFF6B7280), size: 22.sp),
                  splashRadius: 20.r,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Stepper Indicator (when not showing completed success)
          Obx(() {
            if (controller.generatedPdfResponse.value != null) {
              return const SizedBox.shrink();
            }
            return _buildStepperIndicator(controller);
          }),

          // Scrollable Body
          Expanded(
            child: Obx(() {
              if (controller.generatedPdfResponse.value != null) {
                return _buildSuccessView(controller);
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                physics: const BouncingScrollPhysics(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildCurrentStep(controller),
                ),
              );
            }),
          ),

          // Bottom Action Bar
          Obx(() {
            if (controller.generatedPdfResponse.value != null) {
              return const SizedBox.shrink();
            }
            return _buildBottomActionBar(controller);
          }),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Stepper Indicator
  // --------------------------------------------------------------------------

  Widget _buildStepperIndicator(ShareController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: Colors.white,
      child: Row(
        children: [
          _buildStepItem(controller, index: 0, title: "Header"),
          _buildStepConnector(controller, stepAfter: 0),
          _buildStepItem(controller, index: 1, title: "Layout"),
          _buildStepConnector(controller, stepAfter: 1),
          _buildStepItem(controller, index: 2, title: "Styling"),
        ],
      ),
    );
  }

  Widget _buildStepItem(ShareController controller, {required int index, required String title}) {
    final current = controller.pdfCurrentStep.value;
    final isDone = current > index;
    final isActive = current == index;

    return Row(
      children: [
        Container(
          width: 26.w,
          height: 26.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? const Color(0xFF10B981)
                : isActive
                    ? AppColors.primary
                    : const Color(0xFFE5E7EB),
          ),
          alignment: Alignment.center,
          child: isDone
              ? Icon(Icons.check_rounded, color: Colors.white, size: 14.sp)
              : Text(
                  "${index + 1}",
                  style: GoogleFonts.nunito(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
        ),
        SizedBox(width: 6.w),
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 11.sp,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: isActive ? AppColors.primary : const Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(ShareController controller, {required int stepAfter}) {
    final isPassed = controller.pdfCurrentStep.value > stepAfter;
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        color: isPassed ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Current Step Content Router
  // --------------------------------------------------------------------------

  Widget _buildCurrentStep(ShareController controller) {
    switch (controller.pdfCurrentStep.value) {
      case 0:
        return _buildStep1Header(controller);
      case 1:
        return _buildStep2Layout(controller);
      case 2:
      default:
        return _buildStep3Styling(controller);
    }
  }

  // --------------------------------------------------------------------------
  // STEP 1: Header Details & Template Selector
  // --------------------------------------------------------------------------

  Widget _buildStep1Header(ShareController controller) {
    final templates = controller.getAvailableTemplates();

    return Column(
      key: const ValueKey("step1"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("1. Select Menu Template"),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: controller.selectedTemplateId.value,
              icon: Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary, size: 24.sp),
              items: templates.map<DropdownMenuItem<int>>((t) {
                int id = 1;
                String name = 'Template';
                if (t is Map) {
                  id = t['id'] ?? 1;
                  name = t['name'] ?? 'Template';
                } else {
                  try {
                    id = (t as dynamic).id ?? 1;
                    name = (t as dynamic).name ?? 'Template';
                  } catch (_) {}
                }
                return DropdownMenuItem<int>(
                  value: id,
                  child: Text(
                    name,
                    style: GoogleFonts.nunito(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newId) {
                if (newId != null) {
                  controller.selectedTemplateId.value = newId;
                }
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),

        _buildSectionTitle("2. Restaurant Info for Header"),
        SizedBox(height: 8.h),
        _buildInputField(
          label: "Restaurant Display Name",
          controller: controller.headerNameCtrl,
          icon: Icons.storefront_rounded,
        ),
        _buildCheckboxRow(
          label: "Show restaurant name on header",
          value: controller.showHeaderName,
        ),
        SizedBox(height: 10.h),

        _buildInputField(
          label: "Contact Phone Number",
          controller: controller.headerContactCtrl,
          icon: Icons.phone_rounded,
          keyboardType: TextInputType.phone,
        ),
        _buildCheckboxRow(
          label: "Show contact phone on header",
          value: controller.showHeaderContact,
        ),
        SizedBox(height: 10.h),

        _buildInputField(
          label: "Street Address",
          controller: controller.headerAddressCtrl,
          icon: Icons.location_on_rounded,
        ),
        SizedBox(height: 10.h),

        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: "City",
                controller: controller.headerCityCtrl,
                icon: Icons.location_city_rounded,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildInputField(
                label: "Pincode",
                controller: controller.headerPinCtrl,
                icon: Icons.pin_drop_rounded,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        _buildCheckboxRow(
          label: "Show address and location on header",
          value: controller.showHeaderAddress,
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // STEP 2: PDF Layout & Appearance (Screenshot 4)
  // --------------------------------------------------------------------------

  Widget _buildStep2Layout(ShareController controller) {
    return Column(
      key: const ValueKey("step2"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("1. Choose Layout Style"),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildLayoutStyleCard(
                controller: controller,
                styleId: 'classic',
                title: 'Classic',
                subtitle: 'Single / dual traditional',
                icon: Icons.menu_book_rounded,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildLayoutStyleCard(
                controller: controller,
                styleId: 'card',
                title: 'Card',
                subtitle: 'Structured item boxes',
                icon: Icons.view_agenda_rounded,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildLayoutStyleCard(
                controller: controller,
                styleId: 'compact',
                title: 'Compact',
                subtitle: 'Dense 2-column menu',
                icon: Icons.view_compact_rounded,
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),

        _buildSectionTitle("2. Header Alignment"),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildSelectionChip(
              label: "Left",
              icon: Icons.format_align_left_rounded,
              isSelected: controller.headerAlign.value == 'left',
              onTap: () => controller.headerAlign.value = 'left',
            ),
            SizedBox(width: 8.w),
            _buildSelectionChip(
              label: "Center",
              icon: Icons.format_align_center_rounded,
              isSelected: controller.headerAlign.value == 'center',
              onTap: () => controller.headerAlign.value = 'center',
            ),
            SizedBox(width: 8.w),
            _buildSelectionChip(
              label: "Right",
              icon: Icons.format_align_right_rounded,
              isSelected: controller.headerAlign.value == 'right',
              onTap: () => controller.headerAlign.value = 'right',
            ),
          ],
        ),
        SizedBox(height: 18.h),

        _buildSectionTitle("3. Category Heading Banner Style"),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildSelectionChip(
              label: "Plain",
              isSelected: controller.catStyle.value == 'plain',
              onTap: () => controller.catStyle.value = 'plain',
            ),
            SizedBox(width: 8.w),
            _buildSelectionChip(
              label: "Solid",
              isSelected: controller.catStyle.value == 'solid',
              onTap: () => controller.catStyle.value = 'solid',
            ),
            SizedBox(width: 8.w),
            _buildSelectionChip(
              label: "Gradient",
              isSelected: controller.catStyle.value == 'gradient',
              onTap: () => controller.catStyle.value = 'gradient',
            ),
          ],
        ),
        SizedBox(height: 18.h),

        _buildSectionTitle("4. Background Palette Theme"),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildColorPaletteSwatch(controller, id: 'white', name: 'White', color: const Color(0xFFFFFFFF)),
            SizedBox(width: 10.w),
            _buildColorPaletteSwatch(controller, id: 'cream', name: 'Cream', color: const Color(0xFFFFFDF0)),
            SizedBox(width: 10.w),
            _buildColorPaletteSwatch(controller, id: 'beige', name: 'Beige', color: const Color(0xFFF5F5DC)),
            SizedBox(width: 10.w),
            _buildColorPaletteSwatch(controller, id: 'blush', name: 'Blush', color: const Color(0xFFFFF0F5)),
            SizedBox(width: 10.w),
            _buildColorPaletteSwatch(controller, id: 'grey', name: 'Grey', color: const Color(0xFFF3F4F6)),
          ],
        ),
      ],
    );
  }

  Widget _buildLayoutStyleCard({
    required ShareController controller,
    required String styleId,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = controller.selectedPdfStyle.value == styleId;

    return GestureDetector(
      onTap: () => controller.selectedPdfStyle.value = styleId,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFEF2F2) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
                size: 18.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.primary : const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 9.sp,
                color: const Color(0xFF9CA3AF),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPaletteSwatch(
    ShareController controller, {
    required String id,
    required String name,
    required Color color,
  }) {
    final isSelected = controller.bgTheme.value == id;

    return GestureDetector(
      onTap: () => controller.bgTheme.value = id,
      child: Column(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFD1D5DB),
                width: isSelected ? 2.5.w : 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? Icon(Icons.check_rounded, size: 18.sp, color: AppColors.primary)
                : null,
          ),
          SizedBox(height: 4.h),
          Text(
            name,
            style: GoogleFonts.nunito(
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // STEP 3: Menu Styling & Item Filters
  // --------------------------------------------------------------------------

  Widget _buildStep3Styling(ShareController controller) {
    return Column(
      key: const ValueKey("step3"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Item Detail Inclusions"),
        SizedBox(height: 6.h),
        Text(
          "Choose what additional item metadata to print in the PDF menu.",
          style: GoogleFonts.nunito(fontSize: 11.sp, color: const Color(0xFF6B7280)),
        ),
        SizedBox(height: 12.h),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              _buildSwitchRow(
                title: "Portions & Variant Pricing",
                subtitle: "Prints sizes (Half, Full, Regular, Large)",
                icon: Icons.straighten_rounded,
                value: controller.showSize,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _buildSwitchRow(
                title: "Calorie & Nutrition Info",
                subtitle: "Prints calorie count (e.g. 350 kcal)",
                icon: Icons.local_fire_department_rounded,
                value: controller.showCal,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _buildSwitchRow(
                title: "Item Descriptions",
                subtitle: "Prints culinary notes & preparation details",
                icon: Icons.notes_rounded,
                value: controller.showDes,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _buildSwitchRow(
                title: "Ingredients",
                subtitle: "Prints key ingredients for transparency",
                icon: Icons.eco_rounded,
                value: controller.showIng,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _buildSwitchRow(
                title: "Allergen Icons & Tags",
                subtitle: "Shows dairy, nuts, gluten, vegan badges",
                icon: Icons.warning_amber_rounded,
                value: controller.showAik,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Preview Summary Card
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: const Color(0xFF16A34A), size: 20.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "High-resolution vector PDF generated on server with automatic page breaks and table of contents.",
                  style: GoogleFonts.nunito(
                    fontSize: 10.5.sp,
                    color: const Color(0xFF166534),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // Generated PDF Success View
  // --------------------------------------------------------------------------

  Widget _buildSuccessView(ShareController controller) {
    final response = controller.generatedPdfResponse.value;
    if (response == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF86EFAC), width: 2.w),
            ),
            child: Icon(Icons.check_rounded, color: const Color(0xFF16A34A), size: 36.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            "PDF Generated Successfully!",
            style: GoogleFonts.nunito(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            response.fileName,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 12.h),

          // Local file status badge
          Obx(() {
            if (controller.isDownloadingPdfFile.value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Downloading PDF file to device...",
                    style: GoogleFonts.nunito(fontSize: 11.5.sp, color: const Color(0xFF6B7280)),
                  ),
                ],
              );
            }
            if (controller.downloadedLocalPdfFile.value != null) {
              final fileSizeKb = controller.downloadedLocalPdfFile.value!.lengthSync() ~/ 1024;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download_done_rounded, size: 14.sp, color: const Color(0xFF16A34A)),
                    SizedBox(width: 6.w),
                    Text(
                      "Downloaded locally ($fileSizeKb KB) • Ready to open & share",
                      style: GoogleFonts.nunito(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF166534),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          SizedBox(height: 20.h),

          // Primary Open PDF button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.openDownloadedPdf(),
              icon: Icon(Icons.picture_as_pdf_rounded, size: 17.sp),
              label: Text(
                "Open PDF File",
                style: GoogleFonts.nunito(fontSize: 13.5.sp, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Share PDF File button (shares actual file)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => controller.shareDownloadedPdf(),
              icon: Icon(Icons.share_rounded, size: 16.sp, color: const Color(0xFF374151)),
              label: Text(
                "Share PDF Document",
                style: GoogleFonts.nunito(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF374151),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                padding: EdgeInsets.symmetric(vertical: 13.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
          ),
          SizedBox(height: 14.h),

          TextButton(
            onPressed: () => controller.resetPdfWizard(),
            child: Text(
              "Generate Another PDF",
              style: GoogleFonts.nunito(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Sticky Bottom Action Bar
  // --------------------------------------------------------------------------

  Widget _buildBottomActionBar(ShareController controller) {
    final step = controller.pdfCurrentStep.value;
    final isLast = step == 2;
    final isLoading = controller.isGeneratingPdf.value;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE5E7EB), width: 1.h)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (step > 0) ...[
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: isLoading ? null : () => controller.prevPdfStep(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: Text(
                  "Back",
                  style: GoogleFonts.nunito(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isLoading ? null : () => controller.nextPdfStep(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                elevation: 0,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isLast ? "Generate Menu PDF" : "Next: Layout Options",
                      style: GoogleFonts.nunito(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Helper Form Elements
  // --------------------------------------------------------------------------

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF111827)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.nunito(fontSize: 11.sp, color: const Color(0xFF6B7280)),
          prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 18.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow({required String label, required RxBool value}) {
    return Obx(
      () => InkWell(
        onTap: () => value.toggle(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              SizedBox(
                width: 22.w,
                height: 22.w,
                child: Checkbox(
                  value: value.value,
                  onChanged: (v) => value.value = v ?? false,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 9.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFEF2F2) : Colors.white,
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
              width: isSelected ? 1.5.w : 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14.sp, color: isSelected ? AppColors.primary : const Color(0xFF6B7280)),
                SizedBox(width: 4.w),
              ],
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 11.5.sp,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? AppColors.primary : const Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required RxBool value,
  }) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: value.value ? const Color(0xFFFEF2F2) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: value.value ? AppColors.primary : const Color(0xFF6B7280),
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(fontSize: 10.sp, color: const Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value.value,
              onChanged: (v) => value.value = v,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
