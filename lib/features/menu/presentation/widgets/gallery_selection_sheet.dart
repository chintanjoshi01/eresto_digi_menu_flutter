import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/gallery_remote_datasource.dart';
import '../../domain/models/channel_session_group_model.dart';
import 'image_cropper_modal.dart';

class GalleryItem {
  final String id;
  final String url;
  final String fallbackUrl;
  final String type; // 'splash', 'offer', 'slider'
  final String title;

  const GalleryItem({
    required this.id,
    required this.url,
    required this.fallbackUrl,
    required this.type,
    required this.title,
  });
}

/// Gallery selection bottom sheet matching Screenshot 4 with dynamic V6 Gallery fetch,
/// tag-specific Image Picking, Precision Aspect-Ratio Cropping, and Multipart Upload.
class GallerySelectionSheet extends StatefulWidget {
  final List<String> initialSelectedUrls;
  final int maxSelection;
  final String mode; // 'offer' or 'splash' or 'slider'

  const GallerySelectionSheet({
    super.key,
    required this.initialSelectedUrls,
    this.maxSelection = 10,
    this.mode = 'offer',
  });

  static const List<GalleryItem> fallbackGalleryItems = [
    GalleryItem(
      id: 'off_1',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/off_1.webp',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/off_1.png',
      type: 'offer',
      title: 'Get 30% OFF Combo Offer',
    ),
    GalleryItem(
      id: 'off_1759992043_0',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/off_1759992043_0.webp',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/off_1759992043_0.jpeg',
      type: 'offer',
      title: '30% OFF Special Offer',
    ),
    GalleryItem(
      id: 'off_1765375391_069397d9f99aee',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/off_1765375391_069397d9f99aee.webp',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/off_1765375391_069397d9f99aee.png',
      type: 'offer',
      title: 'Port\'O Pizza Slice of Heaven',
    ),
    GalleryItem(
      id: 'off_2',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/off_2.webp',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/off_2.png',
      type: 'offer',
      title: 'Port\'O Pizza Orange',
    ),
    GalleryItem(
      id: 'sp_1768571424_0696a42204fe45',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1768571424_0696a42204fe45.png',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1768571424_0696a42204fe45.png',
      type: 'splash',
      title: 'Opening Promo Special',
    ),
    GalleryItem(
      id: 'sp_1751001978_0',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1751001978_0.webp',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1751001978_0.png',
      type: 'splash',
      title: 'Feast Unlimited June',
    ),
    GalleryItem(
      id: 'sp_1751720499_0',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1751720499_0.webp',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1751720499_0.png',
      type: 'splash',
      title: 'Unlimited Food 529',
    ),
    GalleryItem(
      id: 'sp_1759991117_0',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1759991117_0.webp',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sp_1759991117_0.png',
      type: 'splash',
      title: 'Unlimited Food Feast',
    ),
    GalleryItem(
      id: 'sl_1758873309_0',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sl_1758873309_0.webp',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sl_1758873309_0.jpg',
      type: 'slider',
      title: 'Chef Special Slider',
    ),
    GalleryItem(
      id: 'sl_1759991769_0',
      url: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sl_1759991769_0.webp',
      fallbackUrl: 'https://assets.eresto.app/public/treasure/85/archive/gallery/sl_1759991769_0.png',
      type: 'slider',
      title: 'Slider Welcome Promo',
    ),
  ];

  @override
  State<GallerySelectionSheet> createState() => _GallerySelectionSheetState();
}

class _GallerySelectionSheetState extends State<GallerySelectionSheet> {
  late Set<String> _selectedUrls;
  late String _activeFilter; // 'splash', 'offer', 'slider'
  late final GalleryRemoteDataSource _galleryDataSource;

  final List<GalleryItem> _liveItems = [];
  bool _isLoadingGallery = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadStatusText = '';

  @override
  void initState() {
    super.initState();
    _selectedUrls = Set<String>.from(widget.initialSelectedUrls);
    _activeFilter = widget.mode;

    final apiClient = Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : ApiClient();
    _galleryDataSource = GalleryRemoteDataSourceImpl(apiClient);

    _fetchLiveGallery();
  }

