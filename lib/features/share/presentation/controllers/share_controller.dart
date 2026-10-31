import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/models/digital_menu_link_model.dart';
import '../../domain/models/pdf_download_request.dart';
import '../../domain/models/pdf_download_response.dart';
import '../../domain/models/tnc_model.dart';
import '../../domain/repositories/share_repository.dart';
import '../../../dashboard/presentation/controllers/menu_dashboard_controller.dart';
import '../../../items/domain/models/item_model.dart';
import '../../../items/domain/repositories/items_repository.dart';
import '../../../items/presentation/controllers/items_controller.dart';
import '../../../menu/domain/models/menu_template_model.dart';
import '../../../menu/presentation/controllers/menu_theme_controller.dart';

class ShareController extends GetxController {
  final ShareRepository _shareRepository;
  final StorageService _storageService;

  ShareController(this._shareRepository, this._storageService);

  // --- Dynamic Digital Menu Links State ---
  final isLoadingLinks = false.obs;
  final digitalChannels = <DigitalMenuLinkModel>[].obs;
  final activeChannelIndex = 0.obs;
  final activeChannelSlug = 'dine-in'.obs;
  final activeChannelName = 'Dine In'.obs;
  final qrUrl = 'https://menu.eresto.in'.obs;
  final restoName = ''.obs;

  late final PageController qrPageController;
  late final ScrollController tabScrollController;
  final Map<int, GlobalKey> _qrKeys = {};

  GlobalKey getQrKey(int index) => _qrKeys.putIfAbsent(index, () => GlobalKey());

  // --- Tables QR Zip State ---
  final isDownloadingZip = false.obs;

  // --- Terms & Conditions Master State ---
  final tncList = <TncModel>[].obs;
  final isLoadingTnc = false.obs;
  final isSavingTnc = false.obs;
  final selectedTnc = Rxn<TncModel>();
  final isEditingTnc = false.obs;

  final tncNameCtrl = TextEditingController();
  final tncLineCtrls = <TextEditingController>[].obs;

  // --- Multi-Step PDF Download Wizard State ---
  final pdfCurrentStep = 0.obs; // 0: Header Details, 1: PDF Layout, 2: Menu Styling
  final selectedTemplateId = 0.obs; // 0 = unselected ("Select Menu Template")
  final selectedTemplateName = ''.obs;
  final showTemplateValidationError = false.obs;

  // Step 1: Header Fields (Populated dynamically from authenticated restaurant info)
  final headerNameCtrl = TextEditingController();
  final headerContactCtrl = TextEditingController();
  final headerAddressCtrl = TextEditingController();
  final headerCityCtrl = TextEditingController();
  final headerPinCtrl = TextEditingController();

  final showHeaderName = true.obs;
  final showHeaderAddress = true.obs;
  final showHeaderContact = false.obs;

  // Step 2: PDF Layout Options
  final selectedPdfStyle = 'card'.obs; // 'classic', 'card', 'compact'
  final selectedCardStyle = 'single'.obs; // 'single', 'double'
  final headerAlign = 'center'.obs; // 'left', 'center', 'right'
  final catAlign = 'left'.obs; // 'left', 'center'
  final catStyle = 'plain'.obs; // 'plain', 'solid', 'gradient'
  final bgTheme = 'white'.obs; // 'white', 'cream', 'beige', 'blush', 'grey'
  final fontStyle = 0.obs; // 0: Normal, 1: UPPERCASE, 2: Capitalize

  // Step 3: Menu Styling / Content Toggles
  final showSize = false.obs; // portion/variant
  final showCal = false.obs; // calories
  final showDes = false.obs; // description
  final showIng = false.obs; // ingredients
  final showAik = false.obs; // allergen icons

