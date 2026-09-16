import '../../domain/models/digital_menu_link_model.dart';
import '../../domain/models/pdf_download_request.dart';
import '../../domain/models/pdf_download_response.dart';
import '../../domain/models/tnc_model.dart';

abstract class ShareRepository {
  Future<DigitalMenuLinksData> getDigitalMenuLinks({int? restoId});
  Future<PdfDownloadResponse> downloadTemplatePdf(PdfDownloadRequest request);
  Future<List<int>> downloadTableQrZip({int? restoId});
  Future<List<TncModel>> getTncTemplates({int? restoId});
  Future<TncModel> createTncTemplate({required String name, required String tnc});
  Future<TncModel> updateTncTemplate({required int id, required String name, required String tnc});
  Future<bool> deleteTncTemplate({required int id});
  Future<List<int>> downloadPdfBytes(String url);
}
