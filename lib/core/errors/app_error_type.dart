import 'package:flutter/material.dart';
import '../api/api_exception.dart';
import '../services/device_service.dart';
import '../theme/app_colors.dart';
import 'failures.dart';

/// Enterprise Error & State Categorization
enum AppErrorType {
  /// App version outdated / server requests upgrade from Google Play Store
  appUpdate,

  /// Restaurant subscription has expired (Flag 0: validity and grace period elapsed)
  subscriptionExpired,

  /// No internet, Wi-Fi disabled, network timeout, socket unreachable
  network,

  /// Cloud server undergoing scheduled maintenance or temporary downtime (503)
  maintenance,

  /// Authentication token expired, invalid session, 401 Unauthorized
  unauthorized,

  /// Cloud backend error, 500 Internal Server Error, unhandled exception
  serverError,

  /// Restaurant account does not have license/permission for DigiMenu module
  permissionDenied,

  /// General / unspecified failure
  generic,
}

/// Metadata packet describing visual presentation tokens for an error type
class AppErrorVisuals {
  final String title;
  final String defaultMessage;
  final IconData icon;
  final Color primaryColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color statusDotColor;
  final String cardHeader;
  final IconData cardIcon;
  final List<String> tips;
  final String primaryButtonText;
  final IconData primaryButtonIcon;
  final bool showPlayStoreAction;
  final bool showOfflineModeAction;

  const AppErrorVisuals({
    required this.title,
    required this.defaultMessage,
    required this.icon,
    required this.primaryColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.statusDotColor,
    required this.cardHeader,
    required this.cardIcon,
    required this.tips,
    required this.primaryButtonText,
    required this.primaryButtonIcon,
    this.showPlayStoreAction = false,
    this.showOfflineModeAction = true,
  });
}

/// Enterprise Classifier to convert raw errors, status codes, and messages into structured types
class AppErrorClassifier {
  AppErrorClassifier._();

