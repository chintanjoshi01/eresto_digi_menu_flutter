import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/item_model.dart';
import '../controllers/items_controller.dart';

class ItemEditSheet extends StatefulWidget {
  final ItemModel item;
  const ItemEditSheet({super.key, required this.item});

  @override
  State<ItemEditSheet> createState() => _ItemEditSheetState();
}

class _ItemEditSheetState extends State<ItemEditSheet> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _shortCodeController;
  late final TextEditingController _portionController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _serviceTimeController;

  late String _vegType;
  late bool _isFrequentlySold;
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item.name);
    _priceController = TextEditingController(text: item.price.toString());
    _shortCodeController = TextEditingController(text: item.shortCode);
    _portionController = TextEditingController(text: item.portion ?? '');
    _descriptionController = TextEditingController(text: item.shortDescription ?? '');
    _ingredientsController = TextEditingController(text: item.ingredients ?? '');
    _caloriesController = TextEditingController(text: item.calorificValue?.toString() ?? '');
    _serviceTimeController = TextEditingController(text: item.serviceTime?.toString() ?? '');

    _vegType = item.vegType;
    _isFrequentlySold = item.isFrequentlySold;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _shortCodeController.dispose();
    _portionController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _caloriesController.dispose();
    _serviceTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _localImagePath = pickedFile.path;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final updatedData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'short_code': _shortCodeController.text.trim(),
        'portion': _portionController.text.trim(),
        'veg_type': _vegType,
        'is_frequently_sold': _isFrequentlySold,
        'short_description': _descriptionController.text.trim(),
        'ingredients': _ingredientsController.text.trim(),
        'calorific_value': int.tryParse(_caloriesController.text.trim()),
        'service_time': int.tryParse(_serviceTimeController.text.trim()),
        if (_localImagePath != null) 'image_url': _localImagePath, // standalone mock path
      };

      final controller = Get.find<ItemsController>();
      controller.updateItemDetails(widget.item.id, updatedData);
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edit Menu Item", style: AppTypography.h2),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 24.sp),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Image Slot Container
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: _localImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimensions.radius8),
                          child: Image.file(
                            File(_localImagePath!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, size: 32.sp, color: AppColors.textMuted),
                            SizedBox(height: 6.h),
                            Text("Select Item Image", style: AppTypography.caption),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 16.h),

              // Fields Row 1 (Name & Short Code)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _nameController,
                      style: AppTypography.bodyMedium,
                      decoration: _buildInputDecoration("Item Name"),
                      validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: _shortCodeController,
                      style: AppTypography.bodyMedium,
                      decoration: _buildInputDecoration("Short Code"),
                      validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Fields Row 2 (Price & Portion)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      style: AppTypography.bodyMedium,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _buildInputDecoration("Price (₹)"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Required";
                        final val = double.tryParse(value);
                        if (val == null || val <= 0) return "Must be positive";
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: _portionController,
                      style: AppTypography.bodyMedium,
                      decoration: _buildInputDecoration("Portion Size"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Veg/Non-Veg & Frequently Sold Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Veg type Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Veg Type", style: AppTypography.caption),
                      SizedBox(height: 4.h),
                      Row(
                        children: ['veg', 'non_veg', 'na'].map((type) {
                          final isSel = _vegType == type;
                          return GestureDetector(
                            onTap: () => setState(() => _vegType = type),
                            child: Container(
                              margin: EdgeInsets.only(right: 6.w),
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primaryLight : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(AppDimensions.radius12),
                                border: Border.all(
                                  color: isSel ? AppColors.primary : Colors.transparent,
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                type.replaceAll('_', ' ').toUpperCase(),
                                style: AppTypography.caption.copyWith(
                                  color: isSel ? AppColors.primary : AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  // Frequently Sold Switch
                  Row(
                    children: [
                      Text("Frequently Sold", style: AppTypography.bodySmall),
                      Switch(
                        value: _isFrequentlySold,
                        onChanged: (val) => setState(() => _isFrequentlySold = val),
                        activeColor: Colors.white,
                        activeTrackColor: AppColors.success,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                style: AppTypography.bodyMedium,
                decoration: _buildInputDecoration("Short Description"),
              ),
              SizedBox(height: 12.h),

              // Ingredients
              TextFormField(
                controller: _ingredientsController,
                maxLines: 2,
                style: AppTypography.bodyMedium,
                decoration: _buildInputDecoration("Ingredients list"),
              ),
              SizedBox(height: 12.h),

              // Calorific & Service Time
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      style: AppTypography.bodyMedium,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration("Calories (Kcal)"),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: _serviceTimeController,
                      style: AppTypography.bodyMedium,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration("Prep Time (min)"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Save Button
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
                  child: Text("Save Changes", style: AppTypography.button),
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
