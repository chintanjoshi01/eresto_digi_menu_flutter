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
    return PdfDownloadResponse(
      filePath: json['file_path']?.toString() ?? '',
      fileUrl: json['file_url']?.toString() ?? json['url']?.toString() ?? '',
      url: json['url']?.toString() ?? json['file_url']?.toString() ?? '',
      fileName: json['file_name']?.toString() ?? '',
    );
  }
}