  /// Inspects any error payload and categorizes it into a discrete [AppErrorType]
  static AppErrorType classify(
    dynamic error, {
    String? message,
    int? statusCode,
  }) {
    // 1. Explicit domain failure check
    if (error is AppUpgradeRequiredFailure) {
      return AppErrorType.appUpdate;
    }
    if (error is NetworkFailure) {
      return AppErrorType.network;
    }
    if (error is UnauthorizedFailure) {
      return AppErrorType.unauthorized;
    }
    if (error is PermissionFailure) {
      return AppErrorType.permissionDenied;
    }

    // 2. Check details payload for subscription expired or force update flags
    if (error is ApiException && error.details is Map) {
      final details = error.details as Map;
      if (details['subscription_expired'] == true ||
          details['flag'] == 0 ||
          details['flag'] == 4 ||
          details['flag'] == '0' ||
          details['flag'] == '4') {
        return AppErrorType.subscriptionExpired;
      }
      final forceVal = details['force'];
      final isForce = details['is_force_upgrade'] == true;
      if (forceVal == 1 || forceVal == 2 || forceVal == '1' || forceVal == '2' || isForce) {
        return AppErrorType.appUpdate;
      }
    }

    // 3. HTTP status code inspection
    final resolvedStatus = statusCode ??
        (error is ApiException ? error.statusCode : null) ??
        (error is Failure ? error.statusCode : null);

    if (resolvedStatus == 401) {
      return AppErrorType.unauthorized;
    }
    if (resolvedStatus == 403) {
      // If error details/message indicates expired subscription, categorize specifically
      if (error is ApiException && error.details is Map) {
        final d = error.details as Map;
        if (d['subscription_expired'] == true ||
            d['flag'] == 0 ||
            d['flag'] == 4 ||
            d['flag'] == '0' ||
            d['flag'] == '4') {
          return AppErrorType.subscriptionExpired;
        }
      }
      return AppErrorType.permissionDenied;
    }
    if (resolvedStatus == 503) {
      return AppErrorType.maintenance;
    }

    // 4. String content inspection
    final rawMessage = (message ??
            (error is Failure ? error.message : null) ??
            (error is ApiException ? error.message : null) ??
            error?.toString() ??
            "")
        .toLowerCase()
        .trim();

    // Check Subscription Expired keywords (Priority over general permission)
    if (rawMessage.contains("subscription has expired") ||
        rawMessage.contains("subscription expired") ||
        rawMessage.contains("renew your subscription") ||
        rawMessage.contains("renew subscription") ||
        rawMessage.contains("subscription validity")) {
      return AppErrorType.subscriptionExpired;
    }

    // Check App Update keywords
    if (rawMessage.contains("update the app") ||
        rawMessage.contains("update your app") ||
        rawMessage.contains("latest version") ||
        rawMessage.contains("upgrade-app") ||
        rawMessage.contains("upgrade to") ||
        rawMessage.contains("please upgrade") ||
        rawMessage.contains("upgrade the app") ||
        rawMessage.contains("upgrade your app") ||
        rawMessage.contains("new version is available") ||
        rawMessage.contains("app version outdated") ||
        rawMessage.contains("install the latest")) {
      return AppErrorType.appUpdate;
    }

    // Check Scheduled Maintenance keywords
    if (rawMessage.contains("maintenance") ||
        rawMessage.contains("service unavailable") ||
        rawMessage.contains("server maintenance") ||
        rawMessage.contains("under maintenance") ||
        rawMessage.contains("temporarily unavailable") ||
        rawMessage.contains("scheduled downtime")) {
      return AppErrorType.maintenance;
    }

    // Check Unauthorized / Session keywords
    if (rawMessage.contains("unauthenticated") ||
        rawMessage.contains("unauthorized") ||
        rawMessage.contains("session expired") ||
        rawMessage.contains("token expired") ||
        rawMessage.contains("invalid token") ||
        rawMessage.contains("login required")) {
      return AppErrorType.unauthorized;
    }

    // Check Module Permission keywords
    if (rawMessage.contains("permission") ||
        rawMessage.contains("module not allowed") ||
        rawMessage.contains("digimenu module") ||
        rawMessage.contains("subscription expired") ||
        rawMessage.contains("plan expired") ||
        rawMessage.contains("access denied")) {
      return AppErrorType.permissionDenied;
    }

    // Check Network & Connectivity keywords
    if (rawMessage.contains("connection") ||
        rawMessage.contains("internet") ||
        rawMessage.contains("network") ||
        rawMessage.contains("timeout") ||
        rawMessage.contains("socket") ||
        rawMessage.contains("offline") ||
        rawMessage.contains("failed host lookup") ||
        rawMessage.contains("no address associated") ||
        rawMessage.contains("connection refused") ||
        rawMessage.contains("connect")) {
      return AppErrorType.network;
    }

    // Check 500+ Server error
    if ((resolvedStatus != null && resolvedStatus >= 500) ||
        rawMessage.contains("internal server error") ||
        rawMessage.contains("server error") ||
        rawMessage.contains("bad gateway") ||
        rawMessage.contains("exception") ||
        rawMessage.contains("class \"app\\http\\controllers")) {
      return AppErrorType.serverError;
    }

    return AppErrorType.generic;
  }