  final isGeneratingPdf = false.obs;
  final isDownloadingPdfFile = false.obs;
  final generatedPdfResponse = Rxn<PdfDownloadResponse>();
  final downloadedLocalPdfFile = Rxn<File>();
  final savedDownloadsPath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    qrPageController = PageController();
    tabScrollController = ScrollController();
    _loadCachedProfileInfo();
    fetchDigitalMenuLinks();
    fetchTnc();
  }

  void _loadCachedProfileInfo() {
    String resolvedName = _storageService.restoName.trim();
    String resolvedContact = _storageService.restoContact.trim();
    String resolvedAddress = _storageService.restoAddress.trim();
    String resolvedCity = _storageService.restoCity.trim();
    String resolvedPin = _storageService.restoPin.trim();

    // Pull live restaurant info from Dashboard rawData if available
    if (Get.isRegistered<MenuDashboardController>()) {
      final dash = Get.find<MenuDashboardController>();
      final raw = dash.rawData;
      if (raw != null) {
        if (raw.hero.restoName.trim().isNotEmpty) {
          resolvedName = raw.hero.restoName.trim();
        }
        for (final container in raw.menuSessions) {
          final info = container.restoInfo;
          if (info != null) {
            if (info.title.trim().isNotEmpty) {
              resolvedName = info.title.trim();
            }
            if (info.contactNo.trim().isNotEmpty) {
              resolvedContact = info.contactNo.trim();
            }
            if (info.address.trim().isNotEmpty) {
              resolvedAddress = info.address.trim();
            }
            if (info.city.trim().isNotEmpty) {
              resolvedCity = info.city.trim();
            }
            if (info.pinCode.trim().isNotEmpty) {
              resolvedPin = info.pinCode.trim();
            }
            break;
          }
        }
      }
    }

    if (resolvedName.isNotEmpty) {
      restoName.value = resolvedName;
      headerNameCtrl.text = resolvedName;
    }
    if (resolvedContact.isNotEmpty) {
      headerContactCtrl.text = resolvedContact;
      showHeaderContact.value = true;
    }
    if (resolvedAddress.isNotEmpty) {
      headerAddressCtrl.text = resolvedAddress;
    }
    if (resolvedCity.isNotEmpty) {
      headerCityCtrl.text = resolvedCity;
    }
    if (resolvedPin.isNotEmpty) {
      headerPinCtrl.text = resolvedPin;
    }
  }

  // --------------------------------------------------------------------------
  // Digital Menu Channels & QR Code
  // --------------------------------------------------------------------------

  Future<void> fetchDigitalMenuLinks() async {
    isLoadingLinks.value = true;
    try {
      final data = await _shareRepository.getDigitalMenuLinks();
      if (data.restoName.isNotEmpty) {
        restoName.value = data.restoName;
        headerNameCtrl.text = data.restoName;
      }
      if (data.menus.isNotEmpty) {
        digitalChannels.assignAll(data.menus);
        final defaultIndex = data.menus.indexWhere(
          (m) => m.slug.toLowerCase() == 'dine-in' || m.name.toLowerCase().contains('dine'),
        );
        selectChannelByIndex(defaultIndex != -1 ? defaultIndex : 0, animate: false);
      } else {
        _setFallbackChannels();
      }
    } catch (e) {
      _setFallbackChannels();
    } finally {
      isLoadingLinks.value = false;
    }
  }

  void _setFallbackChannels() {
    digitalChannels.assignAll([
      DigitalMenuLinkModel(
        name: 'Dine In',
        slug: 'dine-in',
        fullUrl: 'https://menu.eresto.in/trulyy-tadkaaz/dine-in',
      ),
      DigitalMenuLinkModel(
        name: 'Ird',
        slug: 'ird',
        fullUrl: 'https://menu.eresto.in/trulyy-tadkaaz/ird',
      ),
      DigitalMenuLinkModel(
        name: 'Takeaway',
        slug: 'takeaway',
        fullUrl: 'https://menu.eresto.in/trulyy-tadkaaz/takeaway',
      ),
    ]);
    selectChannelByIndex(0, animate: false);
  }

  void selectChannelByIndex(int index, {bool animate = true}) {
    if (index >= 0 && index < digitalChannels.length) {
      final channel = digitalChannels[index];
      HapticFeedback.selectionClick();
      activeChannelIndex.value = index;
      activeChannelSlug.value = channel.slug;
      activeChannelName.value = channel.name;
      qrUrl.value = channel.fullUrl;
      if (animate && qrPageController.hasClients) {
        qrPageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
        );
      }
      _scrollToActiveTab(index);
    }
  }

  void onQrPageChanged(int index) {
    if (index >= 0 && index < digitalChannels.length) {
      final channel = digitalChannels[index];
      HapticFeedback.selectionClick();
      activeChannelIndex.value = index;
      activeChannelSlug.value = channel.slug;
      activeChannelName.value = channel.name;
      qrUrl.value = channel.fullUrl;
      _scrollToActiveTab(index);
    }
  }

  void _scrollToActiveTab(int index) {
    if (tabScrollController.hasClients) {
      final target = (index * 70.0) - 30.0;
      tabScrollController.animateTo(
        target.clamp(0.0, tabScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void selectChannel(DigitalMenuLinkModel channel) {
    final idx = digitalChannels.indexOf(channel);
    if (idx != -1) {
      selectChannelByIndex(idx);
    } else {
      activeChannelSlug.value = channel.slug;
      activeChannelName.value = channel.name;
      qrUrl.value = channel.fullUrl;
    }
  }

  void copyUrl() {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: qrUrl.value));
    ToastService.showSuccess("Menu link copied to clipboard");
  }

  // --------------------------------------------------------------------------
  // Sharing & Direct Actions
  // --------------------------------------------------------------------------

  Future<void> triggerNativeShare(GlobalKey qrKey) async {
    try {
      HapticFeedback.lightImpact();
      final imageBytes = await captureQrPng(qrKey);
      if (imageBytes == null) {
        await Share.share("View our digital menu online: ${qrUrl.value}");
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/eresto_menu_qr.png').create();
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: "Scan this QR code to view our digital menu:\n${qrUrl.value}",
      );
    } catch (e) {
      ToastService.showError("Failed to share QR: $e");
    }
  }

  Future<void> shareToWhatsApp() async {
    HapticFeedback.lightImpact();
    final message = "Hello! Check out our digital menu here: ${qrUrl.value}";
    final whatsappUri = Uri.parse("whatsapp://send?text=${Uri.encodeComponent(message)}");
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        await Share.share(message);
      }
    } catch (_) {
      await Share.share(message);
    }
  }

  Future<void> shareToInstagram() async {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: qrUrl.value));
    ToastService.showSuccess("Menu link copied! Paste it into your Instagram bio.");

    final igAppUri = Uri.parse("instagram://app");
    try {
      if (await canLaunchUrl(igAppUri)) {
        await launchUrl(igAppUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Ignored
    }
  }

  // --------------------------------------------------------------------------
  // Tables QR Bulk ZIP Download
  // --------------------------------------------------------------------------

  Future<void> downloadTableQrZip() async {
    isDownloadingZip.value = true;
    HapticFeedback.mediumImpact();
    try {
      ToastService.showInfo("Preparing Table QR Codes archive...");
      final bytes = await _shareRepository.downloadTableQrZip();

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/table_qr_codes.zip';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      ToastService.showSuccess("Downloaded Table QR Codes (${bytes.length ~/ 1024} KB)");

      await Share.shareXFiles(
        [XFile(filePath)],
        text: "Table QR Codes ZIP for ${restoName.value}",
      );
    } catch (e) {
      ToastService.showError("Failed to download Table QR Zip: $e");
    } finally {
      isDownloadingZip.value = false;
    }
  }

  // --------------------------------------------------------------------------
  // Terms & Conditions Master CRUD (Screenshots 1, 2, 3)
  // --------------------------------------------------------------------------

  Future<void> fetchTnc() async {
    isLoadingTnc.value = true;
    try {
      final list = await _shareRepository.getTncTemplates();
      tncList.assignAll(list);
      if (tncList.isNotEmpty) {
        selectTncForEdit(tncList.first);
      } else {
        startNewTnc();
      }
    } catch (_) {
      // Handled
    } finally {
      isLoadingTnc.value = false;
    }
  }

  void selectTncForEdit(TncModel item) {
    HapticFeedback.selectionClick();
    selectedTnc.value = item;
    isEditingTnc.value = true;
    tncNameCtrl.text = item.tncName;

    _disposeTncLineCtrls();
    final lines = item.lines;
    if (lines.isNotEmpty) {
      for (final line in lines) {
        tncLineCtrls.add(TextEditingController(text: line));
      }
    } else {
      tncLineCtrls.add(TextEditingController());
    }
  }

  void startNewTnc() {
    HapticFeedback.selectionClick();
    selectedTnc.value = null;
    isEditingTnc.value = false;
    tncNameCtrl.clear();
    _disposeTncLineCtrls();
    tncLineCtrls.add(TextEditingController());
  }

  void duplicateTnc(TncModel item) {
    HapticFeedback.selectionClick();
    selectedTnc.value = null;
    isEditingTnc.value = false;
    tncNameCtrl.text = "${item.tncName} (Copy)";
    _disposeTncLineCtrls();
    final lines = item.lines;
    if (lines.isNotEmpty) {
      for (final line in lines) {
        tncLineCtrls.add(TextEditingController(text: line));
      }
    } else {
      tncLineCtrls.add(TextEditingController());
    }
    ToastService.showInfo("Template duplicated in editor. Click Save to create.");
  }

  void addTncLine() {
    HapticFeedback.lightImpact();
    tncLineCtrls.add(TextEditingController());
  }

  void removeTncLine(int index) {
    HapticFeedback.lightImpact();
    if (index >= 0 && index < tncLineCtrls.length) {
      final ctrl = tncLineCtrls.removeAt(index);
      ctrl.dispose();
    }
    if (tncLineCtrls.isEmpty) {
      tncLineCtrls.add(TextEditingController());
    }
  }

  Future<bool> saveTnc() async {
    final name = tncNameCtrl.text.trim();
    if (name.isEmpty) {
      ToastService.showError("Please enter template name");
      return false;
    }

    final rawLines = tncLineCtrls
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (rawLines.isEmpty) {
      ToastService.showError("Please add at least one line of terms");
      return false;
    }

    final joinedTnc = TncModel.joinLines(rawLines);

    isSavingTnc.value = true;
    HapticFeedback.mediumImpact();
    try {
      if (selectedTnc.value != null && isEditingTnc.value) {
        // Update existing
        final updated = await _shareRepository.updateTncTemplate(
          id: selectedTnc.value!.id,
          name: name,
          tnc: joinedTnc,
        );
        final idx = tncList.indexWhere((t) => t.id == updated.id);
        if (idx != -1) {
          tncList[idx] = updated;
        } else {
          tncList.add(updated);
        }
        selectedTnc.value = updated;
        ToastService.showSuccess("Terms & Conditions updated successfully!");
        return true;
      } else {
        // Create new
        final created = await _shareRepository.createTncTemplate(
          name: name,
          tnc: joinedTnc,
        );
        tncList.insert(0, created);
        selectedTnc.value = created;
        isEditingTnc.value = true;
        ToastService.showSuccess("Terms & Conditions created successfully!");
        return true;
      }
    } catch (e) {
      ToastService.showError("Failed to save terms: $e");
      return false;
    } finally {
      isSavingTnc.value = false;
    }
  }

  Future<void> deleteTnc(TncModel item) async {
    HapticFeedback.mediumImpact();
    try {
      final success = await _shareRepository.deleteTncTemplate(id: item.id);
      if (success) {
        tncList.removeWhere((t) => t.id == item.id);
        ToastService.showSuccess("Terms template deleted");
        if (selectedTnc.value?.id == item.id) {
          if (tncList.isNotEmpty) {
            selectTncForEdit(tncList.first);
          } else {
            startNewTnc();
          }
        }
      } else {
        ToastService.showError("Could not delete template");
      }
    } catch (e) {
      ToastService.showError("Deletion error: $e");
    }
  }

  void _disposeTncLineCtrls() {
    for (final ctrl in tncLineCtrls) {
      ctrl.dispose();
    }
    tncLineCtrls.clear();
  }

  // --------------------------------------------------------------------------
  // Multi-Step PDF Download Wizard (Downloads local file & enables opening/sharing)
  // --------------------------------------------------------------------------

  List<dynamic> getAvailableTemplates() {
    if (Get.isRegistered<MenuThemeController>()) {
      final mtc = Get.find<MenuThemeController>();
      if (mtc.templatesList.isNotEmpty) {
        return mtc.templatesList;
      }
    }
    return [
      {'id': 1, 'name': 'Breakfast'},
      {'id': 2, 'name': 'Main Menu'},
      {'id': 3, 'name': 'Mid-Night'},
      {'id': 4, 'name': 'HI-TEA'},
      {'id': 5, 'name': 'Multi Menu'},
    ];
  }

  void selectTemplateForPdf(int id, {String? name}) {
    selectedTemplateId.value = id;
    showTemplateValidationError.value = false;
    if (name != null && name.isNotEmpty) {
      selectedTemplateName.value = name;
    } else {
      final templates = getAvailableTemplates();
      for (final t in templates) {
        int tId = 0;
        String tName = '';
        if (t is Map) {
          tId = t['id'] is int ? t['id'] as int : int.tryParse(t['id']?.toString() ?? '0') ?? 0;
          tName = (t['name'] ?? '').toString();
        } else {
          try {
            tId = (t as dynamic).id ?? 0;
            tName = ((t as dynamic).name ?? '').toString();
          } catch (_) {}
        }
        if (tId == id) {
          selectedTemplateName.value = tName;
          break;
        }
      }
    }
  }

  void resetPdfWizard() {
    pdfCurrentStep.value = 0;
    selectedTemplateId.value = 0;
    selectedTemplateName.value = '';
    showTemplateValidationError.value = false;
    generatedPdfResponse.value = null;
    downloadedLocalPdfFile.value = null;
    isGeneratingPdf.value = false;
    isDownloadingPdfFile.value = false;
    _loadCachedProfileInfo();
  }

  void nextPdfStep() {
    if (pdfCurrentStep.value == 0) {
      if (selectedTemplateId.value <= 0) {
        showTemplateValidationError.value = true;
        HapticFeedback.heavyImpact();
        ToastService.showError("Please select a Menu Template before proceeding");
        return;
      }
      showTemplateValidationError.value = false;
    }
    if (pdfCurrentStep.value < 2) {
      HapticFeedback.selectionClick();
      pdfCurrentStep.value++;
    } else {
      generateTemplatePdf();
    }
  }

  void prevPdfStep() {
    if (pdfCurrentStep.value > 0) {
      HapticFeedback.selectionClick();
      pdfCurrentStep.value--;
    }
  }

  Future<void> generateTemplatePdf() async {
    isGeneratingPdf.value = true;
    downloadedLocalPdfFile.value = null;
    savedDownloadsPath.value = '';
    HapticFeedback.mediumImpact();
    try {
      final currentRestoId = _storageService.restoId > 0 ? _storageService.restoId : null;
      final req = PdfDownloadRequest(
        templateId: selectedTemplateId.value,
        restoId: currentRestoId,
        pdfStyle: selectedPdfStyle.value,
        cardStyle: selectedCardStyle.value,
        headerAlign: headerAlign.value,
        catAlign: catAlign.value,
        catStyle: catStyle.value,
        bgTheme: bgTheme.value,
        fontStyle: fontStyle.value,
        showHeaderName: showHeaderName.value ? 1 : 0,
        showHeaderAddress: showHeaderAddress.value ? 1 : 0,
        showHeaderContact: showHeaderContact.value ? 1 : 0,
        size: showSize.value ? 1 : 0,
        cal: showCal.value ? 1 : 0,
        des: showDes.value ? 1 : 0,
        ing: showIng.value ? 1 : 0,
        aik: showAik.value ? 1 : 0,
        restoName: headerNameCtrl.text.trim().isNotEmpty ? headerNameCtrl.text.trim() : restoName.value,
        restoContact: headerContactCtrl.text.trim(),
        restoCity: headerCityCtrl.text.trim(),
        restoPin: headerPinCtrl.text.trim(),
        restoAdd: headerAddressCtrl.text.trim(),
      );

      PdfDownloadResponse? response;
      try {
        response = await _shareRepository.downloadTemplatePdf(req);
      } catch (_) {
        // Fallback response with clean filename
        response = PdfDownloadResponse(
          filePath: '',
          fileUrl: '',
          url: '',
          fileName: "${restoName.value.replaceAll(' ', '_')}_Menu_Template_${selectedTemplateId.value}.pdf",
        );
      }
      generatedPdfResponse.value = response;

      // Automatically download the actual PDF file bytes locally so it can be opened & shared!
      isDownloadingPdfFile.value = true;
      List<int>? bytes;

      if (response.url.isNotEmpty) {
        try {
          final serverBytes = await _shareRepository.downloadPdfBytes(response.url);
          if (serverBytes.length > 50) {
            // Verify it is not an HTML error or JSON error body
            final preview = String.fromCharCodes(serverBytes.take(20)).toLowerCase();
            if (!preview.contains('<html') && !preview.contains('<!doctype') && !preview.contains('{"')) {
              bytes = serverBytes;
            }
          }
        } catch (_) {}
      }

      // If server returned 0 bytes, empty, or failed: generate high-fidelity printable menu PDF on-device
      if (bytes == null || bytes.isEmpty) {
        bytes = await _generateClientFallbackPdf(req);
      }

      // 1. Save locally in temporary directory for instant in-app layout & sharing
      final tempDir = await getTemporaryDirectory();
      final localFile = File('${tempDir.path}/${response.fileName}');
      await localFile.writeAsBytes(bytes, flush: true);
      downloadedLocalPdfFile.value = localFile;

      // 2. Also save to user's phone Download folder (Android / storage)
      final savedInDownloads = await _saveToDownloadsFolder(response.fileName, bytes);
      if (savedInDownloads != null) {
        savedDownloadsPath.value = savedInDownloads.path;
        ToastService.showSuccess("Menu PDF saved to Downloads folder (${(bytes.length / 1024).toStringAsFixed(1)} KB)!");
      } else {
        ToastService.showSuccess("Menu PDF generated (${(bytes.length / 1024).toStringAsFixed(1)} KB)!");
      }

      HapticFeedback.heavyImpact();
    } catch (e) {
      ToastService.showError("PDF generation error: $e");
    } finally {
      isGeneratingPdf.value = false;
      isDownloadingPdfFile.value = false;
    }
  }

  /// Saves a copy of the PDF bytes directly into the public Downloads folder of the user's phone
  Future<File?> _saveToDownloadsFolder(String fileName, List<int> bytes) async {
    // 1. Standard Android public Download directory (/storage/emulated/0/Download)
    try {
      final publicDir = Directory('/storage/emulated/0/Download');
      if (!await publicDir.exists()) {
        try {
          await publicDir.create(recursive: true);
        } catch (_) {}
      }
      if (await publicDir.exists()) {
        final f = File('${publicDir.path}/$fileName');
        await f.writeAsBytes(bytes, flush: true);
        return f;
      }
    } catch (_) {}

    // 2. Alternative Android sdcard Download directory (/sdcard/Download)
    try {
      final sdcardDir = Directory('/sdcard/Download');
      if (await sdcardDir.exists()) {
        final f = File('${sdcardDir.path}/$fileName');
        await f.writeAsBytes(bytes, flush: true);
        return f;
      }
    } catch (_) {}

    // 3. Path provider downloads directory
    try {
      final dDir = await getDownloadsDirectory();
      if (dDir != null) {
        if (!await dDir.exists()) {
          try {
            await dDir.create(recursive: true);
          } catch (_) {}
        }
        final f = File('${dDir.path}/$fileName');
        await f.writeAsBytes(bytes, flush: true);
        return f;
      }
    } catch (_) {}

    // 4. getExternalStorageDirectories for Downloads
    try {
      final extDirs = await getExternalStorageDirectories(type: StorageDirectory.downloads);
      if (extDirs != null && extDirs.isNotEmpty) {
        final f = File('${extDirs.first.path}/$fileName');
        await f.writeAsBytes(bytes, flush: true);
        return f;
      }
    } catch (_) {}

    // 5. App external storage Download subdirectory
    try {
      final extDir = await getExternalStorageDirectory();
      if (extDir != null) {
        final downloadSub = Directory('${extDir.path}/Download');
        if (!await downloadSub.exists()) {
          try {
            await downloadSub.create(recursive: true);
          } catch (_) {}
        }
        final f = File('${downloadSub.path}/$fileName');
        await f.writeAsBytes(bytes, flush: true);
        return f;
      }
    } catch (_) {}

    return null;
  }

  /// User-initiated action to save PDF directly into Downloads folder
  Future<void> savePdfToDownloadsFolder() async {
    final localFile = downloadedLocalPdfFile.value;
    if (localFile == null || !await localFile.exists()) {
      ToastService.showError("Please generate the PDF first.");
      return;
    }
    final bytes = await localFile.readAsBytes();
    if (bytes.isEmpty) {
      ToastService.showError("PDF file is empty. Please regenerate.");
      return;
    }
    final name = generatedPdfResponse.value?.fileName ?? "menu_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final saved = await _saveToDownloadsFolder(name, bytes);
    if (saved != null) {
      savedDownloadsPath.value = saved.path;
      ToastService.showSuccess("Saved to Downloads: ${saved.path.split('/').last}");
    } else {
      // Scoped storage fallback: invoke native share sheet so user can pick 'Save to Files/Drive'
      await Share.shareXFiles([XFile(localFile.path)], text: name);
    }
  }

  /// High-resolution on-device PDF generator that renders the selected Menu Template,
  /// categories, items, and all user-configured layout & styling preferences.
  Future<List<int>> _generateClientFallbackPdf(PdfDownloadRequest req) async {
    final doc = pw.Document();

    // 1. Resolve Selected Menu Template & Theme Color
    MenuTemplateModel? selectedTemplate;
    String templateTitle = selectedTemplateName.value;
    String templateTagline = '';
    PdfColor primaryPdfColor = const PdfColor.fromInt(0xFFDC2626);
    PdfColor accentBgPdfColor = const PdfColor.fromInt(0xFFFEF2F2);

    if (Get.isRegistered<MenuThemeController>()) {
      final mtc = Get.find<MenuThemeController>();
      for (final t in mtc.templatesList) {
        if (t.id == req.templateId) {
          selectedTemplate = t;
          break;
        }
      }
    }

    if (selectedTemplate != null) {
      templateTitle = selectedTemplate.name;
      templateTagline = selectedTemplate.tagline;
      final c = selectedTemplate.themeColor;
      primaryPdfColor = PdfColor(c.red / 255.0, c.green / 255.0, c.blue / 255.0);
      // Soft tint of primary color for badges/accents
      accentBgPdfColor = PdfColor(
        1.0 - (1.0 - primaryPdfColor.red) * 0.12,
        1.0 - (1.0 - primaryPdfColor.green) * 0.12,
        1.0 - (1.0 - primaryPdfColor.blue) * 0.12,
      );
    }

    // 2. Resolve Active Menu Items & Categories
    List<ItemModel> items = [];
    if (Get.isRegistered<ItemsController>()) {
      final ic = Get.find<ItemsController>();
      if (ic.filteredItems.isNotEmpty) {
        items = ic.filteredItems.where((i) => i.isAvailable).toList();
      }
    }
    if (items.isEmpty && Get.isRegistered<ItemsRepository>()) {
      try {
        final repo = Get.find<ItemsRepository>();
        final res = await repo.getItems(forceRefresh: false);
        res.fold((_) {}, (list) {
          items = list.where((i) => i.isAvailable).toList();
        });
      } catch (_) {}
    }

    // Group items by category (preserving category order)
    final Map<String, List<ItemModel>> groupedItems = {};
    for (final item in items) {
      final group = item.itemGroup.trim().isNotEmpty ? item.itemGroup.trim() : 'General';
      groupedItems.putIfAbsent(group, () => []).add(item);
    }

    // 3. Resolve Background Palette Theme
    PdfColor pageBgColor;
    switch (req.bgTheme.toLowerCase()) {
      case 'cream':
        pageBgColor = const PdfColor.fromInt(0xFFFFFDF0);
        break;
      case 'beige':
        pageBgColor = const PdfColor.fromInt(0xFFF5F5DC);
        break;
      case 'blush':
        pageBgColor = const PdfColor.fromInt(0xFFFFF0F5);
        break;
      case 'grey':
        pageBgColor = const PdfColor.fromInt(0xFFF3F4F6);
        break;
      case 'white':
      default:
        pageBgColor = PdfColors.white;
        break;
    }

    // 4. Resolve Restaurant Header Details & Alignment
    final rName = (req.restoName?.trim().isNotEmpty == true)
        ? req.restoName!.trim()
        : (restoName.value.trim().isNotEmpty ? restoName.value.trim() : (selectedTemplate?.customerTitle ?? 'Restaurant Menu'));
    final rContact = req.restoContact?.trim() ?? '';
    final rAddress = req.restoAdd?.trim() ?? '';
    final rCity = req.restoCity?.trim() ?? '';
    final rPin = req.restoPin?.trim() ?? '';

    final addressLine = [
      if (rAddress.isNotEmpty) rAddress,
      if (rCity.isNotEmpty) rCity,
      if (rPin.isNotEmpty) rPin,
    ].join(', ');

    pw.CrossAxisAlignment headerCrossAlign;
    pw.TextAlign headerTextAlign;
    switch (req.headerAlign.toLowerCase()) {
      case 'left':
        headerCrossAlign = pw.CrossAxisAlignment.start;
        headerTextAlign = pw.TextAlign.left;
        break;
      case 'right':
        headerCrossAlign = pw.CrossAxisAlignment.end;
        headerTextAlign = pw.TextAlign.right;
        break;
      case 'center':
      default:
        headerCrossAlign = pw.CrossAxisAlignment.center;
        headerTextAlign = pw.TextAlign.center;
        break;
    }

    final bool isTwoColumn = req.pdfStyle == 'compact' || req.cardStyle == 'double';

    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 28),
      buildBackground: (pw.Context context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(color: pageBgColor),
      ),
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (pw.Context ctx) {
          if (ctx.pageNumber > 1) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 12),
              padding: const pw.EdgeInsets.only(bottom: 6),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.6)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if (req.showHeaderName == 1)
                    pw.Text(
                      _applyFontStyle(rName, req.fontStyle),
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: primaryPdfColor),
                    )
                  else
                    pw.SizedBox(),
                  if (templateTitle.isNotEmpty)
                    pw.Text(
                      _applyFontStyle(templateTitle, req.fontStyle),
                      style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey700),
                    ),
                ],
              ),
            );
          }
          return pw.SizedBox();
        },
        footer: (pw.Context ctx) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 10),
            padding: const pw.EdgeInsets.only(top: 6),
            decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300, width: 0.6)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  rName,
                  style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey600),
                ),
                pw.Text(
                  "Page ${ctx.pageNumber} of ${ctx.pagesCount}",
                  style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey600),
                ),
              ],
            ),
          );
        },
        build: (pw.Context ctx) {
          final widgets = <pw.Widget>[];

          // --- Primary Cover / Restaurant Header Block ---
          widgets.add(
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.only(bottom: 12),
              decoration: pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: primaryPdfColor, width: 1.5)),
              ),
              child: pw.Column(
                crossAxisAlignment: headerCrossAlign,
                children: [
                  if (req.showHeaderName == 1 && rName.isNotEmpty)
                    pw.Text(
                      _applyFontStyle(rName, req.fontStyle),
                      textAlign: headerTextAlign,
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryPdfColor,
                      ),
                    ),
                  if (templateTagline.isNotEmpty) ...[
                    pw.SizedBox(height: 2),
                    pw.Text(
                      templateTagline,
                      textAlign: headerTextAlign,
                      style: pw.TextStyle(
                        fontSize: 9.5,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                  if (req.showHeaderAddress == 1 && addressLine.isNotEmpty) ...[
                    pw.SizedBox(height: 4),
                    pw.Text(
                      addressLine,
                      textAlign: headerTextAlign,
                      style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800),
                    ),
                  ],
                  if (req.showHeaderContact == 1 && rContact.isNotEmpty) ...[
                    pw.SizedBox(height: 2),
                    pw.Text(
                      "Phone: $rContact",
                      textAlign: headerTextAlign,
                      style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800),
                    ),
                  ],
                  if (templateTitle.isNotEmpty) ...[
                    pw.SizedBox(height: 6),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: pw.BoxDecoration(
                        color: accentBgPdfColor,
                        borderRadius: pw.BorderRadius.circular(4),
                        border: pw.Border.all(color: primaryPdfColor, width: 0.6),
                      ),
                      child: pw.Text(
                        _applyFontStyle(templateTitle, req.fontStyle),
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryPdfColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );

          widgets.add(pw.SizedBox(height: 12));

          // --- Menu Categories & Items ---
          if (groupedItems.isEmpty) {
            widgets.add(
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Center(
                  child: pw.Text(
                    "No active menu items available for this template.",
                    style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
                  ),
                ),
              ),
            );
          } else {
            for (final entry in groupedItems.entries) {
              final categoryName = _applyFontStyle(entry.key, req.fontStyle);
              final catItems = entry.value;

              widgets.add(
                _buildPdfCategoryBanner(
                  title: categoryName,
                  count: catItems.length,
                  catStyle: req.catStyle,
                  catAlign: req.catAlign,
                  primaryColor: primaryPdfColor,
                  accentBgColor: accentBgPdfColor,
                ),
              );
              widgets.add(pw.SizedBox(height: 6));

              if (isTwoColumn) {
                for (int i = 0; i < catItems.length; i += 2) {
                  final leftItem = catItems[i];
                  final rightItem = (i + 1 < catItems.length) ? catItems[i + 1] : null;
                  widgets.add(
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: _buildPdfMenuItem(
                              item: leftItem,
                              req: req,
                              primaryColor: primaryPdfColor,
                              accentBgColor: accentBgPdfColor,
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Expanded(
                            child: rightItem != null
                                ? _buildPdfMenuItem(
                                    item: rightItem,
                                    req: req,
                                    primaryColor: primaryPdfColor,
                                    accentBgColor: accentBgPdfColor,
                                  )
                                : pw.SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                for (final item in catItems) {
                  widgets.add(
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: _buildPdfMenuItem(
                        item: item,
                        req: req,
                        primaryColor: primaryPdfColor,
                        accentBgColor: accentBgPdfColor,
                      ),
                    ),
                  );
                }
              }

              widgets.add(pw.SizedBox(height: 10));
            }
          }

          // --- Terms & Conditions Footer Block (if configured) ---
          final activeTnc = selectedTnc.value ?? (tncList.isNotEmpty ? tncList.first : null);
          if (activeTnc != null && activeTnc.lines.isNotEmpty) {
            widgets.add(pw.SizedBox(height: 8));
            widgets.add(
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(color: PdfColors.grey300, width: 0.7),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Terms & Conditions",
                      style: pw.TextStyle(
                        fontSize: 9.5,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    ...activeTnc.lines.map(
                      (line) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Text(
                          "• $line",
                          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return widgets;
        },
      ),
    );
    return await doc.save();
  }

  String _applyFontStyle(String input, int style) {
    if (input.isEmpty) return input;
    if (style == 1) {
      return input.toUpperCase();
    } else if (style == 2) {
      return input
          .split(' ')
          .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
          .join(' ');
    }
    return input;
  }

  pw.Widget _buildPdfCategoryBanner({
    required String title,
    required int count,
    required String catStyle,
    required String catAlign,
    required PdfColor primaryColor,
    required PdfColor accentBgColor,
  }) {
    final bool isCenter = catAlign.toLowerCase() == 'center';
    final align = isCenter ? pw.MainAxisAlignment.center : pw.MainAxisAlignment.spaceBetween;

    if (catStyle == 'solid') {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: pw.BoxDecoration(
          color: primaryColor,
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: pw.Row(
          mainAxisAlignment: align,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 11.5,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
            if (!isCenter)
              pw.Text(
                "$count items",
                style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.white),
              ),
          ],
        ),
      );
    } else if (catStyle == 'gradient') {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: pw.BoxDecoration(
          color: accentBgColor,
          borderRadius: pw.BorderRadius.circular(5),
          border: pw.Border(
            left: pw.BorderSide(color: primaryColor, width: 3.5),
          ),
        ),
        child: pw.Row(
          mainAxisAlignment: align,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 11.5,
                fontWeight: pw.FontWeight.bold,
                color: primaryColor,
              ),
            ),
            if (!isCenter)
              pw.Text(
                "$count items",
                style: pw.TextStyle(fontSize: 8.5, color: primaryColor),
              ),
          ],
        ),
      );
    } else {
      // 'plain'
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.only(bottom: 4, top: 2),
        decoration: pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: primaryColor, width: 1)),
        ),
        child: pw.Row(
          mainAxisAlignment: align,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 11.5,
                fontWeight: pw.FontWeight.bold,
                color: primaryColor,
              ),
            ),
            if (!isCenter)
              pw.Text(
                "$count items",
                style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey600),
              ),
          ],
        ),
      );
    }
  }

  pw.Widget _buildPdfMenuItem({
    required ItemModel item,
    required PdfDownloadRequest req,
    required PdfColor primaryColor,
    required PdfColor accentBgColor,
  }) {
    final isVeg = item.isVeg;
    final PdfColor dietColor = isVeg ? const PdfColor.fromInt(0xFF16A34A) : const PdfColor.fromInt(0xFFDC2626);
    final String itemName = _applyFontStyle(item.name, req.fontStyle);
    final String priceText = "Rs. ${item.formattedPriceRange}";

    // Collect optional metadata lines based on Step 3 toggles
    final List<pw.Widget> metaWidgets = [];

    // 1. Portions & Variant Pricing (req.size == 1)
    if (req.size == 1) {
      final List<String> sizeParts = [];
      if (item.portion != null && item.portion!.trim().isNotEmpty) {
        sizeParts.add("Portion: ${item.portion!.trim()}");
      }
      final vSummary = _extractVariantSummary(item.variantsJson);
      if (vSummary.isNotEmpty) {
        sizeParts.add(vSummary);
      }
      if (sizeParts.isNotEmpty) {
        metaWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 2),
            child: pw.Text(
              sizeParts.join('  |  '),
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
            ),
          ),
        );
      }
    }

    // 2. Calorie & Nutrition Info (req.cal == 1)
    if (req.cal == 1 && item.calorificValue != null && item.calorificValue! > 0) {
      metaWidgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 1.5),
          child: pw.Text(
            "Energy: ${item.calorificValue} kcal",
            style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
          ),
        ),
      );
    }

    // 3. Item Descriptions (req.des == 1)
    if (req.des == 1 && item.shortDescription != null && item.shortDescription!.trim().isNotEmpty) {
      metaWidgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 2),
          child: pw.Text(
            item.shortDescription!.trim(),
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ),
      );
    }

    // 4. Ingredients (req.ing == 1)
    if (req.ing == 1 && item.ingredients != null && item.ingredients!.trim().isNotEmpty) {
      metaWidgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 1.5),
          child: pw.Text(
            "Ingredients: ${item.ingredients!.trim()}",
            style: pw.TextStyle(fontSize: 7.5, fontStyle: pw.FontStyle.italic, color: PdfColors.grey600),
          ),
        ),
      );
    }

    // 5. Allergen Icons & Dietary Tags (req.aik == 1)
    if (req.aik == 1) {
      final List<String> tags = [];
      if (item.dietaryTags != null) {
        for (final t in item.dietaryTags!) {
          final clean = t.trim().toLowerCase();
          if (clean == 'j' || clean == 'jain') {
            tags.add('Jain');
          } else if (clean == 'v' || clean == 'vegan') {
            tags.add('Vegan');
          } else if (clean == 's' || clean == 'spicy') {
            tags.add('Spicy');
          } else if (clean.isNotEmpty) {
            tags.add(t.trim());
          }
        }
      }
      if (item.allergens != null && item.allergens!.isNotEmpty) {
        tags.add("Allergens: ${item.allergens!.join(', ')}");
      }
      if (tags.isNotEmpty) {
        metaWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 2),
            child: pw.Text(
              tags.join(' • '),
              style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: primaryColor),
            ),
          ),
        );
      }
    }

    final itemContent = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Veg / Non-Veg Symbol
            pw.Container(
              width: 9,
              height: 9,
              margin: const pw.EdgeInsets.only(top: 2, right: 5),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: dietColor, width: 1),
                borderRadius: pw.BorderRadius.circular(1.5),
              ),
              alignment: pw.Alignment.center,
              child: pw.Container(
                width: 4.5,
                height: 4.5,
                decoration: pw.BoxDecoration(
                  color: dietColor,
                  shape: pw.BoxShape.circle,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                itemName,
                style: pw.TextStyle(
                  fontSize: req.pdfStyle == 'compact' ? 9.0 : 10.0,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey900,
                ),
              ),
            ),
            pw.SizedBox(width: 6),
            pw.Text(
              priceText,
              style: pw.TextStyle(
                fontSize: req.pdfStyle == 'compact' ? 9.0 : 10.0,
                fontWeight: pw.FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        if (metaWidgets.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 14),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: metaWidgets,
            ),
          ),
      ],
    );

    if (req.pdfStyle == 'card') {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(5),
          border: pw.Border.all(color: PdfColors.grey300, width: 0.7),
        ),
        child: itemContent,
      );
    } else if (req.pdfStyle == 'compact') {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
        ),
        child: itemContent,
      );
    } else {
      // 'classic'
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
        ),
        child: itemContent,
      );
    }
  }

  String _extractVariantSummary(String? variantsJson) {
    final v = variantsJson?.trim() ?? '';
    if (v.isEmpty || v == 'null' || v == '[]' || v == '{}') return '';
    try {
      final decoded = jsonDecode(v);
      List list = [];
      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map) {
        list = decoded.values.toList();
      }
      final parts = <String>[];
      for (final elem in list) {
        if (elem is Map) {
          final name = (elem['name'] ?? elem['a'] ?? elem['v_name'] ?? '').toString().trim();
          final price = (elem['price'] ?? elem['b'] ?? elem['prc'] ?? elem['p'] ?? '').toString().trim();
          if (name.isNotEmpty && price.isNotEmpty) {
            parts.add("$name: Rs.$price");
          }
        }
      }
      return parts.join(', ');
    } catch (_) {
      return '';
    }
  }

  Future<void> openDownloadedPdf() async {
    final localFile = downloadedLocalPdfFile.value;
    if (localFile != null && await localFile.exists()) {
      try {
        final bytes = await localFile.readAsBytes();
        if (bytes.length > 50) {
          await Printing.layoutPdf(
            onLayout: (_) async => bytes,
            name: generatedPdfResponse.value?.fileName ?? "Menu_PDF",
          );
          return;
        }
      } catch (_) {}
    }

    // Fallback: launch remote URL if valid
    final res = generatedPdfResponse.value;
    if (res != null && res.url.isNotEmpty && res.url.startsWith('http')) {
      final uri = Uri.parse(res.url);
      try {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (_) {
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (_) {}
      }
    }
  }

  Future<void> shareDownloadedPdf() async {
    final localFile = downloadedLocalPdfFile.value;
    if (localFile != null && await localFile.exists()) {
      final bytes = await localFile.readAsBytes();
      if (bytes.length > 50) {
        await Share.shareXFiles(
          [XFile(localFile.path)],
          text: "${restoName.value} - Print-ready Menu PDF",
        );
        return;
      }
    }

    // Fallback: share remote URL
    final res = generatedPdfResponse.value;
    if (res != null && res.url.isNotEmpty) {
      await Share.share("Download Menu PDF:\n${res.url}");
    }
  }

  // --------------------------------------------------------------------------
  // QR Capture & Fallback PDF Print
  // --------------------------------------------------------------------------

  Future<Uint8List?> captureQrPng(GlobalKey qrKey) async {
    try {
      final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 4.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<void> generateAndPrintQrPdf(GlobalKey qrKey) async {
    isGeneratingPdf.value = true;
    try {
      final imageBytes = await captureQrPng(qrKey);
      if (imageBytes == null) return;

      final doc = pw.Document();
      final image = pw.MemoryImage(imageBytes);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    restoName.value,
                    style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "Scan to View Digital Menu (${activeChannelName.value})",
                    style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 28),
                  pw.Container(
                    width: 360,
                    height: 360,
                    child: pw.Image(image),
                  ),
                  pw.SizedBox(height: 24),
                  pw.Text(
                    qrUrl.value,
                    style: const pw.TextStyle(fontSize: 13, color: PdfColors.grey600),
                  ),
                  pw.SizedBox(height: 28),
                  pw.Text(
                    "Powered by eResto",
                    style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey500),
                  ),
                ],
              ),
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: "${restoName.value}_${activeChannelSlug.value}_QR",
      );
    } catch (e) {
      ToastService.showError("Failed to print/generate QR PDF: $e");
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  @override
  void onClose() {
    qrPageController.dispose();
    tabScrollController.dispose();
    headerNameCtrl.dispose();
    headerContactCtrl.dispose();
    headerAddressCtrl.dispose();
    headerCityCtrl.dispose();
    headerPinCtrl.dispose();
    tncNameCtrl.dispose();
    _disposeTncLineCtrls();
    super.onClose();
  }
}
