class DigitalMenuLinkModel {
  final String name;
  final String slug;
  final String fullUrl;

  DigitalMenuLinkModel({
    required this.name,
    required this.slug,
    required this.fullUrl,
  });

  factory DigitalMenuLinkModel.fromJson(Map<String, dynamic> json) {
    return DigitalMenuLinkModel(
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      fullUrl: json['full_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'slug': slug,
        'full_url': fullUrl,
      };
}

class DigitalMenuLinksData {
  final int restoId;
  final String restoName;
  final String menuUrl;
  final List<DigitalMenuLinkModel> menus;

  DigitalMenuLinksData({
    required this.restoId,
    required this.restoName,
    required this.menuUrl,
    required this.menus,
  });

  factory DigitalMenuLinksData.fromJson(Map<String, dynamic> json) {
    final rawMenus = json['menus'] as List<dynamic>? ?? [];
    return DigitalMenuLinksData(
      restoId: json['resto_id'] is int
          ? json['resto_id']
          : int.tryParse(json['resto_id']?.toString() ?? '0') ?? 0,
      restoName: json['resto_name']?.toString() ?? '',
      menuUrl: json['menu_url']?.toString() ?? '',
      menus: rawMenus
          .map((m) => DigitalMenuLinkModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
