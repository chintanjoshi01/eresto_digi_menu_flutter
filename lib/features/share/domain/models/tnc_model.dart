class TncModel {
  final int id;
  final String tnc;
  final String tncName;
  final String? createdAt;
  final String? updatedAt;

  TncModel({
    required this.id,
    required this.tnc,
    required this.tncName,
    this.createdAt,
    this.updatedAt,
  });

  factory TncModel.fromJson(Map<String, dynamic> json) {
    return TncModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      tnc: json['tnc']?.toString() ?? '',
      tncName: json['tnc_name']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tnc_name': tncName,
        'tnc': tnc,
      };

  List<String> get lines {
    if (tnc.isEmpty) return [];
    if (tnc.contains('~')) {
      return tnc.split('~').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }
    return tnc.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  static String joinLines(List<String> lines) {
    return lines.map((s) => s.trim()).where((s) => s.isNotEmpty).join('~');
  }

  String get formattedDate {
    if (createdAt == null || createdAt!.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt!);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final day = dt.day.toString().padLeft(2, '0');
      final month = months[dt.month - 1];
      final year = dt.year;
      return "$day, $month $year";
    } catch (_) {
      return createdAt!;
    }
  }

  TncModel copyWith({
    int? id,
    String? tnc,
    String? tncName,
    String? createdAt,
    String? updatedAt,
  }) {
    return TncModel(
      id: id ?? this.id,
      tnc: tnc ?? this.tnc,
      tncName: tncName ?? this.tncName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
