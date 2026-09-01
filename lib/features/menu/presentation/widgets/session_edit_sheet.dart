import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/session_model.dart';
import '../controllers/menu_theme_controller.dart';

class SessionEditSheet extends StatefulWidget {
  final SessionModel session;
  const SessionEditSheet({super.key, required this.session});

  @override
  State<SessionEditSheet> createState() => _SessionEditSheetState();
}

class _SessionEditSheetState extends State<SessionEditSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _offerController;
  late String _startTime;
  late String _endTime;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final session = widget.session;
    _nameController = TextEditingController(text: session.name);
    _offerController = TextEditingController(text: session.offerDescription ?? '');
    _startTime = session.startTime;
    _endTime = session.endTime;
    _isActive = session.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _offerController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final initialTime = isStart ? _parseTime(_startTime) : _parseTime(_endTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        final formatted = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
        if (isStart) {
          _startTime = formatted;
        } else {
          _endTime = formatted;
        }
      });
    }
  }

  TimeOfDay _parseTime(String time) {
    try {
      final parts = time.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (_) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _nameController.text.trim(),
        'start_time': _startTime,
        'end_time': _endTime,
        'is_active': _isActive,
        'offer_description': _offerController.text.trim(),
      };

      final controller = Get.find<MenuThemeController>();
      controller.updateSessionSettings(widget.session.id, data);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edit Session Details", style: AppTypography.h2),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 24.sp),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Session Name
              TextFormField(
                controller: _nameController,
                style: AppTypography.bodyMedium,
                decoration: _buildInputDecoration("Session Name"),
                validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
              ),
              SizedBox(height: 16.h),

              // Time Pickers
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(true),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(AppDimensions.radius8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Start: $_startTime", style: AppTypography.bodyMedium),
                            Icon(Icons.access_time_rounded, size: 20.sp, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(false),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(AppDimensions.radius8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("End: $_endTime", style: AppTypography.bodyMedium),
                            Icon(Icons.access_time_rounded, size: 20.sp, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Session Offer Description
              TextFormField(
                controller: _offerController,
                maxLines: 2,
                style: AppTypography.bodyMedium,
                decoration: _buildInputDecoration("Campaign / Offer Description"),
              ),
              SizedBox(height: 16.h),

              // Active Session Toggle Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Active Status", style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                      Text("Activate this session override", style: AppTypography.caption),
                    ],
                  ),
                  Switch(
                    value: _isActive,
                    onChanged: (val) => setState(() => _isActive = val),
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.success,
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                    ),
                    elevation: 0,
                  ),
                  child: Text("Save Session", style: AppTypography.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    );
  }
}
