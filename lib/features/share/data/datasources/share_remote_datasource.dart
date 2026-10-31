import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../domain/models/digital_menu_link_model.dart';
import '../../domain/models/pdf_download_request.dart';
import '../../domain/models/pdf_download_response.dart';
import '../../domain/models/tnc_model.dart';

abstract class ShareRemoteDataSource {
  Future<DigitalMenuLinksData> getDigitalMenuLinks({int? restoId});
  Future<PdfDownloadResponse> downloadTemplatePdf(PdfDownloadRequest request);
  Future<List<int>> downloadTableQrZip({int? restoId});
  Future<List<TncModel>> getTncTemplates({int? restoId});
  Future<TncModel> createTncTemplate({required String name, required String tnc});
  Future<TncModel> updateTncTemplate({required int id, required String name, required String tnc});
  Future<bool> deleteTncTemplate({required int id});
  Future<List<int>> downloadPdfBytes(String url);
}

class ShareRemoteDataSourceImpl implements ShareRemoteDataSource {
  final ApiClient _apiClient;

  ShareRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DigitalMenuLinksData> getDigitalMenuLinks({int? restoId}) async {
    try {
      final body = restoId != null ? {'resto_id': restoId} : <String, dynamic>{};
      final response = await _apiClient.dio.post(
        Endpoints.v6DigitalMenuLinks,
        data: body,
      );
      final data = response.data;
      if (data != null && data['status'] == 1 && data['data'] != null) {
        return DigitalMenuLinksData.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception(data?['message'] ?? 'Failed to retrieve digital menu links');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PdfDownloadResponse> downloadTemplatePdf(PdfDownloadRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        Endpoints.v6DownloadTemplatePdf,
        data: request.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 1) {
        final inner = data['data'];
        if (inner is Map<String, dynamic>) {
          return PdfDownloadResponse.fromJson(inner);
        } else if (inner is String && inner.trim().isNotEmpty) {
          return PdfDownloadResponse.fromJson({'url': inner.trim()});
        } else {
          return PdfDownloadResponse.fromJson(data);
        }
      } else {
        throw Exception(
          (data is Map ? data['message'] : null) ?? 'Failed to generate menu PDF',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<int>> downloadTableQrZip({int? restoId}) async {
    try {
      final body = restoId != null ? {'resto_id': restoId} : <String, dynamic>{};
      final response = await _apiClient.dio.post<List<int>>(
        Endpoints.v6DownloadTableQrZip,
        data: body,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': 'application/zip, application/json'},
        ),
      );
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('Empty response received from table QR download');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TncModel>> getTncTemplates({int? restoId}) async {
    try {
      final response = await _apiClient.dio.post(
        Endpoints.v6TermsList,
        data: restoId != null ? {'resto_id': restoId} : {},
      );
      final data = response.data;
      if (data != null && data['status'] == 1 && data['data'] is List) {
        return (data['data'] as List)
            .map((item) => TncModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      // Fallback
      return [
        TncModel(
          id: 1,
          tncName: "Tnc",
          tnc: "Outside Food & Liquor Not Permitted In This Hotel.~No Service Charge Is Levied & Rates Are Subject To Change Without Notice.~Additional GST/VAT Applies On Alle Above Items.~Container Charges Rs.10/- Per Container/Give 30 Minutes For Preparation.",
          createdAt: "2022-12-24 09:28:03",
        ),
      ];
    }
  }

  @override
  Future<TncModel> createTncTemplate({required String name, required String tnc}) async {
    try {
      final response = await _apiClient.dio.post(
        Endpoints.v6TermsCreate,
        data: {
          'tnc_name': name,
          'tnc': tnc,
        },
      );
      final data = response.data;
      if (data != null && data['status'] == 1 && data['data'] != null) {
        return TncModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception(data?['message'] ?? 'Failed to create Terms & Conditions');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TncModel> updateTncTemplate({
    required int id,
    required String name,
    required String tnc,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        Endpoints.v6TermsUpdate,
        data: {
          'tnc_id': id,
          'id': id,
          'tnc_name': name,
          'tnc': tnc,
        },
      );
      final data = response.data;
      if (data != null && data['status'] == 1 && data['data'] != null) {
        return TncModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception(data?['message'] ?? 'Failed to update Terms & Conditions');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteTncTemplate({required int id}) async {
    try {
      final response = await _apiClient.dio.post(
        Endpoints.v6TermsDelete,
        data: {
          'tnc_id': id,
          'is_del': 1,
        },
      );
      final data = response.data;
      return data != null && data['status'] == 1;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<int>> downloadPdfBytes(String url) async {
    final cleanUrl = url.trim();
    if (cleanUrl.isEmpty) {
      throw Exception('PDF download URL is empty');
    }
    try {
      final response = await _apiClient.dio.get<List<int>>(
        cleanUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Accept': '*/*',
          },
          followRedirects: true,
          validateStatus: (status) => status != null && status < 400,
        ),
      );
      if (response.data != null && response.data!.isNotEmpty) {
        return response.data!;
      } else {
        throw Exception('Server returned 0 bytes for PDF file');
      }
    } catch (e) {
      rethrow;
    }
  }
}
