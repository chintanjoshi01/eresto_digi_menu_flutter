import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../menu/presentation/widgets/gallery_selection_sheet.dart';
import '../../../menu/presentation/widgets/image_cropper_modal.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/models/item_model.dart';
import '../../domain/models/v6_menu_items_response.dart';
import '../controllers/items_controller.dart';

class _VariantItem {
  int id;
  final TextEditingController nameController;
  final TextEditingController priceController;
  bool isDefault;

  _VariantItem({
    this.id = 0,
    required String name,
    required String price,
    this.isDefault = false,
  })  : nameController = TextEditingController(text: name),
        priceController = TextEditingController(text: price);

  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}

class _AddonChoice {
  int id;
  final TextEditingController nameController;
  final TextEditingController priceController;

  _AddonChoice({
    this.id = 0,
    required String name,
    required String price,
  })  : nameController = TextEditingController(text: name),
        priceController = TextEditingController(text: price);

  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}

class _AddonGroup {
  int id;
  final TextEditingController titleController;
  final TextEditingController minController;
  final TextEditingController maxController;
  final List<_AddonChoice> choices;

  _AddonGroup({
    this.id = 0,
    required String title,
    int min = 0,
    int max = 4,
    List<_AddonChoice>? choices,
  })  : titleController = TextEditingController(text: title),
        minController = TextEditingController(text: min.toString()),
        maxController = TextEditingController(text: max.toString()),
        choices = choices ?? [];

