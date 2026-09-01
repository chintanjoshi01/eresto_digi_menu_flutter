import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import 'core/api/api_client.dart';
import 'core/storage/database_service.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';

// Features bindings
import 'features/auth/bindings/auth_binding.dart';
import 'features/auth/presentation/views/login_screen.dart';
import 'features/dashboard/bindings/dashboard_binding.dart';
import 'features/dashboard/presentation/views/dashboard_screen.dart';
import 'features/items/bindings/items_binding.dart';
import 'features/items/presentation/views/items_screen.dart';
import 'features/menu/bindings/menu_binding.dart';
import 'features/menu/presentation/views/menu_screen.dart';
import 'features/share/bindings/share_binding.dart';
import 'features/share/presentation/views/share_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with registered App options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 1. Initialize core storage & DB services
  await Get.putAsync<StorageService>(() => StorageService().init());
  await Get.putAsync<DatabaseService>(() => DatabaseService().init());

  // 2. Initialize Core API Client
  Get.put<ApiClient>(ApiClient());

  runApp(const ErestoMenuApp());
}

class ErestoMenuApp extends StatelessWidget {
  const ErestoMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();
    final hasToken = storageService.isLoggedIn;

    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(360, 690), // Standard layout responsive canvas size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'eResto Menu',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: hasToken ? '/dashboard' : '/login',
            getPages: [
              GetPage(
                name: '/login',
                page: () => const LoginScreen(),
                binding: AuthBinding(),
              ),
              GetPage(
                name: '/dashboard',
                page: () => const DashboardScreen(),
                binding: DashboardBinding(),
              ),
              GetPage(
                name: '/items',
                page: () => const ItemsScreen(),
                binding: ItemsBinding(),
              ),
              GetPage(
                name: '/menu',
                page: () => const MenuScreen(),
                binding: MenuBinding(),
              ),
              GetPage(
                name: '/share',
                page: () => ShareScreen(),
                binding: ShareBinding(),
              ),
            ],
          );
        },
      ),
    );
  }
}
