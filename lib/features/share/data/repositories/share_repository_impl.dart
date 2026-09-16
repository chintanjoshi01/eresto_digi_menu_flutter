import '../../domain/models/digital_menu_link_model.dart';
import '../../domain/models/pdf_download_request.dart';
import '../../domain/models/pdf_download_response.dart';
import '../../domain/models/tnc_model.dart';
import '../../domain/repositories/share_repository.dart';
import '../datasources/share_remote_datasource.dart';

class ShareRepositoryImpl implements ShareRepository {
  final ShareRemoteDataSource _remoteDataSource;

  ShareRepositoryImpl(this._remoteDataSource);

  @override
  Future<DigitalMenuLinksData> getDigitalMenuLinks({int? restoId}) {
    return _remoteDataSource.getDigitalMenuLinks(restoId: restoId);
  }

  @override
  Future<PdfDownloadResponse> downloadTemplatePdf(PdfDownloadRequest request) {
    return _remoteDataSource.downloadTemplatePdf(request);
  }

  @override
  Future<List<int>> downloadTableQrZip({int? restoId}) {
    return _remoteDataSource.downloadTableQrZip(restoId: restoId);
  }

  @override
  Future<List<TncModel>> getTncTemplates({int? restoId}) {
    return _remoteDataSource.getTncTemplates(restoId: restoId);
  }

  @override
  Future<TncModel> createTncTemplate({required String name, required String tnc}) {
    return _remoteDataSource.createTncTemplate(name: name, tnc: tnc);
  }

  @override
  Future<TncModel> updateTncTemplate({required int id, required String name, required String tnc}) {
    return _remoteDataSource.updateTncTemplate(id: id, name: name, tnc: tnc);
  }

  @override
  Future<bool> deleteTncTemplate({required int id}) {
    return _remoteDataSource.deleteTncTemplate(id: id);
  }

  @override
  Future<List<int>> downloadPdfBytes(String url) {
    return _remoteDataSource.downloadPdfBytes(url);
  }
}
