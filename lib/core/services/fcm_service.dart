import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../firebase_options.dart';
import 'logger_service.dart';
import 'toast_service.dart';

/// Top-level background message handler for FCM
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {}
  if (kDebugMode) {
    debugPrint('📩 [FCM] Background message: ${message.messageId}');
  }
}

/// Enterprise Firebase Cloud Messaging Service
class FcmService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  bool _hasRequestedPermission = false;
  bool get hasRequestedPermission => _hasRequestedPermission;

  Future<FcmService> init() async {
    try {
      // 1. Fetch and store FCM Token
      await _fetchToken();

      // 2. Listen to token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _log('🔄 [FCM] Token refreshed: $newToken');
      });

      // 4. Foreground message listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _log('📬 [FCM] Foreground message received: ${message.notification?.title ?? message.data}');
        final title = message.notification?.title;
        final body = message.notification?.body;
        if (title != null || body != null) {
          final displayMsg = [title, body].where((s) => s != null && s.isNotEmpty).join(': ');
          ToastService.showInfo(displayMsg);
        }
      });

      // 5. Message opened app (user taps notification from background)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _log('🚀 [FCM] Notification opened app: ${message.data}');
      });

      // 6. Check for initial message (app launched from terminated state)
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _log('🌟 [FCM] App opened from terminated notification: ${initialMessage.data}');
      }
    } catch (e, stack) {
      _logError('FCM initialization error', e, stack);
    }
    return this;
  }

  /// Request runtime notification permissions from the user.
  /// Triggered on Dashboard landing, not on Splash screen.
  Future<NotificationSettings?> requestNotificationPermissions() async {
    if (_hasRequestedPermission) return null;
    _hasRequestedPermission = true;
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      _log('🔔 Notification authorization status: ${settings.authorizationStatus}');
      return settings;
    } catch (e, stack) {
      _logError('Failed to request notification permission', e, stack);
      return null;
    }
  }

  Future<void> _fetchToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      _log('🔑 [FCM] Registration Token: $_fcmToken');
    } catch (e) {
      _log('⚠️ [FCM] Failed to get registration token: $e');
    }
  }

  void _log(String message) {
    if (Get.isRegistered<LoggerService>()) {
      Get.find<LoggerService>().i(message);
    } else {
      debugPrint(message);
    }
  }

  void _logError(String message, dynamic error, StackTrace? stack) {
    if (Get.isRegistered<LoggerService>()) {
      Get.find<LoggerService>().e(message, error: error, stackTrace: stack);
    } else {
      debugPrint('❌ $message: $error');
    }
  }
}