  void dispose() {
    titleController.dispose();
    minController.dispose();
    maxController.dispose();
    for (final c in choices) {
      c.dispose();
    }
  }
}

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
  late bool _isAvailable;
  late bool _isFrequentlySold;
  late String _itemGroup;
  late String _taxTemplate;
  late String _kitchenCategory;
  late String _salesCategory;
  String? _localImagePath;
  String? _currentImageUrl;
  bool _isLoadingDetails = true;

  // Dietary tags selection (s = Spicy, j = Jain, v = Vegan)
  final Set<String> _dietaryTags = {};

  // Standard 8 FSSAI allergens
  static const List<({String key, String label, String icon})> kFssaiAllergens = [
    (key: 'Gluten', label: 'Cereals (gluten)', icon: '🌾'),
    (key: 'Crustacean', label: 'Crustaceans', icon: '🦐'),
    (key: 'Eggs', label: 'Eggs', icon: '🥚'),
    (key: 'Fish', label: 'Fish', icon: '🐟'),
    (key: 'Peanuts', label: 'Peanuts', icon: '🥜'),
    (key: 'Soyabean', label: 'Soya', icon: '🌱'),
    (key: 'Milk', label: 'Milk', icon: '🥛'),
    (key: 'Nuts', label: 'Tree nuts', icon: '🌰'),
  ];

  // Active allergen keys for this item
  final Set<String> _selectedAllergens = {};

  // Special instructions selection for this item
  final Set<String> _selectedSpecialInstructions = {};

  // Variants management
  bool _hasVariants = false;
  final List<_VariantItem> _variants = [];

  // Add-on groups management
  final List<_AddonGroup> _addonGroups = [];

  String? _normalizeAllergenToKey(String raw) {
    final lower = raw.trim().toLowerCase();
    if (lower.contains('gluten') || lower.contains('cereal')) return 'Gluten';
    if (lower.contains('crustacean')) return 'Crustacean';
    if (lower.contains('egg')) return 'Eggs';
    if (lower.contains('fish')) return 'Fish';
    if (lower.contains('peanut')) return 'Peanuts';
    if (lower.contains('soya') || lower.contains('soy')) return 'Soyabean';
    if (lower.contains('milk') || lower.contains('dairy')) return 'Milk';
    if (lower.contains('nut') || lower.contains('tree')) return 'Nuts';
    return null;
  }

  void _parseVariantsJson(String? raw) {
    _variants.clear();
    if (raw == null || raw.trim().isEmpty || raw == 'null' || raw == '[]' || raw == '{}') {
      _hasVariants = false;
      return;
    }
    try {
      final decoded = jsonDecode(raw);
      List list = [];
      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map) {
        list = decoded.values.toList();
      }
      for (final v in list) {
        if (v is Map) {
          final id = int.tryParse((v['id'] ?? '0').toString()) ?? 0;
          final name = (v['name'] ?? v['v'] ?? v['n'] ?? '').toString();
          final priceRaw = v['price'] ?? v['b'] ?? v['prc'] ?? v['p'] ?? '0';
          final price = priceRaw.toString();
          final isDef = v['is_default'] == 1 ||
              v['is_default'] == '1' ||
              v['is_default'] == true ||
              v['d'] == 1 ||
              v['d'] == '1' ||
              v['default'] == true;
          if (name.isNotEmpty) {
            _variants.add(_VariantItem(id: id, name: name, price: price, isDefault: isDef));
          }
        }
      }
      _hasVariants = _variants.isNotEmpty;
      if (_hasVariants && !_variants.any((e) => e.isDefault)) {
        _variants.first.isDefault = true;
      }
    } catch (_) {
      _hasVariants = false;
    }
  }

  void _parseAddonsJson(String? raw) {
    _addonGroups.clear();
    if (raw == null || raw.trim().isEmpty || raw == 'null' || raw == '[]' || raw == '{}') {
      return;
    }
    try {
      final decoded = jsonDecode(raw);
      List list = [];
      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map) {
        list = decoded.values.toList();
      }
      for (final g in list) {
        if (g is Map) {
          final gId = int.tryParse((g['id'] ?? '0').toString()) ?? 0;
          final groupTitle = (g['grp_name'] ?? g['title'] ?? g['name'] ?? g['n'] ?? 'Add-ons').toString();
          final min = int.tryParse((g['min'] ?? '0').toString()) ?? 0;
          final max = int.tryParse((g['max'] ?? '4').toString()) ?? 4;
          final rawChoices = g['items'] ?? g['choices'] ?? g['customizations'] ?? [];
          final choicesList = <_AddonChoice>[];
          if (rawChoices is List) {
            for (final c in rawChoices) {
              if (c is Map) {
                final cId = int.tryParse((c['id'] ?? '0').toString()) ?? 0;
                final cName = (c['name'] ?? c['n'] ?? '').toString();
                final cPrice = (c['price'] ?? c['p'] ?? c['prc'] ?? c['b'] ?? '0').toString();
                if (cName.isNotEmpty) {
                  choicesList.add(_AddonChoice(id: cId, name: cName, price: cPrice));
                }
              }
            }
          }
          _addonGroups.add(_AddonGroup(
            id: gId,
            title: groupTitle,
            min: min,
            max: max,
            choices: choicesList,
          ));
        }
      }
    } catch (_) {}
  }

  void _parseSpecialInstructions(dynamic raw) {
    _selectedSpecialInstructions.clear();
    if (raw == null) return;
    if (raw is List) {
      _selectedSpecialInstructions.addAll(raw.map((e) => e.toString().trim()).where((e) => e.isNotEmpty));
      return;
    }
    final s = raw.toString().trim();
    if (s.isEmpty || s == 'null' || s == '[]') return;
    try {
      final decoded = jsonDecode(s);
      if (decoded is List) {
        _selectedSpecialInstructions.addAll(decoded.map((e) => e.toString().trim()).where((e) => e.isNotEmpty));
      } else {
        _selectedSpecialInstructions.addAll(s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
      }
    } catch (_) {
      _selectedSpecialInstructions.addAll(s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
    }
  }

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item.name);
    _priceController = TextEditingController(text: item.price.toString());
    _shortCodeController = TextEditingController(text: item.shortCode);
    _portionController = TextEditingController(text: item.portion ?? '1 portion');
    _descriptionController = TextEditingController(text: item.shortDescription ?? '');
    _ingredientsController = TextEditingController(text: item.ingredients ?? '');
    _caloriesController = TextEditingController(text: item.calorificValue?.toString() ?? '0');
    _serviceTimeController = TextEditingController(text: item.serviceTime?.toString() ?? '15');

    if (item.vegType == 'non_veg' || item.vegType == 'nv') {
      _vegType = 'non_veg';
    } else if (item.vegType == 'na') {
      _vegType = 'na';
    } else {
      _vegType = 'veg';
    }

    _isAvailable = item.isAvailable;
    _isFrequentlySold = item.isFrequentlySold;
    _itemGroup = item.itemGroup.isEmpty ? 'STARTERS' : item.itemGroup;

    final storage = Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;
    _currentImageUrl = V6ApiMenuItem.resolveImageUrl(
      itemImage: item.imageUrl,
      treasureUrl: storage?.treasureUrl,
      restoId: storage?.restoId,
    );
    final defaultTax = storage?.taxTemplates.firstOrNull?.taxTmpl ?? 'GST @ 5%';
    if (item.taxTemplate.trim().isNotEmpty &&
        !item.taxTemplate.startsWith('[') &&
        !item.taxTemplate.startsWith('{')) {
      _taxTemplate = item.taxTemplate.trim();
    } else {
      _taxTemplate = defaultTax;
    }

    final kCats = storage?.kitchenCategories ?? [];
    final sCats = storage?.salesCategories ?? [];
    _kitchenCategory = item.kitchenCategory ?? (kCats.isNotEmpty ? kCats.first.itemKitchenCat : 'Main Kitchen');
    _salesCategory = item.salesCategory ?? (sCats.isNotEmpty ? sCats.first.itemSalesCat : 'Food');

    // Populate initial customizations
    _parseVariantsJson(item.variantsJson);
    _parseAddonsJson(item.addonsJson);
    _parseSpecialInstructions(item.specialInstructions);

    // Populate initial allergens
    _selectedAllergens.clear();
    if (item.allergens != null) {
      for (final a in item.allergens!) {
        final k = _normalizeAllergenToKey(a);
        if (k != null) _selectedAllergens.add(k);
      }
    }

    // Populate initial dietary tags
    _dietaryTags.clear();
    if (item.dietaryTags != null) {
      for (final t in item.dietaryTags!) {
        final lower = t.trim().toLowerCase();
        if (lower == 's' || lower == 'spicy') _dietaryTags.add('Spicy');
        if (lower == 'j' || lower == 'jain') _dietaryTags.add('Jain');
        if (lower == 'v' || lower == 'vegan') _dietaryTags.add('Vegan');
      }
    }

    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final controller = Get.find<ItemsController>();
      final fresh = await controller.getItemDetails(widget.item.id);
      if (fresh != null && mounted) {
        _populateFromDetails(fresh);
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  void _populateFromDetails(ItemModel fresh) {
    _nameController.text = fresh.name;
    _priceController.text = fresh.price.toString();
    _shortCodeController.text = fresh.shortCode;
    if (fresh.portion != null && fresh.portion!.isNotEmpty) {
      _portionController.text = fresh.portion!;
    }
    if (fresh.shortDescription != null && fresh.shortDescription!.isNotEmpty) {
      _descriptionController.text = fresh.shortDescription!;
    }
    if (fresh.ingredients != null && fresh.ingredients!.isNotEmpty) {
      _ingredientsController.text = fresh.ingredients!;
    }
    if (fresh.calorificValue != null) {
      _caloriesController.text = fresh.calorificValue.toString();
    }
    if (fresh.serviceTime != null) {
      _serviceTimeController.text = fresh.serviceTime.toString();
    }
    if (fresh.vegType == 'non_veg' || fresh.vegType == 'nv') {
      _vegType = 'non_veg';
    } else if (fresh.vegType == 'na') {
      _vegType = 'na';
    } else {
      _vegType = 'veg';
    }
    _isAvailable = fresh.isAvailable;
    _isFrequentlySold = fresh.isFrequentlySold;
    if (fresh.itemGroup.isNotEmpty) {
      _itemGroup = fresh.itemGroup;
    }
    if (fresh.kitchenCategory != null && fresh.kitchenCategory!.isNotEmpty) {
      _kitchenCategory = fresh.kitchenCategory!;
    }
    if (fresh.salesCategory != null && fresh.salesCategory!.isNotEmpty) {
      _salesCategory = fresh.salesCategory!;
    }
    if (fresh.imageUrl != null && fresh.imageUrl!.isNotEmpty) {
      final storage = Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;
      _currentImageUrl = V6ApiMenuItem.resolveImageUrl(
        itemImage: fresh.imageUrl,
        treasureUrl: storage?.treasureUrl,
        restoId: storage?.restoId,
      );
    }

    // Sync fresh customizations
    _parseVariantsJson(fresh.variantsJson);
    _parseAddonsJson(fresh.addonsJson);
    _parseSpecialInstructions(fresh.specialInstructions);

    // Sync fresh allergens
    _selectedAllergens.clear();
    if (fresh.allergens != null) {
      for (final a in fresh.allergens!) {
        final k = _normalizeAllergenToKey(a);
        if (k != null) _selectedAllergens.add(k);
      }
    }

    if (fresh.taxTemplate.trim().isNotEmpty &&
        !fresh.taxTemplate.startsWith('[') &&
        !fresh.taxTemplate.startsWith('{')) {
      _taxTemplate = fresh.taxTemplate.trim();
    }

    // Sync fresh dietary tags
    _dietaryTags.clear();
    if (fresh.dietaryTags != null) {
      for (final t in fresh.dietaryTags!) {
        final lower = t.trim().toLowerCase();
        if (lower == 's' || lower == 'spicy') _dietaryTags.add('Spicy');
        if (lower == 'j' || lower == 'jain') _dietaryTags.add('Jain');
        if (lower == 'v' || lower == 'vegan') _dietaryTags.add('Vegan');
      }
    }
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
    for (final v in _variants) {
      v.dispose();
    }
    for (final g in _addonGroups) {
      g.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    HapticFeedback.lightImpact();

    // 1. Bottom sheet to choose image source
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Text(
                  "Set Item Photo (Square 1:1)",
                  style: GoogleFonts.nunito(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 12.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: Color(0xFF2563EB)),
                  ),
                  title: Text(
                    "Choose from Gallery & Crop",
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 13.sp),
                  ),
                  subtitle: Text(
                    "Pick a photo and crop freely to 1:1 square",
                    style: GoogleFonts.nunito(fontSize: 10.5.sp, color: const Color(0xFF6B7280)),
                  ),
                  onTap: () => Navigator.of(ctx).pop('gallery'),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Color(0xFFDC2626)),
                  ),
                  title: Text(
                    "Take with Camera & Crop",
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 13.sp),
                  ),
                  subtitle: Text(
                    "Capture a photo and crop freely to 1:1 square",
                    style: GoogleFonts.nunito(fontSize: 10.5.sp, color: const Color(0xFF6B7280)),
                  ),
                  onTap: () => Navigator.of(ctx).pop('camera'),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(Icons.collections_rounded, color: Color(0xFFD97706)),
                  ),
                  title: Text(
                    "Select from Restaurant Gallery",
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 13.sp),
                  ),
                  subtitle: Text(
                    "Choose an already uploaded gallery image",
                    style: GoogleFonts.nunito(fontSize: 10.5.sp, color: const Color(0xFF6B7280)),
                  ),
                  onTap: () => Navigator.of(ctx).pop('resto_gallery'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (choice == null) return;

    if (choice == 'resto_gallery') {
      final selected = await Get.bottomSheet<List<String>>(
        GallerySelectionSheet(
          initialSelectedUrls: _currentImageUrl != null ? [_currentImageUrl!] : [],
          maxSelection: 1,
          mode: 'offer',
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );

      if (selected != null && selected.isNotEmpty) {
        setState(() {
          _currentImageUrl = selected.first;
          _localImagePath = null;
        });
        ToastService.showSuccess("Item photo updated from Restaurant Gallery!");
      }
      return;
    }

    final source = choice == 'camera' ? ImageSource.camera : ImageSource.gallery;
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 2400,
      maxHeight: 2400,
      imageQuality: 95,
    );

    if (pickedFile == null) return;

    final rawBytes = await pickedFile.readAsBytes();

    // 2. Open Enterprise Cropper with 1:1 Square locked ratio
    if (!mounted) return;
    final cropResult = await ImageCropperModal.open(
      context: context,
      bytes: rawBytes,
      tag: GalleryCropTag.item,
      fileName: pickedFile.name,
    );

    if (cropResult != null) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/item_${widget.item.id}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(cropResult.croppedBytes);

      setState(() {
        _localImagePath = tempFile.path;
      });

      HapticFeedback.selectionClick();
      ToastService.showSuccess("Item photo cropped to 1:1 Square!");
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<ItemsController>();
      final storage = Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;

      // 1. Resolve item_cat_id from controller.categoryNameToId
      int? catId = controller.categoryNameToId[_itemGroup.toUpperCase()];
      catId ??= 1;

      // 2. Resolve kitchen_cat_id from StorageService
      int? kitchenCatId;
      final kList = storage?.kitchenCategories ?? [];
      for (final k in kList) {
        if (k.itemKitchenCat.trim().toLowerCase() == _kitchenCategory.trim().toLowerCase()) {
          kitchenCatId = k.id;
          break;
        }
      }

      // 3. Resolve item_sales_cat_id from StorageService
      int? salesCatId;
      final sList = storage?.salesCategories ?? [];
      for (final s in sList) {
        if (s.itemSalesCat.trim().toLowerCase() == _salesCategory.trim().toLowerCase()) {
          salesCatId = s.id;
          break;
        }
      }

      // 4. Resolve item_tax_tmpl_id from StorageService
      final taxTmplId = storage?.getTaxTemplateId(_taxTemplate) ?? 1;

      final isNonVeg = _vegType == 'non_veg';

      // Serialize allergens (comma-separated for aik, and list)
      final aikStr = _selectedAllergens.join(',');

      // Serialize dietary tags (flags: s, j, v for item_att, and list)
      final attCodes = <String>[];
      if (_dietaryTags.contains('Spicy')) attCodes.add('s');
      if (_dietaryTags.contains('Jain')) attCodes.add('j');
      if (_dietaryTags.contains('Vegan')) attCodes.add('v');
      final attStr = attCodes.join(',');

      // Serialize special instructions
      final spInstJson = jsonEncode(_selectedSpecialInstructions.toList());

      // Serialize variants (Web & V6 standard format)
      String? vrntJson;
      final isVariant = _hasVariants && _variants.isNotEmpty;
      if (isVariant) {
        final vList = _variants
            .map((v) => {
                  'id': v.id,
                  'name': v.nameController.text.trim(),
                  'price': v.priceController.text.trim().isNotEmpty
                      ? v.priceController.text.trim()
                      : '0',
                  'is_default': v.isDefault ? 1 : 0,
                })
            .where((m) => m['name'].toString().isNotEmpty)
            .toList();
        if (vList.isNotEmpty) {
          vrntJson = jsonEncode(vList);
        }
      }

      // Serialize add-on groups (Web & V6 standard format)
      String? aoiJson;
      if (_addonGroups.isNotEmpty) {
        final aList = _addonGroups
            .map((g) {
              final choices = g.choices
                  .map((c) => {
                        'id': c.id,
                        'name': c.nameController.text.trim(),
                        'price': c.priceController.text.trim().isNotEmpty
                            ? c.priceController.text.trim()
                            : '0',
                      })
                  .where((c) => c['name'].toString().isNotEmpty)
                  .toList();
              return {
                'id': g.id,
                'grp_name': g.titleController.text.trim().isEmpty ? 'Add-ons' : g.titleController.text.trim(),
                'min': int.tryParse(g.minController.text.trim()) ?? 0,
                'max': int.tryParse(g.maxController.text.trim()) ?? (choices.isNotEmpty ? choices.length : 4),
                'items': choices,
              };
            })
            .where((g) => (g['items'] as List).isNotEmpty)
            .toList();
        if (aList.isNotEmpty) {
          aoiJson = jsonEncode(aList);
        }
      }

      final updatedData = <String, dynamic>{
        'item_name': _nameController.text.trim(),
        'name': _nameController.text.trim(),
        'item_cat_id': catId,
        'item_price': double.parse(_priceController.text.trim()),
        'price': double.parse(_priceController.text.trim()),
        'item_short_name': _shortCodeController.text.trim(),
        'short_code': _shortCodeController.text.trim(),
        'portion': _portionController.text.trim(),
        'veg_type': isNonVeg ? 'non_veg' : (_vegType == 'na' ? 'na' : 'veg'),
        'is_nonveg': isNonVeg ? 1 : 0,
        'is_available': _isAvailable,
        'is_na': _isAvailable ? 0 : 1,
        'is_frequently_sold': _isFrequentlySold,
        'is_fsi': _isFrequentlySold ? 1 : 0,
        'item_group': _itemGroup,
        'category_name': _itemGroup,
        'short_description': _descriptionController.text.trim(),
        'short_desc': _descriptionController.text.trim(),
        'ingredients': _ingredientsController.text.trim(),
        'calorific_value': int.tryParse(_caloriesController.text.trim()),
        'cal': int.tryParse(_caloriesController.text.trim()),
        'service_time': int.tryParse(_serviceTimeController.text.trim()),
        'delivery_time': _serviceTimeController.text.trim(),
        'kitchen_category': _kitchenCategory,
        if (kitchenCatId != null) 'kitchen_cat_id': kitchenCatId,
        'sales_category': _salesCategory,
        if (salesCatId != null) 'item_sales_cat_id': salesCatId,
        'item_tax_tmpl_id': taxTmplId,
        'tax_tmpl_mast_id': taxTmplId,
        'tax_template': _taxTemplate,
        'aik': aikStr,
        'allergens': _selectedAllergens.toList(),
        'item_att': attStr,
        'dietary_tags': _dietaryTags.toList(),
        'sp_inst': spInstJson,
        'is_variant': isVariant ? 1 : 0,
        'vrnt_json': vrntJson ?? '[]',
        'vrnt': vrntJson ?? '[]',
        'aoi_json': aoiJson ?? '[]',
        'aoi': aoiJson ?? '[]',
        if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) 'image_url': _currentImageUrl,
        if (_localImagePath != null) ...{
          'image_url': _localImagePath,
          'image_change': 1,
        },
      };

      controller.updateItemDetails(
        widget.item.id,
        updatedData,
        imageFile: _localImagePath != null ? File(_localImagePath!) : null,
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDetails) {
      return _buildShimmerSkeleton(context);
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // Drawer Header
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Row(
              children: [
                // Thumb
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: const Color(0xFFF3F4F6),
                    ),
                    child: _localImagePath != null
                        ? Image.file(File(_localImagePath!), fit: BoxFit.cover)
                        : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: _currentImageUrl!,
                                fit: BoxFit.cover,
                                errorListener: (_) {},
                                errorWidget: (_, __, ___) => _buildFallbackThumbnail(),
                              )
                            : _buildFallbackThumbnail()),
                  ),
                ),
                SizedBox(width: 10.w),

                // Name + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameController.text.isEmpty ? widget.item.name : _nameController.text,
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "$_itemGroup · ${_shortCodeController.text} · ${_portionController.text}",
                        style: GoogleFonts.nunito(
                          fontSize: 10.sp,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),

                // Close Button
                IconButton(
                  icon: Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 14.sp, color: const Color(0xFF6B7280)),
                  ),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Scrollable Form Sections
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // SECTION 1: IMAGE (first)
                    _buildDrawerSection(
                      title: "Image",
                      titleIcon: Icons.image_outlined,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 100.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5.w),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: _localImagePath != null
                                        ? Image.file(
                                            File(_localImagePath!),
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: _currentImageUrl!,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                errorListener: (_) {},
                                                placeholder: (context, url) => Container(
                                                  color: const Color(0xFFF3F4F6),
                                                  child: const Center(
                                                    child: SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: AppColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) =>
                                                    _buildFallbackBanner(),
                                              )
                                            : _buildFallbackBanner()),
                                  ),
                                  Positioned(
                                    bottom: 6.h,
                                    right: 6.w,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.65),
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.camera_alt_rounded, size: 11.sp, color: Colors.white),
                                          SizedBox(width: 4.w),
                                          Text(
                                            _localImagePath != null || (_currentImageUrl != null && _currentImageUrl!.isNotEmpty)
                                                ? "Change Photo"
                                                : "Upload Photo",
                                            style: GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "JPG, PNG, WEBP · Max 5 MB · 1:1 Square Crop",
                            style: GoogleFonts.nunito(
                              fontSize: 9.sp,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SECTION 2: SPECIAL INSTRUCTIONS (second)
                    _buildDrawerSection(
                      title: "Special Instructions",
                      titleIcon: Icons.notes_rounded,
                      headerAction: Text(
                        "↔ Pick from list",
                        style: GoogleFonts.nunito(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add_circle_outline_rounded, size: 13.sp, color: AppColors.primary),
                              SizedBox(width: 6.w),
                              Text(
                                "Add custom",
                                style: GoogleFonts.nunito(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "None yet. Use Pick from list above, or add a custom one.",
                            style: GoogleFonts.nunito(
                              fontSize: 11.sp,
                              color: const Color(0xFF9CA3AF),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SECTION 3: IDENTITY
                    _buildDrawerSection(
                      title: "Identity",
                      titleIcon: Icons.person_outline_rounded,
                      child: Column(
                        children: [
                          _buildFieldLabel("ITEM NAME", isRequired: true),
                          SizedBox(height: 4.h),
                          TextFormField(
                            controller: _nameController,
                            style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF111827)),
                            decoration: _buildInputDecoration(),
                            validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
                            onChanged: (_) => setState(() {}),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel("SHORT CODE"),
                                    SizedBox(height: 4.h),
                                    TextFormField(
                                      controller: _shortCodeController,
                                      style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF111827)),
                                      decoration: _buildInputDecoration(),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel("VEG / NON-VEG", isRequired: true),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        _buildVegPill("veg", "Veg", const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
                                        SizedBox(width: 4.w),
                                        _buildVegPill("non_veg", "Non-Veg", const Color(0xFFC1272D), const Color(0xFFFEF2F2)),
                                        SizedBox(width: 4.w),
                                        _buildVegPill("na", "N/A", const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // SECTION 4: STATUS
                    _buildDrawerSection(
                      title: "Status",
                      titleIcon: Icons.check_circle_outline_rounded,
                      child: Column(
                        children: [
                          _buildToggleRow(
                            icon: Icons.check_rounded,
                            iconBg: const Color(0xFFF0FDF4),
                            iconFg: const Color(0xFF16A34A),
                            title: "Available",
                            subtitle: "Item is shown on the customer menu and can be ordered.",
                            value: _isAvailable,
                            onChanged: (val) => setState(() => _isAvailable = val),
                          ),
                          const Divider(height: 1, color: Color(0xFFF3F4F6)),
                          _buildToggleRow(
                            icon: Icons.star_rounded,
                            iconBg: const Color(0xFFFEF9C3),
                            iconFg: const Color(0xFFCA8A04),
                            title: "Frequently Sold",
                            subtitle: "Pinned to the top of its category for quick ordering.",
                            value: _isFrequentlySold,
                            onChanged: (val) => setState(() => _isFrequentlySold = val),
                          ),
                        ],
                      ),
                    ),

                    // SECTION 5: GROUP & TAX
                    Builder(builder: (context) {
                      final itemsCtrl = Get.isRegistered<ItemsController>() ? Get.find<ItemsController>() : null;
                      final storage = Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;

                      final availableGroups = <String>{
                        if (_itemGroup.trim().isNotEmpty) _itemGroup.trim(),
                        if (itemsCtrl != null) ...itemsCtrl.categoriesList.map((c) => c.trim()),
                        'MOCKTAILS', 'AERATED', 'STARTERS', 'MAIN COURSE', 'RICE', 'SOUPS', 'DESSERT', 'DAL',
                      }.toList();

                      final availableTaxes = <String>{
                        if (_taxTemplate.trim().isNotEmpty &&
                            !_taxTemplate.startsWith('[') &&
                            !_taxTemplate.startsWith('{'))
                          _taxTemplate.trim(),
                        if (storage != null)
                          ...storage.taxTemplates.map((t) => t.taxTmpl.trim()).where((t) => t.isNotEmpty),
                        'GST @ 5%',
                      }.toList();

                      final selectedTax = availableTaxes.contains(_taxTemplate)
                          ? _taxTemplate
                          : availableTaxes.first;

                      final availableKitchens = <String>{
                        if (_kitchenCategory.trim().isNotEmpty) _kitchenCategory.trim(),
                        if (storage != null) ...storage.kitchenCategories.map((k) => k.itemKitchenCat.trim()).where((k) => k.isNotEmpty),
                        'Main Kitchen', 'Tandoor', 'Bar / Beverages', 'Chinese', 'Continental',
                      }.toList();

                      final availableSalesCats = <String>{
                        if (_salesCategory.trim().isNotEmpty) _salesCategory.trim(),
                        if (storage != null) ...storage.salesCategories.map((s) => s.itemSalesCat.trim()).where((s) => s.isNotEmpty),
                        'Food', 'Beverages', 'Liquor', 'Dine-In Special', 'Takeaway Offer',
                      }.toList();

                      return _buildDrawerSection(
                        title: "Group & Tax",
                        titleIcon: Icons.shopping_bag_outlined,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel("ITEM GROUP", isRequired: true),
                                      SizedBox(height: 4.h),
                                      _buildDropdown(
                                        value: _itemGroup,
                                        items: availableGroups,
                                        onChanged: (val) => setState(() => _itemGroup = val ?? _itemGroup),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel("TAX TEMPLATE", isRequired: true),
                                      SizedBox(height: 4.h),
                                      _buildDropdown(
                                        value: selectedTax,
                                        items: availableTaxes,
                                        onChanged: (val) => setState(() => _taxTemplate = val ?? _taxTemplate),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel("KITCHEN CATEGORY"),
                                      SizedBox(height: 4.h),
                                      _buildDropdown(
                                        value: _kitchenCategory,
                                        items: availableKitchens,
                                        onChanged: (val) => setState(() => _kitchenCategory = val ?? _kitchenCategory),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel("SALES CATEGORY"),
                                      SizedBox(height: 4.h),
                                      _buildDropdown(
                                        value: _salesCategory,
                                        items: availableSalesCats,
                                        onChanged: (val) => setState(() => _salesCategory = val ?? _salesCategory),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    // SECTION 6: PRICING & PORTION
                    _buildDrawerSection(
                      title: "Pricing & Portion",
                      titleIcon: Icons.sell_outlined,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel("PRICE (₹)", isRequired: true),
                                    SizedBox(height: 4.h),
                                    TextFormField(
                                      controller: _priceController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF111827)),
                                      decoration: _buildInputDecoration(),
                                      validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel("SERVICE TIME"),
                                    SizedBox(height: 4.h),
                                    TextFormField(
                                      controller: _serviceTimeController,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF111827)),
                                      decoration: _buildInputDecoration(hint: "min"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel("SIZE / QTY / PORTION"),
                                    SizedBox(height: 4.h),
                                    TextFormField(
                                      controller: _portionController,
                                      style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF111827)),
                                      decoration: _buildInputDecoration(),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel("CALORIFIC VALUE"),
                                    SizedBox(height: 4.h),
                                    TextFormField(
                                      controller: _caloriesController,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF111827)),
                                      decoration: _buildInputDecoration(hint: "kcal"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // SECTION 6.1: VARIANTS
                    _buildVariantsSection(),

                    // SECTION 6.2: ADD-ONS / EXTRA GROUPS
                    _buildAddonsSection(),

                    // SECTION 7: DIETARY TAGS
                    _buildDrawerSection(
                      title: "Dietary Tags",
                      titleIcon: Icons.favorite_border_rounded,
                      child: Row(
                        children: [
                          _buildDietaryTag("Spicy", "Spicy", icon: Icons.local_fire_department_rounded),
                          SizedBox(width: 8.w),
                          _buildDietaryTag("Jain", "Jain"),
                          SizedBox(width: 8.w),
                          _buildDietaryTag("Vegan", "Vegan", icon: Icons.eco_rounded),
                        ],
                      ),
                    ),

                    // SECTION 8: DESCRIPTION & NOTES
                    _buildDrawerSection(
                      title: "Description & Notes",
                      titleIcon: Icons.description_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("INGREDIENTS"),
                          SizedBox(height: 4.h),
                          TextFormField(
                            controller: _ingredientsController,
                            maxLines: 2,
                            style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF111827)),
                            decoration: _buildInputDecoration(hint: "e.g. Lime juice, soda water, mint leaves, sugar, salt"),
                          ),
                          SizedBox(height: 10.h),
                          _buildFieldLabel("SHORT DESCRIPTION"),
                          SizedBox(height: 4.h),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 2,
                            style: GoogleFonts.nunito(fontSize: 13.sp, color: const Color(0xFF111827)),
                            decoration: _buildInputDecoration(),
                          ),
                        ],
                      ),
                    ),

                    // SECTION 9: ALLERGENS
                    _buildDrawerSection(
                      title: "Allergens",
                      titleIcon: Icons.warning_amber_rounded,
                      headerAction: Text(
                        "FSSAI (8 Mandated)",
                        style: GoogleFonts.nunito(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6.w,
                          mainAxisSpacing: 6.h,
                          childAspectRatio: 3.3,
                        ),
                        itemCount: kFssaiAllergens.length,
                        itemBuilder: (context, index) {
                          final item = kFssaiAllergens[index];
                          final isSelected = _selectedAllergens.contains(item.key);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedAllergens.remove(item.key);
                                } else {
                                  _selectedAllergens.add(item.key);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFFD97706) : const Color(0xFFE5E7EB),
                                  width: 1.5.w,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(item.icon, style: TextStyle(fontSize: 13.sp)),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: GoogleFonts.nunito(
                                        fontSize: 10.5.sp,
                                        color: isSelected ? const Color(0xFFD97706) : const Color(0xFF374151),
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: 14.w,
                                    height: 14.h,
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFD97706) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(3.r),
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFFD97706) : const Color(0xFFD1D5DB),
                                        width: 1.5.w,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: isSelected
                                        ? Icon(Icons.check_rounded, size: 10.sp, color: Colors.white)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // SECTION 10: ROUTING & SPECIAL INSTRUCTIONS (From Login Sync Cache)
                    Builder(builder: (context) {
                      final storage = Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;
                      final availableKitchen = <String>{
                        if (_kitchenCategory.trim().isNotEmpty) _kitchenCategory.trim(),
                        ...(storage?.kitchenCategories.map((e) => e.itemKitchenCat.trim()).where((e) => e.isNotEmpty) ?? []),
                        'Main Kitchen', 'Tandoor', 'Bar / Beverages',
                      }.toList();

                      final selectedKitchen = availableKitchen.contains(_kitchenCategory)
                          ? _kitchenCategory
                          : (availableKitchen.isNotEmpty ? availableKitchen.first : null);

                      final availableSales = <String>{
                        if (_salesCategory.trim().isNotEmpty) _salesCategory.trim(),
                        ...(storage?.salesCategories.map((e) => e.itemSalesCat.trim()).where((e) => e.isNotEmpty) ?? []),
                        'Food', 'Beverages', 'Liquor',
                      }.toList();

                      final selectedSales = availableSales.contains(_salesCategory)
                          ? _salesCategory
                          : (availableSales.isNotEmpty ? availableSales.first : null);

                      final specialNotes = (storage?.specialInstructions.map((e) => e.spInst).toList() ?? [])
                          .where((e) => e.isNotEmpty)
                          .toList();

                      return _buildDrawerSection(
                        title: "Station Routing & Preparation",
                        titleIcon: Icons.alt_route_rounded,
                        headerAction: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "Offline Cached",
                            style: GoogleFonts.nunito(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel("KITCHEN CATEGORY (KOT)"),
                                      SizedBox(height: 4.h),
                                      DropdownButtonFormField<String>(
                                        value: selectedKitchen,
                                        items: availableKitchen
                                            .map((c) => DropdownMenuItem(
                                                  value: c,
                                                  child: Text(
                                                    c,
                                                    style: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF111827)),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) setState(() => _kitchenCategory = val);
                                        },
                                        decoration: _buildInputDecoration(),
                                        isExpanded: true,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel("SALES CATEGORY (POS)"),
                                      SizedBox(height: 4.h),
                                      DropdownButtonFormField<String>(
                                        value: selectedSales,
                                        items: availableSales
                                            .map((c) => DropdownMenuItem(
                                                  value: c,
                                                  child: Text(
                                                    c,
                                                    style: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF111827)),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) setState(() => _salesCategory = val);
                                        },
                                        decoration: _buildInputDecoration(),
                                        isExpanded: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (specialNotes.isNotEmpty) ...[
                              SizedBox(height: 12.h),
                              _buildFieldLabel("COMMON PREPARATION INSTRUCTIONS"),
                              SizedBox(height: 6.h),
                              Wrap(
                                spacing: 6.w,
                                runSpacing: 6.h,
                                children: specialNotes.map((inst) {
                                  final isSelected = _selectedSpecialInstructions.contains(inst);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedSpecialInstructions.remove(inst);
                                        } else {
                                          _selectedSpecialInstructions.add(inst);
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFFEF2F2) : const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(6.r),
                                        border: Border.all(
                                          color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isSelected) ...[
                                            Icon(Icons.check, size: 12.sp, color: AppColors.primary),
                                            SizedBox(width: 4.w),
                                          ],
                                          Text(
                                            inst,
                                            style: GoogleFonts.nunito(
                                              fontSize: 10.5.sp,
                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                              color: isSelected ? AppColors.primary : const Color(0xFF374151),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),

          // Save Bar
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F6),
                      foregroundColor: const Color(0xFF6B7280),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      "Duplicate",
                      style: GoogleFonts.nunito(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_rounded, size: 14.sp, color: Colors.white),
                        SizedBox(width: 5.w),
                        Text(
                          "Save Changes",
                          style: GoogleFonts.nunito(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);
}

  Widget _buildVariantsSection() {
    return _buildDrawerSection(
      title: "Variants",
      titleIcon: Icons.layers_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _hasVariants = !_hasVariants;
                if (_hasVariants && _variants.isEmpty) {
                  _variants.add(_VariantItem(name: "Regular", price: _priceController.text.trim(), isDefault: true));
                }
              });
            },
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Checkbox(
                    value: _hasVariants,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                    onChanged: (val) {
                      setState(() {
                        _hasVariants = val ?? false;
                        if (_hasVariants && _variants.isEmpty) {
                          _variants.add(_VariantItem(name: "Regular", price: _priceController.text.trim(), isDefault: true));
                        }
                      });
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "Item has multiple Variants",
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
          if (_hasVariants) ...[
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Item Variants",
                  style: GoogleFonts.nunito(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF374151),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _variants.add(_VariantItem(
                        name: "",
                        price: _priceController.text.trim(),
                        isDefault: _variants.isEmpty,
                      ));
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: const Color(0xFFFCA5A5), width: 1.5),
                    ),
                    child: Text(
                      "+ Add Variant",
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
            SizedBox(height: 8.h),
            // Header row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "VARIANT NAME",
                      style: GoogleFonts.nunito(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80.w,
                    child: Text(
                      "PRICE (₹)",
                      style: GoogleFonts.nunito(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      "DEFAULT",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  SizedBox(width: 32.w),
                ],
              ),
            ),
            SizedBox(height: 6.h),
            // Variant rows
            ..._variants.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: item.nameController,
                        style: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF111827)),
                        decoration: _buildInputDecoration(hint: "e.g. Regular / Large"),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: item.priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF111827)),
                        decoration: _buildInputDecoration(hint: "0.00"),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    SizedBox(
                      width: 50.w,
                      child: Center(
                        child: Radio<int>(
                          value: idx,
                          groupValue: _variants.indexWhere((v) => v.isDefault),
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            setState(() {
                              for (var i = 0; i < _variants.length; i++) {
                                _variants[i].isDefault = (i == idx);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          final wasDefault = item.isDefault;
                          item.dispose();
                          _variants.removeAt(idx);
                          if (wasDefault && _variants.isNotEmpty) {
                            _variants.first.isDefault = true;
                          }
                        });
                      },
                      child: Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(Icons.close_rounded, size: 14.sp, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildAddonsSection() {
    return _buildDrawerSection(
      title: "Add-Ons / Extra Groups",
      titleIcon: Icons.add_circle_outline_rounded,
      headerAction: GestureDetector(
        onTap: () {
          setState(() {
            _addonGroups.add(_AddonGroup(
              title: "Add-ons",
              min: 0,
              max: 4,
              choices: [
                _AddonChoice(name: "", price: "0.00"),
              ],
            ));
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: const Color(0xFFFCA5A5), width: 1.5),
          ),
          child: Text(
            "+ Add Group",
            style: GoogleFonts.nunito(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_addonGroups.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                "No add-on groups added yet. Tap '+ Add Group' to create choices like extra toppings, dips, cheese, etc.",
                style: GoogleFonts.nunito(
                  fontSize: 11.sp,
                  color: const Color(0xFF9CA3AF),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ..._addonGroups.asMap().entries.map((gEntry) {
            final gIdx = gEntry.key;
            final group = gEntry.value;

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5.w),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  // Group header
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(9.r)),
                      border: const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: group.titleController,
                            style: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                            decoration: _buildInputDecoration(hint: "Group Title e.g. Add-ons / Dips"),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              group.dispose();
                              _addonGroups.removeAt(gIdx);
                            });
                          },
                          child: Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(Icons.delete_outline_rounded, size: 14.sp, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Selection Rules
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFAFAFA),
                      border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Selection Rules:",
                          style: GoogleFonts.nunito(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Min",
                          style: GoogleFonts.nunito(fontSize: 10.sp, color: const Color(0xFF9CA3AF)),
                        ),
                        SizedBox(width: 4.w),
                        SizedBox(
                          width: 42.w,
                          child: TextFormField(
                            controller: group.minController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(fontSize: 11.sp, color: const Color(0xFF111827)),
                            decoration: _buildInputDecoration(hint: "0"),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Max",
                          style: GoogleFonts.nunito(fontSize: 10.sp, color: const Color(0xFF9CA3AF)),
                        ),
                        SizedBox(width: 4.w),
                        SizedBox(
                          width: 42.w,
                          child: TextFormField(
                            controller: group.maxController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(fontSize: 11.sp, color: const Color(0xFF111827)),
                            decoration: _buildInputDecoration(hint: "1"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Options table header
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "OPTION NAME",
                            style: GoogleFonts.nunito(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80.w,
                          child: Text(
                            "EXTRA PRICE (₹)",
                            style: GoogleFonts.nunito(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                        SizedBox(width: 28.w),
                      ],
                    ),
                  ),

                  // Choices list
                  ...group.choices.asMap().entries.map((cEntry) {
                    final cIdx = cEntry.key;
                    final choice = cEntry.value;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: choice.nameController,
                              style: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF111827)),
                              decoration: _buildInputDecoration(hint: "e.g. Extra Cheese"),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          SizedBox(
                            width: 80.w,
                            child: TextFormField(
                              controller: choice.priceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF111827)),
                              decoration: _buildInputDecoration(hint: "0.00"),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                choice.dispose();
                                group.choices.removeAt(cIdx);
                              });
                            },
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Icon(Icons.close_rounded, size: 12.sp, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Add Option button
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            group.choices.add(_AddonChoice(name: "", price: "0.00"));
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "⊕",
                              style: TextStyle(fontSize: 13.sp, color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Add Choice / Option",
                              style: GoogleFonts.nunito(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerSection({
    required String title,
    required IconData titleIcon,
    Widget? headerAction,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(titleIcon, size: 12.sp, color: const Color(0xFF9CA3AF)),
                  SizedBox(width: 6.w),
                  Text(
                    title.toUpperCase(),
                    style: GoogleFonts.nunito(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9CA3AF),
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              if (headerAction != null) headerAction,
            ],
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: GoogleFonts.nunito(
          fontSize: 10.sp,
          color: const Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
        ),
        children: [
          if (isRequired)
            TextSpan(
              text: " *",
              style: GoogleFonts.nunito(color: AppColors.primary),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _buildVegPill(String code, String label, Color color, Color bg) {
    final isSelected = _vegType == code;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _vegType = code),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7.h),
          decoration: BoxDecoration(
            color: isSelected ? bg : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? color : const Color(0xFFE5E7EB),
              width: 1.5.w,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? color : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Icon(icon, size: 14.sp, color: iconFg),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 10.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: value ? const Color(0xFF16A34A) : const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    left: value ? 23.w : 3.w,
                    top: 3.h,
                    child: Container(
                      width: 18.w,
                      height: 18.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final uniqueItems = items.where((e) => e.trim().isNotEmpty).toSet().toList();
    final cleanVal = value.trim();
    if (cleanVal.isNotEmpty && !uniqueItems.contains(cleanVal)) {
      uniqueItems.insert(0, cleanVal);
    }
    final selectedVal = uniqueItems.contains(cleanVal)
        ? cleanVal
        : (uniqueItems.isNotEmpty ? uniqueItems.first : null);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedVal,
          isExpanded: true,
          style: GoogleFonts.nunito(fontSize: 12.sp, color: const Color(0xFF111827)),
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 16.sp, color: const Color(0xFF9CA3AF)),
          items: uniqueItems
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDietaryTag(String keyName, String label, {IconData? icon}) {
    final isSelected = _dietaryTags.contains(keyName);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _dietaryTags.remove(keyName);
          } else {
            _dietaryTags.add(keyName);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFEF2F2) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: 1.5.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
                  width: 1.5.w,
                ),
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Icon(Icons.check_rounded, size: 10.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 5.w),
            if (icon != null) ...[
              Icon(icon, size: 13.sp, color: isSelected ? AppColors.primary : const Color(0xFF6B7280)),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackThumbnail() {
    final isVeg = _vegType == 'veg';
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isVeg
              ? [const Color(0xFFD1FAE5), const Color(0xFFA7F3D0)]
              : [const Color(0xFFFECDD3), const Color(0xFFFDA4AF)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          color: isVeg ? const Color(0xFF059669) : const Color(0xFFBE123C),
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildFallbackBanner() {
    final isVeg = _vegType == 'veg';
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isVeg
              ? [const Color(0xFFD1FAE5), const Color(0xFFA7F3D0)]
              : [const Color(0xFFFECDD3), const Color(0xFFF87171)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 42.sp,
          color: (isVeg ? const Color(0xFF059669) : AppColors.primary).withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildShimmerSkeleton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Shimmer Header
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: const Color(0xFFE5E7EB),
                      highlightColor: const Color(0xFFF9FAFB),
                      child: Container(
                        width: 42.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: const Color(0xFFE5E7EB),
                        highlightColor: const Color(0xFFF9FAFB),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 160.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              width: 100.w,
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close_rounded, size: 14.sp, color: const Color(0xFF6B7280)),
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),

              // Shimmer Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Shimmer.fromColors(
                    baseColor: const Color(0xFFE5E7EB),
                    highlightColor: const Color(0xFFF9FAFB),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image banner skeleton
                          Container(
                            width: double.infinity,
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Section label skeleton
                          Container(
                            width: 80.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Short code & Veg pills skeleton
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Categorization skeleton
                          Container(
                            width: double.infinity,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Container(
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Pricing & portion skeleton
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Container(
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Description skeleton
                          Container(
                            width: double.infinity,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Save Bar Skeleton
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
                ),
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFFE5E7EB),
                  highlightColor: const Color(0xFFF9FAFB),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
