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
import '../../../menu/presentation/controllers/menu_theme_controller.dart';

class ShareController extends GetxController {
  final ShareRepository _shareRepository;
  final StorageService _storageService;

  ShareController(this._shareRepository, this._storageService);

  // --- Dynamic Digital Menu Links State ---
  final isLoadingLinks = false.obs;
  final digitalChannels = <DigitalMenuLinkModel>[].obs;
  final activeChannelSlug = 'dine-in'.obs;
  final activeChannelName = 'Dine In'.obs;
  final qrUrl = 'https://menu.eresto.in/trulyy-tadkaaz/dine-in'.obs;
  final restoName = 'Trulyy Tadkaaz'.obs;

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
  final selectedTemplateId = 1.obs;
  final selectedTemplateName = 'Breakfast'.obs;

  // Step 1: Header Fields
  final headerNameCtrl = TextEditingController(text: 'Trulyy Tadkaaz');
  final headerContactCtrl = TextEditingController(text: '+91 98765 43210');
  final headerAddressCtrl = TextEditingController(text: 'Near Ring Road, Kalawad Road');
  final headerCityCtrl = TextEditingController(text: 'Rajkot');
  final headerPinCtrl = TextEditingController(text: '360005');

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

  @override
  void onInit() {
    super.onInit();
    _loadCachedProfileInfo();
    fetchDigitalMenuLinks();
    fetchTnc();
  }

  void _loadCachedProfileInfo() {
    final cachedName = _storageService.restoName;
    if (cachedName.isNotEmpty) {
      restoName.value = cachedName;
      headerNameCtrl.text = cachedName;
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
        final defaultChannel = data.menus.firstWhere(
          (m) => m.slug.toLowerCase() == 'dine-in' || m.name.toLowerCase().contains('dine'),
          orElse: () => data.menus.first,
        );
        selectChannel(defaultChannel);
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
    selectChannel(digitalChannels.first);
  }

  void selectChannel(DigitalMenuLinkModel channel) {
    HapticFeedback.selectionClick();
    activeChannelSlug.value = channel.slug;
    activeChannelName.value = channel.name;
    qrUrl.value = channel.fullUrl;
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

  void resetPdfWizard() {
    pdfCurrentStep.value = 0;
    generatedPdfResponse.value = null;
    downloadedLocalPdfFile.value = null;
    isGeneratingPdf.value = false;
    isDownloadingPdfFile.value = false;
  }

  void nextPdfStep() {
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
    HapticFeedback.mediumImpact();
    try {
      final req = PdfDownloadRequest(
        templateId: selectedTemplateId.value,
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
        restoName: headerNameCtrl.text.trim(),
        restoContact: headerContactCtrl.text.trim(),
        restoCity: headerCityCtrl.text.trim(),
        restoPin: headerPinCtrl.text.trim(),
        restoAdd: headerAddressCtrl.text.trim(),
      );

      final response = await _shareRepository.downloadTemplatePdf(req);
      generatedPdfResponse.value = response;

      // Automatically download the actual PDF file bytes locally so it can be opened & shared!
      isDownloadingPdfFile.value = true;
      try {
        final bytes = await _shareRepository.downloadPdfBytes(response.url);
        final tempDir = await getTemporaryDirectory();
        final localFile = File('${tempDir.path}/${response.fileName}');
        await localFile.writeAsBytes(bytes);
        downloadedLocalPdfFile.value = localFile;
        ToastService.showSuccess("Menu PDF generated & downloaded locally!");
      } catch (_) {
        // Still have web URL
        ToastService.showSuccess("Menu PDF generated successfully!");
      } finally {
        isDownloadingPdfFile.value = false;
      }

      HapticFeedback.heavyImpact();
    } catch (e) {
      ToastService.showError("PDF generation error: $e");
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  Future<void> openDownloadedPdf() async {
    final localFile = downloadedLocalPdfFile.value;
    if (localFile != null && await localFile.exists()) {
      try {
        final bytes = await localFile.readAsBytes();
        await Printing.layoutPdf(
          onLayout: (_) async => bytes,
          name: generatedPdfResponse.value?.fileName ?? "Menu_PDF",
        );
        return;
      } catch (_) {}
    }

    // Fallback: launch remote URL
    final res = generatedPdfResponse.value;
    if (res != null && res.url.isNotEmpty) {
      final uri = Uri.parse(res.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> shareDownloadedPdf() async {
    final localFile = downloadedLocalPdfFile.value;
    if (localFile != null && await localFile.exists()) {
      await Share.shareXFiles(
        [XFile(localFile.path)],
        text: "${restoName.value} - Print-ready Menu PDF",
      );
      return;
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

      final image = await boundary.toImage(pixelRatio: 3.0);
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
                    style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "Scan to View Digital Menu (${activeChannelName.value})",
                    style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Container(
                    width: 280,
                    height: 280,
                    child: pw.Image(image),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    qrUrl.value,
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey600),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text(
                    "Powered by eResto",
                    style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey500),
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
