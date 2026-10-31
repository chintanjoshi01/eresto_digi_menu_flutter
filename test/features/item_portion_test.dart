import 'package:flutter_test/flutter_test.dart';
import 'package:eresto_menu/features/items/domain/models/v6_menu_items_response.dart';

void main() {
  group('Item Portion & Qty API Mapping Tests', () {
    test('Tea with empty qty ("") parses portion as null instead of "1 portion"', () {
      final json = {
        'id': 1,
        'item_name': 'Tea',
        'item_short_name': 'Te',
        'item_price': '30.00',
        'item_cat_id': 1,
        'menu_type': 0,
        'kitchen_cat_id': 1,
        'item_sales_cat_id': 0,
        'is_na': 1,
        'qty': '',
        'cal': '100',
      };

      final menuItem = V6ApiMenuItem.fromJson(json);
      final model = menuItem.toItemModel(categoryName: 'Hot Beverages');
      final record = menuItem.toIsarCollection(categoryName: 'Hot Beverages');

      expect(menuItem.qty, '');
      expect(model.portion, isNull, reason: 'Empty qty should map to null portion, not "1 portion"');
      expect(record.portion, isNull, reason: 'Empty qty should store null in Isar');
    });

    test('Kullad Tea with null qty parses portion as null instead of "1 portion"', () {
      final json = {
        'id': 2,
        'item_name': 'Kullad Tea 2',
        'item_short_name': 'KT2',
        'item_price': '35.00',
        'item_cat_id': 1,
        'menu_type': 1,
        'is_na': 0,
        'qty': null,
      };

      final menuItem = V6ApiMenuItem.fromJson(json);
      final model = menuItem.toItemModel(categoryName: 'Hot Beverages');

      expect(menuItem.qty, isNull);
      expect(model.portion, isNull, reason: 'Null qty should map to null portion');
    });

    test('Tea 2 with qty "20" parses portion as "20" without appending " portion"', () {
      final json = {
        'id': 59,
        'item_name': 'Tea 2',
        'item_short_name': 'T2',
        'item_price': '250.00',
        'item_cat_id': 1,
        'qty': '20',
      };

      final menuItem = V6ApiMenuItem.fromJson(json);
      final model = menuItem.toItemModel(categoryName: 'Hot Beverages');

      expect(model.portion, equals('20'), reason: 'Should preserve exact qty without appending extra " portion"');
    });

    test('Item with qty "100 ML" parses portion as "100 ML"', () {
      final json = {
        'id': 1,
        'item_name': 'Tea',
        'item_price': '30.00',
        'qty': '100 ML',
      };

      final menuItem = V6ApiMenuItem.fromJson(json);
      final model = menuItem.toItemModel(categoryName: 'Hot Beverages');

      expect(model.portion, equals('100 ML'), reason: 'Should preserve unit measurements like "100 ML"');
    });
  });

  group('Item Allergens & AIK Parsing Tests', () {
    test('Correctly maps all 8 allergens including "Crusta" to "Crustacean"', () {
      final json = {
        'id': 1,
        'item_name': 'Tea',
        'item_price': '30.00',
        'aik': 'Gluten,Eggs,Peanuts,Milk,Nuts,Soyabean,Fish,Crusta',
      };

      final menuItem = V6ApiMenuItem.fromJson(json);
      final allergens = menuItem.parsedAllergens;

      expect(allergens, isNotNull);
      expect(allergens!.length, equals(8));
      expect(allergens, contains('Gluten'));
      expect(allergens, contains('Eggs'));
      expect(allergens, contains('Peanuts'));
      expect(allergens, contains('Milk'));
      expect(allergens, contains('Nuts'));
      expect(allergens, contains('Soyabean'));
      expect(allergens, contains('Fish'));
      expect(allergens, contains('Crustacean'));
    });

    test('Correctly handles "Crustacean" in aik without modification', () {
      final json = {
        'id': 59,
        'item_name': 'Tea 2',
        'item_price': '250.00',
        'aik': 'Gluten,Nuts,Crustacean,Milk',
      };

      final menuItem = V6ApiMenuItem.fromJson(json);
      final allergens = menuItem.parsedAllergens;

      expect(allergens, isNotNull);
      expect(allergens!.length, equals(4));
      expect(allergens, contains('Crustacean'));
    });
  });
}