  /// Returns tailored enterprise visual tokens for the specified error type
  static AppErrorVisuals getVisuals(
    AppErrorType type, {
    String? customMessage,
    String? currentVersion,
    String? latestVersion,
  }) {
    final vStr = currentVersion ?? DeviceService.appVersion;
    final newVStr = latestVersion != null && latestVersion.isNotEmpty ? " · Available: v$latestVersion" : "";

    switch (type) {
      case AppErrorType.appUpdate:
        return AppErrorVisuals(
          title: "App Update Required",
          defaultMessage: customMessage != null && customMessage.isNotEmpty
              ? customMessage
              : "Please update the app to the latest version to access live analytics and real-time menu management.",
          icon: Icons.system_update_rounded,
          primaryColor: AppColors.primary,
          backgroundColor: const Color(0xFFFEF2F2),
          borderColor: const Color(0xFFFEE2E2),
          statusDotColor: const Color(0xFFE11D48),
          cardHeader: "Version & Update Information",
          cardIcon: Icons.verified_rounded,
          tips: [
            "Installed Version: v$vStr$newVStr",
            "Store Availability: Official release on Google Play Store",
            "Includes performance optimizations, security fixes & new features",
          ],
          primaryButtonText: "Update on Google Play",
          primaryButtonIcon: Icons.download_rounded,
          showPlayStoreAction: true,
          showOfflineModeAction: false,
        );

      case AppErrorType.subscriptionExpired:
        return AppErrorVisuals(
          title: "Subscription Expired",
          defaultMessage: customMessage != null && customMessage.isNotEmpty
              ? customMessage
              : "Subscription has expired. Please renew your subscription to continue using services.",
          icon: Icons.hourglass_disabled_rounded,
          primaryColor: const Color(0xFFD97706),
          backgroundColor: const Color(0xFFFFFBEB),
          borderColor: const Color(0xFFFEF3C7),
          statusDotColor: const Color(0xFFF59E0B),
          cardHeader: "Subscription Notice",
          cardIcon: Icons.workspace_premium_rounded,
          tips: [
            "DigiMenu online catalogs and live sessions are paused",
            "Grace period has elapsed. Please renew to restore immediate access",
            "Fast renewal support available via Phone or WhatsApp",
          ],
          primaryButtonText: "Renew Subscription",
          primaryButtonIcon: Icons.support_agent_rounded,
          showPlayStoreAction: false,
          showOfflineModeAction: false, // Expired subscription blocks offline mode
        );

      case AppErrorType.network:
        return AppErrorVisuals(
          title: "Unable to Connect",
          defaultMessage: customMessage != null && customMessage.isNotEmpty
              ? customMessage
              : "We couldn't connect to eResto servers. Please check your internet connection and try again.",
          icon: Icons.wifi_off_rounded,
          primaryColor: const Color(0xFFDC2626),
          backgroundColor: const Color(0xFFFEF2F2),
          borderColor: const Color(0xFFFEE2E2),
          statusDotColor: const Color(0xFFEF4444),
          cardHeader: "Quick Troubleshooting",
          cardIcon: Icons.info_outline_rounded,
          tips: [
            "Verify Wi-Fi or cellular mobile data is turned on",
            "Toggle Airplane mode on and off to reset connectivity",
            "Swipe down from top of screen to refresh anytime",
          ],
          primaryButtonText: "Try Again",
          primaryButtonIcon: Icons.refresh_rounded,
          showPlayStoreAction: false,
          showOfflineModeAction: true,
        );

      case AppErrorType.maintenance:
        return AppErrorVisuals(
          title: "Server Under Maintenance",
          defaultMessage: customMessage != null && customMessage.isNotEmpty
              ? customMessage
              : "eResto cloud servers are currently undergoing scheduled maintenance. Services will resume shortly.",
          icon: Icons.engineering_rounded,
          primaryColor: const Color(0xFFD97706),
          backgroundColor: const Color(0xFFFFFBEB),
          borderColor: const Color(0xFFFEF3C7),
          statusDotColor: const Color(0xFFF59E0B),
          cardHeader: "Service Maintenance Notice",
          cardIcon: Icons.access_time_rounded,
          tips: [
            "Routine maintenance typically completes within a few minutes",
            "Local cached menus and orders remain safe on your device",
            "Offline mode is fully operational for table-side service",
          ],
          primaryButtonText: "Check Server Status",
          primaryButtonIcon: Icons.refresh_rounded,
          showPlayStoreAction: false,
          showOfflineModeAction: true,
        );

      case AppErrorType.unauthorized:
        return AppErrorVisuals(
          title: "Session Expired",
          defaultMessage: customMessage != null && customMessage.isNotEmpty
              ? customMessage
              : "Your authentication session has expired or is no longer valid. Please sign in again to continue.",
          icon: Icons.lock_person_rounded,
          primaryColor: const Color(0xFF4F46E5),
          backgroundColor: const Color(0xFFEEF2FF),
          borderColor: const Color(0xFFE0E7FF),
          statusDotColor: const Color(0xFF6366F1),
          cardHeader: "Security Notice",
          cardIcon: Icons.security_rounded,
          tips: [
            "Automatic session timeout protects your restaurant account",
            "Signing in re-authenticates token credentials instantly",
          ],
          primaryButtonText: "Sign In Again",
          primaryButtonIcon: Icons.login_rounded,
          showPlayStoreAction: false,
          showOfflineModeAction: true,
        );

      case AppErrorType.serverError:
        return AppErrorVisuals(
          title: "Cloud Service Incident",
          defaultMessage: customMessage != null && customMessage.isNotEmpty
              ? customMessage
              : "Our cloud servers encountered an unexpected issue while processing your request. Please try again or switch to offline mode.",
          icon: Icons.cloud_off_rounded,
          primaryColor: const Color(0xFFE11D48),
          backgroundColor: const Color(0xFFFFF1F2),
          borderColor: const Color(0xFFFFE4E6),
          statusDotColor: const Color(0xFFF43F5E),
          cardHeader: "Technical Operations",
          cardIcon: Icons.data_usage_rounded,
          tips: [
            "Our automated cloud monitoring has reported this incident",
            "No data was lost; tap Try Again to re-attempt the connection",
            "You can continue servicing customers seamlessly in Offline Mode",
          ],
          primaryButtonText: "Try Again",
          primaryButtonIcon: Icons.refresh_rounded,
          showPlayStoreAction: false,
          showOfflineModeAction: true,
        );

      case AppErrorType.permissionDenied:
        return AppErrorVisuals(
          title: "Module Access Restricted",
          defaultMessage: customMessage != null && customMessage.isNotEmpty
              ? customMessage
              : "Your restaurant account does not currently have permission to access the DigiMenu module.",
          icon: Icons.shield_outlined,
          primaryColor: const Color(0xFFEA580C),
          backgroundColor: const Color(0xFFFFF7ED),
          borderColor: const Color(0xFFFFEDD5),
          statusDotColor: const Color(0xFFF97316),
          cardHeader: "Subscription Notice",
          cardIcon: Icons.workspace_premium_rounded,
          tips: [
            "Module 'DigiMenu' requires an active restaurant subscription",
            "Contact your restaurant manager or eResto support to activate",
          ],
          primaryButtonText: "Switch Account",
          primaryButtonIcon: Icons.switch_account_rounded,
          showPlayStoreAction: false,
          showOfflineModeAction: true,
        );

      case AppErrorType.generic:
      default:
        return AppErrorVisuals(
          title: "Something Went Wrong",
          defaultMessage: customMessage != null && customMessage.isNotEmpty
              ? customMessage
              : "An unexpected condition occurred while loading this page. Please try refreshing.",
          icon: Icons.error_outline_rounded,
          primaryColor: const Color(0xFF475569),
          backgroundColor: const Color(0xFFF8FAFC),
          borderColor: const Color(0xFFE2E8F0),
          statusDotColor: const Color(0xFF64748B),
          cardHeader: "System Information",
          cardIcon: Icons.info_outline_rounded,
          tips: [
            "Pull down from the top to refresh this screen",
            "Check that your app and device have active connectivity",
          ],
          primaryButtonText: "Try Again",
          primaryButtonIcon: Icons.refresh_rounded,
          showPlayStoreAction: false,
          showOfflineModeAction: true,
        );
    }
  }
}
