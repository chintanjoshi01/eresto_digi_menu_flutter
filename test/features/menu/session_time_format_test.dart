import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eresto_menu/features/menu/domain/models/channel_session_group_model.dart';

void main() {
  group('SessionCardModel Time Format Tests', () {
    test('Converts 12-hour AM/PM to 24-hour format matching backend requirements', () {
      // User's exact prompt cases:
      // "07:30 am" -> "7:30"
      // "10:30 pm" -> "22:30"
      expect(SessionCardModel.formatTo24Hour("07:30 am"), equals("7:30"));
      expect(SessionCardModel.formatTo24Hour("07:30 AM"), equals("7:30"));
      expect(SessionCardModel.formatTo24Hour("7:30 am"), equals("7:30"));
      expect(SessionCardModel.formatTo24Hour("10:30 pm"), equals("22:30"));
      expect(SessionCardModel.formatTo24Hour("10:30 PM"), equals("22:30"));

      // Midnight & Noon boundaries:
      expect(SessionCardModel.formatTo24Hour("12:00 am"), equals("0:00"));
      expect(SessionCardModel.formatTo24Hour("12:30 am"), equals("0:30"));
      expect(SessionCardModel.formatTo24Hour("12:00 pm"), equals("12:00"));
      expect(SessionCardModel.formatTo24Hour("12:45 pm"), equals("12:45"));

      // Afternoon & Evening cases:
      expect(SessionCardModel.formatTo24Hour("01:15 pm"), equals("13:15"));
      expect(SessionCardModel.formatTo24Hour("11:59 pm"), equals("23:59"));
    });

    test('Passes through already 24-hour time or MySQL TIME string', () {
      expect(SessionCardModel.formatTo24Hour("7:30"), equals("7:30"));
      expect(SessionCardModel.formatTo24Hour("07:30"), equals("7:30"));
      expect(SessionCardModel.formatTo24Hour("22:30"), equals("22:30"));
      expect(SessionCardModel.formatTo24Hour("07:30:00"), equals("7:30"));
      expect(SessionCardModel.formatTo24Hour("22:30:00"), equals("22:30"));
      expect(SessionCardModel.formatTo24Hour("00:00"), equals("0:00"));
    });

    test('Converts 24-hour time to user-friendly 12-hour AM/PM format for UI', () {
      expect(SessionCardModel.formatTo12Hour("7:30"), equals("07:30 am"));
      expect(SessionCardModel.formatTo12Hour("07:30"), equals("07:30 am"));
      expect(SessionCardModel.formatTo12Hour("22:30"), equals("10:30 pm"));
      expect(SessionCardModel.formatTo12Hour("00:00"), equals("12:00 am"));
      expect(SessionCardModel.formatTo12Hour("0:00"), equals("12:00 am"));
      expect(SessionCardModel.formatTo12Hour("12:00"), equals("12:00 pm"));
      expect(SessionCardModel.formatTo12Hour("13:15"), equals("01:15 pm"));

      // If already in 12-hour format, preserves cleanly:
      expect(SessionCardModel.formatTo12Hour("07:30 am"), equals("07:30 am"));
      expect(SessionCardModel.formatTo12Hour("10:30 pm"), equals("10:30 pm"));
    });

    test('SessionCardModel.timingFormatted formats using 12-hour AM/PM', () {
      const session = SessionCardModel(
        id: 2,
        name: 'Breakfast',
        statusText: 'Active Now',
        statusBg: Color(0xFFDCFCE7),
        statusFg: Color(0xFF16A34A),
        templateName: 'Parsi New Year',
        startTime: '7:30',
        endTime: '22:30',
      );

      expect(session.timingFormatted, equals('07:30 am – 10:30 pm'));
    });
  });
}
