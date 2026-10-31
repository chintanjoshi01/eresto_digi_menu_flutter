import 'package:flutter_test/flutter_test.dart';
import 'package:eresto_menu/core/api/endpoints.dart';
import 'package:eresto_menu/features/items/domain/models/v6_menu_items_response.dart';
import 'package:eresto_menu/features/menu/domain/models/channel_session_group_model.dart';

void main() {
  setUp(() {
    // Reset to default before each test
    Endpoints.baseUrl = Endpoints.defaultBaseUrl;
  });

  test('Endpoints extracts rootDomain and assetsBaseUrl dynamically from API baseUrl', () {
    Endpoints.baseUrl = 'https://plus.eresto.in';
    expect(Endpoints.extractRootDomain(), equals('eresto.in'));
    expect(Endpoints.domainExtension, equals('in'));
    expect(Endpoints.assetsBaseUrl, equals('https://assets.eresto.in'));

    Endpoints.baseUrl = 'https://plus.eresto.app';
    expect(Endpoints.extractRootDomain(), equals('eresto.app'));
    expect(Endpoints.domainExtension, equals('app'));
    expect(Endpoints.assetsBaseUrl, equals('https://assets.eresto.app'));
  });

  test('Gallery URL resolves dynamically according to active API baseUrl domain', () {
    // 1. When API is .in
    Endpoints.baseUrl = 'https://plus.eresto.in';
    final inUrl = SessionCardModel.resolveGalleryUrl('off_1.webp', 801);
    expect(inUrl, equals('https://assets.eresto.in/public/treasure/801/archive/gallery/off_1.webp'));

    // 2. When API is .app
    Endpoints.baseUrl = 'https://plus.eresto.app';
    final appUrl = SessionCardModel.resolveGalleryUrl('off_1.webp', 85);
    expect(appUrl, equals('https://assets.eresto.app/public/treasure/85/archive/gallery/off_1.webp'));
  });

  test('Item image URL resolves using img_base from API response', () {
    Endpoints.baseUrl = 'https://plus.eresto.in';
    final json = {
      'status': 1,
      'data': {
        'img_base': 'https://assets.eresto.in/public/treasure/801/archive/item_images/',
        'items': [
          {
            'category_name': 'Hot Beverages',
            'menu_type': 1,
            'category_display_order': 0,
            'item_cat_id': 1,
            'en': 1,
            'items': [
              {
                'id': 1,
                'item_name': 'Tea',
                'item_price': '30.00',
                'item_cat_id': 1,
                'item_image': '801_20241221124703.jpeg',
              }
            ]
          }
        ]
      }
    };

    final resp = V6MenuItemsResponse.fromJson(json);
    expect(resp.baseUrl, equals('https://assets.eresto.in/public/treasure/801/archive/item_images/'));
    
    final item = resp.data.first.items.first;
    expect(item.baseUrl, equals('https://assets.eresto.in/public/treasure/801/archive/item_images/'));
    
    final model = item.toItemModel(categoryName: 'Hot Beverages');
    expect(
      model.imageUrl,
      equals('https://assets.eresto.in/public/treasure/801/archive/item_images/801_20241221124703.jpeg'),
    );
  });

  test('Item image URL resolves with item_base key as well', () {
    Endpoints.baseUrl = 'https://plus.eresto.in';
    final json = {
      'status': 1,
      'data': {
        'item_base': 'https://assets.eresto.in/public/treasure/801/archive/item_images/',
        'items': [
          {
            'category_name': 'Hot Beverages',
            'menu_type': 1,
            'category_display_order': 0,
            'item_cat_id': 1,
            'en': 1,
            'items': [
              {
                'id': 2,
                'item_name': 'Kullad Tea',
                'item_price': '35.00',
                'item_cat_id': 1,
                'item_image': '801_20241221124704.jpeg',
              }
            ]
          }
        ]
      }
    };

    final resp = V6MenuItemsResponse.fromJson(json);
    expect(resp.baseUrl, equals('https://assets.eresto.in/public/treasure/801/archive/item_images/'));
    
    final item = resp.data.first.items.first;
    final model = item.toItemModel(categoryName: 'Hot Beverages');
    expect(
      model.imageUrl,
      equals('https://assets.eresto.in/public/treasure/801/archive/item_images/801_20241221124704.jpeg'),
    );
  });

  test('Auto-heals / aligns domain with active API baseUrl', () {
    Endpoints.baseUrl = 'https://plus.eresto.in';
    final fixedUrl = V6ApiMenuItem.resolveImageUrl(
      itemImage: 'https://assets.eresto.app/public/treasure/801/archive/item_images/801_20241221124703.jpeg',
    );
    expect(
      fixedUrl,
      equals('https://assets.eresto.in/public/treasure/801/archive/item_images/801_20241221124703.jpeg'),
    );

    Endpoints.baseUrl = 'https://plus.eresto.app';
    final appAlignedUrl = V6ApiMenuItem.resolveImageUrl(
      itemImage: 'https://assets.eresto.in/public/treasure/85/archive/item_images/85_sample.jpeg',
    );
    expect(
      appAlignedUrl,
      equals('https://assets.eresto.app/public/treasure/85/archive/item_images/85_sample.jpeg'),
    );
  });
}
