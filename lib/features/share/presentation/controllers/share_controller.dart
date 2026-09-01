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
import '../../../../core/services/toast_service.dart';
import '../../../../core/storage/storage_service.dart';

class ShareController extends GetxController {
  final StorageService _storageService;

  final qrUrl = ''.obs;
  final isGeneratingPdf = false.obs;

  ShareController(this._storageService);

  @override
  void onInit() {
    super.onInit();
    generateQrUrl();
  }

  void generateQrUrl() {
    final id = _storageService.restoId;
    if (id != 0) {
      qrUrl.value = "https://menu.eresto.in/r/$id";
    } else {
      qrUrl.value = "https://menu.eresto.in/r/default";
    }
  }

  Future<void> triggerNativeShare(GlobalKey qrKey) async {
    try {
      final imageBytes = await _captureQrPng(qrKey);
      if (imageBytes == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/eresto_menu_qr.png').create();
      await file.writeAsBytes(imageBytes);

      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: "Scan this QR code to view our digital menu: ${qrUrl.value}",
      );

      if (result.status == ShareResultStatus.success) {
        ToastService.showSuccess("Shared successfully");
      }
    } catch (e) {
      ToastService.showError("Failed to share QR: $e");
    }
  }

  Future<void> generateAndPrintPdf(GlobalKey qrKey) async {
    isGeneratingPdf.value = true;
    try {
      final imageBytes = await _captureQrPng(qrKey);
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
                    "eResto Menu",
                    style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "Scan to View Digital Menu",
                    style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Container(
                    width: 300,
                    height: 300,
                    child: pw.Image(image),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text(
                    "Powered by eResto DigiMenu",
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey500),
                  ),
                ],
              ),
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: "eResto_Menu_QR",
      );
    } catch (e) {
      ToastService.showError("Failed to print/generate PDF: $e");
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  Future<Uint8List?> _captureQrPng(GlobalKey qrKey) async {
    try {
      final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      ToastService.showError("Repaint capture error: $e");
      return null;
    }
  }
}
