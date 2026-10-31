import '../../../../core/api/endpoints.dart';

class PdfDownloadResponse {
  final String filePath;
  final String fileUrl;
  final String url;
  final String fileName;

  PdfDownloadResponse({
    required this.filePath,
    required this.fileUrl,
    required this.url,
    required this.fileName,
  });

  factory PdfDownloadResponse.fromJson(Map<String, dynamic> json) {
    final rawFilePath = json['file_path']?.toString().trim() ?? '';
    final rawFileUrl = (json['file_url'] ?? json['pdf_url'] ?? json['download_url'] ?? json['link'])
            ?.toString()
            .trim() ??
        '';
    final rawUrl = json['url']?.toString().trim() ?? '';
    final rawName = json['file_name']?.toString().trim() ?? '';

    String candidateUrl = rawUrl.isNotEmpty
        ? rawUrl
        : (rawFileUrl.isNotEmpty ? rawFileUrl : rawFilePath);

    // Normalize relative paths to absolute URLs
    if (candidateUrl.isNotEmpty &&
        !candidateUrl.startsWith('http://') &&
        !candidateUrl.startsWith('https://')) {
      final useAssetsHost = candidateUrl.contains('treasure/') || candidateUrl.contains('archive/');
      final base = useAssetsHost ? Endpoints.activeAssetsBaseUrl : Endpoints.baseUrl;
      final cleanBase = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
      final cleanPath = candidateUrl.startsWith('/') ? candidateUrl : '/$candidateUrl';
      candidateUrl = '$cleanBase$cleanPath';
    }

    // Normalize fileName
    String resolvedName = rawName;
    if (resolvedName.isEmpty) {
      if (candidateUrl.isNotEmpty) {
        final lastSegment = candidateUrl.split('/').last.split('?').first;
        if (lastSegment.toLowerCase().endsWith('.pdf')) {
          resolvedName = lastSegment;
        }
      }
    }
    if (resolvedName.isEmpty) {
      resolvedName = 'menu_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } else if (!resolvedName.toLowerCase().endsWith('.pdf')) {
      resolvedName = '$resolvedName.pdf';
    }

    return PdfDownloadResponse(
      filePath: rawFilePath,
      fileUrl: candidateUrl,
      url: candidateUrl,
      fileName: resolvedName,
    );
  }
}

