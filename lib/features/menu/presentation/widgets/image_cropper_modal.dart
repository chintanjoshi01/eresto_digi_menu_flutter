import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;

import '../../../../core/theme/app_colors.dart';

/// Supported gallery crop tags matching backend specifications
enum GalleryCropTag {
  slider, // 360 × 300 (1.20:1 wide near-square)
  splash, // 300 × 360 (0.833:1 tall near-square)
  offer,  // Wide (1.00 - 1.30) or Tall (0.75 - 1.00)
  item,   // Square 1:1 (Min 360 × 360)
}

class CropResult {
  final Uint8List croppedBytes;
  final int width;
  final int height;
  final double aspectRatio;
  final int fileSizeBytes;

  const CropResult({
    required this.croppedBytes,
    required this.width,
    required this.height,
    required this.aspectRatio,
    required this.fileSizeBytes,
  });

  String get formattedFileSize {
    final mb = fileSizeBytes / (1024 * 1024);
    if (mb >= 1.0) {
      return "${mb.toStringAsFixed(2)} MB";
    }
    final kb = fileSizeBytes / 1024;
    return "${kb.toStringAsFixed(0)} KB";
  }
}

/// Enterprise Image Cropper with freely movable and resizable crop box,
/// locked aspect ratios, rule-of-thirds grid, min-width 360 guarantee,
/// and responsive scaling for all device screen sizes.
class ImageCropperModal extends StatefulWidget {
  final Uint8List originalBytes;
  final GalleryCropTag tag;
  final String fileName;

  const ImageCropperModal({
    super.key,
    required this.originalBytes,
    required this.tag,
    required this.fileName,
  });