  Future<void> _fetchLiveGallery() async {
    setState(() => _isLoadingGallery = true);
    try {
      final names = await _galleryDataSource.getGalleryImages();
      if (mounted) {
        final currentRestoId = Get.isRegistered<StorageService>() ? Get.find<StorageService>().restoId : 0;
        final restoId = currentRestoId > 0 ? currentRestoId : null;

        final fetched = <GalleryItem>[];
        for (final name in names) {
          final clean = name.trim();
          if (clean.isEmpty) continue;

          String type = 'general';
          if (clean.startsWith('sp_') || clean.startsWith('spl_') || clean.contains('splash')) {
            type = 'splash';
          } else if (clean.startsWith('off_') || clean.startsWith('offer_') || clean.contains('offer')) {
            type = 'offer';
          } else if (clean.startsWith('sl_') || clean.contains('slider')) {
            type = 'slider';
          }

          final url = SessionCardModel.resolveGalleryUrl(clean, restoId);
          fetched.add(GalleryItem(
            id: clean,
            url: url,
            fallbackUrl: url,
            type: type,
            title: clean,
          ));
        }

        setState(() {
          _liveItems.clear();
          _liveItems.addAll(fetched);
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingGallery = false);
    }
  }

  List<GalleryItem> get _filteredItems {
    final currentRestoId = Get.isRegistered<StorageService>() ? Get.find<StorageService>().restoId : 0;

    final items = <GalleryItem>[..._liveItems];
    // Only inject fallback items if explicitly running in mock/demo mode for restaurant 85 and fetch is empty
    if (items.isEmpty && currentRestoId == 85) {
      items.addAll(GallerySelectionSheet.fallbackGalleryItems);
    }

    return items.where((item) {
      if (item.type == 'general') return true;
      return item.type == _activeFilter;
    }).toList();
  }

  void _toggleItem(GalleryItem item) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedUrls.contains(item.url)) {
        _selectedUrls.remove(item.url);
      } else {
        if (_selectedUrls.length >= widget.maxSelection) {
          Get.snackbar(
            "Selection Limit",
            "Maximum ${widget.maxSelection} images can be selected",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF111827),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            margin: EdgeInsets.all(12.w),
          );
          return;
        }
        _selectedUrls.add(item.url);
      }
    });
  }

  Future<void> _pickAndUploadImage() async {
    HapticFeedback.lightImpact();

    // 1. Prompt user: Camera vs Gallery
    final source = await showModalBottomSheet<ImageSource>(
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
                  "Upload Image (${_activeFilter.toUpperCase()})",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
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
                    "Choose from Gallery",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13.sp),
                  ),
                  subtitle: Text(
                    "Select a photo from device storage",
                    style: GoogleFonts.poppins(fontSize: 10.5.sp, color: const Color(0xFF6B7280)),
                  ),
                  onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
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
                    "Take with Camera",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13.sp),
                  ),
                  subtitle: Text(
                    "Capture a new photo with camera",
                    style: GoogleFonts.poppins(fontSize: 10.5.sp, color: const Color(0xFF6B7280)),
                  ),
                  onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 2400,
        maxHeight: 2400,
        imageQuality: 95,
      );

      if (picked == null) return;

      final rawBytes = await picked.readAsBytes();

      // 2. Open Enterprise Cropper with Tag Aspect Ratio
      final cropTag = _activeFilter == 'splash'
          ? GalleryCropTag.splash
          : _activeFilter == 'slider'
              ? GalleryCropTag.slider
              : GalleryCropTag.offer;

      if (!mounted) return;
      final cropResult = await ImageCropperModal.open(
        context: context,
        bytes: rawBytes,
        tag: cropTag,
        fileName: picked.name,
      );

      if (cropResult == null) return;

      // 3. Upload to /api/v4/upload_resto_gallery_neo
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.05;
        _uploadStatusText = "Uploading ${cropResult.formattedFileSize} to Gallery...";
      });

      final uploadResult = await _galleryDataSource.uploadGalleryImage(
        imageBytes: cropResult.croppedBytes,
        fileName: "upload_${DateTime.now().millisecondsSinceEpoch}.jpg",
        type: _activeFilter,
        onSendProgress: (sent, total) {
          if (total > 0 && mounted) {
            setState(() {
              _uploadProgress = sent / total;
              _uploadStatusText = "Uploading ${(_uploadProgress * 100).toStringAsFixed(0)}%...";
            });
          }
        },
      );

      if (uploadResult.success) {
        HapticFeedback.heavyImpact();
        ToastService.showSuccess("Image uploaded successfully!");

        final newItem = GalleryItem(
          id: uploadResult.fileName,
          url: uploadResult.fullUrl,
          fallbackUrl: uploadResult.fullUrl,
          type: _activeFilter,
          title: uploadResult.fileName,
        );

        setState(() {
          _liveItems.insert(0, newItem);
          if (_selectedUrls.length < widget.maxSelection) {
            _selectedUrls.add(uploadResult.fullUrl);
          }
        });
      }
    } catch (e) {
      ToastService.showError("Upload failed: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.mode == 'splash'
        ? "Select Splash Images"
        : widget.mode == 'slider'
            ? "Select Slider Images"
            : "Select Offer Images";

    final typeLabel = _activeFilter == 'splash'
        ? 'Splash'
        : _activeFilter == 'slider'
            ? 'Slider'
            : 'Offer';

    return Container(
      constraints: BoxConstraints(maxHeight: 0.88.sh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Draggable Top Grab Bar
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
                  width: 44.w,
                  height: 4.5.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),

              // 2. Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
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
                        child: Icon(Icons.close_rounded, size: 16.sp, color: const Color(0xFF6B7280)),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFF3F4F6)),

              // 3. Category Filter Chips (Splash, Offer, Slider)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildFilterChip("Splash", 'splash'),
                      SizedBox(width: 8.w),
                      _buildFilterChip("Offer", 'offer'),
                      SizedBox(width: 8.w),
                      _buildFilterChip("Slider", 'slider'),
                    ],
                  ),
                ),
              ),

              const Divider(height: 1, color: Color(0xFFF3F4F6)),

              // 4. Sub-header: Filter title + Count Badge + Upload Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    // Left: Title + Count Badge
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              "$typeLabel Images",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: _isLoadingGallery
                                ? SizedBox(
                                    width: 10.w,
                                    height: 10.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                    ),
                                  )
                                : Text(
                                    "${_filteredItems.length}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF4B5563),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Right: Responsive Upload & Crop Button
                    GestureDetector(
                      onTap: _isUploading ? null : _pickAndUploadImage,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.5.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFF7ED), Color(0xFFFED7AA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(7.r),
                          border: Border.all(color: const Color(0xFFFDBA74)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_photo_alternate_rounded, size: 13.sp, color: const Color(0xFFC2410C)),
                            SizedBox(width: 4.w),
                            Text(
                              "Upload & Crop",
                              style: GoogleFonts.poppins(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF9A3412),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 5. Scrollable 3-Column Image Grid
              // Index 0: "+ Upload New" interactive card
              // Index 1+: Gallery Items
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: _filteredItems.isEmpty ? 2 : (1 + _filteredItems.length),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildUploadActionCard(typeLabel);
                    }
                    if (_filteredItems.isEmpty) {
                      return _buildEmptyGalleryHintCard(typeLabel);
                    }

                    final item = _filteredItems[index - 1];
                    final isSelected = _selectedUrls.contains(item.url);

                    return GestureDetector(
                      onTap: () => _toggleItem(item),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                            width: isSelected ? 2.w : 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7.r),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Network Image with CachedNetworkImage & smooth fallback
                              CachedNetworkImage(
                                imageUrl: item.url,
                                fit: BoxFit.cover,
                                memCacheWidth: 240,
                                memCacheHeight: 240,
                                placeholder: (context, url) => Container(
                                  color: const Color(0xFFF3F4F6),
                                  child: Center(
                                    child: SizedBox(
                                      width: 18.w,
                                      height: 18.h,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  return Container(
                                    color: const Color(0xFFFFF7ED),
                                    padding: EdgeInsets.all(4.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image_outlined, size: 24.sp, color: const Color(0xFFF97316)),
                                        SizedBox(height: 4.h),
                                        Text(
                                          item.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF9A3412),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Selection indicator checkmark on top-right
                              Positioned(
                                top: 6.h,
                                right: 6.w,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : const Color(0xFFD1D5DB),
                                      width: 1.5.w,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: isSelected
                                      ? Icon(Icons.check_rounded, size: 14.sp, color: Colors.white)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 1, color: Color(0xFFE5E7EB)),

              // 6. Sticky Bottom Bar with system navigation clearance
              Container(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  10.h,
                  16.w,
                  12.h + MediaQuery.of(context).padding.bottom,
                ),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Maximum ${widget.maxSelection} images can be selected",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Selected ${_selectedUrls.length} / ${widget.maxSelection}",
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              setState(() => _selectedUrls.clear());
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                              side: const BorderSide(color: Color(0xFFD1D5DB)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.r)),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Clear Selection",
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Get.back(result: _selectedUrls.toList());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 2,
                              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.r)),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Done",
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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

          // Uploading Progress Floating Overlay
          if (_isUploading)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 28.w),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 18,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 36.w,
                          height: 36.h,
                          child: CircularProgressIndicator(
                            value: _uploadProgress > 0 ? _uploadProgress : null,
                            strokeWidth: 3.5,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            backgroundColor: const Color(0xFFFEE2E2),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          "Uploading to Gallery",
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _uploadStatusText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: _uploadProgress > 0 ? _uploadProgress : null,
                            minHeight: 5.h,
                            backgroundColor: const Color(0xFFF3F4F6),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyGalleryHintCard(String typeLabel) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_outlined, size: 24.sp, color: const Color(0xFF9CA3AF)),
          SizedBox(height: 6.h),
          Text(
            "No $typeLabel\nImages",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4B5563),
              height: 1.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Upload for this resto",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 9.sp,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadActionCard(String typeLabel) {
    return GestureDetector(
      onTap: _isUploading ? null : _pickAndUploadImage,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: const Color(0xFFF59E0B),
            width: 1.2.w,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_rounded,
                size: 22.sp,
                color: const Color(0xFFD97706),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "+ Upload New",
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF92400E),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Crop & Add",
              style: GoogleFonts.poppins(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB45309),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String key) {
    final isActive = _activeFilter == key;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _activeFilter = key);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFEF2F2) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive ? AppColors.primary : const Color(0xFFD1D5DB),
            width: 1.2.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 13.sp,
              color: isActive ? AppColors.primary : const Color(0xFF9CA3AF),
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
