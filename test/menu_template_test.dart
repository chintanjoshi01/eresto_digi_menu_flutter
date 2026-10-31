import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eresto_menu/features/menu/domain/models/menu_template_model.dart';

void main() {
  group('MenuTemplateModel V6 API Tests', () {
    test('Correctly parses single menu template without fake multi tag or fake pills', () {
      final json = {
        'id': 11,
        'menu_tmpl_name': 'SMC18-7',
        'menu_type': 1,
        'is_multi': 0,
        'theme_id': 1,
        'theme_name': 'Basic - 1',
        'theme_short_name': 'T1',
        'theme_group': 'BASIC',
        'tagline': '',
        'price_list_id': 0,
        'language_id': 1,
        'language_name': 'English',
        'items_total': 28,
        'item_categories_count': 4,
        'menu_categories_count': 0,
        'sessions': [
          {'id': 1, 'session_name': 'Lunch'}
        ],
      };

      final tmpl = MenuTemplateModel.fromJson(json);

      expect(tmpl.id, 11);
      expect(tmpl.name, 'SMC18-7');
      expect(tmpl.isMulti, false);
      expect(tmpl.isActive, true);
      expect(tmpl.extraPills, isEmpty);
      expect(tmpl.themeColor, const Color(0xFFC1272D)); // Red for Basic
      expect(tmpl.details, 'BASIC · T1 · Used in 1 session · 28 items');
      expect(tmpl.menuType, 'Single Menu');
    });

    test('Correctly parses multi-category template with actual theme and no fake pills', () {
      final json = {
        'id': 13,
        'menu_tmpl_name': 'Multi Menu',
        'menu_type': 1,
        'is_multi': 1,
        'theme_id': 1,
        'theme_name': 'Basic - 1',
        'theme_short_name': 'T1',
        'theme_group': 'BASIC',
        'tagline': '',
        'price_list_id': 0,
        'language_id': 1,
        'language_name': 'English',
        'items_total': 114,
        'item_categories_count': 12,
        'menu_categories_count': 3,
        'sessions': [
          {'id': 1, 'session_name': 'Lunch'}
        ],
      };

      final tmpl = MenuTemplateModel.fromJson(json);

      expect(tmpl.id, 13);
      expect(tmpl.name, 'Multi Menu');
      expect(tmpl.isMulti, true);
      expect(tmpl.isActive, true);
      expect(tmpl.extraPills, isEmpty); // No fake Food/Beverages pills
      expect(tmpl.themeColor, const Color(0xFFC1272D)); // Real theme: Basic - 1 (Red), NOT overridden to purple!
      expect(tmpl.details, 'BASIC · T1 · 3 menu cats · 114 items · 1 session');
      expect(tmpl.menuType, 'Multi Category Menu');
    });

    test('Inactive multi template has isActive = false and sorts after active templates', () {
      final activeTmpl = MenuTemplateModel.fromJson({
        'id': 11,
        'menu_tmpl_name': 'SMC18-7',
        'is_multi': 0,
        'sessions': [{'id': 1}],
      });

      final inactiveMultiTmpl = MenuTemplateModel.fromJson({
        'id': 12,
        'menu_tmpl_name': 'Test18Aug',
        'is_multi': 1,
        'sessions': [],
      });

      final list = [inactiveMultiTmpl, activeTmpl];
      list.sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return a.id.compareTo(b.id);
      });

      expect(list.first.id, 11);
      expect(list.first.isActive, true);
      expect(list.last.id, 12);
      expect(list.last.isActive, false);
    });
  });
}