  static Future<CropResult?> open({
    required BuildContext context,
    required Uint8List bytes,
    required GalleryCropTag tag,
    required String fileName,
  }) async {
    return showGeneralDialog<CropResult>(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Crop Image",
      barrierColor: Colors.black.withOpacity(0.88),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, anim1, anim2) {
        return ImageCropperModal(
          originalBytes: bytes,
          tag: tag,
          fileName: fileName,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<ImageCropperModal> createState() => _ImageCropperModalState();
}

class _ImageCropperModalState extends State<ImageCropperModal> {
  late double _targetAspectRatio;
  int _rotationQuarterTurns = 0;
  bool _isProcessing = false;
  String _processingStatus = "";

  img.Image? _decodedImage;

  // Active crop box in viewport screen coordinates
  Rect? _cropRect;
  Rect? _imageRect;
  Size? _lastViewportSize;

  // Offer Tag specific aspect ratio options
  final List<Map<String, dynamic>> _offerAspectRatios = [
    {"label": "Wide 1.20", "ratio": 1.20, "dims": "360 × 300"},
    {"label": "Wide 1.30", "ratio": 1.30, "dims": "390 × 300"},
    {"label": "Square 1.00", "ratio": 1.00, "dims": "360 × 360"},
    {"label": "Tall 0.83", "ratio": 0.833, "dims": "300 × 360"},
    {"label": "Tall 0.75", "ratio": 0.75, "dims": "300 × 400"},
  ];

  @override
  void initState() {
    super.initState();
    _initAspectRatio();
    _decodeInputImage();
  }

  void _initAspectRatio() {
    switch (widget.tag) {
      case GalleryCropTag.slider:
        _targetAspectRatio = 360 / 300; // 1.20
        break;
      case GalleryCropTag.splash:
        _targetAspectRatio = 300 / 360; // 0.833
        break;
      case GalleryCropTag.item:
        _targetAspectRatio = 1.0; // 1:1 Square
        break;
      case GalleryCropTag.offer:
        _targetAspectRatio = 1.20; // Default wide offer
        break;
    }
  }

  void _decodeInputImage() {
    try {
      final decoded = img.decodeImage(widget.originalBytes);
      if (decoded != null) {
        setState(() {
          _decodedImage = decoded;
        });
      }
    } catch (_) {}
  }

  void _rotateClockwise() {
    HapticFeedback.mediumImpact();
    setState(() {
      _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
      _cropRect = null; // Forces re-centering inside rotated image
    });
  }

  void _resetCropBox() {
    HapticFeedback.lightImpact();
    setState(() {
      _rotationQuarterTurns = 0;
      _cropRect = null;
    });
  }

  void _setAspectRatio(double ratio) {
    HapticFeedback.selectionClick();
    setState(() {
      _targetAspectRatio = ratio;
      _cropRect = null;
    });
  }

  /// Calculates the image rendered rect and initializes/clamps the crop box
  void _calculateLayout(Size viewportSize) {
    if (_decodedImage == null) return;

    final isRotated90 = _rotationQuarterTurns % 2 != 0;
    final imgW = (isRotated90 ? _decodedImage!.height : _decodedImage!.width).toDouble();
    final imgH = (isRotated90 ? _decodedImage!.width : _decodedImage!.height).toDouble();
    final imgAspect = imgW / imgH;

    final vpAspect = viewportSize.width / viewportSize.height;

    double renderedW, renderedH;
    if (vpAspect > imgAspect) {
      renderedH = viewportSize.height * 0.94;
      renderedW = renderedH * imgAspect;
    } else {
      renderedW = viewportSize.width * 0.94;
      renderedH = renderedW / imgAspect;
    }

    final imgLeft = (viewportSize.width - renderedW) / 2;
    final imgTop = (viewportSize.height - renderedH) / 2;
    final newImageRect = Rect.fromLTWH(imgLeft, imgTop, renderedW, renderedH);

    _imageRect = newImageRect;

    // Initialize or adapt crop rect
    if (_cropRect == null || _lastViewportSize != viewportSize) {
      _lastViewportSize = viewportSize;

      double boxW, boxH;
      if (newImageRect.width / newImageRect.height > _targetAspectRatio) {
        boxH = newImageRect.height * 0.88;
        boxW = boxH * _targetAspectRatio;
      } else {
        boxW = newImageRect.width * 0.88;
        boxH = boxW / _targetAspectRatio;
      }

      final boxLeft = newImageRect.left + (newImageRect.width - boxW) / 2;
      final boxTop = newImageRect.top + (newImageRect.height - boxH) / 2;
      _cropRect = Rect.fromLTWH(boxLeft, boxTop, boxW, boxH);
    } else {
      // Clamp existing cropRect inside new imageRect
      _cropRect = _clampRect(_cropRect!, newImageRect);
    }
  }

  Rect _clampRect(Rect rect, Rect boundary) {
    double w = rect.width.clamp(40.0, boundary.width);
    double h = w / _targetAspectRatio;
    if (h > boundary.height) {
      h = boundary.height;
      w = h * _targetAspectRatio;
    }

    double l = rect.left.clamp(boundary.left, boundary.right - w);
    double t = rect.top.clamp(boundary.top, boundary.bottom - h);
    return Rect.fromLTWH(l, t, w, h);
  }

  /// Move the entire crop box freely within the image boundary
  void _onMoveBox(DragUpdateDetails details) {
    if (_cropRect == null || _imageRect == null) return;

    final newLeft = (_cropRect!.left + details.delta.dx)
        .clamp(_imageRect!.left, _imageRect!.right - _cropRect!.width);
    final newTop = (_cropRect!.top + details.delta.dy)
        .clamp(_imageRect!.top, _imageRect!.bottom - _cropRect!.height);

    setState(() {
      _cropRect = Rect.fromLTWH(newLeft, newTop, _cropRect!.width, _cropRect!.height);
    });
  }

  /// Resize crop box from corner handles while maintaining target aspect ratio
  void _onResizeCorner(DragUpdateDetails details, {required bool isTop, required bool isLeft}) {
    if (_cropRect == null || _imageRect == null) return;

    double deltaX = details.delta.dx;
    if (isLeft) deltaX = -deltaX;

    double newW = _cropRect!.width + deltaX;
    newW = newW.clamp(60.0, _imageRect!.width);
    double newH = newW / _targetAspectRatio;

    if (newH > _imageRect!.height) {
      newH = _imageRect!.height;
      newW = newH * _targetAspectRatio;
    }

    double newLeft = _cropRect!.left;
    double newTop = _cropRect!.top;

    if (isLeft) {
      newLeft = _cropRect!.right - newW;
      if (newLeft < _imageRect!.left) {
        newLeft = _imageRect!.left;
        newW = _cropRect!.right - newLeft;
        newH = newW / _targetAspectRatio;
      }
    } else {
      if (newLeft + newW > _imageRect!.right) {
        newW = _imageRect!.right - newLeft;
        newH = newW / _targetAspectRatio;
      }
    }

    if (isTop) {
      newTop = _cropRect!.bottom - newH;
      if (newTop < _imageRect!.top) {
        newTop = _imageRect!.top;
        newH = _cropRect!.bottom - newTop;
        newW = newH * _targetAspectRatio;
      }
    } else {
      if (newTop + newH > _imageRect!.bottom) {
        newH = _imageRect!.bottom - newTop;
        newW = newH * _targetAspectRatio;
      }
    }

    setState(() {
      _cropRect = Rect.fromLTWH(newLeft, newTop, newW, newH);
    });
  }

  Future<void> _processAndConfirmCrop() async {
    if (_decodedImage == null || _cropRect == null || _imageRect == null) return;

    setState(() {
      _isProcessing = true;
      _processingStatus = "Cropping pixels...";
    });

    try {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 40));

      img.Image workingImage = _decodedImage!;

      // 1. Apply 90-degree rotations
      if (_rotationQuarterTurns > 0) {
        setState(() => _processingStatus = "Applying rotation...");
        workingImage = img.copyRotate(
          workingImage,
          angle: _rotationQuarterTurns * 90,
        );
      }

      // 2. Map screen cropRect relative to imageRect into exact pixel coordinates
      final normLeft = (_cropRect!.left - _imageRect!.left) / _imageRect!.width;
      final normTop = (_cropRect!.top - _imageRect!.top) / _imageRect!.height;
      final normWidth = _cropRect!.width / _imageRect!.width;
      final normHeight = _cropRect!.height / _imageRect!.height;

      final pixelX = (normLeft * workingImage.width).round().clamp(0, workingImage.width - 1);
      final pixelY = (normTop * workingImage.height).round().clamp(0, workingImage.height - 1);
      final pixelW = (normWidth * workingImage.width).round().clamp(1, workingImage.width - pixelX);
      final pixelH = (normHeight * workingImage.height).round().clamp(1, workingImage.height - pixelY);

      setState(() => _processingStatus = "Applying precision crop...");
      img.Image cropped = img.copyCrop(
        workingImage,
        x: pixelX,
        y: pixelY,
        width: pixelW,
        height: pixelH,
      );

      // 3. Minimum width guarantee (Server requires min width 360)
      if (cropped.width < 360) {
        setState(() => _processingStatus = "Optimizing resolution (min 360px)...");
        const targetW = 360;
        final targetH = (360 / _targetAspectRatio).round();
        cropped = img.copyResize(
          cropped,
          width: targetW,
          height: targetH,
          interpolation: img.Interpolation.cubic,
        );
      }

      // 4. Encode & 5MB file size compression guard
      setState(() => _processingStatus = "Encoding & validating 5MB limit...");
      int quality = 90;
      Uint8List encoded = Uint8List.fromList(img.encodeJpg(cropped, quality: quality));

      const maxBytes = 5 * 1024 * 1024; // 5 MB
      while (encoded.lengthInBytes > maxBytes && quality > 40) {
        quality -= 10;
        setState(() => _processingStatus = "Compressing ($quality%)...");
        encoded = Uint8List.fromList(img.encodeJpg(cropped, quality: quality));
      }

      HapticFeedback.selectionClick();

      final result = CropResult(
        croppedBytes: encoded,
        width: cropped.width,
        height: cropped.height,
        aspectRatio: _targetAspectRatio,
        fileSizeBytes: encoded.lengthInBytes,
      );

      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _processingStatus = "";
      });
      Get.snackbar(
        "Crop Error",
        "Could not process image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagName = widget.tag == GalleryCropTag.slider
        ? "Slider"
        : widget.tag == GalleryCropTag.splash
            ? "Splash"
            : widget.tag == GalleryCropTag.item
                ? "Item"
                : "Offer";

    final dimsText = widget.tag == GalleryCropTag.slider
        ? "360 × 300 (Wide near-square)"
        : widget.tag == GalleryCropTag.splash
            ? "300 × 360 (Tall near-square)"
            : widget.tag == GalleryCropTag.item
                ? "1:1 Square (Min 360 × 360)"
                : "Ratio ${_targetAspectRatio.toStringAsFixed(2)}:1";

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive viewport calculation
            final topBarH = 58.h;
            final bottomBarH = (widget.tag == GalleryCropTag.offer ? 120.h : 80.h);
            final viewportHeight = constraints.maxHeight - topBarH - bottomBarH;
            final viewportWidth = constraints.maxWidth;
            final viewportSize = Size(viewportWidth, viewportHeight);

            _calculateLayout(viewportSize);

            final cropBox = _cropRect ?? Rect.zero;
            final imgBox = _imageRect ?? Rect.zero;

            return Stack(
              children: [
                // 1. Interactive Image & Crop Box Viewport Area
                Positioned(
                  top: topBarH,
                  left: 0,
                  right: 0,
                  height: viewportHeight,
                  child: Stack(
                    children: [
                      // Rendered Image
                      if (_imageRect != null)
                        Positioned(
                          left: imgBox.left,
                          top: imgBox.top,
                          width: imgBox.width,
                          height: imgBox.height,
                          child: RotatedBox(
                            quarterTurns: _rotationQuarterTurns,
                            child: Image.memory(
                              widget.originalBytes,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),

                      // Dark Translucent Scrim & Grid Overlay
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _CropOverlayPainter(
                              cropRect: cropBox,
                              accentColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      // Dimension Badge above Crop Box
                      if (_cropRect != null)
                        Positioned(
                          left: cropBox.left.clamp(8.w, viewportWidth - 220.w),
                          top: (cropBox.top - 28.h).clamp(4.h, viewportHeight - 30.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: Colors.white24, width: 0.8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.crop_rounded, size: 12.sp, color: const Color(0xFFF97316)),
                                SizedBox(width: 4.w),
                                Text(
                                  dimsText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Freely Movable Crop Box Gesture Detector
                      if (_cropRect != null)
                        Positioned(
                          left: cropBox.left,
                          top: cropBox.top,
                          width: cropBox.width,
                          height: cropBox.height,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanUpdate: _onMoveBox,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),

                      // Corner Resize Handle - Top-Left
                      if (_cropRect != null)
                        Positioned(
                          left: cropBox.left - 16.w,
                          top: cropBox.top - 16.h,
                          child: _buildCornerHandle(
                            onPanUpdate: (d) => _onResizeCorner(d, isTop: true, isLeft: true),
                          ),
                        ),

                      // Corner Resize Handle - Top-Right
                      if (_cropRect != null)
                        Positioned(
                          left: cropBox.right - 16.w,
                          top: cropBox.top - 16.h,
                          child: _buildCornerHandle(
                            onPanUpdate: (d) => _onResizeCorner(d, isTop: true, isLeft: false),
                          ),
                        ),

                      // Corner Resize Handle - Bottom-Left
                      if (_cropRect != null)
                        Positioned(
                          left: cropBox.left - 16.w,
                          top: cropBox.bottom - 16.h,
                          child: _buildCornerHandle(
                            onPanUpdate: (d) => _onResizeCorner(d, isTop: false, isLeft: true),
                          ),
                        ),

                      // Corner Resize Handle - Bottom-Right
                      if (_cropRect != null)
                        Positioned(
                          left: cropBox.right - 16.w,
                          top: cropBox.bottom - 16.h,
                          child: _buildCornerHandle(
                            onPanUpdate: (d) => _onResizeCorner(d, isTop: false, isLeft: false),
                          ),
                        ),
                    ],
                  ),
                ),

                // 2. Top Header Bar (Responsive)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: topBarH,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.96),
                      border: const Border(
                        bottom: BorderSide(color: Color(0xFF334155), width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: Colors.white, size: 22.sp),
                          onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Crop $tagName Image",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Drag box to move · Pinch corners to resize",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: "Reset crop box",
                          icon: Icon(Icons.restart_alt_rounded, color: Colors.white70, size: 20.sp),
                          onPressed: _isProcessing ? null : _resetCropBox,
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Bottom Controls & Action Bar (Responsive)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.98),
                      border: const Border(
                        top: BorderSide(color: Color(0xFF334155), width: 1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Offer Ratio Selector (Only for Offer Tag)
                        if (widget.tag == GalleryCropTag.offer) ...[
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: _offerAspectRatios.map((item) {
                                final isSelected = (_targetAspectRatio - (item["ratio"] as double)).abs() < 0.01;
                                return GestureDetector(
                                  onTap: _isProcessing ? null : () => _setAspectRatio(item["ratio"] as double),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFC1272D) : const Color(0xFF334155),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFFF87171) : Colors.transparent,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          item["label"] as String,
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.5.sp,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "(${item["dims"]})",
                                          style: GoogleFonts.poppins(
                                            fontSize: 9.sp,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],

                        // Action Buttons: Rotate 90° + Confirm & Upload
                        Row(
                          children: [
                            Material(
                              color: const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(10.r),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10.r),
                                onTap: _isProcessing ? null : _rotateClockwise,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
                                  child: Row(
                                    children: [
                                      Icon(Icons.rotate_right_rounded, size: 18.sp, color: Colors.white),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "90°",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC1272D),
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                onPressed: _isProcessing ? null : _processAndConfirmCrop,
                                child: _isProcessing
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 14.w,
                                            height: 14.h,
                                            child: const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Flexible(
                                            child: Text(
                                              _processingStatus,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.5.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_rounded, size: 18.sp, color: Colors.white),
                                          SizedBox(width: 6.w),
                                          Text(
                                            "Crop & Upload",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.2,
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCornerHandle({required GestureDragUpdateCallback onPanUpdate}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: onPanUpdate,
      child: Container(
        width: 32.w,
        height: 32.h,
        alignment: Alignment.center,
        child: Container(
          width: 14.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 3.w),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter to draw the dark scrim mask outside the crop box,
/// rule-of-thirds grid, and accent corner brackets
class _CropOverlayPainter extends CustomPainter {
  final Rect cropRect;
  final Color accentColor;

  _CropOverlayPainter({
    required this.cropRect,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (cropRect.isEmpty) return;

    final fullScreenRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // 1. Dark mask outside cropRect
    final scrimPaint = Paint()
      ..color = Colors.black.withOpacity(0.68)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addRect(fullScreenRect)
      ..addRect(cropRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, scrimPaint);

    // 2. Crop border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRect(cropRect, borderPaint);

    // 3. Rule-of-Thirds Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final thirdW = cropRect.width / 3;
    final thirdH = cropRect.height / 3;

    // Vertical grid lines
    canvas.drawLine(
      Offset(cropRect.left + thirdW, cropRect.top),
      Offset(cropRect.left + thirdW, cropRect.bottom),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left + thirdW * 2, cropRect.top),
      Offset(cropRect.left + thirdW * 2, cropRect.bottom),
      gridPaint,
    );

    // Horizontal grid lines
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + thirdH),
      Offset(cropRect.right, cropRect.top + thirdH),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + thirdH * 2),
      Offset(cropRect.right, cropRect.top + thirdH * 2),
      gridPaint,
    );

    // 4. Accent Corner Brackets
    final cornerPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final cornerLen = 18.w;

    // Top-Left
    canvas.drawLine(cropRect.topLeft, cropRect.topLeft + Offset(cornerLen, 0), cornerPaint);
    canvas.drawLine(cropRect.topLeft, cropRect.topLeft + Offset(0, cornerLen), cornerPaint);

    // Top-Right
    canvas.drawLine(cropRect.topRight, cropRect.topRight + Offset(-cornerLen, 0), cornerPaint);
    canvas.drawLine(cropRect.topRight, cropRect.topRight + Offset(0, cornerLen), cornerPaint);

    // Bottom-Left
    canvas.drawLine(cropRect.bottomLeft, cropRect.bottomLeft + Offset(cornerLen, 0), cornerPaint);
    canvas.drawLine(cropRect.bottomLeft, cropRect.bottomLeft + Offset(0, -cornerLen), cornerPaint);

    // Bottom-Right
    canvas.drawLine(cropRect.bottomRight, cropRect.bottomRight + Offset(-cornerLen, 0), cornerPaint);
    canvas.drawLine(cropRect.bottomRight, cropRect.bottomRight + Offset(0, -cornerLen), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter oldDelegate) {
    return oldDelegate.cropRect != cropRect || oldDelegate.accentColor != accentColor;
  }
}
