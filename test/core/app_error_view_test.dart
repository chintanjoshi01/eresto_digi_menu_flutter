import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eresto_menu/core/widgets/app_error_view.dart';

Widget _wrapWithScreenUtil(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('AppErrorView Widget Tests', () {
    testWidgets('Renders App Update scenario with Google Play button and version card', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool offlineClicked = false;
      bool updateClicked = false;

      await tester.pumpWidget(
        _wrapWithScreenUtil(
          AppErrorView(
            errorMessage: "Please update the app to the latest version.",
            onUpdate: () => updateClicked = true,
            onOfflineMode: () => offlineClicked = true,
            onRetry: () async {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title & copy
      expect(find.text("App Update Required"), findsOneWidget);
      expect(find.text("Please update the app to the latest version."), findsOneWidget);

      // Verify Contextual Card
      expect(find.text("Version & Update Information"), findsOneWidget);

      // Verify Action Buttons
      expect(find.text("Update on Google Play"), findsOneWidget);
      // Offline mode button must NOT be shown when update is required
      expect(find.text("Continue in Offline Mode"), findsNothing);
      expect(offlineClicked, isFalse);

      // Verify subtle Check Again button is available
      expect(find.text("Check Again"), findsOneWidget);

      // Tap Update button
      await tester.tap(find.text("Update on Google Play"), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(updateClicked, isTrue);
    });

    testWidgets('Renders Network scenario with Try Again and Offline Mode button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool retryClicked = false;
      bool offlineClicked = false;

      await tester.pumpWidget(
        _wrapWithScreenUtil(
          AppErrorView(
            errorMessage: "Connection timeout while fetching dashboard",
            onRetry: () async => retryClicked = true,
            onOfflineMode: () => offlineClicked = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Unable to Connect"), findsOneWidget);
      expect(find.text("Quick Troubleshooting"), findsOneWidget);
      expect(find.text("Try Again"), findsOneWidget);
      expect(find.text("Continue in Offline Mode"), findsOneWidget);

      await tester.tap(find.text("Continue in Offline Mode"), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(offlineClicked, isTrue);

      await tester.tap(find.text("Try Again"), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(retryClicked, isTrue);
    });

    testWidgets('Renders Maintenance scenario with Server Maintenance title', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        _wrapWithScreenUtil(
          const AppErrorView(
            errorMessage: "Server is under scheduled maintenance",
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Server Under Maintenance"), findsOneWidget);
      expect(find.text("Service Maintenance Notice"), findsOneWidget);
      expect(find.text("Check Server Status"), findsOneWidget);
    });

    testWidgets('Renders Unauthorized scenario with Sign In Again button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool loginClicked = false;

      await tester.pumpWidget(
        _wrapWithScreenUtil(
          AppErrorView(
            errorMessage: "Unauthenticated.",
            onLogin: () => loginClicked = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Session Expired"), findsOneWidget);
      expect(find.text("Sign In Again"), findsOneWidget);

      await tester.tap(find.text("Sign In Again"), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(loginClicked, isTrue);
    });
  });
}
