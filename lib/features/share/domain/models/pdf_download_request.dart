class PdfDownloadRequest {
  final int templateId;
  final int? restoId;
  final String pdfStyle; // 'card', 'compact', 'classic'
  final String cardStyle; // 'single', 'double'
  final String headerAlign; // 'left', 'center', 'right'
  final String catAlign; // 'left', 'center'
  final String catStyle; // 'plain', 'solid', 'gradient'
  final String bgTheme; // 'white', 'cream', 'beige', 'blush', 'grey'
  final int fontStyle; // 0 = normal, 1 = UPPERCASE, 2 = Capitalize
  final int showHeaderName; // 1 or 0
  final int showHeaderAddress; // 1 or 0
  final int showHeaderContact; // 1 or 0
  final int size; // 1 or 0 (portion/variant)
  final int cal; // 1 or 0 (calories)
  final int des; // 1 or 0 (description)
  final int ing; // 1 or 0 (ingredients)
  final int aik; // 1 or 0 (allergens)
  final String? restoName;
  final String? restoContact;
  final String? restoCity;
  final String? restoPin;
  final String? restoAdd;

  PdfDownloadRequest({
    required this.templateId,
    this.restoId,
    this.pdfStyle = 'card',
    this.cardStyle = 'single',
    this.headerAlign = 'center',
    this.catAlign = 'left',
    this.catStyle = 'plain',
    this.bgTheme = 'white',
    this.fontStyle = 0,
    this.showHeaderName = 1,
    this.showHeaderAddress = 1,
    this.showHeaderContact = 0,
    this.size = 0,
    this.cal = 0,
    this.des = 0,
    this.ing = 0,
    this.aik = 0,
    this.restoName,
    this.restoContact,
    this.restoCity,
    this.restoPin,
    this.restoAdd,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'template_id': templateId,
      'menu_tmpl_id': templateId,
      'id': templateId,
      'pdf_style': pdfStyle,
      'card_style': pdfStyle == 'compact' ? 'double' : cardStyle,
      'header_align': headerAlign,
      'cat_align': catAlign,
      'cat_style': catStyle,
      'bg_theme': bgTheme,
      'font_style': fontStyle,
      'show_header_name': showHeaderName,
      'show_header_address': showHeaderAddress,
      'show_header_contact': showHeaderContact,
      'size': size,
      'cal': cal,
      'des': des,
      'ing': ing,
      'aik': aik,
    };
    if (restoId != null) map['resto_id'] = restoId;
    if (restoName != null && restoName!.isNotEmpty) map['resto_name'] = restoName;
    if (restoContact != null && restoContact!.isNotEmpty) map['resto_contact'] = restoContact;
    if (restoCity != null && restoCity!.isNotEmpty) map['resto_city'] = restoCity;
    if (restoPin != null && restoPin!.isNotEmpty) map['resto_pin'] = restoPin;
    if (restoAdd != null && restoAdd!.isNotEmpty) map['resto_add'] = restoAdd;
    return map;
  }
}
