import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/models/channel_session_group_model.dart';

class GalleryUploadResult {
  final bool success;
  final String fileName;
  final String fullUrl;
  final String galleryType;
  final int restoId;
  final String message;

  const GalleryUploadResult({
    required this.success,
    required this.fileName,
    required this.fullUrl,
    required this.galleryType,
    required this.restoId,
    required this.message,
  });
}

abstract class GalleryRemoteDataSource {
  Future<List<String>> getGalleryImages();
  Future<GalleryUploadResult> uploadGalleryImage({
    required Uint8List imageBytes,
    required String fileName,
    required String type, // 'splash', 'offer', 'slider'
    void Function(int sent, int total)? onSendProgress,
  });
}

class GalleryRemoteDataSourceImpl implements GalleryRemoteDataSource {
  final ApiClient _apiClient;

  GalleryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<String>> getGalleryImages() async {
    try {
      final currentRestoId = Get.isRegistered<StorageService>() ? Get.find<StorageService>().restoId : 0;
      final payload = <String, dynamic>{};
      if (currentRestoId > 0) {
        payload['resto_id'] = currentRestoId;
        payload['rid'] = currentRestoId;
      }

      final response = await _apiClient.dio.post(
        Endpoints.v6GetGallery,
        data: payload,
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 1) {
          final rawData = data['data'];
          if (rawData is List) {
            return rawData
                .map((e) {
                  if (e is Map) {
                    return (e['image'] ?? e['img'] ?? e['name'] ?? e['filename'] ?? e['file'] ?? '').toString().trim();
                  }
                  return e.toString().trim();
                })
                .where((e) => e.isNotEmpty)
                .toList();
          } else if (rawData is Map<String, dynamic>) {
            final list = rawData['images'] ?? rawData['gallery'] ?? rawData['gallery_images'] ?? rawData['items'] ?? rawData['files'];
            if (list is List) {
              return list
                  .map((e) {
                    if (e is Map) {
                      return (e['image'] ?? e['img'] ?? e['name'] ?? e['filename'] ?? e['file'] ?? '').toString().trim();
                    }
                    return e.toString().trim();
                  })
                  .where((e) => e.isNotEmpty)
                  .toList();
            }
          }
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<GalleryUploadResult> uploadGalleryImage({
    required Uint8List imageBytes,
    required String fileName,
    required String type,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final cleanType = type.trim().toLowerCase();
      final formData = FormData.fromMap({
        'type': cleanType,
        'images[0]': MultipartFile.fromBytes(
          imageBytes,
          filename: fileName,
        ),
      });

      final response = await _apiClient.dio.post(
        Endpoints.uploadGalleryNeo,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final resMap = response.data as Map<String, dynamic>;
        final dataMap = resMap['data'] is Map<String, dynamic>
            ? resMap['data'] as Map<String, dynamic>
            : <String, dynamic>{};

        final uploadedList = (dataMap['uploaded_images'] as List? ?? [])
            .map((e) => e.toString())
            .toList();
        final failedList = (dataMap['failed_uploads'] as List? ?? [])
            .map((e) => e.toString())
            .toList();

        if (uploadedList.isNotEmpty) {
          final uploadedName = uploadedList.first;
          final storageRestoId = Get.isRegistered<StorageService>() ? Get.find<StorageService>().restoId : 0;
          final serverRestoId = dataMap['resto_id'] is int
              ? dataMap['resto_id'] as int
              : (int.tryParse(dataMap['resto_id']?.toString() ?? '') ?? 0);
          final restoId = serverRestoId > 0 ? serverRestoId : (storageRestoId > 0 ? storageRestoId : 0);

          final fullUrl = SessionCardModel.resolveGalleryUrl(uploadedName, restoId > 0 ? restoId : null);

          return GalleryUploadResult(
            success: true,
            fileName: uploadedName,
            fullUrl: fullUrl,
            galleryType: cleanType,
            restoId: restoId,
            message: resMap['message']?.toString() ?? 'Image uploaded successfully.',
          );
        } else if (failedList.isNotEmpty) {
          throw ApiException(message: failedList.join('\n'));
        }
      }

      throw ApiException(message: 'Failed to upload gallery image.');
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final map = e.response!.data as Map<String, dynamic>;
        final msg = map['message']?.toString() ?? 'Server upload error';
        throw ApiException(message: msg);
      }
      throw _apiClient.handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }
}
