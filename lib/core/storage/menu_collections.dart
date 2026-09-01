import 'package:isar/isar.dart';

part 'menu_collections.g.dart';

@collection
class MenuItemCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int remoteId;
  late String name;
  late String shortCode;
  late double price;
  late bool isAvailable;
  late bool isFrequentlySold;
  late String vegType;
  String? portion;
  int? calorificValue;
  int? serviceTime;
  String? ingredients;
  String? shortDescription;
  late String itemGroup;
  late String taxTemplate;
  String? kitchenCategory;
  String? salesCategory;
  List<String>? dietaryTags;
  List<String>? allergens;
  String? imageUrl;
}

@collection
class MenuTemplateCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int remoteId;
  late String name;
  late String primaryColor;
  late String backgroundColor;
  late String textColor;
  late bool isActive;
}

@collection
class MenuSessionCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int remoteId;
  late String name;
  late String startTime;
  late String endTime;
  late bool isActive;
  String? splashImageUrl;
  String? offerImageUrl;
  String? offerDescription;
}

@collection
class DashboardAnalyticsCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String period; // today | week | month
  late int totalScans;
  late List<int> scanChartData;
  late List<String> scanChartLabels;
  late int lastUpdatedTime; // Epoch ms for TTL check (5 min TTL)
}
